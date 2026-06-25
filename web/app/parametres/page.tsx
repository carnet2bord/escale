import Link from 'next/link';

import { Header } from '@/app/_components/Header';
import { lireInfosStructure, lireSeuilDistanceKm } from '@/lib/reglages';
import { enregistrerStructure } from './actions';
import { chargerDemo } from './demo';

export const dynamic = 'force-dynamic';

export default async function Parametres({
  searchParams,
}: {
  searchParams: Promise<{ enregistre?: string; demo?: string; vide?: string; doublons?: string }>;
}) {
  const { enregistre, demo, vide, doublons } = await searchParams;
  const s = await lireInfosStructure();
  const seuilDistance = await lireSeuilDistanceKm();

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
        {vide === 'ok' ? (
          <p style={{ color: 'var(--teal)', fontWeight: 600 }}>✓ Données vidées.</p>
        ) : null}
        {doublons != null ? (
          <p style={{ color: 'var(--teal)', fontWeight: 600 }}>
            ✓ {doublons} doublon(s) supprimé(s).
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
            <label>Seuil de distance (km) — alerte « relais éloigné »</label>
            <input
              name="seuilDistance"
              type="number"
              min={1}
              defaultValue={seuilDistance}
              placeholder="Ex. 30"
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
          <p>
            <Link href="/purge">Purge des dossiers clos</Link> — anonymisation
            irréversible des enfants dont les relais sont passés.
          </p>
          <p style={{ marginBottom: 0, color: 'var(--gris)' }}>
            Les exports planning / parcours / bilan ont une variante{' '}
            <strong>anonymisée</strong> (initiales) pour un partage sans
            identités.
          </p>
        </div>

        <h2 style={{ marginTop: 28 }}>Données de démonstration</h2>
        {demo === 'ok' ? (
          <p style={{ color: 'var(--teal)', fontWeight: 600 }}>
            ✓ Jeu de démonstration chargé.
          </p>
        ) : null}
        {demo === 'existe' ? (
          <p className="erreur">
            Des données existent déjà : la démo ne s&apos;ajoute que sur une base
            vide.
          </p>
        ) : null}
        <div className="form-bloc">
          <p style={{ marginTop: 0 }}>
            Charge un jeu <strong>fictif</strong> (4 accueillants, 6 enfants,
            fratries, besoins, adresses) pour découvrir tous les écrans et le
            calcul de distance. Uniquement si la base est vide.
          </p>
          <form action={chargerDemo}>
            <button className="bouton-secondaire" type="submit">
              Charger des données de démo
            </button>
          </form>
        </div>
      </div>
    </>
  );
}
