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

// Renseigne lat/lon : coordonnées manuelles si fournies, sinon géocodage BAN
// si une adresse est présente (et que l'utilisateur n'a pas saisi de coords ou
// a coché « géocoder »).
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

export async function enregistrerAccueillant(formData: FormData) {
  const db = supabaseAdmin();
  const id = num(formData.get('id'));
  const nom = String(formData.get('nom') ?? '').trim();
  if (!nom) redirect(id ? `/accueillants/${id}?erreur=nom` : '/accueillants/nouveau?erreur=nom');
  const adresse = txt(formData.get('adresse'));
  const { latitude, longitude } = await resoudreCoords(formData, adresse);
  const row = {
    nom,
    prenom: txt(formData.get('prenom')) ?? '',
    nb_places: num(formData.get('nbPlaces')) ?? 1,
    restriction_sexe: String(formData.get('restrictionSexe') ?? 'aucune'),
    age_min: num(formData.get('ageMin')),
    age_max: num(formData.get('ageMax')),
    plafond_jours_an: num(formData.get('plafond')),
    secteur: txt(formData.get('secteur')),
    agrement_echeance: txt(formData.get('agrementEcheance')),
    adresse,
    latitude,
    longitude,
    notes: txt(formData.get('notes')),
  };
  const r = id
    ? await db.from('escale_accueillants').update(row).eq('id', id)
    : await db.from('escale_accueillants').insert(row);
  if (r.error) throw new Error(r.error.message);
  revalidatePath('/accueillants');
  redirect('/accueillants');
}

export async function supprimerAccueillant(formData: FormData) {
  const id = num(formData.get('id'));
  if (!id) return;
  const r = await supabaseAdmin().from('escale_accueillants').delete().eq('id', id);
  if (r.error) throw new Error(r.error.message);
  revalidatePath('/accueillants');
  redirect('/accueillants');
}
