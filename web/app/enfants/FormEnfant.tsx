import Link from 'next/link';

import { BlocAdresse } from '@/app/_components/BlocAdresse';
import { ChampFratrie } from './ChampFratrie';
import { enregistrerEnfant } from './actions';

interface Option {
  id: number;
  nom: string;
  prenom?: string;
}
interface Fra {
  id: number;
  nom: string;
  regroupement?: string;
}

export function FormEnfant({
  e,
  accueillants,
  fratries,
}: {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  e?: any;
  accueillants: Option[];
  fratries: Fra[];
}) {
  return (
    <div className="form-bloc">
      <form action={enregistrerEnfant}>
        {e ? <input type="hidden" name="id" value={e.id} /> : null}
        <div className="ligne">
          <div>
            <label>Nom *</label>
            <input name="nom" defaultValue={e?.nom ?? ''} required />
          </div>
          <div>
            <label>Prénom</label>
            <input name="prenom" defaultValue={e?.prenom ?? ''} />
          </div>
        </div>
        <div className="ligne">
          <div>
            <label>Sexe</label>
            <select name="sexe" defaultValue={e?.sexe ?? 'garcon'}>
              <option value="garcon">Garçon</option>
              <option value="fille">Fille</option>
            </select>
          </div>
          <div>
            <label>Date de naissance</label>
            <input name="dateNaissance" type="date" defaultValue={e?.date_naissance ?? ''} />
          </div>
        </div>
        <div className="ligne">
          <div>
            <label>Assistant familial habituel</label>
            <select name="afHabituelId" defaultValue={e?.af_habituel_id ?? ''}>
              <option value="">— Aucun —</option>
              {accueillants.map((a) => (
                <option key={a.id} value={a.id}>
                  {[a.prenom, a.nom].filter(Boolean).join(' ')}
                </option>
              ))}
            </select>
          </div>
          <div>
            <ChampFratrie fratries={fratries} defaultId={e?.fratrie_id ?? null} />
          </div>
        </div>
        <label>Secteur</label>
        <input name="secteur" defaultValue={e?.secteur ?? ''} placeholder="Ex. Secteur Nord" />
        <label>Contact d&apos;urgence</label>
        <input name="contactUrgence" defaultValue={e?.contact_urgence ?? ''} placeholder="Nom et téléphone à prévenir" />
        <BlocAdresse entite={e} />
        <label>Santé (allergies, traitements…) — donnée sensible</label>
        <textarea name="sante" rows={2} defaultValue={e?.sante ?? ''} />
        <label>Notes</label>
        <textarea name="notes" rows={2} defaultValue={e?.notes ?? ''} />
        <div className="actions-form">
          <button className="bouton" type="submit">Enregistrer</button>
          <Link className="bouton-secondaire" href="/enfants">Annuler</Link>
        </div>
      </form>
    </div>
  );
}
