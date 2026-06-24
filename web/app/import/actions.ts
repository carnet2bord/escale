'use server';

import { redirect } from 'next/navigation';

import { enObjets, parseCsv } from '@/lib/csv';
import { cleEnfant, cleNom, mapAccueillants, mapEnfants } from '@/lib/import';
import { supabaseAdmin } from '@/lib/supabase';

const TAILLE_MAX = 2_000_000; // 2 Mo : garde-fou anti-fichier géant

async function lireFichier(formData: FormData): Promise<string | null> {
  const f = formData.get('fichier');
  if (!(f instanceof File) || f.size === 0 || f.size > TAILLE_MAX) return null;
  return await f.text();
}

export async function importerAccueillants(formData: FormData) {
  const texte = await lireFichier(formData);
  if (!texte) redirect('/import?erreur=fichier');
  const dedupe = formData.get('dedupe') != null;
  const candidats = mapAccueillants(enObjets(parseCsv(texte)));
  if (candidats.length === 0) redirect('/import?type=accueillants&importes=0&ignores=0');

  const db = supabaseAdmin();
  const vus = new Set<string>();
  if (dedupe) {
    const { data } = await db.from('accueillants').select('nom, prenom');
    for (const r of data ?? []) vus.add(cleNom({ nom: r.nom, prenom: r.prenom ?? '' }));
  }
  const aInserer = [];
  let ignores = 0;
  for (const c of candidats) {
    const k = cleNom(c);
    if (dedupe && vus.has(k)) {
      ignores++;
      continue;
    }
    vus.add(k);
    aInserer.push(c);
  }
  if (aInserer.length > 0) {
    const r = await db.from('accueillants').insert(aInserer);
    if (r.error) redirect('/import?erreur=insert');
  }
  redirect(`/import?type=accueillants&importes=${aInserer.length}&ignores=${ignores}`);
}

export async function importerEnfants(formData: FormData) {
  const texte = await lireFichier(formData);
  if (!texte) redirect('/import?erreur=fichier');
  const dedupe = formData.get('dedupe') != null;
  const candidats = mapEnfants(enObjets(parseCsv(texte)));
  if (candidats.length === 0) redirect('/import?type=enfants&importes=0&ignores=0');

  const db = supabaseAdmin();
  const vus = new Set<string>();
  if (dedupe) {
    const { data } = await db.from('enfants').select('nom, prenom, date_naissance');
    for (const r of data ?? []) {
      vus.add(
        cleEnfant({ nom: r.nom, prenom: r.prenom ?? '', date_naissance: r.date_naissance ?? null }),
      );
    }
  }
  const aInserer = [];
  let ignores = 0;
  for (const c of candidats) {
    const k = cleEnfant(c);
    if (dedupe && vus.has(k)) {
      ignores++;
      continue;
    }
    vus.add(k);
    aInserer.push(c);
  }
  if (aInserer.length > 0) {
    const r = await db.from('enfants').insert(aInserer);
    if (r.error) redirect('/import?erreur=insert');
  }
  redirect(`/import?type=enfants&importes=${aInserer.length}&ignores=${ignores}`);
}
