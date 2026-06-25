'use server';

import { revalidatePath } from 'next/cache';
import { redirect } from 'next/navigation';

import { normaliser } from '@/lib/csv';
import { supabaseAdmin } from '@/lib/supabase';

// Tables métier dans l'ordre de suppression (FK), réglages exclus.
const TABLES_METIER = [
  'escale_affectations',
  'escale_incompatibilites',
  'escale_besoins_relais',
  'escale_disponibilites_accueil',
  'escale_indisponibilites',
  'escale_preferences_accueil',
  'escale_solutions_alternatives',
  'escale_enfants',
  'escale_fratries',
  'escale_accueillants',
];

// Vide toutes les données métier (irréversible). Garde les réglages.
export async function viderTout() {
  const db = supabaseAdmin();
  for (const t of TABLES_METIER) {
    const r = await db.from(t).delete().gt('id', 0);
    if (r.error) throw new Error(r.error.message);
  }
  revalidatePath('/');
  redirect('/parametres?vide=ok');
}

// Supprime les accueillants/enfants en double (même nom+prénom normalisés),
// en gardant la fiche d'id le plus petit.
export async function supprimerDoublons() {
  const db = supabaseAdmin();
  let total = 0;
  for (const table of ['escale_accueillants', 'escale_enfants']) {
    const { data, error } = await db
      .from(table)
      .select('id, nom, prenom')
      .order('id');
    if (error) throw new Error(error.message);
    const vus = new Set<string>();
    const aSupprimer: number[] = [];
    for (const r of data ?? []) {
      const cle = `${normaliser(r.nom ?? '')}|${normaliser(r.prenom ?? '')}`;
      if (vus.has(cle)) aSupprimer.push(r.id);
      else vus.add(cle);
    }
    if (aSupprimer.length > 0) {
      const del = await db.from(table).delete().in('id', aSupprimer);
      if (del.error) throw new Error(del.error.message);
      total += aSupprimer.length;
    }
  }
  revalidatePath('/');
  redirect(`/parametres?doublons=${total}`);
}
