'use server';

import { revalidatePath } from 'next/cache';
import { redirect } from 'next/navigation';

import { supabaseAdmin } from '@/lib/supabase';

// Anonymisation IRRÉVERSIBLE : on efface les données identifiantes de l'enfant
// mais on conserve la ligne (et ses relais) pour les statistiques.
export async function anonymiserEnfants(formData: FormData) {
  const ids = formData
    .getAll('ids')
    .map((v) => Number(v))
    .filter((n) => Number.isFinite(n) && n > 0);
  if (ids.length === 0) redirect('/purge?erreur=aucun');

  const db = supabaseAdmin();
  let n = 0;
  for (const id of ids) {
    const r = await db
      .from('enfants')
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
    n++;
  }
  revalidatePath('/purge');
  revalidatePath('/enfants');
  redirect(`/purge?anonymises=${n}`);
}
