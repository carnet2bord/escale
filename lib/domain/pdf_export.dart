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

// Identité de la structure, reprise dans les documents générés.
class InfosStructure {
  final String nom;
  final String adresse;
  final String signataire;
  final String mention;
  const InfosStructure({
    this.nom = '',
    this.adresse = '',
    this.signataire = '',
    this.mention = '',
  });

  factory InfosStructure.depuisReglages(Map<String, String> r) =>
      InfosStructure(
        nom: r[cleStructureNom] ?? '',
        adresse: r[cleStructureAdresse] ?? '',
        signataire: r[cleStructureSignataire] ?? '',
        mention: r[cleStructureMention] ?? '',
      );
}

// Remplace les caractères non gérés par la police PDF standard (évite les « tofu »).
String _safe(String s) => s
    .replaceAll('—', '-')
    .replaceAll('–', '-')
    .replaceAll('→', '->')
    .replaceAll('…', '...')
    .replaceAll('’', "'")
    .replaceAll('‘', "'")
    .replaceAll('“', '"')
    .replaceAll('”', '"')
    .replaceAll(' ', ' ')
    .replaceAll(' ', ' ');

String _nom(String nom, String prenom) =>
    _safe(prenom.isEmpty ? nom : '$prenom $nom');

// Initiales seules (pour les exports anonymisés).
String _initiales(String nom, String prenom) {
  final p = prenom.trim();
  final n = nom.trim();
  final s =
      '${p.isNotEmpty ? '${p[0]}.' : ''} ${n.isNotEmpty ? '${n[0]}.' : ''}'
          .trim();
  return s.isEmpty ? '—' : s;
}

