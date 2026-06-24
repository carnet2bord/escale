// Limitation anti-brute-force en mémoire (par IP). Suffisant pour un mono-poste
// auto-hébergé ; pour un déploiement multi-instances, remplacer par Redis/DB.

interface Etat {
  echecs: number;
  premier: number;
  bloqueJusqua: number;
}

const FENETRE_MS = 5 * 60 * 1000; // fenêtre glissante de comptage
const MAX_ECHECS = 5; // au-delà → blocage
const BLOCAGE_MS = 5 * 60 * 1000; // durée du blocage

const parIp = new Map<string, Etat>();

export function estBloque(ip: string, maintenant = Date.now()): boolean {
  const e = parIp.get(ip);
  return !!e && e.bloqueJusqua > maintenant;
}

export function enregistrerEchec(ip: string, maintenant = Date.now()): void {
  let e = parIp.get(ip);
  if (!e || maintenant - e.premier > FENETRE_MS) {
    e = { echecs: 0, premier: maintenant, bloqueJusqua: 0 };
  }
  e.echecs += 1;
  if (e.echecs >= MAX_ECHECS) e.bloqueJusqua = maintenant + BLOCAGE_MS;
  parIp.set(ip, e);
}

export function reinitialiser(ip: string): void {
  parIp.delete(ip);
}
