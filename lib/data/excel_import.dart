import 'dart:typed_data';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart' show compute;
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

import 'database.dart';

enum TypeImport { accueillants, enfants }

// Un champ cible de l'application, à faire correspondre à une colonne Excel.
class ChampCible {
  final String cle;
  final String libelle;
  final bool obligatoire;
  const ChampCible(this.cle, this.libelle, {this.obligatoire = false});
}

const champsAccueillant = [
  ChampCible('nom', 'Nom', obligatoire: true),
  ChampCible('prenom', 'Prénom'),
  ChampCible('places', 'Nombre de places'),
  ChampCible('restriction', 'Restriction (garçons / filles / mixte)'),
  ChampCible('notes', 'Notes'),
];

const champsEnfant = [
  ChampCible('nom', 'Nom', obligatoire: true),
  ChampCible('prenom', 'Prénom'),
  ChampCible('sexe', 'Sexe (garçon / fille)'),
  ChampCible('naissance', 'Date de naissance'),
  ChampCible('notes', 'Notes'),
];

List<ChampCible> champsPour(TypeImport t) =>
    t == TypeImport.accueillants ? champsAccueillant : champsEnfant;

// Une feuille Excel lue, entièrement convertie en texte (sendable entre isolats).
class FeuilleExcel {
  final List<String> entetes;
  final List<List<String>> lignes;
  const FeuilleExcel(this.entetes, this.lignes);
  bool get vide => entetes.isEmpty;
}

// Lit un .xlsx hors du fil de l'interface (isolate). Peut lever une exception.
Future<FeuilleExcel> lireExcel(Uint8List bytes) =>
    compute(lireExcelSync, bytes);

// Version synchrone (callback de compute, et utilisable en test).
FeuilleExcel lireExcelSync(Uint8List bytes) {
  final decodeur = SpreadsheetDecoder.decodeBytes(bytes);
  if (decodeur.tables.isEmpty) return const FeuilleExcel([], []);
  // Première feuille contenant des données.
  SpreadsheetTable feuille = decodeur.tables.values.first;
  for (final t in decodeur.tables.values) {
    if (t.maxRows > 0 && t.rows.isNotEmpty) {
      feuille = t;
      break;
    }
  }
  final rows = feuille.rows;
  // Première ligne non vide = en-têtes.
  var h = 0;
  while (h < rows.length && rows[h].every((c) => _texte(c).isEmpty)) {
    h++;
  }
  if (h >= rows.length) return const FeuilleExcel([], []);
  final entetes = rows[h].map(_texte).toList();
  while (entetes.isNotEmpty && entetes.last.trim().isEmpty) {
    entetes.removeLast();
  }
  if (entetes.isEmpty) return const FeuilleExcel([], []);
  final largeur = entetes.length;
  final data = <List<String>>[];
  for (var i = h + 1; i < rows.length; i++) {
    final r = rows[i];
    if (r.every((c) => _texte(c).isEmpty)) continue;
    data.add(
      List<String>.generate(largeur, (j) => j < r.length ? _texte(r[j]) : ''),
    );
  }
  return FeuilleExcel(entetes, data);
}

// Devine la colonne correspondant à un champ d'après le nom de l'en-tête.
int devinerColonne(String cle, List<String> entetes) {
  bool m(String e, List<String> mots) {
    final s = e.toLowerCase();
    return mots.any(s.contains);
  }

  for (var i = 0; i < entetes.length; i++) {
    final e = entetes[i];
    switch (cle) {
      case 'nom':
        if (m(e, ['nom']) && !m(e, ['prénom', 'prenom'])) return i;
      case 'prenom':
        if (m(e, ['prénom', 'prenom'])) return i;
      case 'places':
        if (m(e, ['place', 'capacit'])) return i;
      case 'restriction':
        if (m(e, ['restrict', 'accueil', 'type'])) return i;
      case 'sexe':
        if (m(e, ['sexe', 'genre'])) return i;
      case 'naissance':
        if (m(e, ['naiss', 'date', 'né', 'ne(e)'])) return i;
      case 'notes':
        if (m(e, ['note', 'remarque', 'observ'])) return i;
    }
  }
  return -1;
}

// --- Imports (insertion par lot, robuste, avec dédoublonnage) ---

typedef ResultatImport = ({int importes, int ignores});

String _cle(String nom, String prenom) =>
    '${nom.trim().toLowerCase()}|${prenom.trim().toLowerCase()}';

