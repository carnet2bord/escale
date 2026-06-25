import type { Metadata } from 'next';
import { cookies } from 'next/headers';

import './globals.css';

export const metadata: Metadata = {
  title: 'Escale',
  description: 'Coordonner les relais d\'accueil familial',
};

export default async function RootLayout({ children }: { children: React.ReactNode }) {
  // Thème lu côté serveur (cookie) → pas de flash au chargement.
  const theme = (await cookies()).get('escale_theme')?.value === 'sombre' ? 'sombre' : 'clair';
  return (
    <html lang="fr" data-theme={theme}>
      <body>{children}</body>
    </html>
  );
}
