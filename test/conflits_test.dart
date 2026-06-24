import 'package:flutter_test/flutter_test.dart';
import 'package:relais/data/database.dart';
import 'package:relais/domain/conflits.dart';

Enfant enfant({
  int id = 1,
  String nom = 'Dupont',
  String sexe = sexeGarcon,
  int? afHabituelId,
  int? fratrieId,
  DateTime? naissance,
  String? secteur,
}) => Enfant(
  id: id,
  nom: nom,
  prenom: '',
  sexe: sexe,
  dateNaissance: naissance,
  afHabituelId: afHabituelId,
  fratrieId: fratrieId,
  secteur: secteur,
  notes: null,
);

Accueillant accueillant({
  int id = 10,
  String nom = 'Martin',
  int nbPlaces = 1,
  String restriction = restrictionAucune,
  int? ageMin,
  int? ageMax,
  DateTime? agrementEcheance,
  int? plafondJoursAn,
  String? secteur,
}) => Accueillant(
  id: id,
  nom: nom,
  prenom: '',
  nbPlaces: nbPlaces,
  restrictionSexe: restriction,
  ageMin: ageMin,
  ageMax: ageMax,
  agrementEcheance: agrementEcheance,
  plafondJoursAn: plafondJoursAn,
  secteur: secteur,
  notes: null,
);

Affectation affectation({
  required int id,
  required int enfantId,
  required int accueillantId,
  required DateTime debut,
  required DateTime fin,
  String statut = statutConfirme,
}) => Affectation(
  id: id,
  enfantId: enfantId,
  accueillantId: accueillantId,
  debut: debut,
  fin: fin,
  besoinId: null,
  statut: statut,
);

DateTime d(int jour) => DateTime(2026, 7, jour);

