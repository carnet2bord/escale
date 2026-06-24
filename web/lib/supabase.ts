import { createClient } from '@supabase/supabase-js';

// Client Supabase côté serveur (clé service role). À n'utiliser QUE dans des
// composants serveur / route handlers — jamais exposé au navigateur.
export function supabaseAdmin() {
  const url = process.env.SUPABASE_URL;
  const key = process.env.SUPABASE_SERVICE_ROLE_KEY;
  if (!url || !key) {
    throw new Error('SUPABASE_URL / SUPABASE_SERVICE_ROLE_KEY manquants (.env).');
  }
  return createClient(url, key, { auth: { persistSession: false } });
}
