import { createClient } from '@supabase/supabase-js';

// Client Supabase côté serveur (clé service role / rôle dédié).
// Sur Supabase AUTO-HÉBERGÉ, la passerelle Kong exige une clé `apikey` valide
// (la clé anon) ; on envoie donc l'anon comme apikey et la vraie clé de rôle
// (ex. rôle « escale_api » restreint aux tables escale_) dans Authorization.
// À n'utiliser QUE dans des composants serveur / route handlers — jamais exposé
// au navigateur.
export function supabaseAdmin() {
  const url = process.env.SUPABASE_URL;
  const key = process.env.SUPABASE_SERVICE_ROLE_KEY; // JWT de rôle (escale_api)
  const apikey = process.env.SUPABASE_ANON_KEY ?? key; // clé anon pour Kong
  if (!url || !key) {
    throw new Error('SUPABASE_URL / SUPABASE_SERVICE_ROLE_KEY manquants (.env).');
  }
  return createClient(url, apikey as string, {
    auth: { persistSession: false },
    global: { headers: { Authorization: `Bearer ${key}` } },
  });
}