String _etiquette(String nom, String prenom, bool anon) =>
    anon ? _initiales(nom, prenom) : _nom(nom, prenom);

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
  InfosStructure structure = const InfosStructure(),
  bool anonymiser = false,
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
              structure.mention.isNotEmpty
                  ? _safe(structure.mention)
                  : 'Escale - Coordonner les relais',
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
        _enTete(
          logoImage,
          structure,
          'Planning des relais',
          'Édité le ${dateLongueFr(date)}',
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
            _sectionAccueillant(acc, anonymiser),
            _tableRelais(groupes[acc.id]!, parEnfant, anonymiser),
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
                [
                  _etiquette(e.nom, e.prenom, anonymiser),
                  periodeFr(d, f),
                  '${nbJours(d, f)} j',
                ],
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

// Fiche de liaison / convention d'un relais, à remettre à l'accueillant.
Future<Uint8List> genererPdfConvention({
  required InfosStructure structure,
  required Uint8List logo,
  required DateTime date,
  required Enfant enfant,
  required Accueillant accueillant,
  Accueillant? afHabituel,
  required DateTime debut,
  required DateTime fin,
  String? motif,
  String? transport,
}) async {
  final doc = pw.Document(title: 'Escale — Fiche de liaison', author: 'Escale');
  final logoImage = pw.MemoryImage(logo);
  final age = ageAnnees(enfant.dateNaissance, a: debut);
  final naiss = enfant.dateNaissance;

  pw.Widget ligne(String label, String valeur) => pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 5),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(
          width: 170,
          child: pw.Text(
            label,
            style: pw.TextStyle(fontSize: 10, color: _gris),
          ),
        ),
        pw.Expanded(
          child: pw.Text(
            valeur,
            style: pw.TextStyle(
              fontSize: 11,
              color: _texte,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );

  doc.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.fromLTRB(40, 40, 40, 40),
      build: (ctx) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _enTete(
            logoImage,
            structure,
            'Fiche de liaison',
            'Relais d\'accueil',
          ),
          pw.SizedBox(height: 8),
          pw.Divider(color: _filet),
          pw.SizedBox(height: 10),
          _bloc('Enfant accueilli'),
          ligne('Nom et prénom', _nom(enfant.nom, enfant.prenom)),
          ligne('Sexe', enfant.sexe == sexeFille ? 'Fille' : 'Garçon'),
          ligne(
            'Date de naissance',
            naiss == null
                ? 'Non renseignée'
                : '${dateLongueFr(naiss)}${age == null ? '' : ' ($age ans)'}',
          ),
          ligne(
            'Assistant familial habituel',
            afHabituel == null
                ? 'Non renseigné'
                : _nom(afHabituel.nom, afHabituel.prenom),
          ),
          if (enfant.contactUrgence != null &&
              enfant.contactUrgence!.trim().isNotEmpty)
            ligne('Contact d\'urgence', _safe(enfant.contactUrgence!.trim())),
          if (enfant.sante != null && enfant.sante!.trim().isNotEmpty) ...[
            pw.SizedBox(height: 8),
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                color: PdfColor.fromInt(0xFFFBEAEA),
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Santé - allergies / traitements',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 10,
                      color: PdfColor.fromInt(0xFFB3261E),
                    ),
                  ),
                  pw.SizedBox(height: 3),
                  pw.Text(
                    _safe(enfant.sante!.trim()),
                    style: pw.TextStyle(fontSize: 10, color: _texte),
                  ),
                ],
              ),
            ),
          ],
          pw.SizedBox(height: 14),
          _bloc('Relais'),
          ligne(
            'Accueillant désigné',
            _nom(accueillant.nom, accueillant.prenom),
          ),
          ligne(
            'Capacité d\'accueil',
            '${accueillant.nbPlaces} place(s) - ${_restrictionCourt(accueillant.restrictionSexe)}',
          ),
          ligne(
            'Période',
            '${periodeFr(debut, fin)}  (${nbJours(debut, fin)} jour(s))',
          ),
          if (motif != null && motif.trim().isNotEmpty)
            ligne('Motif', _safe(motif.trim())),
          if (transport != null && transport.trim().isNotEmpty)
            ligne('Transport / RDV', _safe(transport.trim())),
          pw.SizedBox(height: 18),
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              color: _tealClair,
              borderRadius: pw.BorderRadius.circular(6),
            ),
            child: pw.Text(
              'Document à conserver par l\'accueillant pendant toute la durée du relais.',
              style: pw.TextStyle(fontSize: 9, color: _teal),
            ),
          ),
          pw.Spacer(),
          pw.Row(
            children: [
              pw.Expanded(
                child: _signature(
                  'Le responsable du service',
                  structure.signataire,
                ),
              ),
              pw.SizedBox(width: 24),
              pw.Expanded(
                child: _signature(
                  'L\'accueillant',
                  _nom(accueillant.nom, accueillant.prenom),
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            'Édité le ${dateLongueFr(date)}'
            '${structure.mention.isEmpty ? '' : ' - ${_safe(structure.mention)}'}',
            style: pw.TextStyle(fontSize: 8, color: _gris),
          ),
        ],
      ),
    ),
  );
  return doc.save();
}

