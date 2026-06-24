'use server';

import { revalidatePath } from 'next/cache';
import { redirect } from 'next/navigation';

import { geocoderBAN } from '@/lib/geo';
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

async function resoudreCoords(
  formData: FormData,
  adresse: string | null,
): Promise<{ latitude: number | null; longitude: number | null }> {
  let latitude = num(formData.get('latitude'));
  let longitude = num(formData.get('longitude'));
  const geocoder = formData.get('geocoder') != null;
  if (adresse && (geocoder || (latitude == null && longitude == null))) {
    const c = await geocoderBAN(adresse);
    if (c) {
      latitude = c.latitude;
      longitude = c.longitude;
    }
  }
  return { latitude, longitude };
}

export async function enregistrerEnfant(formData: FormData) {
  const db = supabaseAdmin();
  const id = num(formData.get('id'));
  const nom = String(formData.get('nom') ?? '').trim();
  if (!nom) redirect(id ? `/enfants/${id}?erreur=nom` : '/enfants/nouveau?erreur=nom');
  const adresse = txt(formData.get('adresse'));
  const { latitude, longitude } = await resoudreCoords(formData, adresse);
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
    adresse,
    latitude,
    longitude,
    notes: txt(formData.get('notes')),
  };
  const r = id
    ? await db.from('escale_enfants').update(row).eq('id', id)
    : await db.from('escale_enfants').insert(row);
  if (r.error) throw new Error(r.error.message);
  revalidatePath('/enfants');
  redirect('/enfants');
}

export async function supprimerEnfant(formData: FormData) {
  const id = num(formData.get('id'));
  if (!id) return;
  const r = await supabaseAdmin().from('escale_enfants').delete().eq('id', id);
  if (r.error) throw new Error(r.error.message);
  revalidatePath('/enfants');
  redirect('/enfants');
}
