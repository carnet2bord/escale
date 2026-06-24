// Accès aux données : lecture Supabase + mapping snake_case → modèle domaine.

import { supabaseAdmin } from './supabase';
import type {
  Accueillant,
  Affectation,
  BesoinRelais,
  DisponibiliteAccueil,
  Enfant,
  Fratrie,
  Incompatibilite,
  Indisponibilite,
  PreferenceAccueil,
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
// eslint-disable-next-line @typescript-eslint/no-explicit-any
function mapFratrie(r: any): Fratrie {
  return { id: r.id, nom: r.nom, regroupement: r.regroupement ?? 'ensemble' };
}
// eslint-disable-next-line @typescript-eslint/no-explicit-any
function mapDispo(r: any): DisponibiliteAccueil {
  return { id: r.id, accueillantId: r.accueillant_id, debut: dDateReq(r.debut), fin: dDateReq(r.fin) };
}
// eslint-disable-next-line @typescript-eslint/no-explicit-any
function mapIndispo(r: any): Indisponibilite {
  return { id: r.id, accueillantId: r.accueillant_id, debut: dDateReq(r.debut), fin: dDateReq(r.fin), motif: r.motif };
}
// eslint-disable-next-line @typescript-eslint/no-explicit-any
function mapIncompat(r: any): Incompatibilite {
  return { id: r.id, enfantAId: r.enfant_a_id, enfantBId: r.enfant_b_id };
}
// eslint-disable-next-line @typescript-eslint/no-explicit-any
function mapPreference(r: any): PreferenceAccueil {
  return { id: r.id, enfantId: r.enfant_id, accueillantId: r.accueillant_id, type: r.type };
}

export interface Snapshot {
  accueillants: Accueillant[];
  enfants: Enfant[];
  fratries: Fratrie[];
  affectations: Affectation[];
  besoins: BesoinRelais[];
  disponibilites: DisponibiliteAccueil[];
  indisponibilites: Indisponibilite[];
  incompatibilites: Incompatibilite[];
  preferences: PreferenceAccueil[];
  solutions: SolutionAlternative[];
}

export async function chargerSnapshot(): Promise<Snapshot> {
  const db = supabaseAdmin();
  const [acc, enf, fra, aff, bes, dis, ind, inc, pre, sol] = await Promise.all([
    db.from('accueillants').select('*'),
    db.from('enfants').select('*'),
    db.from('fratries').select('*'),
    db.from('affectations').select('*'),
    db.from('besoins_relais').select('*'),
    db.from('disponibilites_accueil').select('*'),
    db.from('indisponibilites').select('*'),
    db.from('incompatibilites').select('*'),
    db.from('preferences_accueil').select('*'),
    db.from('solutions_alternatives').select('*'),
  ]);
  for (const r of [acc, enf, fra, aff, bes, dis, ind, inc, pre, sol]) {
    if (r.error) throw new Error(r.error.message);
  }
  return {
    accueillants: (acc.data ?? []).map(mapAccueillant),
    enfants: (enf.data ?? []).map(mapEnfant),
    fratries: (fra.data ?? []).map(mapFratrie),
    affectations: (aff.data ?? []).map(mapAffectation),
    besoins: (bes.data ?? []).map(mapBesoin),
    disponibilites: (dis.data ?? []).map(mapDispo),
    indisponibilites: (ind.data ?? []).map(mapIndispo),
    incompatibilites: (inc.data ?? []).map(mapIncompat),
    preferences: (pre.data ?? []).map(mapPreference),
    solutions: (sol.data ?? []).map(mapSolution),
  };
}