// Bilan d'activité institutionnel (synthèse + charge par accueillant).
Future<Uint8List> genererPdfBilan({
  required InfosStructure structure,
  required Uint8List logo,
  required DateTime date,
  required int nbAccueillants,
  required int nbEnfants,
  required int nbRelais,
  required int totalJours,
  required int joursCouverts,
  required List<(String, int, int)> charge,
}) async {
  final doc = pw.Document(
    title: 'Escale — Bilan d\'activité',
    author: 'Escale',
  );
  final logoImage = pw.MemoryImage(logo);
  final pct = totalJours == 0
      ? 100
      : (joursCouverts * 100 / totalJours).round();

  pw.Widget chip(String valeur, String libelle) => pw.Expanded(
    child: pw.Container(
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
              structure.mention.isNotEmpty
                  ? _safe(structure.mention)
                  : 'Escale - Coordonner les relais',
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
        _enTete(
          logoImage,
          structure,
          'Bilan d\'activité',
          'Édité le ${dateLongueFr(date)}',
        ),
        pw.SizedBox(height: 18),
        pw.Row(
          children: [
            chip('$nbRelais', 'Relais'),
            pw.SizedBox(width: 10),
            chip('$nbEnfants', 'Enfants'),
            pw.SizedBox(width: 10),
            chip('$nbAccueillants', 'Accueillants'),
            pw.SizedBox(width: 10),
            chip('$pct %', 'Couverture des besoins'),
          ],
        ),
        pw.SizedBox(height: 22),
        _bloc('Charge par accueillant'),
        pw.SizedBox(height: 6),
        pw.TableHelper.fromTextArray(
          headers: ['Accueillant', 'Relais', 'Jours d\'accueil'],
          data: [
            for (final (nom, jours, relais) in charge)
              [nom, '$relais', '$jours'],
          ],
          headerStyle: pw.TextStyle(
            color: _teal,
            fontWeight: pw.FontWeight.bold,
            fontSize: 10,
          ),
          headerDecoration: pw.BoxDecoration(color: _tealClair),
          cellStyle: pw.TextStyle(fontSize: 10, color: _texte),
          oddRowDecoration: pw.BoxDecoration(
            color: PdfColor.fromInt(0xFFF7F8F8),
          ),
          cellAlignments: {
            1: pw.Alignment.centerRight,
            2: pw.Alignment.centerRight,
          },
          columnWidths: {
            0: const pw.FlexColumnWidth(3),
            1: const pw.FlexColumnWidth(1),
            2: const pw.FlexColumnWidth(1.4),
          },
          border: pw.TableBorder.all(color: _filet, width: 0.5),
          cellPadding: const pw.EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 6,
          ),
        ),
        if (charge.isEmpty)
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 8),
            child: pw.Text(
              'Aucun relais sur la période.',
              style: pw.TextStyle(color: _gris),
            ),
          ),
      ],
    ),
  );
  return doc.save();
}

String _statutCourt(String s) => switch (s) {
  statutPropose => 'Proposé',
  statutRealise => 'Réalisé',
  statutAnnule => 'Annulé',
  _ => 'Confirmé',
};

String _libelleSol(String type) => switch (type) {
  solColonie => 'Colonie de vacances',
  solTiers => 'Accueil par un tiers',
  _ => 'Autre solution',
};

// En-tête commun aux documents : ligne logo + titre, puis le nom de la
// structure sur sa propre ligne pleine largeur (jamais tronqué).
pw.Widget _enTete(
  pw.MemoryImage logo,
  InfosStructure structure,
  String titre,
  String sousTitre,
) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Image(logo, height: 40),
          pw.Spacer(),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                titre,
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  color: _texte,
                ),
              ),
              if (sousTitre.isNotEmpty)
                pw.Text(
                  sousTitre,
                  style: pw.TextStyle(fontSize: 11, color: _teal),
                ),
            ],
          ),
        ],
      ),
      if (structure.nom.isNotEmpty) ...[
        pw.SizedBox(height: 10),
        pw.Text(
          _safe(structure.nom),
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
            color: _texte,
          ),
        ),
        if (structure.adresse.isNotEmpty)
          pw.Text(
            _safe(structure.adresse),
            style: pw.TextStyle(fontSize: 9, color: _gris),
          ),
      ],
    ],
  );
}

pw.Widget _piedMention(pw.Context ctx, InfosStructure structure) =>
    pw.Container(
      margin: const pw.EdgeInsets.only(top: 12),
      padding: const pw.EdgeInsets.only(top: 8),
      decoration: pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: _filet)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            structure.mention.isNotEmpty
                ? _safe(structure.mention)
                : 'Escale - Coordonner les relais',
            style: pw.TextStyle(fontSize: 8, color: _gris),
          ),
          pw.Text(
            'Page ${ctx.pageNumber} / ${ctx.pagesCount}',
            style: pw.TextStyle(fontSize: 8, color: _gris),
          ),
        ],
      ),
    );

