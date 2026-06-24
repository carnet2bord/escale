import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/database.dart';
import '../domain/conflits.dart';
import '../domain/dates.dart';
import '../domain/proposition.dart';
import 'planning_page.dart';
import 'widgets.dart';

enum Couverture { aucune, partielle, complete, incoherente }

class _Snapshot {
  final List<Enfant> enfants;
  final List<Accueillant> accueillants;
  final List<Affectation> affectations;
  final List<BesoinRelais> besoins;
  final List<Incompatibilite> incompatibilites;
  final List<DisponibiliteAccueil> dispos;
  final List<Indisponibilite> indispos;
  final List<Fratrie> fratries;
  final List<PreferenceAccueil> preferences;
  final List<SolutionAlternative> solutions;

  _Snapshot({
    required this.enfants,
    required this.accueillants,
    required this.affectations,
    required this.besoins,
    required this.incompatibilites,
    required this.dispos,
    required this.indispos,
    required this.fratries,
    required this.preferences,
    required this.solutions,
  });

  static Future<_Snapshot> charger(AppDatabase db) async {
    final res = await Future.wait([
      db.tousEnfants(),
      db.tousAccueillants(),
      db.toutesAffectations(),
      db.tousBesoins(),
      db.toutesIncompatibilites(),
      db.toutesDisponibilites(),
      db.toutesIndisponibilites(),
      db.toutesFratries(),
      db.toutesPreferences(),
      db.toutesSolutions(),
    ]);
    return _Snapshot(
      enfants: res[0] as List<Enfant>,
      accueillants: res[1] as List<Accueillant>,
      affectations: res[2] as List<Affectation>,
      besoins: res[3] as List<BesoinRelais>,
      incompatibilites: res[4] as List<Incompatibilite>,
      dispos: res[5] as List<DisponibiliteAccueil>,
      indispos: res[6] as List<Indisponibilite>,
      fratries: res[7] as List<Fratrie>,
      preferences: res[8] as List<PreferenceAccueil>,
      solutions: res[9] as List<SolutionAlternative>,
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late final Stream<_Snapshot> _flux;

  @override
  void initState() {
    super.initState();
    final db = context.read<AppDatabase>();
    // Flux réactif : recharge l'instantané dès qu'une donnée change.
    _flux = db.fluxChangements().asyncMap((_) => _Snapshot.charger(db));
  }

  (DateTime, DateTime) _premierTrou(_Snapshot s, BesoinRelais b) {
    final couvertures = couverturesEnfant(
      b.enfantId,
      s.affectations,
      s.solutions,
    );
    final trous = trousNonCouverts(b.debut, b.fin, couvertures);
    return trous.isEmpty ? (b.debut, b.fin) : trous.first;
  }

  Future<void> _planifier(_Snapshot s, BesoinRelais b) async {
    final (debut, fin) = _premierTrou(s, b);
    await creerRelaisPourBesoin(
      context,
      enfantId: b.enfantId,
      debut: debut,
      fin: fin,
    );
    // Le flux réactif rafraîchit automatiquement.
  }

  Future<void> _solutionAlternative(
    _Snapshot s,
    BesoinRelais b,
    String type,
  ) async {
    final (debut, fin) = _premierTrou(s, b);
    final db = context.read<AppDatabase>();
    final ctrl = TextEditingController();
    final titre = type == solColonie
        ? 'Colonie de vacances'
        : 'Accueil par un tiers';
    final indication = type == solColonie
        ? 'Nom de la colonie / du séjour'
        : 'Nom du tiers (famille, proche…)';
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(titre),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              periodeFr(debut, fin),
              style: Theme.of(ctx).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: ctrl,
              autofocus: true,
              decoration: InputDecoration(labelText: indication),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await db
        .into(db.solutionsAlternatives)
        .insert(
          SolutionsAlternativesCompanion.insert(
            enfantId: b.enfantId,
            debut: debut,
            fin: fin,
            type: type,
            details: Value(ctrl.text.trim().isEmpty ? null : ctrl.text.trim()),
          ),
        );
  }

  Couverture _couvertureBesoin(_Snapshot s, BesoinRelais b) {
    // Besoin aux dates incohérentes (fin avant début) : à signaler, pas à ignorer.
    if (jour(b.fin).isBefore(jour(b.debut))) return Couverture.incoherente;
    final couvertures = couverturesEnfant(
      b.enfantId,
      s.affectations,
      s.solutions,
    );
    var d = jour(b.debut);
    final f = jour(b.fin);
    var couverts = 0, total = 0;
    while (!d.isAfter(f)) {
      total++;
      final jourCouvert = couvertures.any(
        (c) => !d.isBefore(jour(c.$1)) && !d.isAfter(jour(c.$2)),
      );
      if (jourCouvert) couverts++;
      d = d.add(const Duration(days: 1));
    }
    if (couverts == 0) return Couverture.aucune;
    if (couverts < total) return Couverture.partielle;
    return Couverture.complete;
  }

  int _conflitsBloquants(_Snapshot s) {
    var n = 0;
    final parEnfant = {for (final e in s.enfants) e.id: e};
    final parAcc = {for (final a in s.accueillants) a.id: a};
    for (final a in s.affectations) {
      final e = parEnfant[a.enfantId];
      final acc = parAcc[a.accueillantId];
      if (e == null || acc == null) continue;
      final conflits = analyserAffectation(
        enfant: e,
        accueillant: acc,
        debut: a.debut,
        fin: a.fin,
        affectations: s.affectations,
        disponibilites: s.dispos
            .where((x) => x.accueillantId == acc.id)
            .toList(),
        indisponibilites: s.indispos
            .where((x) => x.accueillantId == acc.id)
            .toList(),
        incompatibilites: s.incompatibilites,
        enfants: s.enfants,
        fratries: s.fratries,
        preferences: s.preferences,
        solutions: s.solutions,
        affectationExclueId: a.id,
      );
      if (conflits.any((c) => c.estBloquant)) n++;
    }
    return n;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tableau de bord'), centerTitle: false),
      body: StreamBuilder<_Snapshot>(
        stream: _flux,
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final s = snap.data!;
          final parEnfant = {for (final e in s.enfants) e.id: e};
          final besoinsAProbleme =
              s.besoins
                  .map((b) => (b, _couvertureBesoin(s, b)))
                  .where((t) => t.$2 != Couverture.complete)
                  .toList()
                ..sort((a, b) => a.$1.debut.compareTo(b.$1.debut));
          final conflits = _conflitsBloquants(s);

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _StatCard(
                    icone: Icons.home,
                    valeur: '${s.accueillants.length}',
                    libelle: 'Accueillants',
                  ),
                  _StatCard(
                    icone: Icons.child_care,
                    valeur: '${s.enfants.length}',
                    libelle: 'Enfants',
                  ),
                  _StatCard(
                    icone: Icons.calendar_month,
                    valeur: '${s.affectations.length}',
                    libelle: 'Relais planifiés',
                  ),
                  _StatCard(
                    icone: Icons.warning_amber_rounded,
                    valeur: '$conflits',
                    libelle: 'Relais en conflit',
                    couleur: conflits > 0
                        ? Theme.of(context).colorScheme.error
                        : Colors.green.shade600,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const SectionTitle(
                'Besoins non couverts',
                sousTitre:
                    'Enfants dont la période de besoin n\'est pas entièrement assurée.',
              ),
              if (besoinsAProbleme.isEmpty)
                const Card(
                  child: ListTile(
                    leading: Icon(Icons.check_circle, color: Colors.green),
                    title: Text('Tous les besoins saisis sont couverts.'),
                  ),
                )
              else
                for (final (b, cov) in besoinsAProbleme)
                  Card(
                    child: ListTile(
                      leading: Icon(
                        cov == Couverture.incoherente
                            ? Icons.report_gmailerrorred_outlined
                            : cov == Couverture.aucune
                            ? Icons.error
                            : Icons.timelapse,
                        color: cov == Couverture.partielle
                            ? Colors.orange.shade700
                            : Theme.of(context).colorScheme.error,
                      ),
                      title: Text(() {
                        final e = parEnfant[b.enfantId];
                        return e == null
                            ? 'Enfant supprimé'
                            : nomComplet(e.nom, e.prenom);
                      }()),
                      subtitle: Text(
                        cov == Couverture.incoherente
                            ? 'Dates incohérentes (fin avant début) : ${periodeFr(b.debut, b.fin)}'
                            : periodeFr(b.debut, b.fin),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Pastille(
                            cov == Couverture.incoherente
                                ? 'Dates invalides'
                                : cov == Couverture.aucune
                                ? 'Sans solution'
                                : 'Partiel',
                            couleur: cov == Couverture.partielle
                                ? Colors.orange.shade700
                                : Theme.of(context).colorScheme.error,
                          ),
                          if (cov != Couverture.incoherente) ...[
                            const SizedBox(width: 12),
                            PopupMenuButton<String>(
                              tooltip: 'Couvrir ce besoin',
                              onSelected: (v) {
                                switch (v) {
                                  case 'relais':
                                    _planifier(s, b);
                                  case 'colonie':
                                    _solutionAlternative(s, b, solColonie);
                                  case 'tiers':
                                    _solutionAlternative(s, b, solTiers);
                                }
                              },
                              itemBuilder: (_) => const [
                                PopupMenuItem(
                                  value: 'relais',
                                  child: _ItemCouvrir(
                                    Icons.home_outlined,
                                    'Relais (accueillant)',
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'colonie',
                                  child: _ItemCouvrir(
                                    Icons.beach_access_outlined,
                                    'Colonie de vacances',
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'tiers',
                                  child: _ItemCouvrir(
                                    Icons.diversity_3_outlined,
                                    'Accueil par un tiers',
                                  ),
                                ),
                              ],
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 9,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.add,
                                      size: 18,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Couvrir',
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_drop_down,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
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

class _ItemCouvrir extends StatelessWidget {
  final IconData icone;
  final String texte;
  const _ItemCouvrir(this.icone, this.texte);
  @override
  Widget build(BuildContext context) => Row(
    children: [Icon(icone, size: 20), const SizedBox(width: 12), Text(texte)],
  );
}

class _StatCard extends StatelessWidget {
  final IconData icone;
  final String valeur;
  final String libelle;
  final Color? couleur;
  const _StatCard({
    required this.icone,
    required this.valeur,
    required this.libelle,
    this.couleur,
  });

  @override
  Widget build(BuildContext context) {
    final c = couleur ?? Theme.of(context).colorScheme.primary;
    return SizedBox(
      width: 210,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: c.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icone, size: 22, color: c),
              ),
              const SizedBox(height: 16),
              Text(
                valeur,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                libelle,
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 2,
                softWrap: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
