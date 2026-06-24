'use server';

import { revalidatePath } from 'next/cache';
import { redirect } from 'next/navigation';

import { dossiersClos } from '@/lib/cloture';
import { chargerSnapshot } from '@/lib/data';
import { jour } from '@/lib/domain/dates';
import { supabaseAdmin } from '@/lib/supabase';

// Anonymisation IRRÉVERSIBLE : on efface les données identifiantes de l'enfant
// mais on conserve la ligne (et ses relais) pour les statistiques.
export async function anonymiserEnfants(formData: FormData) {
  const demandes = formData
    .getAll('ids')
    .map((v) => Number(v))
    .filter((n) => Number.isFinite(n) && n > 0);
  if (demandes.length === 0) redirect('/purge?erreur=aucun');

  // Garde-fou serveur : on recharge l'état et on ne garde QUE les ids
  // réellement clos au moment de l'écriture (anti-TOCTOU / anti-falsification).
  const snap = await chargerSnapshot();
  const closSet = new Set(dossiersClos(snap, jour(new Date()).getTime()).map((d) => d.id));
  const valides = demandes.filter((id) => closSet.has(id));
  if (valides.length === 0) redirect('/purge?erreur=non_clos');

  const db = supabaseAdmin();
  for (const id of valides) {
    const r = await db
      .from('escale_enfants')
      .update({
        nom: `Dossier ${id}`,
        prenom: '',
        sante: null,
        contact_urgence: null,
        notes: null,
        date_naissance: null,
        secteur: null,
      })
      .eq('id', id);
    if (r.error) throw new Error(r.error.message);
  }
  revalidatePath('/purge');
  revalidatePath('/enfants');
  redirect(`/purge?anonymises=${valides.length}`);
}
