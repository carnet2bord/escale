import { Header } from '@/app/_components/Header';
import { lireInfosStructure } from '@/lib/reglages';
import { enregistrerStructure } from './actions';

export const dynamic = 'force-dynamic';

export default async function Parametres({
  searchParams,
}: {
  searchParams: Promise<{ enregistre?: string }>;
}) {
  const { enregistre } = await searchParams;
  const s = await lireInfosStructure();

  return (
    <>
      <Header actif="/parametres" />
      <div className="contenu">
        <h1>Paramètres de la structure</h1>
        <p style={{ color: 'var(--gris)' }}>
          Ces informations apparaissent en en-tête et en pied des documents PDF
          générés (fiche de liaison, plannings, bilan).
        </p>

        {enregistre ? (
          <p style={{ color: 'var(--teal)', fontWeight: 600 }}>
            ✓ Paramètres enregistrés.
          </p>
        ) : null}

        <div className="form-bloc">
          <form action={enregistrerStructure}>
            <label>Nom de la structure</label>
            <input name="nom" defaultValue={s.nom} placeholder="Ex. Service d'accueil familial …" />
            <label>Adresse</label>
            <textarea name="adresse" rows={2} defaultValue={s.adresse} />
            <label>Signataire (nom et fonction)</label>
            <input
              name="signataire"
              defaultValue={s.signataire}
              placeholder="Ex. La responsable du service, Mme …"
            />
            <label>Mention de pied de page</label>
            <input
              name="mention"
              defaultValue={s.mention}
              placeholder="Ex. Document confidentiel — usage interne"
            />
            <div className="actions-form">
              <button className="bouton" type="submit">
                Enregistrer
              </button>
            </div>
          </form>
        </div>
      </div>
    </>
  );
}
