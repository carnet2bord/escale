import { Header } from './_components/Header';
import { chargerSnapshot } from '@/lib/data';
import { relaisActif } from '@/lib/domain/types';
import { couvertureBesoins } from '@/lib/stats';

export const dynamic = 'force-dynamic';

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
            </span>
          ) : null}
        </div>
        {erreur ? (
          <div className="banniere" style={{ background: '#fbeaea', color: '#b3261e' }}>
            Connexion à la base impossible : {erreur}. Vérifiez SUPABASE_URL /
            SUPABASE_SERVICE_ROLE_KEY et que le schéma a été exécuté.
          </div>
        ) : s ? (
          <>
            <div className="cartes">
              <div className="carte">
                <div className="valeur">{s.accueillants.length}</div>
                <div className="libelle">Accueillants</div>
              </div>
              <div className="carte">
                <div className="valeur">{s.enfants.length}</div>
                <div className="libelle">Enfants</div>
              </div>
              <div className="carte">
                <div className="valeur">
                  {s.affectations.filter((a) => relaisActif(a.statut)).length}
                </div>
                <div className="libelle">Relais planifiés</div>
              </div>
              <div className="carte">
                <div className="valeur">{s.besoins.length}</div>
                <div className="libelle">Besoins</div>
              </div>
            </div>
            {(() => {
              const c = couvertureBesoins(s!);
              return (
                <div className="kpi">
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                    <strong>Couverture des besoins</strong>
                    <span style={{ fontSize: 24, fontWeight: 700, color: 'var(--teal)' }}>
                      {c.pct == null ? '—' : `${c.pct} %`}
                    </span>
                  </div>
                  <div className="jauge"><div style={{ width: `${c.pct ?? 0}%` }} /></div>
                  <div style={{ color: 'var(--gris)', fontSize: 13 }}>
                    {c.pct == null
                      ? 'Aucun besoin recensé'
                      : `${c.couverts} / ${c.total} journées de besoin assurées`}
                  </div>
                </div>
              );
            })()}
          </>
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
