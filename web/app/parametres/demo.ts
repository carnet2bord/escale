'use server';

import { revalidatePath } from 'next/cache';
import { redirect } from 'next/navigation';

import { supabaseAdmin } from '@/lib/supabase';

function iso(decalageJours: number): string {
  const d = new Date();
  d.setDate(d.getDate() + decalageJours);
  return d.toISOString().slice(0, 10);
}

// Jeu de données FICTIVES (parité avec « Données de démo » du desktop) :
// 4 accueillants + 6 enfants + 2 fratries, avec adresses/coordonnées (towns du
// Nord/Pas-de-Calais) pour illustrer le calcul de distance, des disponibilités,
// des besoins sur une période de vacances, une incompatibilité et une solution.
export async function chargerDemo() {
  const db = supabaseAdmin();

  // Idempotence simple : ne rien faire si des accueillants existent déjà.
  const { count } = await db
    .from('escale_accueillants')
    .select('id', { count: 'exact', head: true });
  if ((count ?? 0) > 0) redirect('/parametres?demo=existe');

  const acc = await db
    .from('escale_accueillants')
    .insert([
      { nom: 'Bernard', prenom: 'Claire', nb_places: 2, restriction_sexe: 'aucune', secteur: 'Nord', adresse: 'Lille', latitude: 50.6292, longitude: 3.0573 },
      { nom: 'Dubois', prenom: 'Marc', nb_places: 1, restriction_sexe: 'garcon', secteur: 'Nord', adresse: 'Roubaix', latitude: 50.6942, longitude: 3.1746 },
      { nom: 'Martin', prenom: 'Sophie', nb_places: 2, restriction_sexe: 'aucune', secteur: 'Sud', adresse: 'Lens', latitude: 50.4319, longitude: 2.8333 },
      { nom: 'Girard', prenom: 'Paul', nb_places: 1, restriction_sexe: 'aucune', secteur: 'Sud', adresse: 'Arras', latitude: 50.291, longitude: 2.7775 },
    ])
    .select('id');
  if (acc.error) throw new Error(acc.error.message);
  const a = (acc.data ?? []).map((r) => r.id);

  const fra = await db
    .from('escale_fratries')
    .insert([
      { nom: 'Fratrie Marchand', regroupement: 'ensemble' },
      { nom: 'Fratrie Roux', regroupement: 'separes' },
    ])
    .select('id');
  if (fra.error) throw new Error(fra.error.message);
  const f = (fra.data ?? []).map((r) => r.id);

  const enf = await db
    .from('escale_enfants')
    .insert([
      { nom: 'Marchand', prenom: 'Lucas', sexe: 'garcon', af_habituel_id: a[0], fratrie_id: f[0], secteur: 'Nord', adresse: 'Lille', latitude: 50.63, longitude: 3.06 },
      { nom: 'Marchand', prenom: 'Emma', sexe: 'fille', af_habituel_id: a[0], fratrie_id: f[0], secteur: 'Nord', adresse: 'Lille', latitude: 50.63, longitude: 3.06 },
      { nom: 'Roux', prenom: 'Nathan', sexe: 'garcon', af_habituel_id: a[1], fratrie_id: f[1], secteur: 'Nord', adresse: 'Roubaix', latitude: 50.69, longitude: 3.17 },
      { nom: 'Roux', prenom: 'Chloé', sexe: 'fille', af_habituel_id: a[1], fratrie_id: f[1], secteur: 'Nord', adresse: 'Roubaix', latitude: 50.69, longitude: 3.17 },
      { nom: 'Faure', prenom: 'Hugo', sexe: 'garcon', af_habituel_id: a[2], secteur: 'Sud', adresse: 'Lens', latitude: 50.43, longitude: 2.83 },
      { nom: 'Blanc', prenom: 'Léa', sexe: 'fille', af_habituel_id: a[3], secteur: 'Sud', adresse: 'Arras', latitude: 50.29, longitude: 2.78 },
    ])
    .select('id');
  if (enf.error) throw new Error(enf.error.message);
  const e = (enf.data ?? []).map((r) => r.id);

  // Disponibilités larges pour tous les accueillants.
  await db.from('escale_disponibilites_accueil').insert(
    a.map((id) => ({ accueillant_id: id, debut: iso(0), fin: iso(150) })),
  );

  // Besoins de relais sur une période de vacances (dans ~3 semaines).
  await db.from('escale_besoins_relais').insert([
    { enfant_id: e[0], debut: iso(21), fin: iso(35), motif: 'Vacances de l’AF' },
    { enfant_id: e[1], debut: iso(21), fin: iso(35), motif: 'Vacances de l’AF' },
    { enfant_id: e[2], debut: iso(21), fin: iso(28), motif: 'Vacances de l’AF' },
    { enfant_id: e[4], debut: iso(10), fin: iso(17), motif: 'Stage de l’AF' },
    { enfant_id: e[5], debut: iso(40), fin: iso(54), motif: 'Vacances de l’AF' },
  ]);

  // Une incompatibilité, une préférence, une solution alternative.
  await db.from('escale_incompatibilites').insert({ enfant_a_id: e[2], enfant_b_id: e[4] });
  await db.from('escale_preferences_accueil').insert({ enfant_id: e[0], accueillant_id: a[2], type: 'favori' });
  await db.from('escale_solutions_alternatives').insert({
    enfant_id: e[3], debut: iso(21), fin: iso(28), type: 'colonie', details: 'Colonie de printemps',
  });

  revalidatePath('/');
  redirect('/parametres?demo=ok');
}
