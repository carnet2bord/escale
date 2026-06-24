'use server';

import { cookies } from 'next/headers';
import { redirect } from 'next/navigation';

import { COOKIE_SESSION, jetonSession, motDePasseValide } from '@/lib/auth';

export async function connexion(formData: FormData) {
  const pw = String(formData.get('motDePasse') ?? '');
  if (!motDePasseValide(pw)) {
    redirect('/login?erreur=1');
  }
  const c = await cookies();
  c.set(COOKIE_SESSION, await jetonSession(), {
    httpOnly: true,
    sameSite: 'lax',
    secure: true,
    path: '/',
    maxAge: 60 * 60 * 12,
  });
  redirect('/');
}

export async function deconnexion() {
  const c = await cookies();
  c.delete(COOKIE_SESSION);
  redirect('/login');
}
