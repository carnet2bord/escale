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
  _Donnees(
    this.enfants,
    this.accueillants,
    this.affectations,
    this.besoins,
    this.solutions,
    this.logo,
  );
}

class ExportPdfPage extends StatefulWidget {
  const ExportPdfPage({super.key});

  @override
  State<ExportPdfPage> createState() => _ExportPdfPageState();
}

class _ExportPdfPageState extends State<ExportPdfPage> {
  late final Future<_Donnees> _future;

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
          return PdfPreview(
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
            ),
            canChangePageFormat: false,
            canChangeOrientation: false,
            canDebug: false,
            pdfFileName: 'planning-escale.pdf',
            pdfPreviewPageDecoration: const BoxDecoration(color: Colors.white),
          );
        },
      ),
    );
  }
}
