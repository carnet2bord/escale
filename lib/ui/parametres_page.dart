import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/database.dart';
import 'widgets.dart';

// Paramètres d'identité de la structure, repris en en-tête / pied des documents.
class ParametresStructurePage extends StatefulWidget {
  const ParametresStructurePage({super.key});

  @override
  State<ParametresStructurePage> createState() =>
      _ParametresStructurePageState();
}

class _ParametresStructurePageState extends State<ParametresStructurePage> {
  final _nom = TextEditingController();
  final _adresse = TextEditingController();
  final _signataire = TextEditingController();
  final _mention = TextEditingController();
  bool _charge = false;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    final r = await context.read<AppDatabase>().lireReglages();
    _nom.text = r[cleStructureNom] ?? '';
    _adresse.text = r[cleStructureAdresse] ?? '';
    _signataire.text = r[cleStructureSignataire] ?? '';
    _mention.text = r[cleStructureMention] ?? '';
    if (mounted) setState(() => _charge = true);
  }

  @override
  void dispose() {
    _nom.dispose();
    _adresse.dispose();
    _signataire.dispose();
    _mention.dispose();
    super.dispose();
  }

  Future<void> _enregistrer() async {
    final db = context.read<AppDatabase>();
    await db.ecrireReglage(cleStructureNom, _nom.text.trim());
    await db.ecrireReglage(cleStructureAdresse, _adresse.text.trim());
    await db.ecrireReglage(cleStructureSignataire, _signataire.text.trim());
    await db.ecrireReglage(cleStructureMention, _mention.text.trim());
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Paramètres enregistrés.')));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres de la structure')),
      body: !_charge
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const Astuce(
                  'Ces informations apparaissent en en-tête et en pied des '
                  'documents générés (planning, conventions, fiches de liaison…).',
                ),
                const SizedBox(height: 16),
                _champ(
                  _nom,
                  'Nom du service',
                  'Ex. Service d\'accueil familial — Département',
                ),
                _champ(_adresse, 'Adresse', 'Adresse postale du service', 2),
                _champ(
                  _signataire,
                  'Responsable / signataire',
                  'Nom et fonction de la personne qui signe',
                ),
                _champ(
                  _mention,
                  'Mention de bas de page',
                  'Ex. Document confidentiel — usage interne',
                  2,
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FilledButton.icon(
                    onPressed: _enregistrer,
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('Enregistrer'),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _champ(
    TextEditingController ctrl,
    String label,
    String hint, [
    int lignes = 1,
  ]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: ctrl,
        minLines: lignes,
        maxLines: lignes > 1 ? lignes + 1 : 1,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
