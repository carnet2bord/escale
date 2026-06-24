'use server';

import { revalidatePath } from 'next/cache';
import { redirect } from 'next/navigation';

import { supabaseAdmin } from '@/lib/supabase';

const REGROUPEMENTS = ['ensemble', 'separes', 'indifferent'];

export async function enregistrerFratrie(formData: FormData) {
  const id = Number(formData.get('id')) || null;
  const nom = String(formData.get('nom') ?? '').trim();
  let regroupement = String(formData.get('regroupement') ?? 'ensemble');
  if (!REGROUPEMENTS.includes(regroupement)) regroupement = 'ensemble';
  if (!nom) redirect('/fratries?erreur=nom');
  const db = supabaseAdmin();
  // Évite les fratries de même nom (ambiguës dans le select de la fiche enfant).
  let doublon = db.from('fratries').select('id').ilike('nom', nom);
  if (id) doublon = doublon.neq('id', id);
  const { data: existant } = await doublon.limit(1);
  if ((existant ?? []).length > 0) redirect('/fratries?erreur=doublon');
  const r = id
    ? await db.from('fratries').update({ nom, regroupement }).eq('id', id)
    : await db.from('fratries').insert({ nom, regroupement });
  if (r.error) throw new Error(r.error.message);
  revalidatePath('/fratries');
  redirect('/fratries');
}

export async function supprimerFratrie(formData: FormData) {
  const id = Number(formData.get('id'));
  if (!id) return;
  // Les enfants liés sont détachés (fratrie_id → null), pas supprimés.
  const r = await supabaseAdmin().from('fratries').delete().eq('id', id);
  if (r.error) throw new Error(r.error.message);
  revalidatePath('/fratries');
  redirect('/fratries');
}
