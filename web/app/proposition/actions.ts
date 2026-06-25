'use server';

import { revalidatePath } from 'next/cache';
import { redirect } from 'next/navigation';

import { analyserAffectation, estBloquant } from '@/lib/domain/conflits';
import type { Affectation } from '@/lib/domain/types';
import { chargerSnapshot } from '@/lib/data';
import { supabaseAdmin } from '@/lib/supabase';

interface Ligne {
  enfant_id: number;
  accueillant_id: number;
  debut: string;
  fin: string;
  besoin_id: number | null;
}

function dDate(s: string): Date {
  return new Date(`${s}T00:00:00`);
}

function ligneDepuis(p: unknown): Ligne | null {
  if (typeof p !== 'object' || p === null) return null;
  const o = p as Record<string, unknown>;
  const enfant_id = Number(o.enfant_id);
  const accueillant_id = Number(o.accueillant_id);
  const debut = String(o.debut ?? '');
  const fin = String(o.fin ?? '');
  if (!Number.isFinite(enfant_id) || !Number.isFinite(accueillant_id)) return null;
  if (!enfant_id || !accueillant_id || !debut || !fin || fin < debut) return null;
  const besoin_id = o.besoin_id != null && String(o.besoin_id) ? Number(o.besoin_id) : null;
  return { enfant_id, accueillant_id, debut, fin, besoin_id };
}

// Garde-fou serveur : ne conserve que les relais sans conflit BLOQUANT, en
// tenant compte des relais déjà retenus dans le même lot (cohérence interne).
async function lignesValides(candidats: Ligne[]): Promise<Ligne[]> {
  if (candidats.length === 0) return [];
  const snap = await chargerSnapshot();
  const enfById = new Map(snap.enfants.map((e) => [e.id, e]));
  const accById = new Map(snap.accueillants.map((a) => [a.id, a]));
  const affs: Affectation[] = [...snap.affectations];
  let sentinelle = -1;
  const ok: Ligne[] = [];
  for (const c of candidats) {
    const enfant = enfById.get(c.enfant_id);
    const accueillant = accById.get(c.accueillant_id);
    if (!enfant || !accueillant) continue;
    const debut = dDate(c.debut);
    const fin = dDate(c.fin);
    const conflits = analyserAffectation({
      enfant,
      accueillant,
      debut,
      fin,
      affectations: affs,
      disponibilites: snap.disponibilites,
      indisponibilites: snap.indisponibilites,
      incompatibilites: snap.incompatibilites,
      enfants: snap.enfants,
      fratries: snap.fratries,
      preferences: snap.preferences,
      solutions: snap.solutions,
    });
    if (conflits.some(estBloquant)) continue;
    ok.push(c);
    affs.push({
      id: sentinelle--,
      enfantId: c.enfant_id,
      accueillantId: c.accueillant_id,
      debut,
      fin,
      besoinId: c.besoin_id,
      statut: 'propose',
      transport: null,
    });
  }
  return ok;
}

function toRow(l: Ligne) {
  return {
    enfant_id: l.enfant_id,
    accueillant_id: l.accueillant_id,
    debut: l.debut,
    fin: l.fin,
    besoin_id: l.besoin_id,
    statut: 'propose',
  };
}

export async function creerRelais(formData: FormData) {
  const ligne = ligneDepuis({
    enfant_id: formData.get('enfantId'),
    accueillant_id: formData.get('accueillantId'),
    debut: formData.get('debut'),
    fin: formData.get('fin'),
    besoin_id: formData.get('besoinId'),
  });
  const apres = String(formData.get('apres') ?? '');
  if (!ligne) {
    if (apres) redirect(`${apres}?erreur=invalide`);
    return;
  }
  const valides = await lignesValides([ligne]);
  if (valides.length === 0) {
    if (apres) redirect(`${apres}?erreur=conflit`);
    return;
  }
  const r = await supabaseAdmin().from('escale_affectations').insert(valides.map(toRow));
  if (r.error) throw new Error(r.error.message);
  revalidatePath('/proposition');
  revalidatePath('/');
  revalidatePath('/planning');
  if (apres) redirect(apres);
}

export async function creerToutes(formData: FormData) {
  let brut: unknown[] = [];
  try {
    brut = JSON.parse(String(formData.get('payload') ?? '[]'));
  } catch {
    return;
  }
  if (!Array.isArray(brut) || brut.length === 0) return;
  const candidats = brut.map(ligneDepuis).filter((l): l is Ligne => l !== null);
  const valides = await lignesValides(candidats);
  if (valides.length === 0) return;
  const r = await supabaseAdmin().from('escale_affectations').insert(valides.map(toRow));
  if (r.error) throw new Error(r.error.message);
  revalidatePath('/proposition');
  revalidatePath('/planning');
}
