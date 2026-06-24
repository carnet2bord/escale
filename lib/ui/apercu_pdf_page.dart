import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

// Page d'aperçu / impression / partage d'un PDF généré (réutilisable).
class ApercuPdfPage extends StatelessWidget {
  final String titre;
  final String fichier;
  final Future<Uint8List> Function(PdfPageFormat) builder;
  const ApercuPdfPage({
    required this.titre,
    required this.fichier,
    required this.builder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(titre)),
      body: PdfPreview(
        build: builder,
        canChangePageFormat: false,
        canChangeOrientation: false,
        canDebug: false,
        pdfFileName: fichier,
        pdfPreviewPageDecoration: const BoxDecoration(color: Colors.white),
      ),
    );
  }
}