// Planning individuel d'un accueillant (ses relais sur la période).
Future<Uint8List> genererPdfPlanningAccueillant({
  required InfosStructure structure,
  required Uint8List logo,
  required DateTime date,
  required Accueillant accueillant,
  required List<Affectation> affectations,
  required Map<int, Enfant> enfants,
}) async {
  final doc = pw.Document(
    title: 'Escale — Planning accueillant',
    author: 'Escale',
  );
  final logoImage = pw.MemoryImage(logo);
  final tri = [...affectations]..sort((a, b) => a.debut.compareTo(b.debut));
  final totalJours = tri.fold<int>(0, (n, a) => n + nbJours(a.debut, a.fin));

  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.fromLTRB(40, 40, 40, 50),
      footer: (ctx) => _piedMention(ctx, structure),
      build: (ctx) => [
        _enTete(
          logoImage,
          structure,
          'Planning individuel',
          _nom(accueillant.nom, accueillant.prenom),
        ),
        pw.SizedBox(height: 8),
        pw.Divider(color: _filet),
        pw.SizedBox(height: 10),
        pw.Text(
          '${tri.length} relais - $totalJours jour(s) d\'accueil - édité le ${dateLongueFr(date)}',
          style: pw.TextStyle(fontSize: 10, color: _gris),
        ),
        pw.SizedBox(height: 12),
        if (tri.isEmpty)
          pw.Text(
            'Aucun relais pour cet accueillant.',
            style: pw.TextStyle(color: _gris),
          )
        else
          pw.TableHelper.fromTextArray(
            headers: ['Enfant', 'Période', 'Durée', 'Statut'],
            data: [
              for (final a in tri)
                [
                  () {
                    final e = enfants[a.enfantId];
                    return e == null ? '—' : _nom(e.nom, e.prenom);
                  }(),
                  periodeFr(a.debut, a.fin),
                  '${nbJours(a.debut, a.fin)} j',
                  _statutCourt(a.statut),
                ],
            ],
            headerStyle: pw.TextStyle(
              color: _teal,
              fontWeight: pw.FontWeight.bold,
              fontSize: 10,
            ),
            headerDecoration: pw.BoxDecoration(color: _tealClair),
            cellStyle: pw.TextStyle(fontSize: 10, color: _texte),
            oddRowDecoration: pw.BoxDecoration(
              color: PdfColor.fromInt(0xFFF7F8F8),
            ),
            cellAlignments: {2: pw.Alignment.centerRight},
            columnWidths: {
              0: const pw.FlexColumnWidth(3),
              1: const pw.FlexColumnWidth(3),
              2: const pw.FlexColumnWidth(1),
              3: const pw.FlexColumnWidth(1.4),
            },
            border: pw.TableBorder.all(color: _filet, width: 0.5),
            cellPadding: const pw.EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 6,
            ),
          ),
      ],
    ),
  );
  return doc.save();
}

