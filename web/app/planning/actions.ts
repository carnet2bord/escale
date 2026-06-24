'use server';

import { revalidatePath } from 'next/cache';

import { supabaseAdmin } from '@/lib/supabase';

export async function majStatut(formData: FormData) {
  const id = Number(formData.get('id'));
  const statut = String(formData.get('statut') ?? '').trim();
  if (!id || !statut) return;
  const r = await supabaseAdmin().from('affectations').update({ statut }).eq('id', id);
  if (r.error) throw new Error(r.error.message);
  revalidatePath('/planning');
}

export async function supprimerAffectation(formData: FormData) {
  const id = Number(formData.get('id'));
  if (!id) return;
  const r = await supabaseAdmin().from('affectations').delete().eq('id', id);
  if (r.error) throw new Error(r.error.message);
  revalidatePath('/planning');
}
