// Proposition automatique par backtracking (port de lib/domain/proposition.dart).

import {
  type Accueillant,
  type Affectation,
  type BesoinRelais,
  type DisponibiliteAccueil,
  type Enfant,
  type Fratrie,
  type Incompatibilite,
  type Indisponibilite,
  type PreferenceAccueil,
  type SolutionAlternative,
  prefFavori,
  regroupementEnsemble,
  relaisActif,
  statutConfirme,
} from './types';
import { jour, nbJours, periodesSeChevauchent } from './dates';
import { analyserAffectation, estBloquant } from './conflits';
import { distanceKm } from './distance';

const JOUR_MS = 86400000;

export interface Cible {
  enfant: Enfant;
  debut: Date;
  fin: Date;
  besoinId: number;
}

export interface Proposition {
  enfant: Enfant;
  accueillant: Accueillant;
  debut: Date;
  fin: Date;
  besoinId: number;
}

export interface ResultatProposition {
  propositions: Proposition[];
  nonPlaces: Cible[];
  limiteAtteinte: boolean;
}

type Intervalle = [Date, Date];

export function trousNonCouverts(debut: Date, fin: Date, couvertures: Intervalle[]): Intervalle[] {
  const res: Intervalle[] = [];
  let debutTrou: Date | null = null;
  let d = jour(debut);
  const f = jour(fin);
  while (d.getTime() <= f.getTime()) {
    const couvert = couvertures.some(
      (c) => d.getTime() >= jour(c[0]).getTime() && d.getTime() <= jour(c[1]).getTime(),
    );
    if (!couvert) {
      debutTrou ??= d;
    } else if (debutTrou) {
      res.push([debutTrou, new Date(d.getTime() - JOUR_MS)]);
      debutTrou = null;
    }
    d = new Date(d.getTime() + JOUR_MS);
  }
  if (debutTrou) res.push([debutTrou, f]);
  return res;
}

export function couverturesEnfant(
  enfantId: number,
  affectations: Affectation[],
  solutions: SolutionAlternative[],
): Intervalle[] {
  const res: Intervalle[] = [];
  for (const a of affectations) {
    if (a.enfantId === enfantId && relaisActif(a.statut)) res.push([a.debut, a.fin]);
  }
  for (const s of solutions) {
    if (s.enfantId === enfantId) res.push([s.debut, s.fin]);
  }
  return res;
}

export function fusionnerPeriodes(xs: Intervalle[]): Intervalle[] {
  const valides = xs
    .filter(([d1, f1]) => jour(f1).getTime() >= jour(d1).getTime())
    .map(([d1, f1]) => [jour(d1), jour(f1)] as Intervalle)
    .sort((a, b) => a[0].getTime() - b[0].getTime());
  if (valides.length === 0) return [];
  const res: Intervalle[] = [];
  let [debut, fin] = valides[0];
  for (const [d, f] of valides.slice(1)) {
    if (d.getTime() <= fin.getTime() + JOUR_MS) {
      if (f.getTime() > fin.getTime()) fin = f;
    } else {
      res.push([debut, fin]);
      debut = d;
      fin = f;
    }
  }
  res.push([debut, fin]);
  return res;
}

const CAP_NOEUDS = 200000;

export interface ParamsProposition {
  enfants: Enfant[];
  accueillants: Accueillant[];
  affectationsExistantes: Affectation[];
  besoins: BesoinRelais[];
  dispos: DisponibiliteAccueil[];
  indispos: Indisponibilite[];
  incompatibilites: Incompatibilite[];
  fratries?: Fratrie[];
  preferences?: PreferenceAccueil[];
  solutions?: SolutionAlternative[];
}

