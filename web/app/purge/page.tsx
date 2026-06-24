import { Header } from '@/app/_components/Header';
import { chargerSnapshot } from '@/lib/data';
import { dateFr, jour } from '@/lib/domain/dates';
import { relaisActif } from '@/lib/domain/types';
import { nomComplet } from '@/lib/format';
import { anonymiserEnfants } from './actions';

export const dynamic = 'force-dynamic';

export default async function PurgePage({
  searchParams,
}: {
  searchParams: Promise<{ anonymises?: string; erreur?: string }>;
}) {
  const sp = await searchParams;
  const s = await chargerSnapshot();
  const aujourdhui = jour(new Date()).getTime();

  // Un dossier est « clos » s'il a au moins une activité passée et aucune
  // activité en cours ou à venir (besoin, relais actif, solution).
  const closables = s.enfants
    .map((e) => {
      const fins: number[] = [];
      for (const b of s.besoins) if (b.enfantId === e.id) fins.push(jour(b.fin).getTime());
      for (const a of s.affectations)
        if (a.enfantId === e.id && relaisActif(a.statut)) fins.push(jour(a.fin).getTime());
      for (const so of s.solutions) if (so.enfantId === e.id) fins.push(jour(so.fin).getTime());
      if (fins.length === 0) return null;
      const derniere = Math.max(...fins);
      if (derniere >= aujourdhui) return null;
      return { id: e.id, nom: nomComplet(e), derniere };
    })
    .filter((x): x is { id: number; nom: string; derniere: number } => x !== null)
    .sort((a, b) => a.derniere - b.derniere);

  return (
    <>
      <Header actif="/purge" />
      <div className="contenu">
        <h1>Purge des dossiers clos</h1>
        <p style={{ color: 'var(--gris)' }}>
          Anonymisation <strong>irréversible</strong> des enfants dont tous les
          relais et besoins sont passés : nom, date de naissance, santé, contacts
          et notes sont effacés. La ligne et ses relais sont conservés pour les
          statistiques.
        </p>

        {sp.anonymises ? (
          <p style={{ color: 'var(--teal)', fontWeight: 600 }}>
            ✓ {sp.anonymises} dossier(s) anonymisé(s).
          </p>
        ) : null}
        {sp.erreur === 'aucun' ? (
          <p className="erreur">Aucun dossier sélectionné.</p>
        ) : null}

        {closables.length === 0 ? (
          <div className="banniere">Aucun dossier clos à anonymiser.</div>
        ) : (
          <form action={anonymiserEnfants}>
            <table className="liste">
              <thead>
                <tr>
                  <th style={{ width: 1 }}></th>
                  <th>Enfant</th>
                  <th>Dernière activité</th>
                </tr>
              </thead>
              <tbody>
                {closables.map((c) => (
                  <tr key={c.id}>
                    <td>
                      <input type="checkbox" name="ids" value={c.id} style={{ width: 'auto' }} />
                    </td>
                    <td>{c.nom}</td>
                    <td style={{ color: 'var(--gris)' }}>{dateFr(new Date(c.derniere))}</td>
                  </tr>
                ))}
              </tbody>
            </table>
            <div className="actions-form" style={{ marginTop: 14 }}>
              <button className="bouton-danger" type="submit">
                Anonymiser les dossiers sélectionnés
              </button>
            </div>
          </form>
        )}
      </div>
    </>
  );
}
