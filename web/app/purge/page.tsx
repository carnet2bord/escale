import { Header } from '@/app/_components/Header';
import { dossiersClos } from '@/lib/cloture';
import { chargerSnapshot } from '@/lib/data';
import { dateFr, jour } from '@/lib/domain/dates';
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
  const nomById = new Map(s.enfants.map((e) => [e.id, nomComplet(e)]));

  const closables = dossiersClos(s, jour(new Date()).getTime())
    .map((d) => ({ id: d.id, nom: nomById.get(d.id) ?? `#${d.id}`, derniere: d.derniere }))
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
        {sp.erreur === 'non_clos' ? (
          <p className="erreur">
            Les dossiers sélectionnés ne sont plus clos (une activité a été
            ajoutée entre-temps). Rien n&apos;a été anonymisé.
          </p>
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
