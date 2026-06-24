// Détermination des « dossiers clos » (enfants dont toute activité est passée).
// Partagé entre la page /purge et l'action serveur, pour que l'écriture
// REVALIDE toujours le statut clos (jamais d'anonymisation d'un dossier actif).

import type { Snapshot } from './data';
import { jour } from './domain/dates';
import { relaisActif } from './domain/types';

export interface DossierClos {
  id: number;
  derniere: number; // timestamp de la dernière activité
}

// Un dossier est clos s'il a au moins une activité ET aucune en cours/à venir.
export function dossiersClos(s: Snapshot, maintenant: number): DossierClos[] {
  const res: DossierClos[] = [];
  for (const e of s.enfants) {
    const fins: number[] = [];
    for (const b of s.besoins) if (b.enfantId === e.id) fins.push(jour(b.fin).getTime());
    for (const a of s.affectations) {
      if (a.enfantId === e.id && relaisActif(a.statut)) fins.push(jour(a.fin).getTime());
    }
    for (const so of s.solutions) if (so.enfantId === e.id) fins.push(jour(so.fin).getTime());
    if (fins.length === 0) continue;
    const derniere = Math.max(...fins);
    if (derniere >= maintenant) continue;
    res.push({ id: e.id, derniere });
  }
  return res;
}
