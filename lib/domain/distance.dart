import 'dart:convert';
import 'dart:math' as math;

import 'package:http/http.dart' as http;

// Seuil par défaut (km) au-delà duquel un relais est signalé « éloigné ».
const double seuilDistanceKmDefaut = 30;

const double _rTerreKm = 6371;

double _rad(double d) => d * math.pi / 180;

// Distance en km entre deux coordonnées, ou null si l'une est inconnue.
double? distanceKm(double? lat1, double? lon1, double? lat2, double? lon2) {
  if (lat1 == null || lon1 == null || lat2 == null || lon2 == null) return null;
  final dLat = _rad(lat2 - lat1);
  final dLon = _rad(lon2 - lon1);
  final h = math.pow(math.sin(dLat / 2), 2) +
      math.cos(_rad(lat1)) * math.cos(_rad(lat2)) * math.pow(math.sin(dLon / 2), 2);
  return 2 * _rTerreKm * math.asin(math.min(1, math.sqrt(h.toDouble())));
}

class Coord {
  final double latitude;
  final double longitude;
  const Coord(this.latitude, this.longitude);
}

// Géocodage via la Base Adresse Nationale (api-adresse.data.gouv.fr) — service
// public français, gratuit, sans clé. APPEL EXTERNE : l'adresse est envoyée à
// data.gouv.fr (données fictives tant que le DPO n'a pas validé). À la demande
// uniquement ; le calcul de distance, lui, reste local.
Future<Coord?> geocoderBAN(String adresse) async {
  final q = adresse.trim();
  if (q.length < 3) return null;
  try {
    final uri = Uri.https('api-adresse.data.gouv.fr', '/search/', {
      'q': q,
      'limit': '1',
    });
    final res = await http.get(uri).timeout(const Duration(seconds: 6));
    if (res.statusCode != 200) return null;
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final features = data['features'] as List<dynamic>?;
    if (features == null || features.isEmpty) return null;
    final f = features.first as Map<String, dynamic>;
    final score = (f['properties']?['score'] as num?)?.toDouble() ?? 0;
    if (score < 0.3) return null;
    final coords = f['geometry']?['coordinates'] as List<dynamic>?;
    if (coords == null || coords.length < 2) return null;
    final lon = (coords[0] as num).toDouble();
    final lat = (coords[1] as num).toDouble();
    return Coord(lat, lon);
  } catch (_) {
    return null;
  }
}
