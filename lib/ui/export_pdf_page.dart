import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../data/database.dart';
import '../domain/pdf_export.dart';

class _Donnees {
  final List<Enfant> enfants;
  final List<Accueillant> accueillants;
  final List<Affectation> affectations;
  final List<BesoinRelais> besoins;
  final List<SolutionAlternative> solutions;
  final Uint8List logo;
  final InfosStructure structure;
  _Donnees(
    this.enfants,
    this.accueillants,
    this.affectations,
    this.besoins,
    this.solutions,
    this.logo,
    this.structure,
  );
}

class ExportPdfPage extends StatefulWidget {
  const ExportPdfPage({super.key});

  @override
  State<ExportPdfPage> createState() => _ExportPdfPageState();
}

class _ExportPdfPageState extends State<ExportPdfPage> {
  late final Future<_Donnees> _future;
  bool _anonymiser = false;

  @override
  void initState() {
    super.initState();
    _future = _charger();
  }

  Future<_Donnees> _charger() async {
    final db = context.read<AppDatabase>();
    final res = await Future.wait([
      db.tousEnfants(),
      db.tousAccueillants(),
      db.toutesAffectations(),
      db.tousBesoins(),
      db.toutesSolutions(),
    ]);
    final reglages = await db.lireReglages();
    final logo = (await rootBundle.load(
      'assets/icon/logo_escale.png',
    )).buffer.asUint8List();
    return _Donnees(
      res[0] as List<Enfant>,
      res[1] as List<Accueillant>,
      res[2] as List<Affectation>,
      res[3] as List<BesoinRelais>,
      res[4] as List<SolutionAlternative>,
      logo,
      InfosStructure.depuisReglages(reglages),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Export PDF du planning')),
      body: FutureBuilder<_Donnees>(
        future: _future,
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final d = snap.data!;
          return Column(
            children: [
              SwitchListTile(
                value: _anonymiser,
                onChanged: (v) => setState(() => _anonymiser = v),
                secondary: const Icon(Icons.visibility_off_outlined),
                title: const Text('Anonymiser (initiales)'),
                subtitle: const Text(
                  'Pour partager le planning en réunion sans diffuser les noms.',
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: PdfPreview(
                  key: ValueKey(_anonymiser),
                  build: (format) => genererPdfRelais(
                    enfants: d.enfants,
                    accueillants: d.accueillants,
                    // Le planning officiel ignore les relais annulés.
                    affectations: d.affectations
                        .where((a) => relaisActif(a.statut))
                        .toList(),
                    besoins: d.besoins,
                    solutions: d.solutions,
                    logo: d.logo,
                    date: DateTime.now(),
                    structure: d.structure,
                    anonymiser: _anonymiser,
                  ),
                  canChangePageFormat: false,
                  canChangeOrientation: false,
                  canDebug: false,
                  pdfFileName: _anonymiser
                      ? 'planning-escale-anonymise.pdf'
                      : 'planning-escale.pdf',
                  pdfPreviewPageDecoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
