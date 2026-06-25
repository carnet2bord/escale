'use client';

import Link from 'next/link';
import { useEffect, useRef, useState } from 'react';

import { deconnexion } from '@/app/actions';
import { supprimerDoublons, viderTout } from '@/app/outils/actions';
import { chargerDemo } from '@/app/parametres/demo';
import { ThemeToggle } from './ThemeToggle';

// Icônes outline reprenant les icônes Material du menu Outils desktop.
const S = (d: React.ReactNode) => (
  <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
    {d}
  </svg>
);
const I = {
  tune: S(<><path d="M4 6h10M18 6h2M4 12h2M10 12h10M4 18h8M16 18h4" /><circle cx="16" cy="6" r="2" /><circle cx="8" cy="12" r="2" /><circle cx="14" cy="18" r="2" /></>),
  lock: S(<><rect x="5" y="11" width="14" height="9" rx="2" /><path d="M8 11V8a4 4 0 0 1 8 0v3" /></>),
  policy: S(<><path d="M12 3l7 3v5c0 4.5-3 7.5-7 9-4-1.5-7-4.5-7-9V6z" /><path d="M9 12l2 2 4-4" /></>),
  magic: S(<><path d="M15 4V2M15 8V6M19 6h-2M13 6h-2" /><path d="M14.5 7.5L4 18l2 2L16.5 9.5z" /></>),
  save: S(<><path d="M12 3v10M8 11l4 4 4-4" /><path d="M5 19h14" /></>),
  restore: S(<><path d="M3 12a9 9 0 1 0 3-6.7L3 8" /><path d="M3 4v4h4" /></>),
  table: S(<><rect x="3" y="4" width="18" height="16" rx="2" /><path d="M3 9h18M3 14h18M9 9v11M15 9v11" /></>),
  broom: S(<><path d="M19 5l-7 7M11 8l5 5" /><path d="M12 12l-5 5-3-1 1-3 5-5" /></>),
  sweep: S(<><path d="M4 7h16M9 7V5a2 2 0 0 1 2-2h2a2 2 0 0 1 2 2v2" /><path d="M6 7l1 13h10l1-13" /><path d="M10 11v6M14 11v6" /></>),
  info: S(<><circle cx="12" cy="12" r="9" /><path d="M12 11v5M12 8h.01" /></>),
};

function Item({ icone, danger, children }: { icone: React.ReactNode; danger?: boolean; children: React.ReactNode }) {
  return (
    <div className={`outils-item${danger ? ' danger' : ''}`}>
      <span className="outils-icone">{icone}</span>
      {children}
    </div>
  );
}

export function OutilsMenu({ initialSombre }: { initialSombre: boolean }) {
  const [ouvert, setOuvert] = useState(false);
  const ref = useRef<HTMLDivElement>(null);

  useEffect(() => {
    function clic(e: MouseEvent) {
      if (ref.current && !ref.current.contains(e.target as Node)) setOuvert(false);
    }
    document.addEventListener('mousedown', clic);
    return () => document.removeEventListener('mousedown', clic);
  }, []);

  return (
    <div className="outils-row" ref={ref}>
      <span className="sidebar-groupe" style={{ margin: 0, padding: 0, flex: 1 }}>
        Outils
      </span>
      <ThemeToggle initialSombre={initialSombre} compact />
      <button type="button" className="outils-bouton" aria-label="Menu Outils" onClick={() => setOuvert((o) => !o)}>
        <svg viewBox="0 0 24 24" width="20" height="20" fill="currentColor">
          <circle cx="5" cy="12" r="2" />
          <circle cx="12" cy="12" r="2" />
          <circle cx="19" cy="12" r="2" />
        </svg>
      </button>

      {ouvert ? (
        <div className="outils-popup">
          <Item icone={I.tune}>
            <Link href="/parametres">Paramètres de la structure</Link>
          </Item>
          <Item icone={I.lock}>
            <form action={deconnexion}>
              <button type="submit">Verrouiller l&apos;application</button>
            </form>
          </Item>
          <Item icone={I.policy}>
            <a href="/api/pdf/registre" target="_blank" rel="noreferrer">Registre RGPD (PDF)</a>
          </Item>
          <div className="outils-sep" />
          <Item icone={I.magic}>
            <form action={chargerDemo}>
              <button type="submit">Données de démo</button>
            </form>
          </Item>
          <Item icone={I.save}>
            <a href="/api/export">Sauvegarder…</a>
          </Item>
          <Item icone={I.restore}>
            <Link href="/restaurer">Restaurer…</Link>
          </Item>
          <div className="outils-sep" />
          <Item icone={I.table}>
            <Link href="/import">Importer (CSV)</Link>
          </Item>
          <Item icone={I.magic}>
            <Link href="/proposition">Proposition automatique</Link>
          </Item>
          <Item icone={I.table}>
            <Link href="/fratries">Fratries</Link>
          </Item>
          <Item icone={I.broom}>
            <form
              action={supprimerDoublons}
              onSubmit={(e) => {
                if (!confirm('Supprimer les fiches en double (même nom + prénom) ?')) e.preventDefault();
              }}
            >
              <button type="submit">Supprimer les doublons</button>
            </form>
          </Item>
          <div className="outils-sep" />
          <Item icone={I.sweep} danger>
            <form
              action={viderTout}
              onSubmit={(e) => {
                if (!confirm('Vider TOUTES les données ? Action irréversible.')) e.preventDefault();
              }}
            >
              <button type="submit">Vider les données</button>
            </form>
          </Item>
          <div className="outils-sep" />
          <Item icone={I.info}>
            <Link href="/apropos">À propos / versions</Link>
          </Item>
        </div>
      ) : null}
    </div>
  );
}
