import 'package:flutter_test/flutter_test.dart';
import 'package:relais/data/database.dart';
import 'package:relais/domain/proposition.dart';

Enfant enfant({
  int id = 1,
  String sexe = sexeGarcon,
  int? afHabituelId,
  int? fratrieId,
}) => Enfant(
  id: id,
  nom: 'Enfant$id',
  prenom: '',
  sexe: sexe,
  dateNaissance: null,
  afHabituelId: afHabituelId,
  fratrieId: fratrieId,
  notes: null,
);

Accueillant accueillant({
  int id = 10,
  int nbPlaces = 1,
  String restriction = restrictionAucune,
}) => Accueillant(
  id: id,
  nom: 'Acc$id',
  prenom: '',
  nbPlaces: nbPlaces,
  restrictionSexe: restriction,
  notes: null,
);

BesoinRelais besoin({
  required int id,
  required int enfantId,
  required DateTime debut,
  required DateTime fin,
}) => BesoinRelais(
  id: id,
  enfantId: enfantId,
  debut: debut,
  fin: fin,
  motif: null,
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

SolutionAlternative solution({
  required int id,
  required int enfantId,
  required DateTime debut,
  required DateTime fin,
  String type = solColonie,
}) => SolutionAlternative(
  id: id,
  enfantId: enfantId,
  debut: debut,
  fin: fin,
  type: type,
  details: null,
);

DateTime d(int jour) => DateTime(2026, 7, jour);

void main() {
  test('un besoin simple est placé', () {
    final r = proposerAffectations(
      enfants: [enfant(id: 1)],
      accueillants: [accueillant(id: 10)],
      affectationsExistantes: const [],
      besoins: [besoin(id: 1, enfantId: 1, debut: d(1), fin: d(7))],
      dispos: const [],
      indispos: const [],
      incompatibilites: const [],
    );
    expect(r.propositions.length, 1);
    expect(r.nonPlaces, isEmpty);
    expect(r.propositions.first.accueillant.id, 10);
  });

  test('aucun candidat (seul accueillant = AF habituel) → non placé', () {
    final r = proposerAffectations(
      enfants: [enfant(id: 1, afHabituelId: 10)],
      accueillants: [accueillant(id: 10)],
      affectationsExistantes: const [],
      besoins: [besoin(id: 1, enfantId: 1, debut: d(1), fin: d(7))],
      dispos: const [],
      indispos: const [],
      incompatibilites: const [],
    );
    expect(r.propositions, isEmpty);
    expect(r.nonPlaces.length, 1);
  });

  test('seul le trou non couvert est proposé', () {
    final r = proposerAffectations(
      enfants: [enfant(id: 1)],
      accueillants: [accueillant(id: 10), accueillant(id: 20)],
      affectationsExistantes: [
        affectation(
          id: 100,
          enfantId: 1,
          accueillantId: 20,
          debut: d(1),
          fin: d(3),
        ),
      ],
      besoins: [besoin(id: 1, enfantId: 1, debut: d(1), fin: d(7))],
      dispos: const [],
      indispos: const [],
      incompatibilites: const [],
    );
    expect(r.propositions.length, 1);
    expect(r.propositions.first.debut, d(4));
    expect(r.propositions.first.fin, d(7));
  });

  test('deux enfants, une seule place chacun → les deux placés ailleurs', () {
    final r = proposerAffectations(
      enfants: [enfant(id: 1), enfant(id: 2)],
      accueillants: [accueillant(id: 10, nbPlaces: 1)],
      affectationsExistantes: const [],
      besoins: [
        besoin(id: 1, enfantId: 1, debut: d(1), fin: d(5)),
        besoin(id: 2, enfantId: 2, debut: d(1), fin: d(5)),
      ],
      dispos: const [],
      indispos: const [],
      incompatibilites: const [],
    );
    // Un seul accueillant à 1 place ne peut prendre les deux en même temps.
    expect(r.propositions.length, 1);
    expect(r.nonPlaces.length, 1);
  });

  test('restriction de sexe : le seul accueillant est écarté → non placé', () {
    final r = proposerAffectations(
      enfants: [enfant(id: 1, sexe: sexeGarcon)],
      accueillants: [accueillant(id: 10, restriction: restrictionFille)],
      affectationsExistantes: const [],
      besoins: [besoin(id: 1, enfantId: 1, debut: d(1), fin: d(7))],
      dispos: const [],
      indispos: const [],
      incompatibilites: const [],
    );
    expect(r.propositions, isEmpty);
    expect(r.nonPlaces.length, 1);
  });

  test(
    'fratrie « ensemble » : les deux sont placés chez le même accueillant',
    () {
      final r = proposerAffectations(
        enfants: [enfant(id: 1, fratrieId: 7), enfant(id: 2, fratrieId: 7)],
        accueillants: [
          accueillant(id: 10, nbPlaces: 2),
          accueillant(id: 20, nbPlaces: 2),
        ],
        affectationsExistantes: const [],
        besoins: [
          besoin(id: 1, enfantId: 1, debut: d(1), fin: d(7)),
          besoin(id: 2, enfantId: 2, debut: d(1), fin: d(7)),
        ],
        dispos: const [],
        indispos: const [],
        incompatibilites: const [],
        fratries: [
          Fratrie(id: 7, nom: 'F', regroupement: regroupementEnsemble),
        ],
      );
      expect(r.propositions.length, 2);
      expect(
        r.propositions[0].accueillant.id,
        r.propositions[1].accueillant.id,
      );
    },
  );

  test('besoins du même enfant qui se chevauchent : une seule cible, pas de '
      'faux « non placé »', () {
    final r = proposerAffectations(
      enfants: [enfant(id: 1)],
      accueillants: [accueillant(id: 10, nbPlaces: 1)],
      affectationsExistantes: const [],
      besoins: [
        besoin(id: 1, enfantId: 1, debut: d(1), fin: d(10)),
        besoin(id: 2, enfantId: 1, debut: d(5), fin: d(15)),
      ],
      dispos: const [],
      indispos: const [],
      incompatibilites: const [],
    );
    expect(r.propositions.length, 1);
    expect(r.propositions.first.debut, d(1));
    expect(r.propositions.first.fin, d(15));
    expect(r.nonPlaces, isEmpty);
  });

  test(
    'une solution alternative couvre une partie : seul le reste est proposé',
    () {
      final r = proposerAffectations(
        enfants: [enfant(id: 1)],
        accueillants: [accueillant(id: 10)],
        affectationsExistantes: const [],
        besoins: [besoin(id: 1, enfantId: 1, debut: d(1), fin: d(10))],
        dispos: const [],
        indispos: const [],
        incompatibilites: const [],
        solutions: [solution(id: 1, enfantId: 1, debut: d(1), fin: d(5))],
      );
      expect(r.propositions.length, 1);
      expect(r.propositions.first.debut, d(6));
      expect(r.propositions.first.fin, d(10));
    },
  );

  test('un relais annulé ne couvre pas : le besoin est re-proposé', () {
    final r = proposerAffectations(
      enfants: [enfant(id: 1)],
      accueillants: [accueillant(id: 10)],
      affectationsExistantes: [
        affectation(
          id: 100,
          enfantId: 1,
          accueillantId: 20,
          debut: d(1),
          fin: d(7),
          statut: statutAnnule,
        ),
      ],
      besoins: [besoin(id: 1, enfantId: 1, debut: d(1), fin: d(7))],
      dispos: const [],
      indispos: const [],
      incompatibilites: const [],
    );
    expect(r.propositions.length, 1);
    expect(r.nonPlaces, isEmpty);
  });
}
