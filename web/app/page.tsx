import { Header } from './_components/Header';
import { analyserAffectation, estBloquant } from '@/lib/domain/conflits';
import { chargerSnapshot } from '@/lib/data';
import { jour, periodeFr } from '@/lib/domain/dates';
import { couverturesEnfant, trousNonCouverts } from '@/lib/domain/proposition';
import { relaisActif, statutPropose } from '@/lib/domain/types';
import { nomComplet } from '@/lib/format';
import { couvertureBesoins } from '@/lib/stats';
import { majStatut } from './planning/actions';

export const dynamic = 'force-dynamic';

const JOUR_MS = 86400000;

function urgence(debut: Date): { texte: string; couleur: string } {
  const j = Math.round((jour(debut).getTime() - jour(new Date()).getTime()) / JOUR_MS);
  if (j < 0) return { texte: 'En retard', couleur: '#c62828' };
  if (j === 0) return { texte: "Aujourd'hui", couleur: '#c62828' };
  if (j === 1) return { texte: 'Demain', couleur: '#b26a00' };
  if (j <= 7) return { texte: `Dans ${j} j`, couleur: '#b26a00' };
  return { texte: `Dans ${j} j`, couleur: 'var(--gris)' };
}

function nbConflitsBloquants(s: Awaited<ReturnType<typeof chargerSnapshot>>): number {
  const enfById = new Map(s.enfants.map((e) => [e.id, e]));
  const accById = new Map(s.accueillants.map((a) => [a.id, a]));
  let n = 0;
  for (const a of s.affectations) {
    if (!relaisActif(a.statut)) continue;
    const e = enfById.get(a.enfantId);
    const acc = accById.get(a.accueillantId);
    if (!e || !acc) continue;
    const conflits = analyserAffectation({
      enfant: e,
      accueillant: acc,
      debut: a.debut,
      fin: a.fin,
      affectations: s.affectations,
      disponibilites: s.disponibilites,
      indisponibilites: s.indisponibilites,
      incompatibilites: s.incompatibilites,
      enfants: s.enfants,
      fratries: s.fratries,
      preferences: s.preferences,
      solutions: s.solutions,
      affectationExclueId: a.id,
    });
    if (conflits.some(estBloquant)) n++;
  }
  return n;
}

function Pastille({ u }: { u: { texte: string; couleur: string } }) {
  return (
    <span
      style={{
        fontSize: 12,
        fontWeight: 600,
        color: u.couleur,
        border: `1px solid ${u.couleur}`,
        borderRadius: 999,
        padding: '1px 8px',
        whiteSpace: 'nowrap',
      }}
    >
      {u.texte}
    </span>
  );
}

export default async function DashboardPage() {
  let s: Awaited<ReturnType<typeof chargerSnapshot>> | null = null;
  let erreur: string | null = null;
  try {
    s = await chargerSnapshot();
  } catch (e) {
    erreur = e instanceof Error ? e.message : String(e);
  }

  return (
    <>
      <Header actif="/" />
      <div className="contenu">
        <div className="aligne-droite">
          <h1>Tableau de bord</h1>
          {s ? (
            <span style={{ display: 'flex', gap: 10, alignItems: 'center' }}>
              <a className="bouton" href="/api/pdf/bilan" target="_blank" rel="noreferrer">
                Bilan PDF
              </a>
              <a href="/api/pdf/bilan?anon=1" target="_blank" rel="noreferrer" style={{ fontSize: 13 }}>
                anonymisé
              </a>
              <a className="bouton-secondaire" href="/api/csv-relais">
                Export CSV
              </a>
            </span>
          ) : null}
        </div>

        {erreur ? (
          <div className="banniere" style={{ background: '#fbeaea', color: '#b3261e' }}>
            Connexion à la base impossible : {erreur}. Vérifiez SUPABASE_URL /
            SUPABASE_SERVICE_ROLE_KEY et que le schéma a été exécuté.
          </div>
        ) : s ? (
          <Contenu s={s} />
        ) : null}

        {s ? (
          <div className="banniere">
            Données fictives uniquement tant que le DPO n&apos;a pas validé la
            mise en ligne de données réelles.
          </div>
        ) : null}
      </div>
    </>
  );
}

