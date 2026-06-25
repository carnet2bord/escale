'use server';

import { revalidatePath } from 'next/cache';

import { supabaseAdmin } from '@/lib/supabase';

export async function majStatut(formData: FormData) {
  const id = Number(formData.get('id'));
  const statut = String(formData.get('statut') ?? '').trim();
  if (!id || !statut) return;
  const r = await supabaseAdmin().from('escale_affectations').update({ statut }).eq('id', id);
  if (r.error) throw new Error(r.error.message);
  revalidatePath('/planning');
  revalidatePath('/');
}

export async function supprimerAffectation(formData: FormData) {
  const id = Number(formData.get('id'));
  if (!id) return;
  const r = await supabaseAdmin().from('escale_affectations').delete().eq('id', id);
  if (r.error) throw new Error(r.error.message);
  revalidatePath('/planning');
  revalidatePath('/');
}

export async function majTransport(formData: FormData) {
  const id = Number(formData.get('id'));
  if (!id) return;
  const t = String(formData.get('transport') ?? '').trim();
  const r = await supabaseAdmin()
    .from('escale_affectations')
    .update({ transport: t || null })
    .eq('id', id);
  if (r.error) throw new Error(r.error.message);
  revalidatePath('/planning');
}

// Duplique un relais (nouvelle copie au statut « proposé »).
export async function dupliquerRelais(formData: FormData) {
  const id = Number(formData.get('id'));
  if (!id) return;
  const db = supabaseAdmin();
  const { data, error } = await db
    .from('escale_affectations')
    .select('enfant_id, accueillant_id, debut, fin, besoin_id, transport')
    .eq('id', id)
    .maybeSingle();
  if (error) throw new Error(error.message);
  if (!data) return;
  const r = await db.from('escale_affectations').insert({ ...data, statut: 'propose' });
  if (r.error) throw new Error(r.error.message);
  revalidatePath('/planning');
  revalidatePath('/');
}
