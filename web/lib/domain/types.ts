// Modèle de données d'Escale (version web), miroir du modèle desktop.

export const sexeGarcon = 'garcon';
export const sexeFille = 'fille';

export const restrictionAucune = 'aucune';
export const restrictionGarcon = 'garcon';
export const restrictionFille = 'fille';

export const regroupementEnsemble = 'ensemble';
export const regroupementSepares = 'separes';
export const regroupementIndifferent = 'indifferent';

export const prefFavori = 'favori';
export const prefExclu = 'exclu';

export const solColonie = 'colonie';
export const solTiers = 'tiers';
export const solAutre = 'autre';

export const statutPropose = 'propose';
export const statutConfirme = 'confirme';
export const statutRealise = 'realise';
export const statutAnnule = 'annule';

export const relaisActif = (statut: string): boolean => statut !== statutAnnule;

export interface Accueillant {
  id: number;
  nom: string;
  prenom: string;
  nbPlaces: number;
  restrictionSexe: string;
  ageMin: number | null;
  ageMax: number | null;
  agrementEcheance: Date | null;
  plafondJoursAn: number | null;
  secteur: string | null;
  adresse: string | null;
  latitude: number | null;
  longitude: number | null;
  notes: string | null;
}

export interface Fratrie {
  id: number;
  nom: string;
  regroupement: string;
}

export interface Enfant {
  id: number;
  nom: string;
  prenom: string;
  sexe: string;
  dateNaissance: Date | null;
  afHabituelId: number | null;
  fratrieId: number | null;
  sante: string | null;
  contactUrgence: string | null;
  secteur: string | null;
  adresse: string | null;
  latitude: number | null;
  longitude: number | null;
  notes: string | null;
}

export interface DisponibiliteAccueil {
  id: number;
  accueillantId: number;
  debut: Date;
  fin: Date;
}

export interface Indisponibilite {
  id: number;
  accueillantId: number;
  debut: Date;
  fin: Date;
  motif: string | null;
}

export interface BesoinRelais {
  id: number;
  enfantId: number;
  debut: Date;
  fin: Date;
  motif: string | null;
}

export interface Affectation {
  id: number;
  enfantId: number;
  accueillantId: number;
  debut: Date;
  fin: Date;
  besoinId: number | null;
  statut: string;
  transport: string | null;
}

export interface Incompatibilite {
  id: number;
  enfantAId: number;
  enfantBId: number;
}

export interface PreferenceAccueil {
  id: number;
  enfantId: number;
  accueillantId: number;
  type: string;
}

export interface SolutionAlternative {
  id: number;
  enfantId: number;
  debut: Date;
  fin: Date;
  type: string;
  details: string | null;
}
