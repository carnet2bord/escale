import Link from 'next/link';

import { BlocAdresse } from '@/app/_components/BlocAdresse';
import { enregistrerAccueillant, supprimerAccueillant } from './actions';

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export function FormAccueillant({ a }: { a?: any }) {
  return (
    <div className="form-bloc">
      <form action={enregistrerAccueillant}>
        {a ? <input type="hidden" name="id" value={a.id} /> : null}
        <div className="ligne">
          <div>
            <label>Nom *</label>
            <input name="nom" defaultValue={a?.nom ?? ''} required />
          </div>
          <div>
            <label>Prénom</label>
            <input name="prenom" defaultValue={a?.prenom ?? ''} />
          </div>
        </div>
        <div className="ligne">
          <div>
            <label>Nombre de places</label>
            <input name="nbPlaces" type="number" min={1} defaultValue={a?.nb_places ?? 1} />
          </div>
          <div>
            <label>Accueil</label>
            <select name="restrictionSexe" defaultValue={a?.restriction_sexe ?? 'aucune'}>
              <option value="aucune">Mixte</option>
              <option value="garcon">Garçons uniquement</option>
              <option value="fille">Filles uniquement</option>
            </select>
          </div>
        </div>
        <div className="ligne">
          <div>
            <label>Âge min</label>
            <input name="ageMin" type="number" defaultValue={a?.age_min ?? ''} />
          </div>
          <div>
            <label>Âge max</label>
            <input name="ageMax" type="number" defaultValue={a?.age_max ?? ''} />
          </div>
          <div>
            <label>Plafond jours / an</label>
            <input name="plafond" type="number" defaultValue={a?.plafond_jours_an ?? ''} />
          </div>
        </div>
        <div className="ligne">
          <div>
            <label>Secteur</label>
            <input name="secteur" defaultValue={a?.secteur ?? ''} placeholder="Ex. Secteur Nord" />
          </div>
          <div>
            <label>Échéance d&apos;agrément</label>
            <input name="agrementEcheance" type="date" defaultValue={a?.agrement_echeance ?? ''} />
          </div>
        </div>
        <BlocAdresse entite={a} />
        <label>Notes</label>
        <textarea name="notes" rows={2} defaultValue={a?.notes ?? ''} />
        <div className="actions-form">
          <button className="bouton" type="submit">Enregistrer</button>
          <Link className="bouton-secondaire" href="/accueillants">Annuler</Link>
        </div>
      </form>
      {a ? (
        <form action={supprimerAccueillant} style={{ marginTop: 16 }}>
          <input type="hidden" name="id" value={a.id} />
          <button className="bouton-danger" type="submit">Supprimer cet accueillant</button>
        </form>
      ) : null}
    </div>
  );
}
