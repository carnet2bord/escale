import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

// Valeurs possibles pour le sexe d'un enfant.
const String sexeGarcon = 'garcon';
const String sexeFille = 'fille';

// Restriction d'accueil d'un assistant familial.
const String restrictionAucune = 'aucune';
const String restrictionGarcon = 'garcon'; // n'accueille que des garçons
const String restrictionFille = 'fille'; // n'accueille que des filles

// Politique de regroupement d'une fratrie en relais.
const String regroupementEnsemble = 'ensemble'; // à garder ensemble
const String regroupementSepares = 'separes'; // à séparer
const String regroupementIndifferent = 'indifferent';

// Préférence enfant ↔ accueillant.
const String prefFavori = 'favori'; // accueillant privilégié
const String prefExclu = 'exclu'; // accueillant à éviter

// Types de solution alternative (hors relais d'accueillant).
const String solColonie = 'colonie'; // colonie de vacances
const String solTiers = 'tiers'; // accueil par un tiers
const String solAutre = 'autre';

// Statut d'un relais (affectation) dans son cycle de vie.
const String statutPropose = 'propose'; // pressenti, à confirmer
const String statutConfirme = 'confirme'; // verrouillé
const String statutRealise = 'realise'; // accueil effectué
const String statutAnnule = 'annule'; // annulé — n'occupe plus de place

// Un relais annulé ne compte ni dans la couverture, ni dans l'occupation/conflits.
bool relaisActif(String statut) => statut != statutAnnule;

// Clés de réglages (table Reglages) — identité de la structure pour les documents.
const String cleStructureNom = 'structure.nom';
const String cleStructureAdresse = 'structure.adresse';
const String cleStructureSignataire = 'structure.signataire';
const String cleStructureMention = 'structure.mention';

// Les assistants familiaux qui peuvent accueillir des enfants en relais.
@DataClassName('Accueillant')
class Accueillants extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nom => text().withLength(min: 1, max: 80)();
  TextColumn get prenom => text().withDefault(const Constant(''))();
  // Nombre de places d'accueil simultanées.
  IntColumn get nbPlaces => integer().withDefault(const Constant(1))();
  // 'aucune' | 'garcon' | 'fille'
  TextColumn get restrictionSexe =>
      text().withDefault(const Constant(restrictionAucune))();
  TextColumn get notes => text().nullable()();
}

// Groupes de fratrie (frères / sœurs).
@DataClassName('Fratrie')
class Fratries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nom => text().withLength(min: 1, max: 80)();
  // 'ensemble' | 'separes' | 'indifferent'
  TextColumn get regroupement =>
      text().withDefault(const Constant(regroupementEnsemble))();
}

// Les enfants à placer en relais.
@DataClassName('Enfant')
class Enfants extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nom => text().withLength(min: 1, max: 80)();
  TextColumn get prenom => text().withDefault(const Constant(''))();
  // 'garcon' | 'fille'
  TextColumn get sexe => text().withDefault(const Constant(sexeGarcon))();
  DateTimeColumn get dateNaissance => dateTime().nullable()();
  // L'assistant familial chez qui vit habituellement l'enfant.
  IntColumn get afHabituelId => integer().nullable().references(
    Accueillants,
    #id,
    onDelete: KeyAction.setNull,
  )();
  IntColumn get fratrieId => integer().nullable().references(
    Fratries,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get notes => text().nullable()();
}

// Périodes pendant lesquelles un accueillant peut recevoir des enfants.
@DataClassName('DisponibiliteAccueil')
class DisponibilitesAccueil extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get accueillantId =>
      integer().references(Accueillants, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get debut => dateTime()();
  DateTimeColumn get fin => dateTime()();
}

// Périodes pendant lesquelles un accueillant est indisponible (ses vacances).
@DataClassName('Indisponibilite')
class Indisponibilites extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get accueillantId =>
      integer().references(Accueillants, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get debut => dateTime()();
  DateTimeColumn get fin => dateTime()();
  TextColumn get motif => text().nullable()();
}

