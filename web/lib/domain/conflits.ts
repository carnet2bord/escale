// Détection de conflits (port de lib/domain/conflits.dart). Mêmes règles 0–12.

import {
  type Accueillant,
  type Affectation,
  type DisponibiliteAccueil,
  type Enfant,
  type Fratrie,
  type Incompatibilite,
  type Indisponibilite,
  type PreferenceAccueil,
  type SolutionAlternative,
  prefExclu,
  regroupementEnsemble,
  regroupementSepares,
  relaisActif,
  restrictionAucune,
  sexeFille,
  solColonie,
  solTiers,
} from './types';
import { ageAnnees, dateFr, jour, nbJours, periodeFr, periodesSeChevauchent } from './dates';
import { SEUIL_DISTANCE_KM, distanceKm } from './distance';

export type Severite = 'bloquant' | 'avertissement';

export interface Conflit {
  severite: Severite;
  message: string;
}

export const estBloquant = (c: Conflit): boolean => c.severite === 'bloquant';

const nomEnfant = (e: Enfant): string => (e.prenom ? `${e.prenom} ${e.nom}` : e.nom);
const libelleSexe = (s: string): string => (s === sexeFille ? 'fille' : 'garçon');

function libelleSolution(type: string): string {
  switch (type) {
    case solColonie:
      return 'en colonie de vacances';
    case solTiers:
      return 'accueilli(e) par un tiers';
    default:
      return 'pris(e) en charge (autre solution)';
  }
}

function periodeCouverte(debut: Date, fin: Date, dispos: DisponibiliteAccueil[]): boolean {
  let d = jour(debut);
  const f = jour(fin);
  while (d.getTime() <= f.getTime()) {
    const couvert = dispos.some(
      (disp) => d.getTime() >= jour(disp.debut).getTime() && d.getTime() <= jour(disp.fin).getTime(),
    );
    if (!couvert) return false;
    d = new Date(d.getTime() + 86400000);
  }
  return true;
}

function picOccupation(debut: Date, fin: Date, intervalles: [Date, Date][]): number {
  if (intervalles.length === 0) return 0;
  const candidats = new Set<number>([jour(debut).getTime()]);
  for (const [d] of intervalles) {
    const dd = jour(d);
    if (dd.getTime() >= jour(debut).getTime() && dd.getTime() <= jour(fin).getTime()) {
      candidats.add(dd.getTime());
    }
  }
  let pic = 0;
  for (const c of candidats) {
    let n = 0;
    for (const [d, f] of intervalles) {
      if (c >= jour(d).getTime() && c <= jour(f).getTime()) n++;
    }
    if (n > pic) pic = n;
  }
  return pic;
}

export interface ParamsConflit {
  enfant: Enfant;
  accueillant: Accueillant;
  debut: Date;
  fin: Date;
  affectations: Affectation[];
  disponibilites: DisponibiliteAccueil[];
  indisponibilites: Indisponibilite[];
  incompatibilites: Incompatibilite[];
  enfants: Enfant[];
  fratries?: Fratrie[];
  preferences?: PreferenceAccueil[];
  solutions?: SolutionAlternative[];
  affectationExclueId?: number | null;
  seuilDistanceKm?: number;
}

