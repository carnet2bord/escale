// Accès partagé : un mot de passe unique + cookie de session signé (HMAC).
// Compatible runtime edge (middleware) et node (server actions) via Web Crypto.

export const COOKIE_SESSION = 'escale_auth';

const enc = new TextEncoder();

function hex(buf: ArrayBuffer): string {
  return Array.from(new Uint8Array(buf))
    .map((b) => b.toString(16).padStart(2, '0'))
    .join('');
}

// Jeton attendu dans le cookie : HMAC(SESSION_SECRET, constante). Ne contient
// pas le mot de passe ; il prouve seulement que la connexion a été validée.
export async function jetonSession(): Promise<string> {
  const secret = process.env.SESSION_SECRET ?? 'dev-secret-a-changer';
  const key = await crypto.subtle.importKey(
    'raw',
    enc.encode(secret),
    { name: 'HMAC', hash: 'SHA-256' },
    false,
    ['sign'],
  );
  const sig = await crypto.subtle.sign('HMAC', key, enc.encode('escale-auth-v1'));
  return hex(sig);
}

export function motDePasseValide(motDePasse: string): boolean {
  const attendu = process.env.APP_PASSWORD ?? '';
  return attendu.length > 0 && motDePasse === attendu;
}
