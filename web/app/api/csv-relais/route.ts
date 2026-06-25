import { chargerSnapshot } from '@/lib/data';
import { dateFr } from '@/lib/domain/dates';
import { relaisActif } from '@/lib/domain/types';
import { nomComplet } from '@/lib/format';

export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';

const STATUT: Record<string, string> = {
  propose: 'Proposé',
  confirme: 'Confirmé',
  realise: 'Réalisé',
  annule: 'Annulé',
};

function champ(v: string): string {
  return /[;"\n]/.test(v) ? `"${v.replace(/"/g, '""')}"` : v;
}

// Export CSV des relais (séparateur ;, BOM UTF-8) — équivalent du desktop.
export async function GET() {
  const s = await chargerSnapshot();
  const enf = new Map(s.enfants.map((e) => [e.id, e]));
  const acc = new Map(s.accueillants.map((a) => [a.id, a]));
  const lignes = [['Enfant', 'Accueillant', 'Début', 'Fin', 'Statut', 'Transport']];
  for (const a of [...s.affectations].sort((x, y) => x.debut.getTime() - y.debut.getTime())) {
    if (!relaisActif(a.statut)) continue;
    const e = enf.get(a.enfantId);
    const c = acc.get(a.accueillantId);
    lignes.push([
      e ? nomComplet(e) : '',
      c ? nomComplet(c) : '',
      dateFr(a.debut),
      dateFr(a.fin),
      STATUT[a.statut] ?? a.statut,
      a.transport ?? '',
    ]);
  }
  const csv = '﻿' + lignes.map((l) => l.map(champ).join(';')).join('\r\n');
  return new Response(csv, {
    headers: {
      'Content-Type': 'text/csv; charset=utf-8',
      'Content-Disposition': 'attachment; filename="escale-relais.csv"',
    },
  });
}
