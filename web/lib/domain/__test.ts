// Vérification rapide de la logique métier portée (lancer : npx tsx __test.ts).
import { analyserAffectation, estBloquant, type Conflit } from './conflits';
import { proposerAffectations } from './proposition';
import {
  type Accueillant,
  type Affectation,
  type Enfant,
  statutAnnule,
  statutConfirme,
} from './types';

let ok = 0;
let ko = 0;
function check(nom: string, cond: boolean) {
  if (cond) {
    ok++;
  } else {
    ko++;
    console.error('  ✗ ' + nom);
  }
}

const d = (j: number) => new Date(2026, 6, j); // juillet 2026

function enfant(o: Partial<Enfant> & { id: number }): Enfant {
  return {
    nom: 'Dupont', prenom: '', sexe: 'garcon', dateNaissance: null,
    afHabituelId: null, fratrieId: null, sante: null, contactUrgence: null,
    secteur: null, adresse: null, latitude: null, longitude: null,
    notes: null, ...o,
  };
}
function acc(o: Partial<Accueillant> & { id: number }): Accueillant {
  return {
    nom: 'Martin', prenom: '', nbPlaces: 1, restrictionSexe: 'aucune',
    ageMin: null, ageMax: null, agrementEcheance: null, plafondJoursAn: null,
    secteur: null, adresse: null, latitude: null, longitude: null,
    notes: null, ...o,
  };
}
function aff(o: Partial<Affectation> & { id: number; enfantId: number; accueillantId: number; debut: Date; fin: Date }): Affectation {
  return { besoinId: null, statut: statutConfirme, transport: null, ...o };
}
const bloq = (c: Conflit[]) => c.some(estBloquant);
const avert = (c: Conflit[]) => c.some((x) => x.severite === 'avertissement');

const base = {
  affectations: [] as Affectation[], disponibilites: [], indisponibilites: [],
  incompatibilites: [], enfants: [] as Enfant[],
};

// Restriction de sexe.
{
  const e = enfant({ id: 1, sexe: 'garcon' });
  const c = analyserAffectation({ ...base, enfant: e, accueillant: acc({ id: 10, restrictionSexe: 'fille' }), debut: d(1), fin: d(3), enfants: [e] });
  check('restriction de sexe bloque', bloq(c));
}
// AF habituel.
{
  const e = enfant({ id: 1, afHabituelId: 10 });
  const c = analyserAffectation({ ...base, enfant: e, accueillant: acc({ id: 10 }), debut: d(1), fin: d(3), enfants: [e] });
  check('AF habituel bloque', bloq(c));
}
// Capacité.
{
  const e1 = enfant({ id: 1 }), e2 = enfant({ id: 2, nom: 'Durand' });
  const c = analyserAffectation({ ...base, enfant: e2, accueillant: acc({ id: 10, nbPlaces: 1 }), debut: d(1), fin: d(7), enfants: [e1, e2], affectations: [aff({ id: 100, enfantId: 1, accueillantId: 10, debut: d(3), fin: d(5) })] });
  check('capacité dépassée bloque', bloq(c));
}
// Relais annulé n'occupe pas.
{
  const e1 = enfant({ id: 1 }), e2 = enfant({ id: 2, nom: 'Durand' });
  const c = analyserAffectation({ ...base, enfant: e2, accueillant: acc({ id: 10, nbPlaces: 1 }), debut: d(1), fin: d(7), enfants: [e1, e2], affectations: [aff({ id: 100, enfantId: 1, accueillantId: 10, debut: d(3), fin: d(5), statut: statutAnnule })] });
  check('relais annulé n\'occupe pas', !bloq(c));
}
// Secteur différent → avertissement.
{
  const e = enfant({ id: 1, secteur: 'Sud' });
  const c = analyserAffectation({ ...base, enfant: e, accueillant: acc({ id: 10, secteur: 'Nord' }), debut: d(1), fin: d(3), enfants: [e] });
  check('secteur différent avertit', avert(c) && !bloq(c));
}
// Plafond dépassé → avertissement.
{
  const e = enfant({ id: 1 });
  const c = analyserAffectation({ ...base, enfant: e, accueillant: acc({ id: 10, plafondJoursAn: 5 }), debut: d(1), fin: d(10), enfants: [e] });
  check('plafond dépassé avertit', avert(c) && !bloq(c));
}
// Proposition : un besoin simple est placé.
{
  const r = proposerAffectations({
    enfants: [enfant({ id: 1 })], accueillants: [acc({ id: 10 })],
    affectationsExistantes: [], besoins: [{ id: 1, enfantId: 1, debut: d(1), fin: d(7), motif: null }],
    dispos: [], indispos: [], incompatibilites: [],
  });
  check('proposition place un besoin', r.propositions.length === 1 && r.nonPlaces.length === 0);
}
// Proposition : AF habituel seul → non placé.
{
  const r = proposerAffectations({
    enfants: [enfant({ id: 1, afHabituelId: 10 })], accueillants: [acc({ id: 10 })],
    affectationsExistantes: [], besoins: [{ id: 1, enfantId: 1, debut: d(1), fin: d(7), motif: null }],
    dispos: [], indispos: [], incompatibilites: [],
  });
  check('AF habituel seul → non placé', r.propositions.length === 0 && r.nonPlaces.length === 1);
}

// Distance : relais éloigné → avertissement (Paris ↔ Lyon ≈ 390 km).
{
  const e = enfant({ id: 1, latitude: 48.8566, longitude: 2.3522 });
  const a = acc({ id: 10, latitude: 45.7578, longitude: 4.832 });
  const c = analyserAffectation({ ...base, enfant: e, accueillant: a, debut: d(1), fin: d(3), enfants: [e], seuilDistanceKm: 30 });
  check('relais éloigné avertit', avert(c) && !bloq(c));
}
// Distance : sans coordonnées, pas d'avertissement d'éloignement.
{
  const e = enfant({ id: 1 });
  const c = analyserAffectation({ ...base, enfant: e, accueillant: acc({ id: 10 }), debut: d(1), fin: d(3), enfants: [e], seuilDistanceKm: 30 });
  check('pas de distance sans coords', !avert(c));
}
// Distance : la proposition préfère l'accueillant le plus proche.
{
  const r = proposerAffectations({
    enfants: [enfant({ id: 1, latitude: 48.85, longitude: 2.35 })],
    accueillants: [
      acc({ id: 10, latitude: 45.75, longitude: 4.83 }), // loin (Lyon)
      acc({ id: 11, latitude: 48.86, longitude: 2.34 }), // proche (Paris)
    ],
    affectationsExistantes: [], besoins: [{ id: 1, enfantId: 1, debut: d(1), fin: d(7), motif: null }],
    dispos: [], indispos: [], incompatibilites: [],
  });
  check('proposition préfère le plus proche', r.propositions[0]?.accueillant.id === 11);
}

console.log(`\nDomaine web : ${ok} ok, ${ko} ko`);
if (ko > 0) process.exit(1);
