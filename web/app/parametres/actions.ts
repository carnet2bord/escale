'use server';

import { revalidatePath } from 'next/cache';
import { redirect } from 'next/navigation';

import {
  CLE_DISTANCE_SEUIL,
  CLE_STRUCTURE_ADRESSE,
  CLE_STRUCTURE_MENTION,
  CLE_STRUCTURE_NOM,
  CLE_STRUCTURE_SIGNATAIRE,
} from '@/lib/reglages';
import { supabaseAdmin } from '@/lib/supabase';

function txt(v: FormDataEntryValue | null): string {
  return String(v ?? '').trim();
}

export async function enregistrerStructure(formData: FormData) {
  const seuil = Number(formData.get('seuilDistance'));
  const lignes = [
    { cle: CLE_STRUCTURE_NOM, valeur: txt(formData.get('nom')) },
    { cle: CLE_STRUCTURE_ADRESSE, valeur: txt(formData.get('adresse')) },
    { cle: CLE_STRUCTURE_SIGNATAIRE, valeur: txt(formData.get('signataire')) },
    { cle: CLE_STRUCTURE_MENTION, valeur: txt(formData.get('mention')) },
    {
      cle: CLE_DISTANCE_SEUIL,
      valeur: Number.isFinite(seuil) && seuil > 0 ? String(seuil) : '',
    },
  ];
  const r = await supabaseAdmin()
    .from('escale_reglages')
    .upsert(lignes, { onConflict: 'cle' });
  if (r.error) throw new Error(r.error.message);
  revalidatePath('/parametres');
  redirect('/parametres?enregistre=1');
}
