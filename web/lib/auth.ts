// Accès partagé : un mot de passe unique + cookie de session signé (HMAC) avec
// expiration. Compatible runtime edge (middleware) et node (server actions).

export const COOKIE_SESSION = 'escale_auth';
export const DUREE_SESSION_MS = 1000 * 60 * 60 * 12; // 12 h

const enc = new TextEncoder();

function hex(buf: ArrayBuffer): string {
  return Array.from(new Uint8Array(buf))
    .map((b) => b.toString(16).padStart(2, '0'))
    .join('');
}

// Secret OBLIGATOIRE : pas de repli (sinon une mauvaise config = clé publique
// connue → cookie forgeable → accès total). On échoue volontairement fermé.
function getSecret(): string {
  const secret = process.env.SESSION_SECRET;
  if (!secret || secret.length < 32) {
    throw new Error(
      'SESSION_SECRET manquant ou trop court (≥ 32 caractères requis). ' +
        'Définissez-le avant de démarrer Escale (cf. .env.example).',
    );
  }
  return secret;
}

async function signer(message: string): Promise<string> {
  const key = await crypto.subtle.importKey(
    'raw',
    enc.encode(getSecret()),
    { name: 'HMAC', hash: 'SHA-256' },
    false,
    ['sign'],
  );
  const sig = await crypto.subtle.sign('HMAC', key, enc.encode(message));
  return hex(sig);
}

// Comparaison à temps constant (évite les attaques temporelles sur la signature).
function memeChaine(a: string, b: string): boolean {
  if (a.length !== b.length) return false;
  let diff = 0;
  for (let i = 0; i < a.length; i++) diff |= a.charCodeAt(i) ^ b.charCodeAt(i);
  return diff === 0;
}

// Jeton = `${expiration}.${signature}`. La signature couvre l'expiration, donc
// un cookie modifié OU périmé est rejeté côté serveur (le maxAge ne suffit pas).
export async function creerJeton(maintenant = Date.now()): Promise<string> {
  const exp = maintenant + DUREE_SESSION_MS;
  const sig = await signer(`escale-auth-v1.${exp}`);
  return `${exp}.${sig}`;
}

export async function jetonValide(
  jeton: string | undefined | null,
  maintenant = Date.now(),
): Promise<boolean> {
  if (!jeton) return false;
  const sep = jeton.indexOf('.');
  if (sep <= 0) return false;
  const expStr = jeton.slice(0, sep);
  const sig = jeton.slice(sep + 1);
  const exp = Number(expStr);
  if (!Number.isFinite(exp) || exp < maintenant) return false;
  const attendu = await signer(`escale-auth-v1.${expStr}`);
  return memeChaine(sig, attendu);
}

export function motDePasseValide(motDePasse: string): boolean {
  const attendu = process.env.APP_PASSWORD ?? '';
  return attendu.length > 0 && motDePasse === attendu;
}
