'use client';

import Link from 'next/link';
import { useState } from 'react';

import { Avatar, EmptyState, Pastille } from '@/app/_components/ui';
import { IcoCake, IcoChild, IcoDelete, IcoEdit, IcoFemale, IcoMale, IcoPdf, IcoSearch } from '@/app/_components/icons';
import { ageAnnees } from '@/lib/domain/dates';
import { nomComplet } from '@/lib/format';
import { supprimerEnfant } from './actions';

interface Ligne {
  id: number;
  nom: string;
  prenom: string | null;
  sexe: string | null;
  date_naissance: string | null;
}

// Couleurs sexe du desktop : garçon #2F6BB2, fille #B23A6B.
const couleurSexe = (s: string | null) => (s === 'fille' ? '#b23a6b' : '#2f6bb2');

export function ListeEnfants({ enfants }: { enfants: Ligne[] }) {
  const [q, setQ] = useState('');

  if (enfants.length === 0) {
    return (
      <EmptyState
        icone={<IcoChild />}
        titre="Aucun enfant pour l'instant"
        sousTitre="Ajoutez les enfants à placer en relais, avec leurs besoins et leurs incompatibilités."
        action={
          <Link className="bouton" href="/enfants/nouveau">
            Nouvel enfant
          </Link>
        }
      />
    );
  }

  const liste = q
    ? enfants.filter((e) => nomComplet(e).toLowerCase().includes(q.toLowerCase()))
    : enfants;

  return (
    <>
      <div className="recherche">
        <IcoSearch />
        <input value={q} onChange={(e) => setQ(e.target.value)} placeholder="Rechercher un enfant…" />
      </div>
      {liste.map((e) => {
        const couleur = couleurSexe(e.sexe);
        const age = ageAnnees(e.date_naissance ? new Date(`${e.date_naissance}T00:00:00`) : null);
        const fille = e.sexe === 'fille';
        return (
          <div className="carte-liste" key={e.id}>
            <Avatar initiale={(e.nom[0] ?? '?').toUpperCase()} couleur={couleur} />
            <div className="cl-corps">
              <div className="cl-titre">{nomComplet(e)}</div>
              <div className="cl-pastilles">
                <Pastille
                  texte={fille ? 'Fille' : 'Garçon'}
                  couleur={couleur}
                  icone={fille ? <IcoFemale /> : <IcoMale />}
                />
                {age != null ? (
                  <Pastille texte={`${age} ans`} couleur="var(--teal)" icone={<IcoCake />} />
                ) : null}
              </div>
            </div>
            <div className="cl-actions">
              <a href={`/api/pdf/enfant/${e.id}`} target="_blank" rel="noreferrer" title="Parcours (PDF)">
                <IcoPdf size={20} />
              </a>
              <Link href={`/enfants/${e.id}`} title="Modifier">
                <IcoEdit size={20} />
              </Link>
              <form
                action={supprimerEnfant}
                onSubmit={(ev) => {
                  if (!confirm('Supprimer cet enfant ? Ses besoins et ses affectations seront aussi supprimés.'))
                    ev.preventDefault();
                }}
              >
                <input type="hidden" name="id" value={e.id} />
                <button type="submit" title="Supprimer">
                  <IcoDelete size={20} />
                </button>
              </form>
            </div>
          </div>
        );
      })}
    </>
  );
}
