import { cookies } from 'next/headers';
import Link from 'next/link';

import { VERSION_ESCALE } from '@/lib/changelog';
import { OutilsMenu } from './OutilsMenu';

// Icônes (outline simple, façon Material) pour la nav principale.
const ICONES: Record<string, React.ReactNode> = {
  tableau: (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
      <rect x="3" y="3" width="7" height="7" rx="1.5" />
      <rect x="14" y="3" width="7" height="7" rx="1.5" />
      <rect x="14" y="14" width="7" height="7" rx="1.5" />
      <rect x="3" y="14" width="7" height="7" rx="1.5" />
    </svg>
  ),
  accueillants: (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinejoin="round">
      <path d="M4 11l8-6 8 6" />
      <path d="M6 10v9h12v-9" />
    </svg>
  ),
  enfants: (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round">
      <circle cx="12" cy="6" r="3" />
      <path d="M6 21v-3a6 6 0 0 1 12 0v3" />
    </svg>
  ),
  planning: (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
      <rect x="3" y="4.5" width="18" height="16" rx="2" />
      <path d="M3 9h18M8 2.5v4M16 2.5v4" strokeLinecap="round" />
    </svg>
  ),
};

const principaux = [
  { href: '/', label: 'Tableau de bord', icone: 'tableau' },
  { href: '/accueillants', label: 'Accueillants', icone: 'accueillants' },
  { href: '/enfants', label: 'Enfants', icone: 'enfants' },
  { href: '/planning', label: 'Planning', icone: 'planning' },
];

export async function Header({ actif }: { actif?: string }) {
  const sombre = (await cookies()).get('escale_theme')?.value === 'sombre';
  return (
    <nav className="sidebar">
      <div className="sidebar-logo">
        {/* eslint-disable-next-line @next/next/no-img-element */}
        <img src="/logo-escale.png" alt="Escale" />
      </div>
      <div className="sidebar-version">v{VERSION_ESCALE}</div>

      <div className="sidebar-nav">
        {principaux.map((l) => (
          <Link key={l.href} href={l.href} className={actif === l.href ? 'actif' : ''}>
            {ICONES[l.icone]}
            {l.label}
          </Link>
        ))}
      </div>

      <div className="sidebar-bas">
        <OutilsMenu initialSombre={sombre} />
      </div>
    </nav>
  );
}
