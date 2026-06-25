'use client';

import { useEffect, useRef, useState } from 'react';

import {
  IcoBlock,
  IcoCar,
  IcoCheck,
  IcoCopy,
  IcoDelete,
  IcoDescription,
  IcoMore,
  IcoRestore,
  IcoTask,
} from '@/app/_components/icons';
import { dupliquerRelais, majStatut, majTransport, supprimerAffectation } from './actions';

export function RelaisActions({
  id,
  statut,
  transport,
}: {
  id: number;
  statut: string;
  transport: string | null;
}) {
  const [ouvert, setOuvert] = useState(false);
  const ref = useRef<HTMLDivElement>(null);

  useEffect(() => {
    function clic(e: MouseEvent) {
      if (ref.current && !ref.current.contains(e.target as Node)) setOuvert(false);
    }
    document.addEventListener('mousedown', clic);
    return () => document.removeEventListener('mousedown', clic);
  }, []);

  async function changerStatut(s: string) {
    const fd = new FormData();
    fd.set('id', String(id));
    fd.set('statut', s);
    await majStatut(fd);
  }
  async function editerTransport() {
    const t = window.prompt('Transport / RDV (point et heure de RDV…)', transport ?? '');
    if (t === null) return;
    const fd = new FormData();
    fd.set('id', String(id));
    fd.set('transport', t);
    await majTransport(fd);
  }
  async function dupliquer() {
    const fd = new FormData();
    fd.set('id', String(id));
    await dupliquerRelais(fd);
  }
  async function supprimer() {
    if (!window.confirm('Supprimer ce relais ?')) return;
    const fd = new FormData();
    fd.set('id', String(id));
    await supprimerAffectation(fd);
  }

  const ferme = (fn: () => void) => () => {
    setOuvert(false);
    fn();
  };

  return (
    <div className="relais-actions" ref={ref}>
      <button type="button" className="outils-bouton" aria-label="Actions" onClick={() => setOuvert((o) => !o)}>
        <IcoMore />
      </button>
      {ouvert ? (
        <div className="outils-popup" style={{ bottom: 'auto', top: 40, left: 'auto', right: 4, width: 230 }}>
          {statut === 'propose' ? (
            <div className="outils-item">
              <span className="outils-icone"><IcoCheck /></span>
              <button type="button" onClick={ferme(() => changerStatut('confirme'))}>Confirmer</button>
            </div>
          ) : null}
          {statut !== 'realise' && statut !== 'annule' ? (
            <div className="outils-item">
              <span className="outils-icone"><IcoTask /></span>
              <button type="button" onClick={ferme(() => changerStatut('realise'))}>Marquer réalisé</button>
            </div>
          ) : null}
          {statut !== 'annule' ? (
            <div className="outils-item">
              <span className="outils-icone"><IcoBlock /></span>
              <button type="button" onClick={ferme(() => changerStatut('annule'))}>Annuler</button>
            </div>
          ) : (
            <div className="outils-item">
              <span className="outils-icone"><IcoRestore /></span>
              <button type="button" onClick={ferme(() => changerStatut('confirme'))}>Rétablir</button>
            </div>
          )}
          <div className="outils-item">
            <span className="outils-icone"><IcoCar size={18} /></span>
            <button type="button" onClick={ferme(editerTransport)}>Transport / RDV</button>
          </div>
          <div className="outils-item">
            <span className="outils-icone"><IcoDescription /></span>
            <a href={`/api/pdf/fiche/${id}`} target="_blank" rel="noreferrer">Fiche de liaison (PDF)</a>
          </div>
          <div className="outils-item">
            <span className="outils-icone"><IcoCopy /></span>
            <button type="button" onClick={ferme(dupliquer)}>Dupliquer</button>
          </div>
          <div className="outils-sep" />
          <div className="outils-item danger">
            <span className="outils-icone"><IcoDelete /></span>
            <button type="button" onClick={ferme(supprimer)}>Supprimer</button>
          </div>
        </div>
      ) : null}
    </div>
  );
}
