'use server';

import { revalidatePath } from 'next/cache';
import { redirect } from 'next/navigation';

import { supabaseAdmin } from '@/lib/supabase';

function num(v: FormDataEntryValue | null): number | null {
  const s = String(v ?? '').trim();
  if (!s) return null;
  const n = Number(s);
  return Number.isFinite(n) ? n : null;
}
function txt(v: FormDataEntryValue | null): string | null {
  const s = String(v ?? '').trim();
  return s ? s : null;
}

export async function enregistrerEnfant(formData: FormData) {
  const db = supabaseAdmin();
  const id = num(formData.get('id'));
  const nom = String(formData.get('nom') ?? '').trim();
  if (!nom) redirect(id ? `/enfants/${id}?erreur=nom` : '/enfants/nouveau?erreur=nom');
  const row = {
    nom,
    prenom: txt(formData.get('prenom')) ?? '',
    sexe: String(formData.get('sexe') ?? 'garcon'),
    date_naissance: txt(formData.get('dateNaissance')),
    af_habituel_id: num(formData.get('afHabituelId')),
    fratrie_id: num(formData.get('fratrieId')),
    secteur: txt(formData.get('secteur')),
    contact_urgence: txt(formData.get('contactUrgence')),
    sante: txt(formData.get('sante')),
    notes: txt(formData.get('notes')),
  };
  const r = id
    ? await db.from('enfants').update(row).eq('id', id)
    : await db.from('enfants').insert(row);
  if (r.error) throw new Error(r.error.message);
  revalidatePath('/enfants');
  redirect('/enfants');
}

export async function supprimerEnfant(formData: FormData) {
  const id = num(formData.get('id'));
  if (!id) return;
  const r = await supabaseAdmin().from('enfants').delete().eq('id', id);
  if (r.error) throw new Error(r.error.message);
  revalidatePath('/enfants');
  redirect('/enfants');
}
