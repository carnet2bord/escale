'use client';

import Link from 'next/link';
import { useEffect, useRef, useState } from 'react';

import { deconnexion } from '@/app/actions';
import { supprimerDoublons, viderTout } from '@/app/outils/actions';
import { chargerDemo } from '@/app/parametres/demo';
import { ThemeToggle } from './ThemeToggle';

function Item({ children, danger }: { children: React.ReactNode; danger?: boolean }) {
  return <div className={`outils-item${danger ? ' danger' : ''}`}>{children}</div>;
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
      <button
        type="button"
        className="outils-bouton"
        aria-label="Menu Outils"
        onClick={() => setOuvert((o) => !o)}
      >
        <svg viewBox="0 0 24 24" width="20" height="20" fill="currentColor">
          <circle cx="5" cy="12" r="2" />
          <circle cx="12" cy="12" r="2" />
          <circle cx="19" cy="12" r="2" />
        </svg>
      </button>

      {ouvert ? (
        <div className="outils-popup" onClick={() => setOuvert(false)}>
          <Item>
            <Link href="/parametres">⚙️ Paramètres de la structure</Link>
          </Item>
          <Item>
            <form action={deconnexion}>
              <button type="submit">🔒 Verrouiller l&apos;application</button>
            </form>
          </Item>
          <Item>
            <a href="/api/pdf/registre" target="_blank" rel="noreferrer">
              📄 Registre RGPD (PDF)
            </a>
          </Item>
          <div className="outils-sep" />
          <Item>
            <form action={chargerDemo}>
              <button type="submit">✨ Données de démo</button>
            </form>
          </Item>
          <Item>
            <a href="/api/export">💾 Sauvegarder (JSON)</a>
          </Item>
          <Item>
            <Link href="/restaurer">↩️ Restaurer…</Link>
          </Item>
          <div className="outils-sep" />
          <Item>
            <Link href="/import">📥 Importer (CSV)</Link>
          </Item>
          <Item>
            <Link href="/proposition">🪄 Proposition automatique</Link>
          </Item>
          <Item>
            <Link href="/fratries">👪 Fratries</Link>
          </Item>
          <Item>
            <form
              action={supprimerDoublons}
              onSubmit={(e) => {
                if (!confirm('Supprimer les fiches en double (même nom + prénom) ?')) e.preventDefault();
              }}
            >
              <button type="submit">🧹 Supprimer les doublons</button>
            </form>
          </Item>
          <div className="outils-sep" />
          <Item danger>
            <form
              action={viderTout}
              onSubmit={(e) => {
                if (!confirm('Vider TOUTES les données ? Action irréversible.')) e.preventDefault();
              }}
            >
              <button type="submit">🗑 Vider les données</button>
            </form>
          </Item>
          <div className="outils-sep" />
          <Item>
            <Link href="/apropos">ℹ️ À propos / versions</Link>
          </Item>
        </div>
      ) : null}
    </div>
  );
}