function Contenu({ s }: { s: Awaited<ReturnType<typeof chargerSnapshot>> }) {
  const enfById = new Map(s.enfants.map((e) => [e.id, e]));
  const accById = new Map(s.accueillants.map((a) => [a.id, a]));
  const c = couvertureBesoins(s);
  const vert = c.pct != null && c.pct >= 100;
  const nbConflits = nbConflitsBloquants(s);

  // Relais à confirmer (statut « proposé »), triés par début.
  const aConfirmer = s.affectations
    .filter((a) => a.statut === statutPropose)
    .sort((a, b) => a.debut.getTime() - b.debut.getTime());

  // Besoins non (entièrement) couverts → sous-périodes à traiter.
  const aTraiter: { enfant: string; debut: Date; fin: Date }[] = [];
  for (const b of s.besoins) {
    if (jour(b.fin).getTime() < jour(b.debut).getTime()) continue;
    const cov = couverturesEnfant(b.enfantId, s.affectations, s.solutions);
    for (const [d, f] of trousNonCouverts(b.debut, b.fin, cov)) {
      aTraiter.push({ enfant: nomComplet(enfById.get(b.enfantId) ?? { nom: '—' }), debut: d, fin: f });
    }
  }
  aTraiter.sort((a, b) => a.debut.getTime() - b.debut.getTime());

  return (
    <>
      <div className="cartes">
        <Carte valeur={s.accueillants.length} libelle="Accueillants" />
        <Carte valeur={s.enfants.length} libelle="Enfants" />
        <Carte
          valeur={s.affectations.filter((a) => relaisActif(a.statut)).length}
          libelle="Relais planifiés"
        />
        <Carte
          valeur={nbConflits}
          libelle="Relais en conflit"
          couleur={nbConflits > 0 ? '#c62828' : '#2e7d32'}
        />
      </div>

      <div className="kpi">
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <strong>Couverture des besoins</strong>
          <span style={{ fontSize: 26, fontWeight: 700, color: vert ? '#2e7d32' : 'var(--teal)' }}>
            {c.pct == null ? '—' : `${c.pct} %`}
          </span>
        </div>
        <div className="jauge">
          <div style={{ width: `${c.pct ?? 0}%`, background: vert ? '#2e7d32' : 'var(--teal)' }} />
        </div>
        <div style={{ color: 'var(--gris)', fontSize: 13 }}>
          {c.pct == null
            ? 'Aucun besoin recensé'
            : `${c.couverts} / ${c.total} journées de besoin assurées`}
        </div>
      </div>

      <div style={{ display: 'flex', gap: 16, flexWrap: 'wrap', marginTop: 24, alignItems: 'flex-start' }}>
        <section className="form-bloc" style={{ flex: '1 1 360px', maxWidth: 'none' }}>
          <h2 style={{ marginTop: 0 }}>Relais à confirmer ({aConfirmer.length})</h2>
          {aConfirmer.length === 0 ? (
            <p style={{ color: 'var(--gris)' }}>Aucun relais en attente de confirmation.</p>
          ) : (
            aConfirmer.map((a) => {
              const enf = enfById.get(a.enfantId);
              const acc = accById.get(a.accueillantId);
              return (
                <div
                  key={a.id}
                  style={{
                    display: 'flex',
                    alignItems: 'center',
                    gap: 10,
                    padding: '8px 0',
                    borderTop: '1px solid var(--filet)',
                  }}
                >
                  <div style={{ flex: 1 }}>
                    <div style={{ fontWeight: 600 }}>
                      {enf ? nomComplet(enf) : '—'} → {acc ? nomComplet(acc) : '—'}
                    </div>
                    <div style={{ color: 'var(--gris)', fontSize: 13 }}>
                      {periodeFr(a.debut, a.fin)}
                    </div>
                  </div>
                  <Pastille u={urgence(a.debut)} />
                  <form action={majStatut}>
                    <input type="hidden" name="id" value={a.id} />
                    <input type="hidden" name="statut" value="confirme" />
                    <button className="bouton-secondaire" type="submit" style={{ padding: '6px 12px' }}>
                      Confirmer
                    </button>
                  </form>
                </div>
              );
            })
          )}
        </section>

        <section className="form-bloc" style={{ flex: '1 1 360px', maxWidth: 'none' }}>
          <h2 style={{ marginTop: 0 }}>À traiter — besoins non couverts ({aTraiter.length})</h2>
          {aTraiter.length === 0 ? (
            <p style={{ color: 'var(--gris)' }}>Tous les besoins sont couverts. 🎉</p>
          ) : (
            aTraiter.map((t, i) => (
              <div
                key={i}
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  gap: 10,
                  padding: '8px 0',
                  borderTop: '1px solid var(--filet)',
                }}
              >
                <div style={{ flex: 1 }}>
                  <div style={{ fontWeight: 600 }}>{t.enfant}</div>
                  <div style={{ color: 'var(--gris)', fontSize: 13 }}>{periodeFr(t.debut, t.fin)}</div>
                </div>
                <Pastille u={urgence(t.debut)} />
              </div>
            ))
          )}
          {aTraiter.length > 0 ? (
            <div style={{ marginTop: 12 }}>
              <a className="bouton" href="/proposition">
                Proposer des relais
              </a>
            </div>
          ) : null}
        </section>
      </div>
    </>
  );
}

function Carte({ valeur, libelle, couleur }: { valeur: number; libelle: string; couleur?: string }) {
  return (
    <div className="carte">
      <div className="valeur" style={couleur ? { color: couleur } : undefined}>{valeur}</div>
      <div className="libelle">{libelle}</div>
    </div>
  );
}
