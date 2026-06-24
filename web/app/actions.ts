'use server';

import { cookies, headers } from 'next/headers';
import { redirect } from 'next/navigation';

import { COOKIE_SESSION, creerJeton, motDePasseValide } from '@/lib/auth';
import { enregistrerEchec, estBloque, reinitialiser } from '@/lib/rate-limit';

async function ipAppelant(): Promise<string> {
  const h = await headers();
  const fwd = h.get('x-forwarded-for');
  if (fwd) return fwd.split(',')[0].trim();
  return h.get('x-real-ip') ?? 'inconnu';
}

export async function connexion(formData: FormData) {
  const ip = await ipAppelant();
  if (estBloque(ip)) {
    redirect('/login?erreur=bloque');
  }
  const pw = String(formData.get('motDePasse') ?? '');
  if (!motDePasseValide(pw)) {
    enregistrerEchec(ip);
    // Petit délai pour ralentir les tentatives automatisées.
    await new Promise((r) => setTimeout(r, 600));
    redirect('/login?erreur=1');
  }
  reinitialiser(ip);
  const c = await cookies();
  c.set(COOKIE_SESSION, await creerJeton(), {
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
