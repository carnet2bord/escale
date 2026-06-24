import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../data/database.dart';
import 'dates.dart';
import 'proposition.dart';

// Couleurs de la charte Escale.
final _teal = PdfColor.fromInt(0xFF156F6C);
final _tealClair = PdfColor.fromInt(0xFFEAF3F1);
final _gris = PdfColor.fromInt(0xFF5A6168);
final _texte = PdfColor.fromInt(0xFF1A1C1E);
final _filet = PdfColor.fromInt(0xFFDDE1E4);

String _nom(String nom, String prenom) => prenom.isEmpty ? nom : '$prenom $nom';

String _restrictionCourt(String r) {
  switch (r) {
    case restrictionGarcon:
      return 'garçons uniquement';
    case restrictionFille:
      return 'filles uniquement';
    default:
      return 'mixte';
  }
}

// Génère le PDF du planning des relais, soigné et prêt à imprimer.
Future<Uint8List> genererPdfRelais({
  required List<Enfant> enfants,
  required List<Accueillant> accueillants,
  required List<Affectation> affectations,
  required List<BesoinRelais> besoins,
  required Uint8List logo,
  required DateTime date,
  List<SolutionAlternative> solutions = const [],
}) async {
  final doc = pw.Document(
    title: 'Escale — Planning des relais',
    author: 'Escale',
  );
  final logoImage = pw.MemoryImage(logo);

  final parEnfant = {for (final e in enfants) e.id: e};
  final parAcc = {for (final a in accueillants) a.id: a};

  // Affectations groupées par accueillant.
  final groupes = <int, List<Affectation>>{};
  for (final a in affectations) {
    (groupes[a.accueillantId] ??= []).add(a);
  }
  final accueillantsTries =
      groupes.keys.map((id) => parAcc[id]).whereType<Accueillant>().toList()
        ..sort(
          (a, b) => _nom(a.nom, a.prenom).compareTo(_nom(b.nom, b.prenom)),
        );

  // Période couverte.
  DateTime? minD, maxF;
  for (final a in affectations) {
    if (minD == null || a.debut.isBefore(minD)) minD = a.debut;
    if (maxF == null || a.fin.isAfter(maxF)) maxF = a.fin;
  }
  final enfantsConcernes = affectations.map((a) => a.enfantId).toSet().length;

  // Besoins non (entièrement) couverts.
  final aPlanifier = <(Enfant, DateTime, DateTime)>[];
  for (final b in besoins) {
    final e = parEnfant[b.enfantId];
    if (e == null) continue;
    final couvertures = couverturesEnfant(b.enfantId, affectations, solutions);
    for (final (d, f) in trousNonCouverts(b.debut, b.fin, couvertures)) {
      aPlanifier.add((e, d, f));
    }
  }

  pw.Widget chip(String valeur, String libelle) => pw.Container(
    padding: const pw.EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    decoration: pw.BoxDecoration(
      color: _tealClair,
      borderRadius: pw.BorderRadius.circular(8),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          valeur,
          style: pw.TextStyle(
            fontSize: 17,
            fontWeight: pw.FontWeight.bold,
            color: _teal,
          ),
        ),
        pw.SizedBox(height: 2),
        pw.Text(libelle, style: pw.TextStyle(fontSize: 9, color: _gris)),
      ],
    ),
  );

  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.fromLTRB(40, 40, 40, 50),
      footer: (ctx) => pw.Container(
        margin: const pw.EdgeInsets.only(top: 12),
        padding: const pw.EdgeInsets.only(top: 8),
        decoration: pw.BoxDecoration(
          border: pw.Border(top: pw.BorderSide(color: _filet)),
        ),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'Escale — Coordonner les relais',
              style: pw.TextStyle(fontSize: 8, color: _gris),
            ),
            pw.Text(
              'Page ${ctx.pageNumber} / ${ctx.pagesCount}',
              style: pw.TextStyle(fontSize: 8, color: _gris),
            ),
          ],
        ),
      ),
      build: (ctx) => [
        // En-tête : logo + titre + date.
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Image(logoImage, height: 42),
            pw.Spacer(),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  'Planning des relais',
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                    color: _texte,
                  ),
                ),
                pw.SizedBox(height: 2),
                pw.Text(
                  'Édité le ${dateLongueFr(date)}',
                  style: pw.TextStyle(fontSize: 10, color: _gris),
                ),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 18),
        // Bandeau de synthèse.
        pw.Row(
          children: [
            pw.Expanded(
              child: chip('${affectations.length}', 'Relais planifiés'),
            ),
            pw.SizedBox(width: 10),
            pw.Expanded(child: chip('$enfantsConcernes', 'Enfants concernés')),
            pw.SizedBox(width: 10),
            pw.Expanded(
              child: chip(
                '${accueillantsTries.length}',
                'Accueillants mobilisés',
              ),
            ),
            pw.SizedBox(width: 10),
            pw.Expanded(
              child: chip(
                minD == null ? '-' : '${dateFr(minD)} au ${dateFr(maxF!)}',
                'Période couverte',
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 22),

        if (affectations.isEmpty)
          pw.Text(
            'Aucun relais planifié pour l\'instant.',
            style: pw.TextStyle(color: _gris),
          )
        else
          for (final acc in accueillantsTries) ...[
            _sectionAccueillant(acc),
            _tableRelais(groupes[acc.id]!, parEnfant),
            pw.SizedBox(height: 18),
          ],

        // Section « à planifier ».
        if (aPlanifier.isNotEmpty) ...[
          pw.SizedBox(height: 6),
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: PdfColor.fromInt(0xFFFBEAEA),
            child: pw.Text(
              'Besoins encore à planifier',
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                color: PdfColor.fromInt(0xFFB3261E),
              ),
            ),
          ),
          pw.SizedBox(height: 6),
          pw.TableHelper.fromTextArray(
            headers: ['Enfant', 'Période', 'Durée'],
            data: [
              for (final (e, d, f) in aPlanifier)
                [_nom(e.nom, e.prenom), periodeFr(d, f), '${nbJours(d, f)} j'],
            ],
            headerStyle: pw.TextStyle(
              color: PdfColors.white,
              fontWeight: pw.FontWeight.bold,
              fontSize: 10,
            ),
            headerDecoration: pw.BoxDecoration(
              color: PdfColor.fromInt(0xFFB3261E),
            ),
            cellStyle: pw.TextStyle(fontSize: 10, color: _texte),
            cellAlignments: {2: pw.Alignment.centerRight},
            border: pw.TableBorder.all(color: _filet, width: 0.5),
            cellPadding: const pw.EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 6,
            ),
          ),
        ],
      ],
    ),
  );

  return doc.save();
}

