// Mapping des lignes CSV vers les colonnes des tables (pur, testable).

import { champ, normaliser } from './csv';

export interface RowAccueillant {
  nom: string;
  prenom: string;
  nb_places: number;
  restriction_sexe: string;
  secteur: string | null;
  notes: string | null;
}

export interface RowEnfant {
  nom: string;
  prenom: string;
  sexe: string;
  date_naissance: string | null;
  secteur: string | null;
  notes: string | null;
}

function entier(v: string, defaut: number): number {
  const n = parseInt(v.replace(/[^0-9-]/g, ''), 10);
  return Number.isFinite(n) && n > 0 ? n : defaut;
}

function restriction(v: string): string {
  const n = normaliser(v);
  if (!n) return 'aucune';
  if (n.includes('garc') || n.includes('garç')) return 'garcon';
  if (n.includes('fille')) return 'fille';
  return 'aucune';
}

function sexe(v: string): string {
  return normaliser(v).startsWith('f') ? 'fille' : 'garcon';
}

// Accepte AAAA-MM-JJ, JJ/MM/AAAA, JJ-MM-AAAA → renvoie AAAA-MM-JJ ou null.
export function dateIso(v: string): string | null {
  const s = v.trim();
  if (/^\d{4}-\d{2}-\d{2}$/.test(s)) return s;
  const m = s.match(/^(\d{1,2})[/.-](\d{1,2})[/.-](\d{2,4})$/);
  if (m) {
    const j = m[1].padStart(2, '0');
    const mo = m[2].padStart(2, '0');
    let a = m[3];
    if (a.length === 2) a = (Number(a) > 50 ? '19' : '20') + a;
    if (Number(mo) >= 1 && Number(mo) <= 12 && Number(j) >= 1 && Number(j) <= 31) {
      return `${a}-${mo}-${j}`;
    }
  }
  return null;
}

const SYN_NOM = ['nom', 'nom de famille'];
const SYN_PRENOM = ['prenom'];
const SYN_SECTEUR = ['secteur', 'zone'];
const SYN_NOTES = ['notes', 'remarques', 'commentaire', 'commentaires', 'observations'];

export function mapAccueillants(objs: Record<string, string>[]): RowAccueillant[] {
  const res: RowAccueillant[] = [];
  for (const o of objs) {
    const nom = champ(o, SYN_NOM);
    if (!nom) continue;
    res.push({
      nom,
      prenom: champ(o, SYN_PRENOM),
      nb_places: entier(champ(o, ['places', 'nb places', 'nombre de places', 'capacite']), 1),
      restriction_sexe: restriction(
        champ(o, ['restriction', 'restriction sexe', 'sexe accueilli', 'accueille']),
      ),
      secteur: champ(o, SYN_SECTEUR) || null,
      notes: champ(o, SYN_NOTES) || null,
    });
  }
  return res;
}

export function mapEnfants(objs: Record<string, string>[]): RowEnfant[] {
  const res: RowEnfant[] = [];
  for (const o of objs) {
    const nom = champ(o, SYN_NOM);
    if (!nom) continue;
    res.push({
      nom,
      prenom: champ(o, SYN_PRENOM),
      sexe: sexe(champ(o, ['sexe', 'genre'])),
      date_naissance: dateIso(
        champ(o, ['date de naissance', 'date naissance', 'naissance', 'ddn']),
      ),
      secteur: champ(o, SYN_SECTEUR) || null,
      notes: champ(o, SYN_NOTES) || null,
    });
  }
  return res;
}

export const cleNom = (r: { nom: string; prenom: string }): string =>
  `${normaliser(r.nom)}|${normaliser(r.prenom)}`;
