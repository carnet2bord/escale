'use server';

import { revalidatePath } from 'next/cache';

import { supabaseAdmin } from '@/lib/supabase';

function txt(v: FormDataEntryValue | null): string | null {
  const s = String(v ?? '').trim();
  return s ? s : null;
}

export async function ajouterDispo(formData: FormData) {
  const accueillantId = Number(formData.get('accueillantId'));
  const debut = txt(formData.get('debut'));
  const fin = txt(formData.get('fin'));
  if (!accueillantId || !debut || !fin) return;
  const r = await supabaseAdmin()
    .from('disponibilites_accueil')
    .insert({ accueillant_id: accueillantId, debut, fin });
  if (r.error) throw new Error(r.error.message);
  revalidatePath(`/accueillants/${accueillantId}`);
}

export async function supprimerDispo(formData: FormData) {
  const id = Number(formData.get('id'));
  const accueillantId = Number(formData.get('accueillantId'));
  if (!id) return;
  const r = await supabaseAdmin().from('disponibilites_accueil').delete().eq('id', id);
  if (r.error) throw new Error(r.error.message);
  revalidatePath(`/accueillants/${accueillantId}`);
}

export async function ajouterIndispo(formData: FormData) {
  const accueillantId = Number(formData.get('accueillantId'));
  const debut = txt(formData.get('debut'));
  const fin = txt(formData.get('fin'));
  if (!accueillantId || !debut || !fin) return;
  const r = await supabaseAdmin()
    .from('indisponibilites')
    .insert({ accueillant_id: accueillantId, debut, fin, motif: txt(formData.get('motif')) });
  if (r.error) throw new Error(r.error.message);
  revalidatePath(`/accueillants/${accueillantId}`);
}

export async function supprimerIndispo(formData: FormData) {
  const id = Number(formData.get('id'));
  const accueillantId = Number(formData.get('accueillantId'));
  if (!id) return;
  const r = await supabaseAdmin().from('indisponibilites').delete().eq('id', id);
  if (r.error) throw new Error(r.error.message);
  revalidatePath(`/accueillants/${accueillantId}`);
}
