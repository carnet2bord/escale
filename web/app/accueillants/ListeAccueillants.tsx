'use client';

import Link from 'next/link';
import { useState } from 'react';

import { Avatar, EmptyState, Pastille } from '@/app/_components/ui';
import { IcoDelete, IcoEdit, IcoHome, IcoPdf, IcoSearch, IcoSeat, IcoWc } from '@/app/_components/icons';
import { nomComplet } from '@/lib/format';
import { supprimerAccueillant } from './actions';

interface Ligne {
  id: number;
  nom: string;
  prenom: string | null;
  nb_places: number | null;
  restriction_sexe: string | null;
}

const RESTRICTION: Record<string, string> = { garcon: 'Garçons', fille: 'Filles' };

export function ListeAccueillants({ accueillants }: { accueillants: Ligne[] }) {
  const [q, setQ] = useState('');

  if (accueillants.length === 0) {
    return (
      <EmptyState
        icone={<IcoHome />}
        titre="Aucun accueillant pour l'instant"
        sousTitre="Ajoutez les assistants familiaux qui peuvent recevoir des enfants en relais."
        action={
          <Link className="bouton" href="/accueillants/nouveau">
            Nouvel accueillant
          </Link>
        }
      />
    );
  }

  const liste = q
    ? accueillants.filter((a) => nomComplet(a).toLowerCase().includes(q.toLowerCase()))
    : accueillants;

  return (
    <>
      <div className="recherche">
        <IcoSearch />
        <input
          value={q}
          onChange={(e) => setQ(e.target.value)}
          placeholder="Rechercher un accueillant…"
        />
      </div>
      {liste.map((a) => (
        <div className="carte-liste" key={a.id}>
          <Avatar initiale={(a.nom[0] ?? '?').toUpperCase()} />
          <div className="cl-corps">
            <div className="cl-titre">{nomComplet(a)}</div>
            <div className="cl-pastilles">
              <Pastille
                texte={`${a.nb_places ?? 1} place(s)`}
                couleur="var(--teal)"
                icone={<IcoSeat />}
              />
              {a.restriction_sexe && a.restriction_sexe !== 'aucune' ? (
                <Pastille
                  texte={RESTRICTION[a.restriction_sexe] ?? a.restriction_sexe}
                  couleur="#3f51b5"
                  icone={<IcoWc />}
                />
              ) : null}
            </div>
          </div>
          <div className="cl-actions">
            <a href={`/api/pdf/accueillant/${a.id}`} target="_blank" rel="noreferrer" title="Planning (PDF)">
              <IcoPdf size={20} />
            </a>
            <Link href={`/accueillants/${a.id}`} title="Modifier">
              <IcoEdit size={20} />
            </Link>
            <form
              action={supprimerAccueillant}
              onSubmit={(e) => {
                if (!confirm('Supprimer cet accueillant ? Ses périodes et ses affectations seront aussi supprimées.'))
                  e.preventDefault();
              }}
            >
              <input type="hidden" name="id" value={a.id} />
              <button type="submit" title="Supprimer">
                <IcoDelete size={20} />
              </button>
            </form>
          </div>
        </div>
      ))}
    </>
  );
}
