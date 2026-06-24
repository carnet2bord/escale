import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:relais/data/database.dart';
import 'package:relais/data/excel_import.dart';

void main() {
  test('import accueillants depuis un .xlsx réel', () async {
    final bytes = File('test/assets/accueillants.xlsx').readAsBytesSync();
    final f = lireExcelSync(bytes);
    expect(f.vide, isFalse);
    expect(f.lignes.length, 3);

    final map = {
      for (final c in champsAccueillant)
        c.cle: devinerColonne(c.cle, f.entetes),
    };
    expect(map['nom'], 0);

    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final r = await importerAccueillants(db, f, map);
    expect(r.importes, 3);
    expect(r.ignores, 0);

    final accs = await db.tousAccueillants();
    final lefevre = accs.firstWhere((a) => a.nom == 'Lefèvre');
    expect(lefevre.nbPlaces, 2);
    expect(lefevre.restrictionSexe, restrictionFille);
    final bernard = accs.firstWhere((a) => a.nom == 'Bernard');
    expect(bernard.nbPlaces, 3);
    expect(bernard.restrictionSexe, restrictionAucune);

    // Réimport du même fichier : tout est ignoré (dédoublonnage).
    final r2 = await importerAccueillants(db, f, map);
    expect(r2.importes, 0);
    expect(r2.ignores, 3);
    expect((await db.tousAccueillants()).length, 3);
  });

  test(
    'import enfants depuis un .xlsx réel (en-têtes variés, dates mixtes)',
    () async {
      final bytes = File('test/assets/enfants.xlsx').readAsBytesSync();
      final f = lireExcelSync(bytes);
      expect(f.lignes.length, 3);

      final map = {
        for (final c in champsEnfant) c.cle: devinerColonne(c.cle, f.entetes),
      };
      expect(map['nom'], greaterThanOrEqualTo(0));
      expect(map['sexe'], greaterThanOrEqualTo(0));

      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final r = await importerEnfants(db, f, map);
      expect(r.importes, 3);

      final enfants = await db.tousEnfants();
      final camille = enfants.firstWhere((e) => e.nom == 'Petit');
      expect(camille.sexe, sexeFille);
      expect(camille.dateNaissance?.year, 2017);
      final sarah = enfants.firstWhere((e) => e.nom == 'Bonnet');
      expect(sarah.sexe, sexeFille);
      expect(sarah.dateNaissance?.day, 12); // "12/06/2018"
      expect(sarah.dateNaissance?.month, 6);
    },
  );
}