export function proposerAffectations(p: ParamsProposition): ResultatProposition {
  const {
    enfants,
    accueillants,
    affectationsExistantes,
    besoins,
    dispos,
    indispos,
    incompatibilites,
    fratries = [],
    preferences = [],
    solutions = [],
  } = p;

  const parEnfant = new Map(enfants.map((e) => [e.id, e]));
  const politiqueParFratrie = new Map(fratries.map((f) => [f.id, f.regroupement]));
  const dispoParAcc = new Map<number, DisponibiliteAccueil[]>();
  for (const d of dispos) {
    (dispoParAcc.get(d.accueillantId) ?? dispoParAcc.set(d.accueillantId, []).get(d.accueillantId)!).push(d);
  }
  const indispoParAcc = new Map<number, Indisponibilite[]>();
  for (const i of indispos) {
    (indispoParAcc.get(i.accueillantId) ?? indispoParAcc.set(i.accueillantId, []).get(i.accueillantId)!).push(i);
  }
  const affsActives = affectationsExistantes.filter((a) => relaisActif(a.statut));

  // 1. Cibles (trous à combler), besoins fusionnés par enfant.
  const besoinsParEnfant = new Map<number, BesoinRelais[]>();
  for (const b of besoins) {
    if (!parEnfant.has(b.enfantId)) continue;
    (besoinsParEnfant.get(b.enfantId) ?? besoinsParEnfant.set(b.enfantId, []).get(b.enfantId)!).push(b);
  }
  const cibles: Cible[] = [];
  for (const [enfantId, liste] of besoinsParEnfant) {
    const enfant = parEnfant.get(enfantId)!;
    const couvertures = couverturesEnfant(enfant.id, affectationsExistantes, solutions);
    const periodes = fusionnerPeriodes(liste.map((b) => [b.debut, b.fin] as Intervalle));
    for (const [bDebut, bFin] of periodes) {
      for (const [debut, fin] of trousNonCouverts(bDebut, bFin, couvertures)) {
        const source =
          liste.find((b) => periodesSeChevauchent(b.debut, b.fin, debut, fin)) ?? liste[0];
        cibles.push({ enfant, debut, fin, besoinId: source.id });
      }
    }
  }

  if (cibles.length === 0) return { propositions: [], nonPlaces: [], limiteAtteinte: false };

  const sansBloquant = (c: Cible, acc: Accueillant, retenues: Proposition[]): boolean => {
    const affs: Affectation[] = [
      ...affsActives,
      ...retenues.map((p2, k) => ({
        id: -(k + 1),
        enfantId: p2.enfant.id,
        accueillantId: p2.accueillant.id,
        debut: p2.debut,
        fin: p2.fin,
        besoinId: null,
        statut: statutConfirme,
        transport: null,
      })),
    ];
    const conflits = analyserAffectation({
      enfant: c.enfant,
      accueillant: acc,
      debut: c.debut,
      fin: c.fin,
      affectations: affs,
      disponibilites: dispoParAcc.get(acc.id) ?? [],
      indisponibilites: indispoParAcc.get(acc.id) ?? [],
      incompatibilites,
      enfants,
      fratries,
      preferences,
      solutions,
    });
    return !conflits.some(estBloquant);
  };

  const candidats = (c: Cible, retenues: Proposition[]): Accueillant[] => {
    const faisables = accueillants.filter((a) => sansBloquant(c, a, retenues));
    const freresDe = (): Set<number> =>
      new Set(
        enfants.filter((e) => e.fratrieId === c.enfant.fratrieId && e.id !== c.enfant.id).map((e) => e.id),
      );
    const scoreFratrie = (a: Accueillant): number => {
      if (c.enfant.fratrieId == null) return 0;
      if (politiqueParFratrie.get(c.enfant.fratrieId) !== regroupementEnsemble) return 0;
      const freres = freresDe();
      const viaExistant = affsActives.some(
        (x) => x.accueillantId === a.id && freres.has(x.enfantId) && periodesSeChevauchent(c.debut, c.fin, x.debut, x.fin),
      );
      const viaRetenu = retenues.some(
        (q) => q.accueillant.id === a.id && freres.has(q.enfant.id) && periodesSeChevauchent(c.debut, c.fin, q.debut, q.fin),
      );
      return viaExistant || viaRetenu ? 1 : 0;
    };
    const charge = (a: Accueillant): number => {
      let n = 0;
      for (const x of affsActives) {
        if (x.accueillantId === a.id && periodesSeChevauchent(c.debut, c.fin, x.debut, x.fin)) n++;
      }
      for (const q of retenues) {
        if (q.accueillant.id === a.id && periodesSeChevauchent(c.debut, c.fin, q.debut, q.fin)) n++;
      }
      return n;
    };
    const scoreFavori = (a: Accueillant): number =>
      preferences.some((x) => x.enfantId === c.enfant.id && x.accueillantId === a.id && x.type === prefFavori) ? 1 : 0;
    const scoreSecteur = (a: Accueillant): number => {
      const sa = (a.secteur ?? '').trim().toLowerCase();
      const se = (c.enfant.secteur ?? '').trim().toLowerCase();
      return sa && sa === se ? 1 : 0;
    };
    const souPlafond = (a: Accueillant): number => {
      if (a.plafondJoursAn == null) return 1;
      const annee = jour(c.debut).getFullYear();
      let cumul = nbJours(c.debut, c.fin);
      for (const x of affsActives) {
        if (x.accueillantId === a.id && jour(x.debut).getFullYear() === annee) cumul += nbJours(x.debut, x.fin);
      }
      for (const q of retenues) {
        if (q.accueillant.id === a.id && jour(q.debut).getFullYear() === annee) cumul += nbJours(q.debut, q.fin);
      }
      return cumul <= a.plafondJoursAn ? 1 : 0;
    };
    faisables.sort((a, b) => {
      const fav = scoreFavori(b) - scoreFavori(a);
      if (fav !== 0) return fav;
      const sect = scoreSecteur(b) - scoreSecteur(a);
      if (sect !== 0) return sect;
      const f = scoreFratrie(b) - scoreFratrie(a);
      if (f !== 0) return f;
      const pla = souPlafond(b) - souPlafond(a);
      if (pla !== 0) return pla;
      // Plus proche d'abord (si les deux adresses sont géolocalisées).
      const da = distanceKm(c.enfant, a);
      const db = distanceKm(c.enfant, b);
      if (da != null && db != null && da !== db) return da - db;
      const ch = charge(a) - charge(b);
      if (ch !== 0) return ch;
      return a.id - b.id; // départage stable (parité avec le desktop)
    });
    return faisables;
  };

  const ordre = [...cibles].sort((a, b) => {
    const n = candidats(a, []).length - candidats(b, []).length;
    if (n !== 0) return n;
    // Départage stable : besoin, puis enfant, puis début (parité desktop).
    if (a.besoinId !== b.besoinId) return a.besoinId - b.besoinId;
    if (a.enfant.id !== b.enfant.id) return a.enfant.id - b.enfant.id;
    return jour(a.debut).getTime() - jour(b.debut).getTime();
  });

  let courant: Proposition[] = [];
  let meilleur: Proposition[] = [];
  let meilleurNb = -1;
  let meilleurFratrie = -1;
  let noeuds = 0;
  let limite = false;

  const bonusFratrie = (sol: Proposition[]): number => {
    let n = 0;
    for (const q of sol) {
      if (q.enfant.fratrieId == null) continue;
      if (politiqueParFratrie.get(q.enfant.fratrieId) !== regroupementEnsemble) continue;
      const freres = new Set(
        enfants.filter((e) => e.fratrieId === q.enfant.fratrieId && e.id !== q.enfant.id).map((e) => e.id),
      );
      const avecFrere =
        sol.some(
          (r) => r !== q && r.accueillant.id === q.accueillant.id && freres.has(r.enfant.id) && periodesSeChevauchent(q.debut, q.fin, r.debut, r.fin),
        ) ||
        affsActives.some(
          (x) => x.accueillantId === q.accueillant.id && freres.has(x.enfantId) && periodesSeChevauchent(q.debut, q.fin, x.debut, x.fin),
        );
      if (avecFrere) n++;
    }
    return n;
  };

  const dfs = (i: number): void => {
    if (noeuds > CAP_NOEUDS) {
      limite = true;
      return;
    }
    noeuds++;
    const maxPossible = courant.length + (ordre.length - i);
    if (maxPossible < meilleurNb) return;
    if (i === ordre.length) {
      const nb = courant.length;
      const fr = bonusFratrie(courant);
      if (nb > meilleurNb || (nb === meilleurNb && fr > meilleurFratrie)) {
        meilleur = [...courant];
        meilleurNb = nb;
        meilleurFratrie = fr;
      }
      return;
    }
    const c = ordre[i];
    for (const acc of candidats(c, courant)) {
      courant.push({ enfant: c.enfant, accueillant: acc, debut: c.debut, fin: c.fin, besoinId: c.besoinId });
      dfs(i + 1);
      courant.pop();
      if (noeuds > CAP_NOEUDS) {
        limite = true;
        return;
      }
    }
    dfs(i + 1);
  };

  dfs(0);

  const cle = (besoinId: number, enfantId: number, debut: Date, fin: Date): string =>
    `${besoinId}|${enfantId}|${debut.getTime()}|${fin.getTime()}`;
  const placees = new Set(meilleur.map((q) => cle(q.besoinId, q.enfant.id, q.debut, q.fin)));
  const nonPlaces = ordre.filter((c) => !placees.has(cle(c.besoinId, c.enfant.id, c.debut, c.fin)));

  return { propositions: meilleur, nonPlaces, limiteAtteinte: limite };
}