// Parcours individuel d'un enfant : relais + solutions, dans l'ordre.
Future<Uint8List> genererPdfPlanningEnfant({
  required InfosStructure structure,
  required Uint8List logo,
  required DateTime date,
  required Enfant enfant,
  required List<Affectation> affectations,
  required Map<int, Accueillant> accueillants,
  required List<SolutionAlternative> solutions,
}) async {
  final doc = pw.Document(title: 'Escale — Parcours enfant', author: 'Escale');
  final logoImage = pw.MemoryImage(logo);

  // (debut, fin, prise en charge)
  final entrees = <(DateTime, DateTime, String)>[
    for (final a in affectations)
      (
        a.debut,
        a.fin,
        () {
          final acc = accueillants[a.accueillantId];
          final nom = acc == null ? '?' : _nom(acc.nom, acc.prenom);
          final st = a.statut == statutConfirme
              ? ''
              : ' (${_statutCourt(a.statut)})';
          return 'Relais chez $nom$st';
        }(),
      ),
    for (final s in solutions)
      (
        s.debut,
        s.fin,
        s.details == null || s.details!.trim().isEmpty
            ? _libelleSol(s.type)
            : '${_libelleSol(s.type)} - ${_safe(s.details!.trim())}',
      ),
  ]..sort((a, b) => a.$1.compareTo(b.$1));

  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.fromLTRB(40, 40, 40, 50),
      footer: (ctx) => _piedMention(ctx, structure),
      build: (ctx) => [
        _enTete(
          logoImage,
          structure,
          'Parcours de l\'enfant',
          _nom(enfant.nom, enfant.prenom),
        ),
        pw.SizedBox(height: 8),
        pw.Divider(color: _filet),
        pw.SizedBox(height: 10),
        pw.Text(
          'Édité le ${dateLongueFr(date)}',
          style: pw.TextStyle(fontSize: 10, color: _gris),
        ),
        pw.SizedBox(height: 12),
        if (entrees.isEmpty)
          pw.Text(
            'Aucune prise en charge enregistrée.',
            style: pw.TextStyle(color: _gris),
          )
        else
          pw.TableHelper.fromTextArray(
            headers: ['Période', 'Prise en charge', 'Durée'],
            data: [
              for (final (d, f, lieu) in entrees)
                [periodeFr(d, f), lieu, '${nbJours(d, f)} j'],
            ],
            headerStyle: pw.TextStyle(
              color: _teal,
              fontWeight: pw.FontWeight.bold,
              fontSize: 10,
            ),
            headerDecoration: pw.BoxDecoration(color: _tealClair),
            cellStyle: pw.TextStyle(fontSize: 10, color: _texte),
            oddRowDecoration: pw.BoxDecoration(
              color: PdfColor.fromInt(0xFFF7F8F8),
            ),
            cellAlignments: {2: pw.Alignment.centerRight},
            columnWidths: {
              0: const pw.FlexColumnWidth(3),
              1: const pw.FlexColumnWidth(4),
              2: const pw.FlexColumnWidth(1),
            },
            border: pw.TableBorder.all(color: _filet, width: 0.5),
            cellPadding: const pw.EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 6,
            ),
          ),
      ],
    ),
  );
  return doc.save();
}

