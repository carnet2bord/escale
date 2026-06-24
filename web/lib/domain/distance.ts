// Distance géographique entre deux points (formule de Haversine). 100% local.

export interface Point {
  latitude: number | null;
  longitude: number | null;
}

const R_TERRE_KM = 6371;

function rad(d: number): number {
  return (d * Math.PI) / 180;
}

// Distance en km entre deux coordonnées, ou null si l'une est inconnue.
export function distanceKm(a: Point, b: Point): number | null {
  if (
    a.latitude == null ||
    a.longitude == null ||
    b.latitude == null ||
    b.longitude == null
  ) {
    return null;
  }
  const dLat = rad(b.latitude - a.latitude);
  const dLon = rad(b.longitude - a.longitude);
  const lat1 = rad(a.latitude);
  const lat2 = rad(b.latitude);
  const h =
    Math.sin(dLat / 2) ** 2 +
    Math.cos(lat1) * Math.cos(lat2) * Math.sin(dLon / 2) ** 2;
  return 2 * R_TERRE_KM * Math.asin(Math.min(1, Math.sqrt(h)));
}

// Seuil par défaut au-delà duquel un relais est signalé « éloigné ».
export const SEUIL_DISTANCE_KM = 30;
