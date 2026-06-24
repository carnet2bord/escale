import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

import { COOKIE_SESSION, jetonSession } from '@/lib/auth';

// Protège toutes les routes : redirige vers /login si la session est absente/invalide.
export async function middleware(req: NextRequest) {
  const cookie = req.cookies.get(COOKIE_SESSION)?.value;
  const attendu = await jetonSession();
  if (cookie !== attendu) {
    const url = req.nextUrl.clone();
    url.pathname = '/login';
    return NextResponse.redirect(url);
  }
  return NextResponse.next();
}

export const config = {
  // Tout sauf les assets internes, le favicon, l'API de connexion et /login.
  matcher: ['/((?!_next/static|_next/image|favicon.ico|login|api/connexion).*)'],
};
