import Link from 'next/link';

import { Header } from '@/app/_components/Header';
import { analyserAffectation } from '@/lib/domain/conflits';
import { dateFr } from '@/lib/domain/dates';
import { relaisActif } from '@/lib/domain/types';
import { distanceKm } from '@/lib/domain/distance';
import { chargerSnapshot } from '@/lib/data';
import { nomComplet } from '@/lib/format';
import { lireSeuilDistanceKm } from '@/lib/reglages';
import { CalendrierPlanning } from './CalendrierPlanning';
import { majStatut, supprimerAffectation } from './actions';

export const dynamic = 'force-dynamic';

const STATUTS = [
  { v: 'propose', label: 'Proposé' },
  { v: 'confirme', label: 'Confirmé' },
  { v: 'realise', label: 'Réalisé' },
  { v: 'annule', label: 'Annulé' },
];

const COULEUR_STATUT: Record<string, string> = {
  propose: '#b26a00',
  confirme: '#156f6c',
  realise: '#2e7d32',
  annule: '#8a8f94',
};

export default async function Planning({
  searchParams,
}: {
  searchParams: Promise<{ vue?: string }>;
}) {
  const { vue } = await searchParams;
  const calendrier = vue === 'calendrier';
  const snap = await chargerSnapshot();
  const seuilDistanceKm = await lireSeuilDistanceKm();
  const accById = new Map(snap.accueillants.map((a) => [a.id, a]));
  const enfById = new Map(snap.enfants.map((e) => [e.id, e]));

  const affs = [...snap.affectations].sort(
    (a, b) => a.debut.getTime() - b.debut.getTime(),
  );

  const lignes = affs.map((a) => {
    const enfant = enfById.get(a.enfantId);
    const accueillant = accById.get(a.accueillantId);
    let conflits: { severite: string; message: string }[] = [];
    if (enfant && accueillant && relaisActif(a.statut)) {
      conflits = analyserAffectation({
        enfant,
        accueillant,
        debut: a.debut,
        fin: a.fin,
        affectations: snap.affectations,
        disponibilites: snap.disponibilites,
        indisponibilites: snap.indisponibilites,
        incompatibilites: snap.incompatibilites,
        enfants: snap.enfants,
        fratries: snap.fratries,
        preferences: snap.preferences,
        solutions: snap.solutions,
        affectationExclueId: a.id,
        seuilDistanceKm,
      });
    }
    const dist =
      enfant && accueillant ? distanceKm(enfant, accueillant) : null;
    return { a, enfant, accueillant, conflits, dist };
  });

  return (
    <>
      <Header actif="/planning" />
      <div className="contenu">
        <h1>Planning des relais</h1>
        <div style={{ display: 'flex', gap: 8, alignItems: 'center', marginBottom: 12 }}>
          <Link
            href="/planning"
            className={calendrier ? 'bouton-secondaire' : 'bouton'}
            style={{ padding: '6px 14px' }}
          >
            Liste
          </Link>
          <Link
            href="/planning?vue=calendrier"
            className={calendrier ? 'bouton' : 'bouton-secondaire'}
            style={{ padding: '6px 14px' }}
          >
            Calendrier
          </Link>
          <span style={{ color: 'var(--gris)', marginLeft: 8 }}>
            {affs.length} relais enregistré(s).
          </span>
        </div>

        {calendrier ? (
          <CalendrierPlanning
            accueillants={snap.accueillants.map((a) => ({ id: a.id, nom: nomComplet(a) }))}
            enfants={snap.enfants.map((e) => ({ id: e.id, nom: nomComplet(e) }))}
            affectations={snap.affectations}
            solutions={snap.solutions}
          />
        ) : lignes.length === 0 ? (
          <p>Aucun relais. Utilisez la proposition automatique pour en créer.</p>
        ) : (
          <table className="liste">
            <thead>
              <tr>
                <th>Période</th>
                <th>Enfant</th>
                <th>Accueillant</th>
                <th>Distance</th>
                <th>Transport</th>
                <th>Statut</th>
                <th>Alertes</th>
                <th style={{ width: 1 }}></th>
              </tr>
            </thead>
            <tbody>
              {lignes.map(({ a, enfant, accueillant, conflits, dist }) => (
                <tr key={a.id}>
                  <td>
                    {dateFr(a.debut)} → {dateFr(a.fin)}
                  </td>
                  <td>{enfant ? nomComplet(enfant) : '—'}</td>
                  <td>{accueillant ? nomComplet(accueillant) : '—'}</td>
                  <td>{dist == null ? '—' : `${Math.round(dist)} km`}</td>
                  <td>{a.transport ?? ''}</td>
                  <td>
                    <form action={majStatut} style={{ display: 'flex', gap: 6 }}>
                      <input type="hidden" name="id" value={a.id} />
                      <select
                        name="statut"
                        defaultValue={a.statut}
                        style={{
                          padding: '4px 6px',
                          borderRadius: 7,
                          border: '1px solid var(--filet)',
                          color: COULEUR_STATUT[a.statut] ?? 'var(--texte)',
                          fontWeight: 600,
                        }}
                      >
                        {STATUTS.map((s) => (
                          <option key={s.v} value={s.v}>
                            {s.label}
                          </option>
                        ))}
                      </select>
                      <button className="bouton-secondaire" type="submit" style={{ padding: '4px 10px' }}>
                        OK
                      </button>
                    </form>
                  </td>
                  <td>
                    {conflits.length === 0 ? (
                      <span style={{ color: 'var(--gris)' }}>—</span>
                    ) : (
                      <ul style={{ margin: 0, paddingLeft: 16 }}>
                        {conflits.map((c, i) => (
                          <li
                            key={i}
                            style={{
                              color: c.severite === 'bloquant' ? '#c62828' : '#b26a00',
                              fontSize: 12,
                            }}
                          >
                            {c.message}
                          </li>
                        ))}
                      </ul>
                    )}
                  </td>
                  <td style={{ whiteSpace: 'nowrap' }}>
                    <a
                      href={`/api/pdf/fiche/${a.id}`}
                      target="_blank"
                      rel="noreferrer"
                      title="Fiche de liaison (PDF)"
                    >
                      Fiche
                    </a>
                    {'  '}
                    <form action={supprimerAffectation} style={{ display: 'inline' }}>
                      <input type="hidden" name="id" value={a.id} />
                      <button className="lien-deco" type="submit" title="Supprimer">
                        ✕
                      </button>
                    </form>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>
    </>
  );
}
