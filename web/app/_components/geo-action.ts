'use server';

import { geocoderBAN } from '@/lib/geo';

// Géocode une adresse via la BAN (appel externe) — déclenché manuellement.
export async function geocoderAdresse(
  adresse: string,
): Promise<{ latitude: number; longitude: number } | null> {
  return geocoderBAN(adresse);
}
