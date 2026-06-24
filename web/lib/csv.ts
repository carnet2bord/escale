// Parseur CSV robuste (BOM, délimiteur ; ou , détecté, champs entre guillemets,
// retours à la ligne dans les champs). Suffisant pour des exports Excel/Sheets.

export function parseCsv(raw: string): string[][] {
  const text = raw.replace(/^﻿/, '');
  const premiereLigne = text.split(/\r?\n/).find((l) => l.trim().length > 0) ?? '';
  const pv = (premiereLigne.match(/;/g) ?? []).length;
  const virg = (premiereLigne.match(/,/g) ?? []).length;
  const delim = pv >= virg ? ';' : ',';

  const rows: string[][] = [];
  let field = '';
  let row: string[] = [];
  let inQuotes = false;
  for (let i = 0; i < text.length; i++) {
    const c = text[i];
    if (inQuotes) {
      if (c === '"') {
        if (text[i + 1] === '"') {
          field += '"';
          i++;
        } else {
          inQuotes = false;
        }
      } else {
        field += c;
      }
    } else if (c === '"') {
      inQuotes = true;
    } else if (c === delim) {
      row.push(field);
      field = '';
    } else if (c === '\n') {
      row.push(field);
      rows.push(row);
      row = [];
      field = '';
    } else if (c !== '\r') {
      field += c;
    }
  }
  if (field.length > 0 || row.length > 0) {
    row.push(field);
    rows.push(row);
  }
  return rows.filter((r) => r.some((x) => x.trim().length > 0));
}

// Minuscule sans accents (pour comparer en-têtes et valeurs).
export function normaliser(s: string): string {
  return s
    .normalize('NFD')
    .replace(/[̀-ͯ]/g, '')
    .toLowerCase()
    .trim();
}

// Transforme un tableau de lignes en objets indexés par en-tête normalisé.
export function enObjets(rows: string[][]): Record<string, string>[] {
  if (rows.length === 0) return [];
  const entetes = rows[0].map(normaliser);
  return rows.slice(1).map((r) => {
    const o: Record<string, string> = {};
    entetes.forEach((h, i) => {
      o[h] = (r[i] ?? '').trim();
    });
    return o;
  });
}

// Récupère une valeur par synonymes d'en-tête : correspondance exacte d'abord,
// puis « contient ».
export function champ(o: Record<string, string>, synonymes: string[]): string {
  for (const s of synonymes) {
    if (o[s] != null && o[s] !== '') return o[s];
  }
  for (const s of synonymes) {
    for (const k of Object.keys(o)) {
      if (k.includes(s) && o[k] !== '') return o[k];
    }
  }
  return '';
}
