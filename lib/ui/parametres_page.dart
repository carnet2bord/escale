import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/database.dart';
import 'verrou.dart';
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
  final _seuilDistance = TextEditingController();
  bool _charge = false;
  bool _aMdp = false;

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
    _seuilDistance.text = r[cleDistanceSeuil] ?? '';
    _aMdp = (r[cleSecuriteHash] ?? '').isNotEmpty;
    if (mounted) setState(() => _charge = true);
  }

  Future<void> _definirMotDePasse() async {
    final db = context.read<AppDatabase>();
    final verrou = context.read<VerrouController>();
    final mdp = await _saisirMotDePasse();
    if (mdp == null) return;
    await db.definirMotDePasse(mdp);
    await verrou.rafraichir();
    if (!mounted) return;
    setState(() => _aMdp = true);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Mot de passe enregistré.')));
  }

  Future<void> _retirerMotDePasse() async {
    final db = context.read<AppDatabase>();
    final verrou = context.read<VerrouController>();
    if (!await confirmer(
      context,
      titre: 'Retirer le mot de passe ?',
      message: 'L\'application ne sera plus verrouillée au démarrage.',
      confirmer: 'Retirer',
    )) {
      return;
    }
    await db.supprimerMotDePasse();
    await verrou.rafraichir();
    if (!mounted) return;
    setState(() => _aMdp = false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Mot de passe retiré.')));
  }

  Future<String?> _saisirMotDePasse() {
    final mdp = TextEditingController();
    final conf = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) {
          String? erreur;
          void valider() {
            if (mdp.text.length < 4) {
              setLocal(() => erreur = '4 caractères minimum.');
            } else if (mdp.text != conf.text) {
              setLocal(
                () => erreur = 'Les mots de passe ne correspondent pas.',
              );
            } else {
              Navigator.pop(ctx, mdp.text);
            }
          }

          return AlertDialog(
            title: const Text('Mot de passe'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: mdp,
                  obscureText: true,
                  autofocus: true,
                  decoration: const InputDecoration(labelText: 'Mot de passe'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: conf,
                  obscureText: true,
                  onSubmitted: (_) => valider(),
                  decoration: InputDecoration(
                    labelText: 'Confirmer',
                    errorText: erreur,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Annuler'),
              ),
              FilledButton(
                onPressed: valider,
                child: const Text('Enregistrer'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _nom.dispose();
    _adresse.dispose();
    _signataire.dispose();
    _mention.dispose();
    _seuilDistance.dispose();
    super.dispose();
  }

  Future<void> _enregistrer() async {
    final db = context.read<AppDatabase>();
    await db.ecrireReglage(cleStructureNom, _nom.text.trim());
    await db.ecrireReglage(cleStructureAdresse, _adresse.text.trim());
    await db.ecrireReglage(cleStructureSignataire, _signataire.text.trim());
    await db.ecrireReglage(cleStructureMention, _mention.text.trim());
    await db.ecrireReglage(cleDistanceSeuil, _seuilDistance.text.trim());
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
                _champ(
                  _seuilDistance,
                  'Seuil de distance (km)',
                  'Alerte « relais éloigné » au-delà. Défaut : 30 km',
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
                const SizedBox(height: 28),
                const SectionTitle(
                  'Sécurité',
                  sousTitre:
                      'Protéger l\'accès à l\'application par un mot de passe '
                      '(verrouillage au démarrage et après 10 min d\'inactivité).',
                ),
                Card(
                  child: ListTile(
                    leading: Icon(
                      _aMdp ? Icons.lock_outline : Icons.lock_open_outlined,
                      color: _aMdp
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    title: Text(
                      _aMdp
                          ? 'Mot de passe actif'
                          : 'Aucun mot de passe défini',
                    ),
                    subtitle: Text(
                      _aMdp
                          ? 'L\'application est verrouillée au démarrage.'
                          : 'L\'accès n\'est pas protégé.',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          onPressed: _definirMotDePasse,
                          child: Text(_aMdp ? 'Modifier' : 'Définir'),
                        ),
                        if (_aMdp)
                          TextButton(
                            onPressed: _retirerMotDePasse,
                            child: const Text('Retirer'),
                          ),
                      ],
                    ),
                  ),
                ),
                const Astuce(
                  'Le mot de passe protège l\'ouverture de l\'application mais '
                  'ne chiffre pas le fichier de données. Pour une protection '
                  'au repos, gardez le poste lui-même sécurisé.',
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
