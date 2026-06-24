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

// Construit AAAA-MM-JJ seulement si la date existe réellement (rejette 31/02,
// 2020-13-40, etc.) via un aller-retour Date.
function composer(a: number, mo: number, j: number): string | null {
  if (!Number.isFinite(a) || !Number.isFinite(mo) || !Number.isFinite(j)) return null;
  const d = new Date(Date.UTC(a, mo - 1, j));
  if (d.getUTCFullYear() !== a || d.getUTCMonth() !== mo - 1 || d.getUTCDate() !== j) {
    return null;
  }
  const p = (n: number) => String(n).padStart(2, '0');
  return `${a}-${p(mo)}-${p(j)}`;
}

// Accepte AAAA-MM-JJ, JJ/MM/AAAA, JJ-MM-AAAA → renvoie AAAA-MM-JJ valide ou null.
export function dateIso(v: string): string | null {
  const s = v.trim();
  const iso = s.match(/^(\d{4})-(\d{2})-(\d{2})$/);
  if (iso) return composer(Number(iso[1]), Number(iso[2]), Number(iso[3]));
  const m = s.match(/^(\d{1,2})[/.-](\d{1,2})[/.-](\d{2,4})$/);
  if (m) {
    let a = m[3];
    if (a.length === 2) a = (Number(a) > 50 ? '19' : '20') + a;
    return composer(Number(a), Number(m[2]), Number(m[1]));
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

// Pour les enfants, la date de naissance distingue les homonymes.
export const cleEnfant = (r: { nom: string; prenom: string; date_naissance: string | null }): string =>
  `${cleNom(r)}|${r.date_naissance ?? ''}`;