export function analyserAffectation(p: ParamsConflit): Conflit[] {
  const {
    enfant,
    accueillant,
    debut,
    fin,
    affectations,
    disponibilites,
    indisponibilites,
    incompatibilites,
    enfants,
    fratries = [],
    preferences = [],
    solutions = [],
    affectationExclueId = null,
    seuilDistanceKm = SEUIL_DISTANCE_KM,
  } = p;
  const conflits: Conflit[] = [];

  // 0. Cohérence des dates.
  if (jour(fin).getTime() < jour(debut).getTime()) {
    conflits.push({ severite: 'bloquant', message: 'La date de fin est avant la date de début.' });
    return conflits;
  }

  const parId = new Map(enfants.map((e) => [e.id, e]));

  // 1. Restriction de sexe.
  if (accueillant.restrictionSexe !== restrictionAucune && accueillant.restrictionSexe !== enfant.sexe) {
    conflits.push({
      severite: 'bloquant',
      message: `${accueillant.nom} n'accueille que des ${libelleSexe(accueillant.restrictionSexe)}s, or ${nomEnfant(enfant)} est un(e) ${libelleSexe(enfant.sexe)}.`,
    });
  }

  // 2. Pas chez son AF habituel.
  if (enfant.afHabituelId === accueillant.id) {
    conflits.push({
      severite: 'bloquant',
      message: `${nomEnfant(enfant)} serait placé(e) chez son propre assistant familial habituel.`,
    });
  }

  // 2b. Accueillant à éviter (exclu).
  if (preferences.some((x) => x.enfantId === enfant.id && x.accueillantId === accueillant.id && x.type === prefExclu)) {
    conflits.push({
      severite: 'bloquant',
      message: `${accueillant.nom} fait partie des accueillants à éviter pour ${nomEnfant(enfant)}.`,
    });
  }

  // 3. Disponibilités (si déclarées, couverture complète exigée).
  if (disponibilites.length > 0 && !periodeCouverte(debut, fin, disponibilites)) {
    conflits.push({
      severite: 'bloquant',
      message: `${accueillant.nom} n'est pas déclaré(e) disponible sur toute la période (${periodeFr(debut, fin)}).`,
    });
  }

  // 4. Indisponibilités (vacances).
  for (const ind of indisponibilites) {
    if (periodesSeChevauchent(debut, fin, ind.debut, ind.fin)) {
      const motif = ind.motif ? ` (${ind.motif})` : '';
      conflits.push({
        severite: 'bloquant',
        message: `${accueillant.nom} est indisponible ${periodeFr(ind.debut, ind.fin)}${motif}.`,
      });
    }
  }

  // Affectations chevauchantes actives (hors celle éditée).
  const chevauchantes = affectations.filter(
    (a) => a.id !== affectationExclueId && relaisActif(a.statut) && periodesSeChevauchent(debut, fin, a.debut, a.fin),
  );

  // 5. Enfant déjà placé ailleurs.
  for (const a of chevauchantes.filter((a) => a.enfantId === enfant.id)) {
    conflits.push({
      severite: 'bloquant',
      message: `${nomEnfant(enfant)} est déjà affecté(e) ${periodeFr(a.debut, a.fin)}.`,
    });
  }

  // 5b. Enfant déjà pris en charge hors relais (colonie/tiers).
  for (const s of solutions) {
    if (s.enfantId === enfant.id && periodesSeChevauchent(debut, fin, s.debut, s.fin)) {
      conflits.push({
        severite: 'bloquant',
        message: `${nomEnfant(enfant)} est déjà ${libelleSolution(s.type)} ${periodeFr(s.debut, s.fin)}.`,
      });
    }
  }

  const chezCetAccueillant = chevauchantes.filter(
    (a) => a.accueillantId === accueillant.id && a.enfantId !== enfant.id,
  );

  // 6. Capacité.
  const pic = picOccupation(debut, fin, chezCetAccueillant.map((a) => [a.debut, a.fin]));
  if (pic + 1 > accueillant.nbPlaces) {
    conflits.push({
      severite: 'bloquant',
      message: `Capacité dépassée : ${pic + 1} enfant(s) en même temps pour ${accueillant.nbPlaces} place(s).`,
    });
  }

  // 7. Incompatibilités.
  const incompatiblesIds = new Set<number>();
  for (const inc of incompatibilites) {
    if (inc.enfantAId === enfant.id) incompatiblesIds.add(inc.enfantBId);
    if (inc.enfantBId === enfant.id) incompatiblesIds.add(inc.enfantAId);
  }
  for (const a of chezCetAccueillant) {
    if (incompatiblesIds.has(a.enfantId)) {
      const autre = parId.get(a.enfantId);
      conflits.push({
        severite: 'bloquant',
        message: `${nomEnfant(enfant)} ne doit pas être avec ${autre ? nomEnfant(autre) : 'un enfant incompatible'} (${periodeFr(a.debut, a.fin)}).`,
      });
    }
  }

  // 8. Fratrie.
  if (enfant.fratrieId != null) {
    const politique = fratries.find((f) => f.id === enfant.fratrieId)?.regroupement;
    const fratrieIds = new Set(
      enfants.filter((e) => e.fratrieId === enfant.fratrieId && e.id !== enfant.id).map((e) => e.id),
    );
    for (const a of chevauchantes.filter((a) => fratrieIds.has(a.enfantId))) {
      const frere = parId.get(a.enfantId);
      const nomFrere = frere ? nomEnfant(frere) : 'un frère/une sœur';
      const memeLieu = a.accueillantId === accueillant.id;
      if (politique === regroupementSepares && memeLieu) {
        conflits.push({
          severite: 'bloquant',
          message: `Fratrie à séparer : ${nomFrere} est accueilli(e) au même endroit sur cette période.`,
        });
      } else if (politique === regroupementEnsemble && !memeLieu) {
        conflits.push({
          severite: 'avertissement',
          message: `Fratrie séparée : ${nomFrere} est accueilli(e) ailleurs sur cette période.`,
        });
      }
    }
  }

  // 9. Tranche d'âge (avertissement).
  const age = ageAnnees(enfant.dateNaissance, debut);
  if (
    age != null &&
    ((accueillant.ageMin != null && age < accueillant.ageMin) ||
      (accueillant.ageMax != null && age > accueillant.ageMax))
  ) {
    conflits.push({
      severite: 'avertissement',
      message: `${nomEnfant(enfant)} a ${age} ans, hors de la tranche d'âge habituelle de ${accueillant.nom}.`,
    });
  }

  // 10. Échéance d'agrément (avertissement).
  if (accueillant.agrementEcheance && jour(fin).getTime() > jour(accueillant.agrementEcheance).getTime()) {
    conflits.push({
      severite: 'avertissement',
      message: `L'agrément de ${accueillant.nom} expire le ${dateFr(accueillant.agrementEcheance)}, avant la fin du relais.`,
    });
  }

  // 11. Secteur différent (avertissement).
  const secteurAcc = (accueillant.secteur ?? '').trim();
  const secteurEnf = (enfant.secteur ?? '').trim();
  if (secteurAcc && secteurEnf && secteurAcc.toLowerCase() !== secteurEnf.toLowerCase()) {
    conflits.push({
      severite: 'avertissement',
      message: `${accueillant.nom} est sur le secteur « ${secteurAcc} », différent de celui de ${nomEnfant(enfant)} (« ${secteurEnf} »).`,
    });
  }

  // 12. Plafond de jours/an (avertissement).
  if (accueillant.plafondJoursAn != null) {
    const annee = jour(debut).getFullYear();
    let cumul = nbJours(debut, fin);
    for (const a of affectations) {
      if (
        a.id !== affectationExclueId &&
        relaisActif(a.statut) &&
        a.accueillantId === accueillant.id &&
        a.enfantId !== enfant.id &&
        jour(a.debut).getFullYear() === annee
      ) {
        cumul += nbJours(a.debut, a.fin);
      }
    }
    if (cumul > accueillant.plafondJoursAn) {
      conflits.push({
        severite: 'avertissement',
        message: `Plafond de jours dépassé pour ${accueillant.nom} : ${cumul} / ${accueillant.plafondJoursAn} jour(s) en ${annee}.`,
      });
    }
  }

  // 13. Éloignement (avertissement) si les deux adresses sont géolocalisées.
  const d = distanceKm(enfant, accueillant);
  if (d != null && seuilDistanceKm > 0 && d > seuilDistanceKm) {
    conflits.push({
      severite: 'avertissement',
      message: `${accueillant.nom} est à environ ${Math.round(d)} km de ${nomEnfant(enfant)} (seuil : ${seuilDistanceKm} km).`,
    });
  }

  return conflits;
}
