// Utilitaires de dates (port de lib/domain/dates.dart). Raisonnement au jour près.

export function jour(d: Date): Date {
  return new Date(d.getFullYear(), d.getMonth(), d.getDate());
}

export function periodesSeChevauchent(
  a1: Date,
  a2: Date,
  b1: Date,
  b2: Date,
): boolean {
  const d1 = jour(a1).getTime();
  const f1 = jour(a2).getTime();
  const d2 = jour(b1).getTime();
  const f2 = jour(b2).getTime();
  return d1 <= f2 && d2 <= f1;
}

export function nbJours(debut: Date, fin: Date): number {
  const ms = jour(fin).getTime() - jour(debut).getTime();
  return Math.floor(ms / 86400000) + 1;
}

export function ageAnnees(naissance: Date | null, ref?: Date): number | null {
  if (!naissance) return null;
  const a = ref ?? new Date();
  let age = a.getFullYear() - naissance.getFullYear();
  if (
    a.getMonth() < naissance.getMonth() ||
    (a.getMonth() === naissance.getMonth() && a.getDate() < naissance.getDate())
  ) {
    age--;
  }
  return age < 0 ? null : age;
}

const MOIS = [
  'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
  'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre',
];

function pad2(n: number): string {
  return n < 10 ? `0${n}` : `${n}`;
}

export function dateFr(d: Date): string {
  return `${pad2(d.getDate())}/${pad2(d.getMonth() + 1)}/${d.getFullYear()}`;
}

export function dateLongueFr(d: Date): string {
  return `${d.getDate()} ${MOIS[d.getMonth()]} ${d.getFullYear()}`;
}

export function periodeFr(debut: Date, fin: Date): string {
  if (jour(debut).getTime() === jour(fin).getTime()) return `le ${dateFr(debut)}`;
  return `du ${dateFr(debut)} au ${dateFr(fin)}`;
}
