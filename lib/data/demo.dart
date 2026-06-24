import 'package:drift/drift.dart';

import 'database.dart';

// Remplit la base avec un jeu de données réaliste pour la démonstration.
// Remplace toutes les données existantes.
Future<void> chargerDonneesDemo(AppDatabase db) async {
  final annee = DateTime.now().year;
  DateTime j(int mois, int jour) => DateTime(annee, mois, jour);
  DateTime naiss(int age) => DateTime(annee - age, 5, 12);

  await db.viderTout();

  // --- Accueillants ---
  final bernard = await db
      .into(db.accueillants)
      .insert(
        AccueillantsCompanion.insert(
          nom: 'Bernard',
          prenom: const Value('Sylvie'),
          nbPlaces: const Value(3),
        ),
      );
  final lefevre = await db
      .into(db.accueillants)
      .insert(
        AccueillantsCompanion.insert(
          nom: 'Lefèvre',
          prenom: const Value('Claire'),
          nbPlaces: const Value(2),
          restrictionSexe: const Value(restrictionFille),
        ),
      );
  final moreau = await db
      .into(db.accueillants)
      .insert(
        AccueillantsCompanion.insert(
          nom: 'Moreau',
          prenom: const Value('Karim'),
          nbPlaces: const Value(2),
        ),
      );
  final garnier = await db
      .into(db.accueillants)
      .insert(
        AccueillantsCompanion.insert(
          nom: 'Garnier',
          prenom: const Value('Paul'),
          nbPlaces: const Value(2),
          restrictionSexe: const Value(restrictionGarcon),
        ),
      );
  final petit = await db
      .into(db.accueillants)
      .insert(
        AccueillantsCompanion.insert(
          nom: 'Petit',
          prenom: const Value('Nadia'),
          nbPlaces: const Value(2),
        ),
      );
  // Roux : accueillant polyvalent, 3 places, disponible librement.
  await db
      .into(db.accueillants)
      .insert(
        AccueillantsCompanion.insert(
          nom: 'Roux',
          prenom: const Value('Élodie'),
          nbPlaces: const Value(3),
        ),
      );

  // Moreau est en congés du 10 au 20 juillet.
  await db
      .into(db.indisponibilites)
      .insert(
        IndisponibilitesCompanion.insert(
          accueillantId: moreau,
          debut: j(7, 10),
          fin: j(7, 20),
          motif: const Value('Congés'),
        ),
      );
  // Petit n'accueille qu'au mois d'août.
  await db
      .into(db.disponibilitesAccueil)
      .insert(
        DisponibilitesAccueilCompanion.insert(
          accueillantId: petit,
          debut: j(8, 1),
          fin: j(8, 31),
        ),
      );

  // --- Fratries ---
  final dubois = await db
      .into(db.fratries)
      .insert(
        FratriesCompanion.insert(
          nom: 'Fratrie Dubois',
          regroupement: const Value(regroupementEnsemble),
        ),
      );
  final roy = await db
      .into(db.fratries)
      .insert(
        FratriesCompanion.insert(
          nom: 'Fratrie Roy',
          regroupement: const Value(regroupementSepares),
        ),
      );

  // --- Enfants ---
  Future<int> enfant(
    String nom,
    String prenom,
    String sexe,
    int age, {
    int? af,
    int? fratrie,
  }) {
    return db
        .into(db.enfants)
        .insert(
          EnfantsCompanion.insert(
            nom: nom,
            prenom: Value(prenom),
            sexe: Value(sexe),
            dateNaissance: Value(naiss(age)),
            afHabituelId: Value(af),
            fratrieId: Value(fratrie),
          ),
        );
  }

  final lea = await enfant(
    'Dubois',
    'Léa',
    sexeFille,
    8,
    af: bernard,
    fratrie: dubois,
  );
  final tom = await enfant(
    'Dubois',
    'Tom',
    sexeGarcon,
    10,
    af: bernard,
    fratrie: dubois,
  );
  final hugo = await enfant(
    'Roy',
    'Hugo',
    sexeGarcon,
    9,
    af: lefevre,
    fratrie: roy,
  );
  final manon = await enfant(
    'Roy',
    'Manon',
    sexeFille,
    7,
    af: lefevre,
    fratrie: roy,
  );
  final ines = await enfant('Faure', 'Inès', sexeFille, 6, af: moreau);
  final lucas = await enfant('Marchand', 'Lucas', sexeGarcon, 8, af: bernard);
  final jade = await enfant('Lopez', 'Jade', sexeFille, 9, af: garnier);
  final noah = await enfant('Blanc', 'Noah', sexeGarcon, 11, af: petit);

  // --- Incompatibilité ---
  await db
      .into(db.incompatibilites)
      .insert(
        IncompatibilitesCompanion.insert(enfantAId: lucas, enfantBId: tom),
      );

  // --- Préférences d'accueil (favori / à éviter) ---
  await db
      .into(db.preferencesAccueil)
      .insert(
        PreferencesAccueilCompanion.insert(
          enfantId: jade,
          accueillantId: bernard,
          type: prefFavori,
        ),
      );
  await db
      .into(db.preferencesAccueil)
      .insert(
        PreferencesAccueilCompanion.insert(
          enfantId: lucas,
          accueillantId: moreau,
          type: prefExclu,
        ),
      );

  // --- Besoins de relais ---
  Future<void> besoin(int enfantId, DateTime debut, DateTime fin) => db
      .into(db.besoinsRelais)
      .insert(
        BesoinsRelaisCompanion.insert(
          enfantId: enfantId,
          debut: debut,
          fin: fin,
        ),
      );

  await besoin(lea, j(7, 6), j(7, 13));
  await besoin(tom, j(7, 6), j(7, 13));
  await besoin(hugo, j(7, 6), j(7, 13));
  await besoin(manon, j(7, 6), j(7, 13));
  await besoin(ines, j(7, 12), j(7, 19));
  await besoin(lucas, j(7, 6), j(7, 13));
  await besoin(jade, j(7, 6), j(7, 13));
  await besoin(noah, j(7, 13), j(7, 20));
}
