'use server';

import { revalidatePath } from 'next/cache';

import { supabaseAdmin } from '@/lib/supabase';

interface RelaisInput {
  enfant_id: number;
  accueillant_id: number;
  debut: string;
  fin: string;
  besoin_id: number | null;
}

export async function creerRelais(formData: FormData) {
  const enfant_id = Number(formData.get('enfantId'));
  const accueillant_id = Number(formData.get('accueillantId'));
  const debut = String(formData.get('debut') ?? '');
  const fin = String(formData.get('fin') ?? '');
  const besoinRaw = formData.get('besoinId');
  const besoin_id = besoinRaw && String(besoinRaw) ? Number(besoinRaw) : null;
  if (!enfant_id || !accueillant_id || !debut || !fin) return;
  const r = await supabaseAdmin().from('affectations').insert({
    enfant_id,
    accueillant_id,
    debut,
    fin,
    besoin_id,
    statut: 'propose',
  });
  if (r.error) throw new Error(r.error.message);
  revalidatePath('/proposition');
  revalidatePath('/planning');
}

export async function creerToutes(formData: FormData) {
  let liste: RelaisInput[] = [];
  try {
    liste = JSON.parse(String(formData.get('payload') ?? '[]'));
  } catch {
    return;
  }
  if (!liste.length) return;
  const rows = liste.map((p) => ({ ...p, statut: 'propose' }));
  const r = await supabaseAdmin().from('affectations').insert(rows);
  if (r.error) throw new Error(r.error.message);
  revalidatePath('/proposition');
  revalidatePath('/planning');
}
