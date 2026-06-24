// Réglages clé/valeur (table reglages), notamment l'identité de la structure
// utilisée en en-tête des documents PDF.

import { supabaseAdmin } from './supabase';

export const CLE_STRUCTURE_NOM = 'structure.nom';
export const CLE_STRUCTURE_ADRESSE = 'structure.adresse';
export const CLE_STRUCTURE_SIGNATAIRE = 'structure.signataire';
export const CLE_STRUCTURE_MENTION = 'structure.mention';

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