// Registre des traitements (modèle RGPD pré-rempli, à valider par le DPO).
Future<Uint8List> genererPdfRegistre({
  required InfosStructure structure,
  required Uint8List logo,
  required DateTime date,
}) async {
  final doc = pw.Document(title: 'Escale — Registre RGPD', author: 'Escale');
  final logoImage = pw.MemoryImage(logo);

  pw.Widget section(String titre, String contenu) => pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.SizedBox(height: 10),
      _bloc(titre),
      pw.SizedBox(height: 4),
      pw.Text(_safe(contenu), style: pw.TextStyle(fontSize: 10, color: _texte)),
    ],
  );

  final resp = structure.nom.isEmpty ? '[Nom du service]' : structure.nom;
  final dpo = structure.signataire.isEmpty
      ? '[Responsable / DPO]'
      : structure.signataire;

  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.fromLTRB(40, 40, 40, 50),
      footer: (ctx) => _piedMention(ctx, structure),
      build: (ctx) => [
        _enTete(
          logoImage,
          structure,
          'Registre des traitements',
          'Édité le ${dateLongueFr(date)}',
        ),
        pw.SizedBox(height: 6),
        pw.Divider(color: _filet),
        section(
          'Traitement',
          'Organisation et planification des relais d\'accueil familial '
              '(placement temporaire d\'enfants confiés chez un autre assistant '
              'familial).',
        ),
        section('Responsable du traitement', '$resp — $dpo.'),
        section(
          'Finalités',
          'Coordonner les relais, détecter les conflits, proposer des '
              'affectations, éditer les plannings et documents de liaison.',
        ),
        section(
          'Catégories de personnes concernées',
          'Enfants accueillis ; assistants familiaux ; personnes à prévenir / '
              'contacts d\'urgence.',
        ),
        section(
          'Catégories de données',
          'Identité (nom, prénom, sexe, date de naissance) ; assistant familial '
              'habituel ; périodes de besoin et d\'accueil ; préférences et '
              'incompatibilités ; le cas échéant, données de santé (allergies, '
              'traitements) — catégorie particulière (art. 9 RGPD).',
        ),
        section(
          'Base légale',
          'Mission d\'intérêt public / obligation légale liée à la protection '
              'de l\'enfance (art. 6 RGPD), et art. 9-2 pour les données de '
              'santé. À CONFIRMER par le DPO selon le cadre de la structure.',
        ),
        section(
          'Destinataires',
          'Personnels habilités du service ; assistants familiaux concernés '
              '(informations strictement nécessaires au relais).',
        ),
        section(
          'Hébergement & localisation',
          'Application locale (données sur le poste) ou serveur interne / '
              'hébergeur de données de santé (HDS) selon le déploiement retenu.',
        ),
        section(
          'Durée de conservation',
          'À définir par la structure (ex. N mois après le dernier relais), '
              'puis suppression ou anonymisation.',
        ),
        section(
          'Mesures de sécurité',
          'Accès protégé par mot de passe ; sauvegardes ; chiffrement du disque '
              'du poste recommandé (FileVault / BitLocker) ; en version web, '
              'chiffrement assuré par la base et l\'hébergement HDS.',
        ),
        pw.SizedBox(height: 16),
        pw.Container(
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(
            color: _tealClair,
            borderRadius: pw.BorderRadius.circular(6),
          ),
          child: pw.Text(
            'Modèle à compléter et à faire valider par le délégué à la '
            'protection des données (DPO). Ne constitue pas un avis juridique.',
            style: pw.TextStyle(fontSize: 9, color: _teal),
          ),
        ),
      ],
    ),
  );
  return doc.save();
}

pw.Widget _bloc(String titre) => pw.Container(
  width: double.infinity,
  margin: const pw.EdgeInsets.only(bottom: 4),
  padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
  decoration: pw.BoxDecoration(
    color: _tealClair,
    borderRadius: pw.BorderRadius.circular(6),
  ),
  child: pw.Text(
    titre,
    style: pw.TextStyle(
      fontWeight: pw.FontWeight.bold,
      fontSize: 11,
      color: _teal,
    ),
  ),
);

pw.Widget _signature(String role, String nom) => pw.Column(
  crossAxisAlignment: pw.CrossAxisAlignment.start,
  children: [
    pw.Text(role, style: pw.TextStyle(fontSize: 9, color: _gris)),
    if (nom.isNotEmpty)
      pw.Text(_safe(nom), style: pw.TextStyle(fontSize: 10, color: _texte)),
    pw.SizedBox(height: 38),
    pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: _filet)),
      ),
      padding: const pw.EdgeInsets.only(top: 3),
      child: pw.Text(
        'Signature',
        style: pw.TextStyle(fontSize: 8, color: _gris),
      ),
    ),
  ],
);

pw.Widget _sectionAccueillant(Accueillant a, bool anon) {
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
          _etiquette(a.nom, a.prenom, anon),
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

pw.Widget _tableRelais(
  List<Affectation> affs,
  Map<int, Enfant> parEnfant,
  bool anon,
) {
  affs.sort((a, b) => a.debut.compareTo(b.debut));
  return pw.TableHelper.fromTextArray(
    headers: ['Enfant', 'Période', 'Durée'],
    data: [
      for (final a in affs)
        [
          () {
            final e = parEnfant[a.enfantId];
            return e == null ? '—' : _etiquette(e.nom, e.prenom, anon);
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