pw.Widget _sectionAccueillant(Accueillant a) {
  return pw.Container(
    width: double.infinity,
    margin: const pw.EdgeInsets.only(bottom: 6),
    padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: pw.BoxDecoration(
      color: _tealClair,
      borderRadius: pw.BorderRadius.circular(6),
    ),
    child: pw.Row(
      children: [
        pw.Text(
          _nom(a.nom, a.prenom),
          style: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            fontSize: 12,
            color: _teal,
          ),
        ),
        pw.Spacer(),
        pw.Text(
          '${a.nbPlaces} place(s) · ${_restrictionCourt(a.restrictionSexe)}',
          style: pw.TextStyle(fontSize: 9, color: _gris),
        ),
      ],
    ),
  );
}

pw.Widget _tableRelais(List<Affectation> affs, Map<int, Enfant> parEnfant) {
  affs.sort((a, b) => a.debut.compareTo(b.debut));
  return pw.TableHelper.fromTextArray(
    headers: ['Enfant', 'Période', 'Durée'],
    data: [
      for (final a in affs)
        [
          () {
            final e = parEnfant[a.enfantId];
            return e == null ? '—' : _nom(e.nom, e.prenom);
          }(),
          periodeFr(a.debut, a.fin),
          '${nbJours(a.debut, a.fin)} j',
        ],
    ],
    headerStyle: pw.TextStyle(
      color: _teal,
      fontWeight: pw.FontWeight.bold,
      fontSize: 10,
    ),
    headerDecoration: pw.BoxDecoration(color: _tealClair),
    cellStyle: pw.TextStyle(fontSize: 10, color: _texte),
    oddRowDecoration: pw.BoxDecoration(color: PdfColor.fromInt(0xFFF7F8F8)),
    cellAlignments: {2: pw.Alignment.centerRight},
    columnWidths: {
      0: const pw.FlexColumnWidth(3),
      1: const pw.FlexColumnWidth(3),
      2: const pw.FlexColumnWidth(1),
    },
    border: pw.TableBorder.all(color: _filet, width: 0.5),
    cellPadding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
  );
}