// Le besoin d'un enfant d'être accueilli en relais sur une période.
@DataClassName('BesoinRelais')
class BesoinsRelais extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get enfantId =>
      integer().references(Enfants, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get debut => dateTime()();
  DateTimeColumn get fin => dateTime()();
  TextColumn get motif => text().nullable()();
}

// L'affectation d'un enfant chez un accueillant sur une période (le relais).
@DataClassName('Affectation')
class Affectations extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get enfantId =>
      integer().references(Enfants, #id, onDelete: KeyAction.cascade)();
  IntColumn get accueillantId =>
      integer().references(Accueillants, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get debut => dateTime()();
  DateTimeColumn get fin => dateTime()();
  IntColumn get besoinId => integer().nullable().references(
    BesoinsRelais,
    #id,
    onDelete: KeyAction.setNull,
  )();
  // 'propose' | 'confirme' | 'realise' | 'annule'
  TextColumn get statut => text().withDefault(const Constant(statutConfirme))();
}

// Paires d'enfants à ne jamais réunir.
@DataClassName('Incompatibilite')
class Incompatibilites extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get enfantAId =>
      integer().references(Enfants, #id, onDelete: KeyAction.cascade)();
  IntColumn get enfantBId =>
      integer().references(Enfants, #id, onDelete: KeyAction.cascade)();
}

// Préférence d'un enfant pour un accueillant : favori ou à éviter (exclu).
@DataClassName('PreferenceAccueil')
class PreferencesAccueil extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get enfantId =>
      integer().references(Enfants, #id, onDelete: KeyAction.cascade)();
  IntColumn get accueillantId =>
      integer().references(Accueillants, #id, onDelete: KeyAction.cascade)();
  // 'favori' | 'exclu'
  TextColumn get type => text()();
}

// Solution alternative couvrant le besoin d'un enfant sans relais d'accueillant
// (colonie de vacances, accueil par un tiers, autre).
@DataClassName('SolutionAlternative')
class SolutionsAlternatives extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get enfantId =>
      integer().references(Enfants, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get debut => dateTime()();
  DateTimeColumn get fin => dateTime()();
  // 'colonie' | 'tiers' | 'autre'
  TextColumn get type => text()();
  TextColumn get details => text().nullable()();
}

// Réglages de l'application (clé/valeur) : identité de la structure, etc.
@DataClassName('Reglage')
class Reglages extends Table {
  TextColumn get cle => text()();
  TextColumn get valeur => text().withDefault(const Constant(''))();
  @override
  Set<Column> get primaryKey => {cle};
}

@DriftDatabase(
  tables: [
    Accueillants,
    Fratries,
    Enfants,
    DisponibilitesAccueil,
    Indisponibilites,
    BesoinsRelais,
    Affectations,
    Incompatibilites,
    PreferencesAccueil,
    SolutionsAlternatives,
    Reglages,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _ouvrir());

  static QueryExecutor _ouvrir() {
    return LazyDatabase(() async {
      final fichier = await cheminBase();
      // Base synchrone (même isolat) : lecture-après-écriture immédiate et
      // notifications de flux fiables — adapté à un volume de données modeste.
      return NativeDatabase(fichier);
    });
  }

  // Emplacement du fichier de base de données local.
  static Future<File> cheminBase() async {
    final dir = await getApplicationSupportDirectory();
    return File(p.join(dir.path, 'escale.sqlite'));
  }

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) await m.createTable(preferencesAccueil);
      if (from < 3) await m.createTable(solutionsAlternatives);
      if (from < 4) await m.addColumn(affectations, affectations.statut);
      if (from < 5) await m.createTable(reglages);
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  // --- Sauvegarde / restauration / réinitialisation ---

  // Écrit une copie propre et autonome de la base vers [chemin].
  Future<void> sauvegarderVers(String chemin) async {
    final c = chemin.replaceAll("'", "''");
    await customStatement("VACUUM INTO '$c'");
  }

  // Remplace toutes les données par celles du fichier de sauvegarde [chemin].
  Future<void> restaurerDepuis(String chemin) async {
    final source = AppDatabase(NativeDatabase(File(chemin)));
    try {
      final acc = await source.select(source.accueillants).get();
      final fra = await source.select(source.fratries).get();
      final enf = await source.select(source.enfants).get();
      final disp = await source.select(source.disponibilitesAccueil).get();
      final indisp = await source.select(source.indisponibilites).get();
      final bes = await source.select(source.besoinsRelais).get();
      final aff = await source.select(source.affectations).get();
      final inc = await source.select(source.incompatibilites).get();
      final prefs = await source.select(source.preferencesAccueil).get();
      final sols = await source.select(source.solutionsAlternatives).get();
      final regs = await source.select(source.reglages).get();
      await transaction(() async {
        await viderTout();
        await delete(reglages).go();
        await batch((b) {
          b.insertAll(reglages, regs.map((e) => e.toCompanion(false)));
          b.insertAll(accueillants, acc.map((e) => e.toCompanion(false)));
          b.insertAll(fratries, fra.map((e) => e.toCompanion(false)));
          b.insertAll(enfants, enf.map((e) => e.toCompanion(false)));
          b.insertAll(
            disponibilitesAccueil,
            disp.map((e) => e.toCompanion(false)),
          );
          b.insertAll(
            indisponibilites,
            indisp.map((e) => e.toCompanion(false)),
          );
          b.insertAll(besoinsRelais, bes.map((e) => e.toCompanion(false)));
          b.insertAll(affectations, aff.map((e) => e.toCompanion(false)));
          b.insertAll(incompatibilites, inc.map((e) => e.toCompanion(false)));
          b.insertAll(
            preferencesAccueil,
            prefs.map((e) => e.toCompanion(false)),
          );
          b.insertAll(
            solutionsAlternatives,
            sols.map((e) => e.toCompanion(false)),
          );
        });
      });
    } finally {
      await source.close();
    }
  }

  // Supprime les accueillants et enfants en double (même nom + prénom),
  // en conservant la première fiche (id le plus petit) de chaque. Renvoie le
  // nombre de fiches supprimées.
  Future<int> supprimerDoublons() async {
    String cle(String nom, String prenom) =>
        '${nom.trim().toLowerCase()}|${prenom.trim().toLowerCase()}';
    var total = 0;
    final accs = await tousAccueillants()
      ..sort((a, b) => a.id.compareTo(b.id));
    final vusA = <String>{};
    for (final a in accs) {
      if (!vusA.add(cle(a.nom, a.prenom))) {
        await (delete(accueillants)..where((t) => t.id.equals(a.id))).go();
        total++;
      }
    }
    final enfs = await tousEnfants()
      ..sort((a, b) => a.id.compareTo(b.id));
    final vusE = <String>{};
    for (final e in enfs) {
      if (!vusE.add(cle(e.nom, e.prenom))) {
        await (delete(enfants)..where((t) => t.id.equals(e.id))).go();
        total++;
      }
    }
    return total;
  }

  // Supprime toutes les données (enfants d'abord, parents ensuite).
  Future<void> viderTout() async {
    await delete(affectations).go();
    await delete(incompatibilites).go();
    await delete(besoinsRelais).go();
    await delete(disponibilitesAccueil).go();
    await delete(indisponibilites).go();
    await delete(enfants).go();
    await delete(fratries).go();
    await delete(accueillants).go();
  }

  // Émet une fois immédiatement, puis à chaque modification d'une table.
  // Sert à recharger les écrans agrégés (tableau de bord, planning).
  Stream<void> fluxChangements() async* {
    yield null;
    await for (final _ in tableUpdates()) {
      yield null;
    }
  }

  // --- Lectures réactives (streams) utilisées par l'interface ---

  Stream<List<Accueillant>> watchAccueillants() => (select(
    accueillants,
  )..orderBy([(a) => OrderingTerm(expression: a.nom)])).watch();

  Stream<List<Enfant>> watchEnfants() => (select(
    enfants,
  )..orderBy([(e) => OrderingTerm(expression: e.nom)])).watch();

  Stream<List<Fratrie>> watchFratries() => (select(
    fratries,
  )..orderBy([(f) => OrderingTerm(expression: f.nom)])).watch();

  Stream<List<Affectation>> watchAffectations() => select(affectations).watch();

  Stream<List<BesoinRelais>> watchBesoins() => select(besoinsRelais).watch();

  Stream<List<Incompatibilite>> watchIncompatibilites() =>
      select(incompatibilites).watch();

  // --- Lectures ponctuelles (pour le moteur de conflits) ---

  Future<List<Accueillant>> tousAccueillants() => select(accueillants).get();
  Future<List<Enfant>> tousEnfants() => select(enfants).get();
  Future<List<Fratrie>> toutesFratries() => select(fratries).get();
  Future<List<Affectation>> toutesAffectations() => select(affectations).get();

  // Met à jour le statut d'un relais (proposé/confirmé/réalisé/annulé).
  Future<void> majStatutAffectation(int id, String statut) =>
      (update(affectations)..where((t) => t.id.equals(id))).write(
        AffectationsCompanion(statut: Value(statut)),
      );

  // Ré-insère une ligne supprimée (pour l'annulation « Annuler » après suppression).
  Future<void> reinsererAffectation(Affectation a) =>
      into(affectations).insert(a, mode: InsertMode.insertOrReplace);

  Future<void> reinsererSolution(SolutionAlternative s) =>
      into(solutionsAlternatives).insert(s, mode: InsertMode.insertOrReplace);

  // --- Réglages (clé/valeur) ---
  Future<Map<String, String>> lireReglages() async {
    final rows = await select(reglages).get();
    return {for (final r in rows) r.cle: r.valeur};
  }

  Future<void> ecrireReglage(String cle, String valeur) =>
      into(reglages).insert(
        Reglage(cle: cle, valeur: valeur),
        mode: InsertMode.insertOrReplace,
      );

  Future<List<BesoinRelais>> tousBesoins() => select(besoinsRelais).get();
  Future<List<Incompatibilite>> toutesIncompatibilites() =>
      select(incompatibilites).get();
  Future<List<PreferenceAccueil>> toutesPreferences() =>
      select(preferencesAccueil).get();
  Future<List<SolutionAlternative>> toutesSolutions() =>
      select(solutionsAlternatives).get();

  Stream<List<PreferenceAccueil>> watchPreferencesDe(int enfantId) => (select(
    preferencesAccueil,
  )..where((p) => p.enfantId.equals(enfantId))).watch();

  Stream<List<SolutionAlternative>> watchSolutionsDe(int enfantId) => (select(
    solutionsAlternatives,
  )..where((s) => s.enfantId.equals(enfantId))).watch();

  Future<List<DisponibiliteAccueil>> toutesDisponibilites() =>
      select(disponibilitesAccueil).get();
  Future<List<Indisponibilite>> toutesIndisponibilites() =>
      select(indisponibilites).get();

  Future<List<DisponibiliteAccueil>> disponibilitesDe(int accueillantId) =>
      (select(
        disponibilitesAccueil,
      )..where((d) => d.accueillantId.equals(accueillantId))).get();

  Future<List<Indisponibilite>> indisponibilitesDe(int accueillantId) =>
      (select(
        indisponibilites,
      )..where((i) => i.accueillantId.equals(accueillantId))).get();

  Stream<List<DisponibiliteAccueil>> watchDisponibilitesDe(int accueillantId) =>
      (select(disponibilitesAccueil)
            ..where((d) => d.accueillantId.equals(accueillantId))
            ..orderBy([(d) => OrderingTerm(expression: d.debut)]))
          .watch();

  Stream<List<Indisponibilite>> watchIndisponibilitesDe(int accueillantId) =>
      (select(indisponibilites)
            ..where((i) => i.accueillantId.equals(accueillantId))
            ..orderBy([(i) => OrderingTerm(expression: i.debut)]))
          .watch();

  Stream<List<BesoinRelais>> watchBesoinsDe(int enfantId) =>
      (select(besoinsRelais)
            ..where((b) => b.enfantId.equals(enfantId))
            ..orderBy([(b) => OrderingTerm(expression: b.debut)]))
          .watch();

  Stream<List<Incompatibilite>> watchIncompatibilitesDe(int enfantId) =>
      (select(incompatibilites)..where(
            (i) => i.enfantAId.equals(enfantId) | i.enfantBId.equals(enfantId),
          ))
          .watch();
}
