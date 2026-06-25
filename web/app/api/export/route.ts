import { supabaseAdmin } from '@/lib/supabase';

export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';

const TABLES = [
  'escale_accueillants',
  'escale_fratries',
  'escale_enfants',
  'escale_disponibilites_accueil',
  'escale_indisponibilites',
  'escale_besoins_relais',
  'escale_affectations',
  'escale_incompatibilites',
  'escale_preferences_accueil',
  'escale_solutions_alternatives',
  'escale_reglages',
];

// Sauvegarde JSON de toutes les données (équivalent web du « Sauvegarder » desktop).
export async function GET() {
  const db = supabaseAdmin();
  const dump: Record<string, unknown[]> = {};
  for (const t of TABLES) {
    const { data, error } = await db.from(t).select('*');
    if (error) return new Response(error.message, { status: 500 });
    dump[t] = data ?? [];
  }
  const corps = JSON.stringify({ version: 1, tables: dump }, null, 2);
  return new Response(corps, {
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Content-Disposition': 'attachment; filename="escale-sauvegarde.json"',
    },
  });
}