void main() {
  test('aucun conflit dans le cas nominal', () {
    final conflits = analyserAffectation(
      enfant: enfant(),
      accueillant: accueillant(nbPlaces: 1),
      debut: d(1),
      fin: d(7),
      affectations: const [],
      disponibilites: const [],
      indisponibilites: const [],
      incompatibilites: const [],
      enfants: [enfant()],
    );
    expect(conflits, isEmpty);
  });

  test('restriction de sexe bloque', () {
    final e = enfant(sexe: sexeGarcon);
    final conflits = analyserAffectation(
      enfant: e,
      accueillant: accueillant(restriction: restrictionFille),
      debut: d(1),
      fin: d(3),
      affectations: const [],
      disponibilites: const [],
      indisponibilites: const [],
      incompatibilites: const [],
      enfants: [e],
    );
    expect(conflits.any((c) => c.estBloquant), isTrue);
  });

  test('placement chez son AF habituel bloque', () {
    final e = enfant(id: 1, afHabituelId: 10);
    final conflits = analyserAffectation(
      enfant: e,
      accueillant: accueillant(id: 10),
      debut: d(1),
      fin: d(3),
      affectations: const [],
      disponibilites: const [],
      indisponibilites: const [],
      incompatibilites: const [],
      enfants: [e],
    );
    expect(conflits.any((c) => c.estBloquant), isTrue);
  });

  test('capacité dépassée bloque', () {
    final e1 = enfant(id: 1);
    final e2 = enfant(id: 2, nom: 'Durand');
    final conflits = analyserAffectation(
      enfant: e2,
      accueillant: accueillant(id: 10, nbPlaces: 1),
      debut: d(1),
      fin: d(7),
      affectations: [
        affectation(
          id: 100,
          enfantId: 1,
          accueillantId: 10,
          debut: d(3),
          fin: d(5),
        ),
      ],
      disponibilites: const [],
      indisponibilites: const [],
      incompatibilites: const [],
      enfants: [e1, e2],
    );
    expect(
      conflits.any((c) => c.estBloquant && c.message.contains('Capacité')),
      isTrue,
    );
  });

  test('deux places suffisent pour deux enfants', () {
    final e1 = enfant(id: 1);
    final e2 = enfant(id: 2, nom: 'Durand');
    final conflits = analyserAffectation(
      enfant: e2,
      accueillant: accueillant(id: 10, nbPlaces: 2),
      debut: d(1),
      fin: d(7),
      affectations: [
        affectation(
          id: 100,
          enfantId: 1,
          accueillantId: 10,
          debut: d(3),
          fin: d(5),
        ),
      ],
      disponibilites: const [],
      indisponibilites: const [],
      incompatibilites: const [],
      enfants: [e1, e2],
    );
    expect(conflits.any((c) => c.estBloquant), isFalse);
  });

  test('incompatibilité bloque au même endroit', () {
    final e1 = enfant(id: 1);
    final e2 = enfant(id: 2, nom: 'Durand');
    final conflits = analyserAffectation(
      enfant: e2,
      accueillant: accueillant(id: 10, nbPlaces: 5),
      debut: d(1),
      fin: d(7),
      affectations: [
        affectation(
          id: 100,
          enfantId: 1,
          accueillantId: 10,
          debut: d(3),
          fin: d(5),
        ),
      ],
      disponibilites: const [],
      indisponibilites: const [],
      incompatibilites: [Incompatibilite(id: 1, enfantAId: 1, enfantBId: 2)],
      enfants: [e1, e2],
    );
    expect(conflits.any((c) => c.estBloquant), isTrue);
  });

  test('accueillant à éviter (exclu) bloque', () {
    final e = enfant(id: 1);
    final conflits = analyserAffectation(
      enfant: e,
      accueillant: accueillant(id: 10),
      debut: d(1),
      fin: d(3),
      affectations: const [],
      disponibilites: const [],
      indisponibilites: const [],
      incompatibilites: const [],
      enfants: [e],
      preferences: [
        PreferenceAccueil(
          id: 1,
          enfantId: 1,
          accueillantId: 10,
          type: prefExclu,
        ),
      ],
    );
    expect(conflits.any((c) => c.estBloquant), isTrue);
  });

  test('accueillant favori ne bloque pas', () {
    final e = enfant(id: 1);
    final conflits = analyserAffectation(
      enfant: e,
      accueillant: accueillant(id: 10),
      debut: d(1),
      fin: d(3),
      affectations: const [],
      disponibilites: const [],
      indisponibilites: const [],
      incompatibilites: const [],
      enfants: [e],
      preferences: [
        PreferenceAccueil(
          id: 1,
          enfantId: 1,
          accueillantId: 10,
          type: prefFavori,
        ),
      ],
    );
    expect(conflits.any((c) => c.estBloquant), isFalse);
  });

  test('indisponibilité (vacances) bloque', () {
    final e = enfant();
    final conflits = analyserAffectation(
      enfant: e,
      accueillant: accueillant(id: 10),
      debut: d(4),
      fin: d(8),
      affectations: const [],
      disponibilites: const [],
      indisponibilites: [
        Indisponibilite(
          id: 1,
          accueillantId: 10,
          debut: d(6),
          fin: d(10),
          motif: null,
        ),
      ],
      incompatibilites: const [],
      enfants: [e],
    );
    expect(conflits.any((c) => c.estBloquant), isTrue);
  });

  test('restriction « aucune » laisse passer une fille', () {
    final e = enfant(sexe: sexeFille);
    final conflits = analyserAffectation(
      enfant: e,
      accueillant: accueillant(restriction: restrictionAucune),
      debut: d(1),
      fin: d(3),
      affectations: const [],
      disponibilites: const [],
      indisponibilites: const [],
      incompatibilites: const [],
      enfants: [e],
    );
    expect(conflits.any((c) => c.estBloquant), isFalse);
  });

  test('sexe correspondant passe (garçon chez restriction garçon)', () {
    final e = enfant(sexe: sexeGarcon);
    final conflits = analyserAffectation(
      enfant: e,
      accueillant: accueillant(restriction: restrictionGarcon),
      debut: d(1),
      fin: d(3),
      affectations: const [],
      disponibilites: const [],
      indisponibilites: const [],
      incompatibilites: const [],
      enfants: [e],
    );
    expect(conflits.any((c) => c.estBloquant), isFalse);
  });

  test('fille chez restriction garçon bloque', () {
    final e = enfant(sexe: sexeFille);
    final conflits = analyserAffectation(
      enfant: e,
      accueillant: accueillant(restriction: restrictionGarcon),
      debut: d(1),
      fin: d(3),
      affectations: const [],
      disponibilites: const [],
      indisponibilites: const [],
      incompatibilites: const [],
      enfants: [e],
    );
    expect(conflits.any((c) => c.estBloquant), isTrue);
  });

  test('fratrie à séparer : même accueillant bloque', () {
    final e1 = enfant(id: 1, fratrieId: 7);
    final e2 = enfant(id: 2, nom: 'Durand', fratrieId: 7);
    final conflits = analyserAffectation(
      enfant: e2,
      accueillant: accueillant(id: 10, nbPlaces: 5),
      debut: d(1),
      fin: d(7),
      affectations: [
        affectation(
          id: 100,
          enfantId: 1,
          accueillantId: 10,
          debut: d(3),
          fin: d(5),
        ),
      ],
      disponibilites: const [],
      indisponibilites: const [],
      incompatibilites: const [],
      enfants: [e1, e2],
      fratries: [Fratrie(id: 7, nom: 'F', regroupement: regroupementSepares)],
    );
    expect(conflits.any((c) => c.estBloquant), isTrue);
  });

  test('fratrie à séparer : accueillants différents ne bloque pas', () {
    final e1 = enfant(id: 1, fratrieId: 7);
    final e2 = enfant(id: 2, nom: 'Durand', fratrieId: 7);
    final conflits = analyserAffectation(
      enfant: e2,
      accueillant: accueillant(id: 20, nbPlaces: 5),
      debut: d(1),
      fin: d(7),
      affectations: [
        affectation(
          id: 100,
          enfantId: 1,
          accueillantId: 10,
          debut: d(3),
          fin: d(5),
        ),
      ],
      disponibilites: const [],
      indisponibilites: const [],
      incompatibilites: const [],
      enfants: [e1, e2],
      fratries: [Fratrie(id: 7, nom: 'F', regroupement: regroupementSepares)],
    );
    expect(conflits.any((c) => c.estBloquant), isFalse);
  });

  test('fratrie ensemble : séparée = avertissement non bloquant', () {
    final e1 = enfant(id: 1, fratrieId: 7);
    final e2 = enfant(id: 2, nom: 'Durand', fratrieId: 7);
    final conflits = analyserAffectation(
      enfant: e2,
      accueillant: accueillant(id: 20, nbPlaces: 5),
      debut: d(1),
      fin: d(7),
      affectations: [
        affectation(
          id: 100,
          enfantId: 1,
          accueillantId: 10,
          debut: d(3),
          fin: d(5),
        ),
      ],
      disponibilites: const [],
      indisponibilites: const [],
      incompatibilites: const [],
      enfants: [e1, e2],
      fratries: [Fratrie(id: 7, nom: 'F', regroupement: regroupementEnsemble)],
    );
    expect(conflits.any((c) => c.estBloquant), isFalse);
    expect(conflits.any((c) => c.severite == Severite.avertissement), isTrue);
  });

  test('enfant déjà en colonie/tiers : relais chevauchant bloque', () {
    final e = enfant(id: 1);
    final conflits = analyserAffectation(
      enfant: e,
      accueillant: accueillant(id: 10),
      debut: d(3),
      fin: d(7),
      affectations: const [],
      disponibilites: const [],
      indisponibilites: const [],
      incompatibilites: const [],
      enfants: [e],
      solutions: [
        SolutionAlternative(
          id: 1,
          enfantId: 1,
          debut: d(1),
          fin: d(5),
          type: solColonie,
          details: null,
        ),
      ],
    );
    expect(conflits.any((c) => c.estBloquant), isTrue);
  });

  test('âge hors tranche : avertissement non bloquant', () {
    final e = enfant(naissance: DateTime(2010, 1, 1));
    final conflits = analyserAffectation(
      enfant: e,
      accueillant: accueillant(ageMin: 0, ageMax: 6),
      debut: d(1),
      fin: d(3),
      affectations: const [],
      disponibilites: const [],
      indisponibilites: const [],
      incompatibilites: const [],
      enfants: [e],
    );
    expect(conflits.any((c) => c.estBloquant), isFalse);
    expect(conflits.any((c) => c.severite == Severite.avertissement), isTrue);
  });

  test('agrément expiré avant la fin du relais : avertissement', () {
    final e = enfant();
    final conflits = analyserAffectation(
      enfant: e,
      accueillant: accueillant(agrementEcheance: d(2)),
      debut: d(1),
      fin: d(7),
      affectations: const [],
      disponibilites: const [],
      indisponibilites: const [],
      incompatibilites: const [],
      enfants: [e],
    );
    expect(conflits.any((c) => c.estBloquant), isFalse);
    expect(conflits.any((c) => c.severite == Severite.avertissement), isTrue);
  });

  test('secteur différent : avertissement non bloquant', () {
    final e = enfant(secteur: 'Sud');
    final conflits = analyserAffectation(
      enfant: e,
      accueillant: accueillant(secteur: 'Nord'),
      debut: d(1),
      fin: d(3),
      affectations: const [],
      disponibilites: const [],
      indisponibilites: const [],
      incompatibilites: const [],
      enfants: [e],
    );
    expect(conflits.any((c) => c.estBloquant), isFalse);
    expect(conflits.any((c) => c.severite == Severite.avertissement), isTrue);
  });

  test('plafond de jours dépassé : avertissement non bloquant', () {
    final e = enfant();
    final conflits = analyserAffectation(
      enfant: e,
      accueillant: accueillant(plafondJoursAn: 5),
      debut: d(1),
      fin: d(10),
      affectations: const [],
      disponibilites: const [],
      indisponibilites: const [],
      incompatibilites: const [],
      enfants: [e],
    );
    expect(conflits.any((c) => c.estBloquant), isFalse);
    expect(conflits.any((c) => c.severite == Severite.avertissement), isTrue);
  });

  test('un relais annulé n\'occupe pas de place', () {
    final e1 = enfant(id: 1);
    final e2 = enfant(id: 2, nom: 'Durand');
    final conflits = analyserAffectation(
      enfant: e2,
      accueillant: accueillant(id: 10, nbPlaces: 1),
      debut: d(1),
      fin: d(7),
      affectations: [
        affectation(
          id: 100,
          enfantId: 1,
          accueillantId: 10,
          debut: d(3),
          fin: d(5),
          statut: statutAnnule,
        ),
      ],
      disponibilites: const [],
      indisponibilites: const [],
      incompatibilites: const [],
      enfants: [e1, e2],
    );
    expect(conflits.any((c) => c.estBloquant), isFalse);
  });
}
