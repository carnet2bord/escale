import { Header } from '@/app/_components/Header';
import { restaurer } from './actions';

export const dynamic = 'force-dynamic';

export default async function RestaurerPage({
  searchParams,
}: {
  searchParams: Promise<{ ok?: string; erreur?: string }>;
}) {
  const sp = await searchParams;
  return (
    <>
      <Header actif="/parametres" />
      <div className="contenu">
        <h1>Restaurer une sauvegarde</h1>
        <p style={{ color: 'var(--gris)' }}>
          Importe un fichier <strong>escale-sauvegarde.json</strong> (créé via
          « Sauvegarder »). <strong>Toutes les données actuelles seront
          remplacées.</strong>
        </p>

        {sp.ok ? (
          <p style={{ color: 'var(--teal)', fontWeight: 600 }}>✓ Données restaurées.</p>
        ) : null}
        {sp.erreur ? (
          <p className="erreur">
            Échec de la restauration ({sp.erreur}). Vérifiez le fichier.
          </p>
        ) : null}

        <div className="form-bloc">
          <form action={restaurer}>
            <input type="file" name="fichier" accept="application/json,.json" required />
            <div className="actions-form">
              <button className="bouton-danger" type="submit">
                Restaurer (remplacer les données)
              </button>
            </div>
          </form>
        </div>
      </div>
    </>
  );
}
