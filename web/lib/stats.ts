// Statistiques partagées (tableau de bord + bilan PDF).

import type { Snapshot } from './data';
import { jour, nbJours } from './domain/dates';
import { couverturesEnfant, fusionnerPeriodes } from './domain/proposition';
import { relaisActif } from './domain/types';

const JOUR_MS = 86400000;

export interface Couverture {
  total: number;
  couverts: number;
  pct: number | null; // null = aucun besoin recensé
}

export function couvertureBesoins(s: Snapshot): Couverture {
  // Regrouper les besoins par enfant et FUSIONNER les périodes pour ne pas
  // compter deux fois les jours communs à des besoins qui se chevauchent.
  const parEnfant = new Map<number, [Date, Date][]>();
  for (const b of s.besoins) {
    if (jour(b.fin).getTime() < jour(b.debut).getTime()) continue;
    const liste = parEnfant.get(b.enfantId) ?? [];
    liste.push([b.debut, b.fin]);
    parEnfant.set(b.enfantId, liste);
  }

  let total = 0;
  let couverts = 0;
  for (const [enfantId, periodes] of parEnfant) {
    const cov = couverturesEnfant(enfantId, s.affectations, s.solutions);
    for (const [d0, f0] of fusionnerPeriodes(periodes)) {
      let d = jour(d0);
      const f = jour(f0);
      while (d.getTime() <= f.getTime()) {
        total++;
        if (
          cov.some(
            (c) => d.getTime() >= jour(c[0]).getTime() && d.getTime() <= jour(c[1]).getTime(),
          )
        ) {
          couverts++;
        }
        d = new Date(d.getTime() + JOUR_MS);
      }
    }
  }
  return { total, couverts, pct: total === 0 ? null : Math.round((couverts * 100) / total) };
}

export interface ChargeAccueillant {
  accueillantId: number;
  nbRelais: number;
  nbJours: number;
}

// Charge par accueillant (relais actifs uniquement).
export function chargeParAccueillant(s: Snapshot): Map<number, ChargeAccueillant> {
  const m = new Map<number, ChargeAccueillant>();
  for (const a of s.affectations) {
    if (!relaisActif(a.statut)) continue;
    const c = m.get(a.accueillantId) ?? {
      accueillantId: a.accueillantId,
      nbRelais: 0,
      nbJours: 0,
    };
    c.nbRelais += 1;
    c.nbJours += nbJours(a.debut, a.fin);
    m.set(a.accueillantId, c);
  }
  return m;
}
