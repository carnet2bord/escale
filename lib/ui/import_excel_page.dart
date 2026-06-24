import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/database.dart';
import '../data/excel_import.dart';
import 'widgets.dart';

class ImportExcelPage extends StatefulWidget {
  final TypeImport type;
  const ImportExcelPage({required this.type, super.key});

  @override
  State<ImportExcelPage> createState() => _ImportExcelPageState();
}

class _ImportExcelPageState extends State<ImportExcelPage> {
  FeuilleExcel? _feuille;
  String? _nomFichier;
  String? _erreur;
  bool _chargement = true;
  bool _enCours = false;
  bool _dedupe = true;
  final Map<String, int> _map = {};

  String get _titre =>
      widget.type == TypeImport.accueillants ? 'accueillants' : 'enfants';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _ouvrir());
  }

  Future<void> _ouvrir() async {
    setState(() {
      _chargement = true;
      _erreur = null;
    });
    try {
      const groupe = XTypeGroup(label: 'Excel', extensions: ['xlsx']);
      final fichier = await openFile(acceptedTypeGroups: [groupe]);
      if (fichier == null) {
        if (mounted) Navigator.of(context).pop();
        return;
      }
      final bytes = await fichier.readAsBytes();
      final feuille = await lireExcel(bytes);
      if (!mounted) return;
      if (feuille.vide) {
        setState(() {
          _erreur =
              'Aucune colonne lisible dans ce fichier. Vérifiez qu\'il contient une ligne d\'en-têtes.';
          _chargement = false;
        });
        return;
      }
      _map.clear();
      for (final c in champsPour(widget.type)) {
        _map[c.cle] = devinerColonne(c.cle, feuille.entetes);
      }
      setState(() {
        _feuille = feuille;
        _nomFichier = fichier.name;
        _chargement = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _erreur =
            'Impossible de lire ce fichier Excel (.xlsx attendu).\n\nDétail : $e';
        _chargement = false;
      });
    }
  }

  bool get _pretAImporter {
    final nomCol = _map['nom'] ?? -1;
    return nomCol >= 0 && (_feuille?.lignes.isNotEmpty ?? false);
  }

  Future<void> _importer() async {
    final db = context.read<AppDatabase>();
    setState(() => _enCours = true);
    try {
      final r = widget.type == TypeImport.accueillants
          ? await importerAccueillants(db, _feuille!, _map, dedupe: _dedupe)
          : await importerEnfants(db, _feuille!, _map, dedupe: _dedupe);
      if (mounted) Navigator.of(context).pop(r);
    } catch (e) {
      if (!mounted) return;
      setState(() => _enCours = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Échec de l\'import : $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Importer des $_titre depuis Excel')),
      body: _chargement
          ? const Center(child: CircularProgressIndicator())
          : _erreur != null
          ? _vueErreur()
          : (_feuille == null || _feuille!.vide)
          ? _vueErreur()
          : _contenu(),
      floatingActionButton: (_chargement || _erreur != null || _feuille == null)
          ? null
          : FloatingActionButton.extended(
              onPressed: _pretAImporter && !_enCours ? _importer : null,
              backgroundColor: _pretAImporter
                  ? null
                  : Theme.of(context).disabledColor,
              icon: _enCours
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.download),
              label: Text('Importer ${_feuille?.lignes.length ?? 0} ligne(s)'),
            ),
    );
  }

  Widget _vueErreur() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                _erreur ?? 'Fichier illisible.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _ouvrir,
                icon: const Icon(Icons.folder_open),
                label: const Text('Choisir un autre fichier'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _contenu() {
    final f = _feuille!;
    final premiere = f.lignes.isNotEmpty ? f.lignes.first : null;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 96),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Astuce(
                'Fichier « $_nomFichier » · ${f.lignes.length} ligne(s) détectée(s). '
                'Indiquez quelle colonne du fichier correspond à chaque information.',
              ),
              const SizedBox(height: 12),
              Card(
                child: CheckboxListTile(
                  value: _dedupe,
                  onChanged: (v) => setState(() => _dedupe = v ?? true),
                  title: const Text('Ignorer les doublons'),
                  subtitle: const Text(
                    'Ne pas réimporter une personne déjà présente (même nom et prénom).',
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
              const SizedBox(height: 16),
              FormBloc(
                titre: 'Correspondance des colonnes',
                sousTitre:
                    'Le « Nom » est obligatoire. Laissez « — ignorer — » pour ne pas importer un champ.',
                enfants: [
                  for (final champ in champsPour(widget.type))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 220,
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(text: champ.libelle),
                                  if (champ.obligatoire)
                                    const TextSpan(
                                      text: ' *',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              initialValue: _map[champ.cle] ?? -1,
                              isExpanded: true,
                              decoration: const InputDecoration(isDense: true),
                              items: [
                                const DropdownMenuItem(
                                  value: -1,
                                  child: Text('— ignorer —'),
                                ),
                                for (var i = 0; i < f.entetes.length; i++)
                                  DropdownMenuItem(
                                    value: i,
                                    child: Text(
                                      f.entetes[i].isEmpty
                                          ? 'Colonne ${i + 1}'
                                          : f.entetes[i],
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                              ],
                              onChanged: (v) =>
                                  setState(() => _map[champ.cle] = v ?? -1),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              if (premiere != null) ...[
                const SizedBox(height: 16),
                FormBloc(
                  titre: 'Aperçu (1re ligne)',
                  sousTitre: 'Vérifiez que les valeurs tombent au bon endroit.',
                  enfants: [
                    for (final champ in champsPour(widget.type))
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 220,
                              child: Text(
                                champ.libelle,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                _apercu(champ.cle, premiere),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _apercu(String cle, List<String> ligne) {
    final col = _map[cle] ?? -1;
    if (col < 0 || col >= ligne.length) return '—';
    final v = ligne[col].trim();
    return v.isEmpty ? '—' : v;
  }
}
