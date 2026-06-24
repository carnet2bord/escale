// Réglages clé/valeur (table reglages), notamment l'identité de la structure
// utilisée en en-tête des documents PDF.

import { SEUIL_DISTANCE_KM } from './domain/distance';
import { supabaseAdmin } from './supabase';

export const CLE_STRUCTURE_NOM = 'structure.nom';
export const CLE_STRUCTURE_ADRESSE = 'structure.adresse';
export const CLE_STRUCTURE_SIGNATAIRE = 'structure.signataire';
export const CLE_STRUCTURE_MENTION = 'structure.mention';
export const CLE_DISTANCE_SEUIL = 'distance.seuilKm';

export interface InfosStructure {
  nom: string;
  adresse: string;
  signataire: string;
  mention: string;
}

export async function lireInfosStructure(): Promise<InfosStructure> {
  const { data, error } = await supabaseAdmin().from('reglages').select('cle, valeur');
  if (error) throw new Error(error.message);
  const m = new Map((data ?? []).map((r) => [r.cle, r.valeur]));
  return {
    nom: m.get(CLE_STRUCTURE_NOM) ?? '',
    adresse: m.get(CLE_STRUCTURE_ADRESSE) ?? '',
    signataire: m.get(CLE_STRUCTURE_SIGNATAIRE) ?? '',
    mention: m.get(CLE_STRUCTURE_MENTION) ?? '',
  };
}

// Seuil de distance (km) au-delà duquel un relais est signalé « éloigné ».
export async function lireSeuilDistanceKm(): Promise<number> {
  const { data } = await supabaseAdmin()
    .from('reglages')
    .select('valeur')
    .eq('cle', CLE_DISTANCE_SEUIL)
    .maybeSingle();
  const n = Number(data?.valeur);
  return Number.isFinite(n) && n > 0 ? n : SEUIL_DISTANCE_KM;
}
