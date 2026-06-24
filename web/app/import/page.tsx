import { Header } from '@/app/_components/Header';
import { importerAccueillants, importerEnfants } from './actions';

export const dynamic = 'force-dynamic';

export default async function ImportPage({
  searchParams,
}: {
  searchParams: Promise<{
    type?: string;
    importes?: string;
    ignores?: string;
    erreur?: string;
  }>;
}) {
  const sp = await searchParams;

  return (
    <>
      <Header actif="/import" />
      <div className="contenu">
        <h1>Import CSV</h1>
        <p style={{ color: 'var(--gris)' }}>
          Importez des accueillants ou des enfants depuis un fichier{' '}
          <strong>.csv</strong> (depuis Excel : « Enregistrer sous » → CSV). La
          première ligne contient les en-têtes de colonnes.
        </p>

        {sp.erreur === 'fichier' ? (
          <p className="erreur">Aucun fichier sélectionné, ou fichier trop volumineux (max 2 Mo).</p>
        ) : null}
        {sp.erreur === 'insert' ? (
          <p className="erreur">
            L&apos;import a échoué (données invalides). Vérifiez le format du
            fichier et réessayez.
          </p>
        ) : null}
        {sp.type ? (
          <p style={{ color: 'var(--teal)', fontWeight: 600 }}>
            ✓ {sp.type === 'accueillants' ? 'Accueillants' : 'Enfants'} :{' '}
            {sp.importes} importé(s), {sp.ignores} ignoré(s) (doublons).
          </p>
        ) : null}

        <div className="form-bloc" style={{ marginBottom: 16 }}>
          <h2 style={{ marginTop: 0 }}>Accueillants</h2>
          <p style={{ color: 'var(--gris)', marginTop: -4 }}>
            Colonnes reconnues : <code>nom</code>, <code>prenom</code>,{' '}
            <code>places</code>, <code>restriction</code> (garçons/filles),{' '}
            <code>secteur</code>, <code>notes</code>.
          </p>
          <form action={importerAccueillants}>
            <input type="file" name="fichier" accept=".csv,text/csv" required />
            <label style={{ display: 'flex', alignItems: 'center', gap: 8, marginTop: 10 }}>
              <input type="checkbox" name="dedupe" defaultChecked style={{ width: 'auto' }} />
              Ignorer les doublons (même nom + prénom)
            </label>
            <div className="actions-form">
              <button className="bouton" type="submit">
                Importer les accueillants
              </button>
            </div>
          </form>
        </div>

        <div className="form-bloc">
          <h2 style={{ marginTop: 0 }}>Enfants</h2>
          <p style={{ color: 'var(--gris)', marginTop: -4 }}>
            Colonnes reconnues : <code>nom</code>, <code>prenom</code>,{' '}
            <code>sexe</code>, <code>date de naissance</code> (JJ/MM/AAAA ou
            AAAA-MM-JJ), <code>secteur</code>, <code>notes</code>.
          </p>
          <form action={importerEnfants}>
            <input type="file" name="fichier" accept=".csv,text/csv" required />
            <label style={{ display: 'flex', alignItems: 'center', gap: 8, marginTop: 10 }}>
              <input type="checkbox" name="dedupe" defaultChecked style={{ width: 'auto' }} />
              Ignorer les doublons (même nom + prénom)
            </label>
            <div className="actions-form">
              <button className="bouton" type="submit">
                Importer les enfants
              </button>
            </div>
          </form>
        </div>
      </div>
    </>
  );
}
