'use server';

import { revalidatePath } from 'next/cache';

import { supabaseAdmin } from '@/lib/supabase';

function txt(v: FormDataEntryValue | null): string | null {
  const s = String(v ?? '').trim();
  return s ? s : null;
}

export async function ajouterBesoin(formData: FormData) {
  const enfantId = Number(formData.get('enfantId'));
  const debut = txt(formData.get('debut'));
  const fin = txt(formData.get('fin'));
  if (!enfantId || !debut || !fin || fin < debut) return;
  const r = await supabaseAdmin()
    .from('escale_besoins_relais')
    .insert({ enfant_id: enfantId, debut, fin, motif: txt(formData.get('motif')) });
  if (r.error) throw new Error(r.error.message);
  revalidatePath(`/enfants/${enfantId}`);
}

export async function supprimerBesoin(formData: FormData) {
  const id = Number(formData.get('id'));
  const enfantId = Number(formData.get('enfantId'));
  if (!id) return;
  const r = await supabaseAdmin().from('escale_besoins_relais').delete().eq('id', id);
  if (r.error) throw new Error(r.error.message);
  revalidatePath(`/enfants/${enfantId}`);
}

// --- Incompatibilités enfant ↔ enfant ---

export async function ajouterIncompatibilite(formData: FormData) {
  const enfantId = Number(formData.get('enfantId'));
  const autreId = Number(formData.get('autreId'));
  if (!enfantId || !autreId || enfantId === autreId) return;
  const db = supabaseAdmin();
  // Évite le doublon dans un sens comme dans l'autre.
  const existant = await db
    .from('escale_incompatibilites')
    .select('id')
    .or(
      `and(enfant_a_id.eq.${enfantId},enfant_b_id.eq.${autreId}),and(enfant_a_id.eq.${autreId},enfant_b_id.eq.${enfantId})`,
    )
    .limit(1);
  if (existant.error) throw new Error(existant.error.message);
  if ((existant.data ?? []).length === 0) {
    const r = await db
      .from('escale_incompatibilites')
      .insert({ enfant_a_id: enfantId, enfant_b_id: autreId });
    if (r.error) throw new Error(r.error.message);
  }
  revalidatePath(`/enfants/${enfantId}`);
}

export async function supprimerIncompatibilite(formData: FormData) {
  const id = Number(formData.get('id'));
  const enfantId = Number(formData.get('enfantId'));
  if (!id) return;
  const r = await supabaseAdmin().from('escale_incompatibilites').delete().eq('id', id);
  if (r.error) throw new Error(r.error.message);
  revalidatePath(`/enfants/${enfantId}`);
}

// --- Préférences d'accueil (favori / à éviter) ---

export async function ajouterPreference(formData: FormData) {
  const enfantId = Number(formData.get('enfantId'));
  const accueillantId = Number(formData.get('accueillantId'));
  const type = String(formData.get('type') ?? '').trim();
  if (!enfantId || !accueillantId || (type !== 'favori' && type !== 'exclu')) return;
  // Un seul choix par couple (favori OU exclu) : upsert atomique sur la
  // contrainte unique (enfant_id, accueillant_id) — pas de delete+insert.
  const r = await supabaseAdmin()
    .from('escale_preferences_accueil')
    .upsert(
      { enfant_id: enfantId, accueillant_id: accueillantId, type },
      { onConflict: 'enfant_id,accueillant_id' },
    );
  if (r.error) throw new Error(r.error.message);
  revalidatePath(`/enfants/${enfantId}`);
}

export async function supprimerPreference(formData: FormData) {
  const id = Number(formData.get('id'));
  const enfantId = Number(formData.get('enfantId'));
  if (!id) return;
  const r = await supabaseAdmin().from('escale_preferences_accueil').delete().eq('id', id);
  if (r.error) throw new Error(r.error.message);
  revalidatePath(`/enfants/${enfantId}`);
}

// --- Solutions alternatives (colonie / tiers / autre) ---

export async function ajouterSolution(formData: FormData) {
  const enfantId = Number(formData.get('enfantId'));
  const debut = txt(formData.get('debut'));
  const fin = txt(formData.get('fin'));
  const type = String(formData.get('type') ?? '').trim();
  if (!enfantId || !debut || !fin || !type || fin < debut) return;
  const r = await supabaseAdmin().from('escale_solutions_alternatives').insert({
    enfant_id: enfantId,
    debut,
    fin,
    type,
    details: txt(formData.get('details')),
  });
  if (r.error) throw new Error(r.error.message);
  revalidatePath(`/enfants/${enfantId}`);
}

export async function supprimerSolution(formData: FormData) {
  const id = Number(formData.get('id'));
  const enfantId = Number(formData.get('enfantId'));
  if (!id) return;
  const r = await supabaseAdmin().from('escale_solutions_alternatives').delete().eq('id', id);
  if (r.error) throw new Error(r.error.message);
  revalidatePath(`/enfants/${enfantId}`);
}
