import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/database.dart';
import '../domain/dates.dart';
import '../domain/proposition.dart';
import 'widgets.dart';

class _Donnees {
  final ResultatProposition resultat;
  _Donnees(this.resultat);

  static Future<_Donnees> calculer(AppDatabase db) async {
    final res = await Future.wait([
      db.tousEnfants(),
      db.tousAccueillants(),
      db.toutesAffectations(),
      db.tousBesoins(),
      db.toutesDisponibilites(),
      db.toutesIndisponibilites(),
      db.toutesIncompatibilites(),
      db.toutesFratries(),
      db.toutesPreferences(),
      db.toutesSolutions(),
    ]);
    final resultat = proposerAffectations(
      enfants: res[0] as List<Enfant>,
      accueillants: res[1] as List<Accueillant>,
      affectationsExistantes: res[2] as List<Affectation>,
      besoins: res[3] as List<BesoinRelais>,
      dispos: res[4] as List<DisponibiliteAccueil>,
      indispos: res[5] as List<Indisponibilite>,
      incompatibilites: res[6] as List<Incompatibilite>,
      fratries: res[7] as List<Fratrie>,
      preferences: res[8] as List<PreferenceAccueil>,
      solutions: res[9] as List<SolutionAlternative>,
    );
    return _Donnees(resultat);
  }
}

class PropositionPage extends StatefulWidget {
  const PropositionPage({super.key});

  @override
  State<PropositionPage> createState() => _PropositionPageState();
}

class _PropositionPageState extends State<PropositionPage> {
  late Future<_Donnees> _future;
  List<bool> _selection = const [];
  bool _selectionInit = false;

  @override
  void initState() {
    super.initState();
    _future = _Donnees.calculer(context.read<AppDatabase>());
  }

  Future<void> _appliquer(ResultatProposition r) async {
    final db = context.read<AppDatabase>();
    var n = 0;
    await db.batch((batch) {
      for (var i = 0; i < r.propositions.length; i++) {
        if (i < _selection.length && _selection[i]) {
          final p = r.propositions[i];
          batch.insert(
            db.affectations,
            AffectationsCompanion.insert(
              enfantId: p.enfant.id,
              accueillantId: p.accueillant.id,
              debut: p.debut,
              fin: p.fin,
            ),
          );
          n++;
        }
      }
    });
    if (mounted) Navigator.of(context).pop(n);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Proposition automatique')),
      body: FutureBuilder<_Donnees>(
        future: _future,
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Calcul des affectations possibles…'),
                  ],
                ),
              ),
            );
          }
          final r = snap.data!.resultat;
          if (!_selectionInit) {
            _selection = List<bool>.filled(r.propositions.length, true);
            _selectionInit = true;
          }
          if (r.propositions.isEmpty && r.nonPlaces.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'Rien à proposer : tous les besoins saisis sont déjà couverts '
                  '(ou aucun besoin n\'a été saisi).',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          final nbSel = _selection.where((x) => x).length;
          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                  children: [
                    Row(
                      children: [
                        Pastille(
                          '${r.propositions.length} proposée(s)',
                          couleur: Colors.green.shade700,
                          icone: Icons.auto_awesome,
                        ),
                        const SizedBox(width: 8),
                        if (r.nonPlaces.isNotEmpty)
                          Pastille(
                            '${r.nonPlaces.length} non placée(s)',
                            couleur: Theme.of(context).colorScheme.error,
                            icone: Icons.report_problem,
                          ),
                      ],
                    ),
                    if (r.limiteAtteinte)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          'Recherche tronquée (problème volumineux) : la proposition '
                          'est valable mais peut ne pas être optimale.',
                          style: TextStyle(color: Colors.orange.shade800),
                        ),
                      ),
                    const SizedBox(height: 20),
                    if (r.propositions.isNotEmpty) ...[
                      Text(
                        'Affectations proposées',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Décochez celles que vous ne voulez pas appliquer.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 8),
                      for (var i = 0; i < r.propositions.length; i++)
                        _LigneProposition(
                          p: r.propositions[i],
                          coche: i < _selection.length && _selection[i],
                          onChange: (v) =>
                              setState(() => _selection[i] = v ?? false),
                        ),
                    ],
                    if (r.nonPlaces.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Text(
                        'Non placées',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Aucun accueillant disponible sans conflit sur ces périodes — à traiter manuellement.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 8),
                      for (final c in r.nonPlaces)
                        Card(
                          child: ListTile(
                            leading: Icon(
                              Icons.error,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            title: Text(
                              nomComplet(c.enfant.nom, c.enfant.prenom),
                            ),
                            subtitle: Text(periodeFr(c.debut, c.fin)),
                          ),
                        ),
                    ],
                  ],
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(0),
                        child: const Text('Annuler'),
                      ),
                      const SizedBox(width: 12),
                      FilledButton.icon(
                        onPressed: nbSel == 0 ? null : () => _appliquer(r),
                        icon: const Icon(Icons.check),
                        label: Text('Appliquer la sélection ($nbSel)'),
                      ),
                    ],
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

class _LigneProposition extends StatelessWidget {
  final Proposition p;
  final bool coche;
  final ValueChanged<bool?> onChange;
  const _LigneProposition({
    required this.p,
    required this.coche,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: CheckboxListTile(
        value: coche,
        onChanged: onChange,
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(
          '${nomComplet(p.enfant.nom, p.enfant.prenom)}'
          '  →  '
          '${nomComplet(p.accueillant.nom, p.accueillant.prenom)}',
        ),
        subtitle: Text(
          '${periodeFr(p.debut, p.fin)} · ${nbJours(p.debut, p.fin)} jour(s)',
        ),
      ),
    );
  }
}
