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
  let doublon = db.from('escale_fratries').select('id').ilike('nom', nom);
  if (id) doublon = doublon.neq('id', id);
  const { data: existant } = await doublon.limit(1);
  if ((existant ?? []).length > 0) redirect('/fratries?erreur=doublon');
  const r = id
    ? await db.from('escale_fratries').update({ nom, regroupement }).eq('id', id)
    : await db.from('escale_fratries').insert({ nom, regroupement });
  if (r.error) throw new Error(r.error.message);
  revalidatePath('/fratries');
  redirect('/fratries');
}

export async function supprimerFratrie(formData: FormData) {
  const id = Number(formData.get('id'));
  if (!id) return;
  // Les enfants liés sont détachés (fratrie_id → null), pas supprimés.
  const r = await supabaseAdmin().from('escale_fratries').delete().eq('id', id);
  if (r.error) throw new Error(r.error.message);
  revalidatePath('/fratries');
  redirect('/fratries');
}

// Création rapide depuis l'éditeur enfant : renvoie la fratrie créée.
export async function creerFratrieRapide(
  nom: string,
): Promise<{ id: number; nom: string; regroupement: string } | null> {
  const n = nom.trim();
  if (!n) return null;
  const db = supabaseAdmin();
  const exist = await db.from('escale_fratries').select('id, nom, regroupement').ilike('nom', n).limit(1);
  if ((exist.data ?? []).length > 0) return exist.data![0];
  const r = await db
    .from('escale_fratries')
    .insert({ nom: n, regroupement: 'ensemble' })
    .select('id, nom, regroupement')
    .single();
  if (r.error) throw new Error(r.error.message);
  revalidatePath('/fratries');
  return r.data;
}

export async function majRegroupement(fratrieId: number, regroupement: string) {
  if (!REGROUPEMENTS.includes(regroupement)) return;
  const r = await supabaseAdmin()
    .from('escale_fratries')
    .update({ regroupement })
    .eq('id', fratrieId);
  if (r.error) throw new Error(r.error.message);
  revalidatePath('/fratries');
}
