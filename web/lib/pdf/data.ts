// Préparation des données pour les documents PDF (pur, testable).

import type { Snapshot } from '../data';
import { ageAnnees, periodeFr } from '../domain/dates';
import { relaisActif, sexeFille } from '../domain/types';
import { nomComplet } from '../format';
import type { InfosStructure } from '../reglages';
import { chargeParAccueillant, couvertureBesoins } from '../stats';
import type { BilanData, FicheData, PlanningData } from './documents';

const libelleSexe = (s: string): string => (s === sexeFille ? 'Fille' : 'Garçon');

const STATUT: Record<string, string> = {
  propose: 'Proposé',
  confirme: 'Confirmé',
  realise: 'Réalisé',
  annule: 'Annulé',
};

const SOLUTION: Record<string, string> = {
  colonie: 'Colonie de vacances',
  tiers: 'Accueil par un tiers',
  autre: 'Autre solution',
};

function ageTexte(naissance: Date | null, ref: Date): string {
  const a = ageAnnees(naissance, ref);
  return a == null ? '' : `${a} ans`;
}

export function ficheData(
  s: Snapshot,
  structure: InfosStructure,
  affId: number,
): FicheData | null {
  const aff = s.affectations.find((a) => a.id === affId);
  if (!aff) return null;
  const enfant = s.enfants.find((e) => e.id === aff.enfantId);
  const accueillant = s.accueillants.find((a) => a.id === aff.accueillantId);
  if (!enfant || !accueillant) return null;
  const af = enfant.afHabituelId
    ? s.accueillants.find((a) => a.id === enfant.afHabituelId)
    : null;
  return {
    structure,
    enfant: {
      nom: nomComplet(enfant),
      sexe: libelleSexe(enfant.sexe),
      age: ageTexte(enfant.dateNaissance, aff.debut),
      secteur: enfant.secteur ?? '',
      afHabituel: af ? nomComplet(af) : '',
      sante: enfant.sante ?? '',
      contactUrgence: enfant.contactUrgence ?? '',
    },
    accueillant: {
      nom: nomComplet(accueillant),
      places: String(accueillant.nbPlaces),
      secteur: accueillant.secteur ?? '',
    },
    periode: periodeFr(aff.debut, aff.fin),
    transport: aff.transport ?? '',
  };
}

export function bilanData(s: Snapshot, structure: InfosStructure): BilanData {
  const cov = couvertureBesoins(s);
  const charges = chargeParAccueillant(s);
  const lignes = s.accueillants
    .map((a) => {
      const c = charges.get(a.id);
      return { nom: nomComplet(a), nbRelais: c?.nbRelais ?? 0, nbJours: c?.nbJours ?? 0 };
    })
    .filter((l) => l.nbRelais > 0)
    .sort((a, b) => b.nbJours - a.nbJours);
  return {
    structure,
    nbEnfants: s.enfants.length,
    nbAccueillants: s.accueillants.length,
    nbRelais: s.affectations.filter((a) => relaisActif(a.statut)).length,
    couverturePct: cov.pct,
    couvertureTexte: `${cov.couverts} / ${cov.total} journées`,
    charges: lignes,
  };
}

export function planningAccueillantData(
  s: Snapshot,
  structure: InfosStructure,
  accId: number,
): PlanningData | null {
  const acc = s.accueillants.find((a) => a.id === accId);
  if (!acc) return null;
  const enfById = new Map(s.enfants.map((e) => [e.id, e]));
  const lignes = s.affectations
    .filter((a) => a.accueillantId === accId)
    .sort((a, b) => a.debut.getTime() - b.debut.getTime())
    .map((a) => {
      const enf = enfById.get(a.enfantId);
      const info = [STATUT[a.statut] ?? a.statut, a.transport ? `Transport : ${a.transport}` : '']
        .filter(Boolean)
        .join(' — ');
      return { periode: periodeFr(a.debut, a.fin), lieu: enf ? nomComplet(enf) : '—', info };
    });
  return { structure, titre: `Planning — ${nomComplet(acc)}`, colonneLieu: 'Enfant', lignes };
}

export function planningEnfantData(
  s: Snapshot,
  structure: InfosStructure,
  enfId: number,
): PlanningData | null {
  const enf = s.enfants.find((e) => e.id === enfId);
  if (!enf) return null;
  const accById = new Map(s.accueillants.map((a) => [a.id, a]));
  type Item = { debut: Date; periode: string; lieu: string; info: string };
  const items: Item[] = [];
  for (const a of s.affectations.filter((x) => x.enfantId === enfId)) {
    const acc = accById.get(a.accueillantId);
    items.push({
      debut: a.debut,
      periode: periodeFr(a.debut, a.fin),
      lieu: acc ? `Relais : ${nomComplet(acc)}` : 'Relais',
      info: [STATUT[a.statut] ?? a.statut, a.transport ? `Transport : ${a.transport}` : '']
        .filter(Boolean)
        .join(' — '),
    });
  }
  for (const sol of s.solutions.filter((x) => x.enfantId === enfId)) {
    items.push({
      debut: sol.debut,
      periode: periodeFr(sol.debut, sol.fin),
      lieu: SOLUTION[sol.type] ?? sol.type,
      info: sol.details ?? '',
    });
  }
  items.sort((a, b) => a.debut.getTime() - b.debut.getTime());
  return {
    structure,
    titre: `Parcours — ${nomComplet(enf)}`,
    colonneLieu: 'Lieu',
    lignes: items.map(({ periode, lieu, info }) => ({ periode, lieu, info })),
  };
}
