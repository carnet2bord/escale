import 'package:intl/intl.dart';

// Ramène une date à minuit (on raisonne au jour près, pas à l'heure).
DateTime jour(DateTime d) => DateTime(d.year, d.month, d.day);

// Deux périodes [a1, a2] et [b1, b2] se chevauchent-elles ? (bornes incluses)
bool periodesSeChevauchent(DateTime a1, DateTime a2, DateTime b1, DateTime b2) {
  final d1 = jour(a1), f1 = jour(a2), d2 = jour(b1), f2 = jour(b2);
  return !d1.isAfter(f2) && !d2.isAfter(f1);
}

// Une période [debut, fin] est-elle entièrement contenue dans [borneDebut, borneFin] ?
bool periodeContenue(
  DateTime debut,
  DateTime fin,
  DateTime borneDebut,
  DateTime borneFin,
) {
  return !jour(debut).isBefore(jour(borneDebut)) &&
      !jour(fin).isAfter(jour(borneFin));
}

final DateFormat _fmtCourt = DateFormat('dd/MM/yyyy');
final DateFormat _fmtLong = DateFormat.yMMMMd('fr_FR');

String dateFr(DateTime d) => _fmtCourt.format(d);
String dateLongueFr(DateTime d) => _fmtLong.format(d);

final DateFormat _fmtMoisAnnee = DateFormat.yMMMM('fr_FR');

// Ex. « Juillet 2026 » (première lettre en majuscule).
String moisAnneeFr(DateTime d) {
  final s = _fmtMoisAnnee.format(d);
  return s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
}

String periodeFr(DateTime debut, DateTime fin) {
  if (jour(debut) == jour(fin)) return 'le ${dateFr(debut)}';
  return 'du ${dateFr(debut)} au ${dateFr(fin)}';
}

// Nombre de jours d'une période, bornes incluses.
int nbJours(DateTime debut, DateTime fin) =>
    jour(fin).difference(jour(debut)).inDays + 1;

// Calcule l'âge en années à une date de référence.
int? ageAnnees(DateTime? naissance, {DateTime? a}) {
  if (naissance == null) return null;
  final ref = a ?? DateTime.now();
  var age = ref.year - naissance.year;
  if (ref.month < naissance.month ||
      (ref.month == naissance.month && ref.day < naissance.day)) {
    age--;
  }
  return age < 0 ? null : age;
}
