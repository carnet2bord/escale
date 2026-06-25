'use server';

import { revalidatePath } from 'next/cache';
import { redirect } from 'next/navigation';

import { supabaseAdmin } from '@/lib/supabase';

// Ordre de suppression (FK) puis d'insertion (inverse).
const SUPPRESSION = [
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
const INSERTION = [...SUPPRESSION].reverse();

// Restaure une sauvegarde JSON (remplace TOUTES les données métier + réglages).
export async function restaurer(formData: FormData) {
  const f = formData.get('fichier');
  if (!(f instanceof File) || f.size === 0) redirect('/restaurer?erreur=fichier');
  let parsed: { tables?: Record<string, unknown[]> };
  try {
    parsed = JSON.parse(await f.text());
  } catch {
    redirect('/restaurer?erreur=format');
  }
  const tables = parsed.tables ?? {};
  const db = supabaseAdmin();

  // 1. Vider les tables métier (ordre FK).
  for (const t of SUPPRESSION) {
    const r = await db.from(t).delete().gt('id', 0);
    if (r.error) redirect('/restaurer?erreur=suppression');
  }

  // 2. Réinsérer dans l'ordre des dépendances (ids explicites conservés).
  for (const t of INSERTION) {
    const rows = tables[t];
    if (Array.isArray(rows) && rows.length > 0) {
      const r = await db.from(t).insert(rows);
      if (r.error) redirect('/restaurer?erreur=insertion');
    }
  }

  // 3. Réglages (upsert) puis réalignement des séquences.
  const reglages = tables['escale_reglages'];
  if (Array.isArray(reglages) && reglages.length > 0) {
    await db.from('escale_reglages').upsert(reglages, { onConflict: 'cle' });
  }
  await db.rpc('escale_reset_sequences');

  revalidatePath('/');
  redirect('/restaurer?ok=1');
}
