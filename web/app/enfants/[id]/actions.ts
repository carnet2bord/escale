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
  if (!enfantId || !debut || !fin) return;
  const r = await supabaseAdmin()
    .from('besoins_relais')
    .insert({ enfant_id: enfantId, debut, fin, motif: txt(formData.get('motif')) });
  if (r.error) throw new Error(r.error.message);
  revalidatePath(`/enfants/${enfantId}`);
}

export async function supprimerBesoin(formData: FormData) {
  const id = Number(formData.get('id'));
  const enfantId = Number(formData.get('enfantId'));
  if (!id) return;
  const r = await supabaseAdmin().from('besoins_relais').delete().eq('id', id);
  if (r.error) throw new Error(r.error.message);
  revalidatePath(`/enfants/${enfantId}`);
}