Future<ResultatImport> importerAccueillants(
  AppDatabase db,
  FeuilleExcel f,
  Map<String, int> map, {
  bool dedupe = true,
}) async {
  final vus = dedupe
      ? {for (final a in await db.tousAccueillants()) _cle(a.nom, a.prenom)}
      : <String>{};
  final companions = <AccueillantsCompanion>[];
  var ignores = 0;
  for (final row in f.lignes) {
    final nom = _val(row, map['nom']);
    if (nom.isEmpty) continue;
    final prenom = _val(row, map['prenom']);
    if (dedupe && !vus.add(_cle(nom, prenom))) {
      ignores++;
      continue;
    }
    companions.add(
      AccueillantsCompanion.insert(
        nom: nom,
        prenom: Value(prenom),
        nbPlaces: Value(_int(_val(row, map['places']), defaut: 1)),
        restrictionSexe: Value(_restriction(_val(row, map['restriction']))),
        notes: Value(_nul(_val(row, map['notes']))),
      ),
    );
  }
  if (companions.isNotEmpty) {
    await db.batch((b) => b.insertAll(db.accueillants, companions));
  }
  return (importes: companions.length, ignores: ignores);
}

Future<ResultatImport> importerEnfants(
  AppDatabase db,
  FeuilleExcel f,
  Map<String, int> map, {
  bool dedupe = true,
}) async {
  final vus = dedupe
      ? {for (final e in await db.tousEnfants()) _cle(e.nom, e.prenom)}
      : <String>{};
  final companions = <EnfantsCompanion>[];
  var ignores = 0;
  for (final row in f.lignes) {
    final nom = _val(row, map['nom']);
    if (nom.isEmpty) continue;
    final prenom = _val(row, map['prenom']);
    if (dedupe && !vus.add(_cle(nom, prenom))) {
      ignores++;
      continue;
    }
    companions.add(
      EnfantsCompanion.insert(
        nom: nom,
        prenom: Value(prenom),
        sexe: Value(_sexe(_val(row, map['sexe']))),
        dateNaissance: Value(_dateOf(_val(row, map['naissance']))),
        notes: Value(_nul(_val(row, map['notes']))),
      ),
    );
  }
  if (companions.isNotEmpty) {
    await db.batch((b) => b.insertAll(db.enfants, companions));
  }
  return (importes: companions.length, ignores: ignores);
}

// --- Helpers de conversion ---

String _pad2(int n) => n.toString().padLeft(2, '0');

String _texte(dynamic c) {
  if (c == null) return '';
  if (c is String) return c.trim();
  if (c is DateTime) return '${_pad2(c.day)}/${_pad2(c.month)}/${c.year}';
  if (c is int) return c.toString();
  if (c is double) {
    return c == c.roundToDouble() ? c.toInt().toString() : c.toString();
  }
  if (c is bool) return c ? 'oui' : 'non';
  return c.toString().trim();
}

String _val(List<String> row, int? col) =>
    (col != null && col >= 0 && col < row.length) ? row[col].trim() : '';

String? _nul(String s) => s.trim().isEmpty ? null : s.trim();

int _int(String s, {int defaut = 0}) {
  final m = RegExp(r'\d+').firstMatch(s);
  return m == null ? defaut : (int.tryParse(m.group(0)!) ?? defaut);
}

String _sexe(String s) {
  final v = s.toLowerCase().trim();
  if (v.startsWith('f') || v.contains('fille') || v.contains('fém')) {
    return sexeFille;
  }
  return sexeGarcon;
}

String _restriction(String s) {
  final v = s.toLowerCase().trim();
  if (v.contains('fille') || v == 'f') return restrictionFille;
  if (v.contains('garç') ||
      v.contains('garc') ||
      v.contains('masc') ||
      v == 'g' ||
      v == 'm') {
    return restrictionGarcon;
  }
  return restrictionAucune;
}

DateTime? _dateOf(String s) {
  final t = s.trim();
  if (t.isEmpty) return null;
  // jj/mm/aaaa (ou jj-mm-aaaa, jj.mm.aaaa)
  final m = RegExp(r'^(\d{1,2})[/.\-](\d{1,2})[/.\-](\d{2,4})$').firstMatch(t);
  if (m != null) {
    var y = int.parse(m.group(3)!);
    if (y < 100) y += 2000;
    final mois = int.parse(m.group(2)!);
    final jour = int.parse(m.group(1)!);
    if (mois >= 1 && mois <= 12 && jour >= 1 && jour <= 31) {
      return DateTime(y, mois, jour);
    }
  }
  // aaaa-mm-jj (ISO) et autres formats reconnus.
  return DateTime.tryParse(t);
}
