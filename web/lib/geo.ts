// Géocodage via la Base Adresse Nationale (api-adresse.data.gouv.fr) — service
// public français, gratuit, sans clé. APPEL EXTERNE : l'adresse est envoyée à
// data.gouv.fr → données fictives tant que le DPO n'a pas validé.
// Le calcul de distance, lui, reste 100% local (lib/domain/distance.ts).

export interface Coord {
  latitude: number;
  longitude: number;
}

export async function geocoderBAN(adresse: string): Promise<Coord | null> {
  const q = adresse.trim();
  if (q.length < 3) return null;
  try {
    const url = `https://api-adresse.data.gouv.fr/search/?q=${encodeURIComponent(q)}&limit=1`;
    const res = await fetch(url, { signal: AbortSignal.timeout(6000) });
    if (!res.ok) return null;
    const data = await res.json();
    const f = data?.features?.[0];
    if (!f || (f.properties?.score ?? 0) < 0.3) return null;
    const coords = f.geometry?.coordinates;
    if (!Array.isArray(coords)) return null;
    const [lon, lat] = coords;
    if (typeof lat !== 'number' || typeof lon !== 'number') return null;
    return { latitude: lat, longitude: lon };
  } catch {
    return null;
  }
}
