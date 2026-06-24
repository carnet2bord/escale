// Accès aux données : lecture Supabase + mapping snake_case → modèle domaine.

import { supabaseAdmin } from './supabase';
import type {
  Accueillant,
  Affectation,
  BesoinRelais,
  Enfant,
  SolutionAlternative,
} from './domain/types';

function dDate(v: string | null): Date | null {
  return v ? new Date(`${v}T00:00:00`) : null;
}
function dDateReq(v: string): Date {
  return new Date(`${v}T00:00:00`);
}

// eslint-disable-next-line @typescript-eslint/no-explicit-any
function mapAccueillant(r: any): Accueillant {
  return {
    id: r.id, nom: r.nom, prenom: r.prenom ?? '', nbPlaces: r.nb_places ?? 1,
    restrictionSexe: r.restriction_sexe ?? 'aucune', ageMin: r.age_min,
    ageMax: r.age_max, agrementEcheance: dDate(r.agrement_echeance),
    plafondJoursAn: r.plafond_jours_an, secteur: r.secteur, notes: r.notes,
  };
}
// eslint-disable-next-line @typescript-eslint/no-explicit-any
function mapEnfant(r: any): Enfant {
  return {
    id: r.id, nom: r.nom, prenom: r.prenom ?? '', sexe: r.sexe ?? 'garcon',
    dateNaissance: dDate(r.date_naissance), afHabituelId: r.af_habituel_id,
    fratrieId: r.fratrie_id, sante: r.sante, contactUrgence: r.contact_urgence,
    secteur: r.secteur, notes: r.notes,
  };
}
// eslint-disable-next-line @typescript-eslint/no-explicit-any
function mapAffectation(r: any): Affectation {
  return {
    id: r.id, enfantId: r.enfant_id, accueillantId: r.accueillant_id,
    debut: dDateReq(r.debut), fin: dDateReq(r.fin), besoinId: r.besoin_id,
    statut: r.statut ?? 'confirme', transport: r.transport,
  };
}
// eslint-disable-next-line @typescript-eslint/no-explicit-any
function mapBesoin(r: any): BesoinRelais {
  return { id: r.id, enfantId: r.enfant_id, debut: dDateReq(r.debut), fin: dDateReq(r.fin), motif: r.motif };
}
// eslint-disable-next-line @typescript-eslint/no-explicit-any
function mapSolution(r: any): SolutionAlternative {
  return { id: r.id, enfantId: r.enfant_id, debut: dDateReq(r.debut), fin: dDateReq(r.fin), type: r.type, details: r.details };
}

export interface Snapshot {
  accueillants: Accueillant[];
  enfants: Enfant[];
  affectations: Affectation[];
  besoins: BesoinRelais[];
  solutions: SolutionAlternative[];
}

export async function chargerSnapshot(): Promise<Snapshot> {
  const db = supabaseAdmin();
  const [acc, enf, aff, bes, sol] = await Promise.all([
    db.from('accueillants').select('*'),
    db.from('enfants').select('*'),
    db.from('affectations').select('*'),
    db.from('besoins_relais').select('*'),
    db.from('solutions_alternatives').select('*'),
  ]);
  for (const r of [acc, enf, aff, bes, sol]) {
    if (r.error) throw new Error(r.error.message);
  }
  return {
    accueillants: (acc.data ?? []).map(mapAccueillant),
    enfants: (enf.data ?? []).map(mapEnfant),
    affectations: (aff.data ?? []).map(mapAffectation),
    besoins: (bes.data ?? []).map(mapBesoin),
    solutions: (sol.data ?? []).map(mapSolution),
  };
}
