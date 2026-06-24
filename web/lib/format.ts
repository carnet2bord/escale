// Formatage des dates ISO (YYYY-MM-DD) renvoyées par Supabase vers le français.
export function frDate(s: string | null | undefined): string {
  if (!s) return '';
  const [y, m, d] = s.split('-');
  if (!y || !m || !d) return s;
  return `${d}/${m}/${y}`;
}

export function nomComplet(p: { prenom?: string | null; nom?: string | null }): string {
  return [p.prenom, p.nom].filter(Boolean).join(' ').trim();
}

// Date JS → chaîne ISO YYYY-MM-DD (pour les colonnes date de Postgres).
export function isoDate(d: Date): string {
  const p = (n: number) => String(n).padStart(2, '0');
  return `${d.getFullYear()}-${p(d.getMonth() + 1)}-${p(d.getDate())}`;
}
