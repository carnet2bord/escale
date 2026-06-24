import Link from 'next/link';

import { deconnexion } from '@/app/actions';

const liens = [
  { href: '/', label: 'Tableau de bord' },
  { href: '/accueillants', label: 'Accueillants' },
  { href: '/enfants', label: 'Enfants' },
  { href: '/apropos', label: 'À propos' },
];

export function Header({ actif }: { actif?: string }) {
  return (
    <div className="barre">
      <div style={{ display: 'flex', alignItems: 'center' }}>
        <span className="marque">Escale</span>
        <nav className="nav">
          {liens.map((l) => (
            <Link key={l.href} href={l.href} className={actif === l.href ? 'actif' : ''}>
              {l.label}
            </Link>
          ))}
        </nav>
      </div>
      <form action={deconnexion}>
        <button className="lien-deco" type="submit">Se déconnecter</button>
      </form>
    </div>
  );
}
