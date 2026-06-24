import Link from 'next/link';

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

        <h2 style={{ marginTop: 28 }}>Conformité / RGPD</h2>
        <div className="form-bloc">
          <p style={{ marginTop: 0 }}>
            <Link href="/journal">Journal d&apos;audit</Link> — trace des écritures
            sur les données (triggers PostgreSQL).
          </p>
          <p>
            <a href="/api/pdf/registre" target="_blank" rel="noreferrer">
              Registre des traitements (PDF)
            </a>{' '}
            — document type à compléter avec votre DPO.
          </p>
          <p style={{ marginBottom: 0, color: 'var(--gris)' }}>
            Les exports planning / parcours / bilan ont une variante{' '}
            <strong>anonymisée</strong> (initiales) pour un partage sans
            identités.
          </p>
        </div>
      </div>
    </>
  );
}
