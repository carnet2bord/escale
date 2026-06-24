import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';

import '../data/database.dart';
import '../domain/conflits.dart';
import '../domain/dates.dart';
import '../domain/pdf_export.dart';
import 'apercu_pdf_page.dart';
import 'export_pdf_page.dart';
import 'proposition_page.dart';
import 'widgets.dart';

// Ouvre l'éditeur de relais pré-rempli pour couvrir un besoin (un enfant sur
// une période). Retourne true si un relais a été créé.
Future<bool> creerRelaisPourBesoin(
  BuildContext context, {
  required int enfantId,
  required DateTime debut,
  required DateTime fin,
}) async {
  final db = context.read<AppDatabase>();
  final data = await _PlanningData.charger(db);
  if (!context.mounted) return false;
  final cree = await Navigator.of(context).push<bool>(
    MaterialPageRoute(
      builder: (_) => _AffectationEditor(
        data: data,
        enfantInitial: enfantId,
        periodeInitiale: DateTimeRange(start: debut, end: fin),
      ),
    ),
  );
  return cree == true;
}

// Instantané de toutes les données nécessaires au planning et aux conflits.
class _PlanningData {
  final List<Enfant> enfants;
  final List<Accueillant> accueillants;
  final List<Affectation> affectations;
  final List<Incompatibilite> incompatibilites;
  final List<DisponibiliteAccueil> dispos;
  final List<Indisponibilite> indispos;
  final List<Fratrie> fratries;
  final List<PreferenceAccueil> preferences;
  final List<SolutionAlternative> solutions;

  _PlanningData({
    required this.enfants,
    required this.accueillants,
    required this.affectations,
    required this.incompatibilites,
    required this.dispos,
    required this.indispos,
    required this.fratries,
    required this.preferences,
    required this.solutions,
  });

  static Future<_PlanningData> charger(AppDatabase db) async {
    final res = await Future.wait([
      db.tousEnfants(),
      db.tousAccueillants(),
      db.toutesAffectations(),
      db.toutesIncompatibilites(),
      db.toutesDisponibilites(),
      db.toutesIndisponibilites(),
      db.toutesFratries(),
      db.toutesPreferences(),
      db.toutesSolutions(),
    ]);
    return _PlanningData(
      enfants: res[0] as List<Enfant>,
      accueillants: res[1] as List<Accueillant>,
      affectations: res[2] as List<Affectation>,
      incompatibilites: res[3] as List<Incompatibilite>,
      dispos: res[4] as List<DisponibiliteAccueil>,
      indispos: res[5] as List<Indisponibilite>,
      fratries: res[6] as List<Fratrie>,
      preferences: res[7] as List<PreferenceAccueil>,
      solutions: res[8] as List<SolutionAlternative>,
    );
  }

  Enfant? enfant(int id) {
    for (final e in enfants) {
      if (e.id == id) return e;
    }
    return null;
  }

  Accueillant? accueillant(int id) {
    for (final a in accueillants) {
      if (a.id == id) return a;
    }
    return null;
  }
}

enum _Vue { liste, calendrier }

class PlanningPage extends StatefulWidget {
  const PlanningPage({super.key});

  @override
  State<PlanningPage> createState() => _PlanningPageState();
}

class _PlanningPageState extends State<PlanningPage> {
  late final Stream<_PlanningData> _flux;
  _Vue _vue = _Vue.liste;

  @override
  void initState() {
    super.initState();
    final db = context.read<AppDatabase>();
    _flux = db.fluxChangements().asyncMap((_) => _PlanningData.charger(db));
  }

  List<Conflit> _conflitsDe(_PlanningData d, Affectation a) {
    final enfant = d.enfant(a.enfantId);
    final accueillant = d.accueillant(a.accueillantId);
    if (enfant == null || accueillant == null) return const [];
    return analyserAffectation(
      enfant: enfant,
      accueillant: accueillant,
      debut: a.debut,
      fin: a.fin,
      affectations: d.affectations,
      disponibilites: d.dispos
          .where((x) => x.accueillantId == accueillant.id)
          .toList(),
      indisponibilites: d.indispos
          .where((x) => x.accueillantId == accueillant.id)
          .toList(),
      incompatibilites: d.incompatibilites,
      enfants: d.enfants,
      fratries: d.fratries,
      preferences: d.preferences,
      solutions: d.solutions,
      affectationExclueId: a.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planning des relais'),
        centerTitle: false,
        actions: [
          IconButton(
            tooltip: 'Exporter en PDF',
            icon: const Icon(Icons.picture_as_pdf_outlined),
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const ExportPdfPage())),
          ),
          const SizedBox(width: 4),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: FilledButton.tonalIcon(
              onPressed: _proposer,
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Proposer'),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _nouveauRelais(),
        icon: const Icon(Icons.add),
        label: const Text('Nouveau relais'),
      ),
      body: StreamBuilder<_PlanningData>(
        stream: _flux,
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final d = snap.data!;
          final vide = d.affectations.isEmpty && d.solutions.isEmpty;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SegmentedButton<_Vue>(
                    segments: const [
                      ButtonSegment(
                        value: _Vue.liste,
                        icon: Icon(Icons.view_list_outlined),
                        label: Text('Liste'),
                      ),
                      ButtonSegment(
                        value: _Vue.calendrier,
                        icon: Icon(Icons.calendar_view_week_outlined),
                        label: Text('Calendrier'),
                      ),
                    ],
                    selected: {_vue},
                    onSelectionChanged: (s) => setState(() => _vue = s.first),
                  ),
                ),
              ),
              Expanded(
                child: vide
                    ? EmptyState(
                        icone: Icons.calendar_month_outlined,
                        titre: 'Aucun relais planifié',
                        sousTitre:
                            'Créez un relais manuellement, ou laissez « Proposer » placer automatiquement les enfants.',
                        action: FilledButton.icon(
                          onPressed: _nouveauRelais,
                          icon: const Icon(Icons.add),
                          label: const Text('Nouveau relais'),
                        ),
                      )
                    : (_vue == _Vue.liste ? _vueListe(d) : _VueCalendrier(d)),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _vueListe(_PlanningData d) {
    final affectations = [...d.affectations]
      ..sort((a, b) => a.debut.compareTo(b.debut));
    final solutions = [...d.solutions]
      ..sort((a, b) => a.debut.compareTo(b.debut));
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
      children: [
        for (final a in affectations)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _carteAffectation(d, a),
          ),
        if (solutions.isNotEmpty) ...[
          const SizedBox(height: 12),
          const SectionTitle(
            'Solutions alternatives',
            sousTitre:
                'Couvertures hors relais (colonie, accueil par un tiers…).',
          ),
          for (final sol in solutions)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _carteSolution(d, sol),
            ),
        ],
      ],
    );
  }

  Widget _carteAffectation(_PlanningData d, Affectation a) {
    final enfant = d.enfant(a.enfantId);
    final accueillant = d.accueillant(a.accueillantId);
    final annule = a.statut == statutAnnule;
    // Un relais annulé n'occupe plus de place : on n'affiche pas ses conflits.
    final conflits = annule ? const <Conflit>[] : _conflitsDe(d, a);
    final bloquants = conflits.where((c) => c.estBloquant).length;
    final avert = conflits.length - bloquants;
    final cs = Theme.of(context).colorScheme;
    final carte = Card(
      child: ListTile(
        leading: Icon(
          bloquants > 0
              ? Icons.error
              : (avert > 0 ? Icons.warning_amber_rounded : Icons.check_circle),
          color: bloquants > 0
              ? cs.error
              : (avert > 0 ? Colors.orange.shade700 : Colors.green.shade600),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                '${enfant == null ? '?' : nomComplet(enfant.nom, enfant.prenom)}'
                '  →  '
                '${accueillant == null ? '?' : nomComplet(accueillant.nom, accueillant.prenom)}',
                style: annule
                    ? const TextStyle(decoration: TextDecoration.lineThrough)
                    : null,
              ),
            ),
            const SizedBox(width: 8),
            Pastille(libelleStatut(a.statut), couleur: couleurStatut(a.statut)),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(periodeFr(a.debut, a.fin)),
            if (a.transport != null && a.transport!.trim().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.directions_car_outlined,
                      size: 14,
                      color: cs.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        a.transport!.trim(),
                        style: TextStyle(
                          fontSize: 12,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (conflits.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: ConflitsView(conflits),
              ),
          ],
        ),
        isThreeLine: conflits.isNotEmpty,
        trailing: PopupMenuButton<String>(
          tooltip: 'Actions',
          icon: const Icon(Icons.more_vert),
          onSelected: (v) => _actionRelais(d, a, v),
          itemBuilder: (_) => [
            if (a.statut == statutPropose)
              const PopupMenuItem(
                value: 'confirme',
                child: _ItemAction(Icons.check_circle_outline, 'Confirmer'),
              ),
            if (a.statut != statutRealise && a.statut != statutAnnule)
              const PopupMenuItem(
                value: 'realise',
                child: _ItemAction(Icons.task_alt, 'Marquer réalisé'),
              ),
            if (a.statut != statutAnnule)
              const PopupMenuItem(
                value: 'annule',
                child: _ItemAction(Icons.block, 'Annuler'),
              ),
            if (a.statut == statutAnnule)
              const PopupMenuItem(
                value: 'retablir',
                child: _ItemAction(Icons.restore, 'Rétablir'),
              ),
            const PopupMenuItem(
              value: 'transport',
              child: _ItemAction(
                Icons.directions_car_outlined,
                'Transport / RDV',
              ),
            ),
            const PopupMenuItem(
              value: 'fiche',
              child: _ItemAction(
                Icons.description_outlined,
                'Fiche de liaison (PDF)',
              ),
            ),
            const PopupMenuItem(
              value: 'dupliquer',
              child: _ItemAction(Icons.copy_all_outlined, 'Dupliquer'),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 'supprimer',
              child: _ItemAction(Icons.delete_outline, 'Supprimer'),
            ),
          ],
        ),
      ),
    );
    return annule ? Opacity(opacity: 0.6, child: carte) : carte;
  }

  Future<void> _actionRelais(_PlanningData d, Affectation a, String v) async {
    final db = context.read<AppDatabase>();
    if (v == 'supprimer') {
      await (db.delete(db.affectations)..where((t) => t.id.equals(a.id))).go();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Relais supprimé.'),
          action: SnackBarAction(
            label: 'Annuler',
            onPressed: () => db.reinsererAffectation(a),
          ),
        ),
      );
      return;
    }
    if (v == 'dupliquer') {
      await Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (_) => _AffectationEditor(
            data: d,
            enfantInitial: a.enfantId,
            accueillantInitial: a.accueillantId,
            periodeInitiale: DateTimeRange(start: a.debut, end: a.fin),
          ),
        ),
      );
      return;
    }
    if (v == 'transport') {
      final ctrl = TextEditingController(text: a.transport ?? '');
      final res = await showDialog<String?>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Transport / RDV'),
          content: TextField(
            controller: ctrl,
            autofocus: true,
            minLines: 2,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Modalités du jour J',
              hintText: 'Point et heure de RDV, qui amène / récupère…',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Annuler'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, ctrl.text),
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      );
      if (res != null) await db.majTransportAffectation(a.id, res);
      return;
    }
    if (v == 'fiche') {
      final enfant = d.enfant(a.enfantId);
      final accueillant = d.accueillant(a.accueillantId);
      if (enfant == null || accueillant == null) return;
      final reglages = await db.lireReglages();
      final logo = (await rootBundle.load(
        'assets/icon/logo_escale.png',
      )).buffer.asUint8List();
      if (!mounted) return;
      final afHab = enfant.afHabituelId == null
          ? null
          : d.accueillant(enfant.afHabituelId!);
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ApercuPdfPage(
            titre: 'Fiche de liaison',
            fichier: 'fiche-liaison-${enfant.nom.toLowerCase()}.pdf',
            builder: (format) => genererPdfConvention(
              structure: InfosStructure.depuisReglages(reglages),
              logo: logo,
              date: DateTime.now(),
              enfant: enfant,
              accueillant: accueillant,
              afHabituel: afHab,
              debut: a.debut,
              fin: a.fin,
              transport: a.transport,
            ),
          ),
        ),
      );
      return;
    }
    // Changement de statut.
    await db.majStatutAffectation(a.id, v == 'retablir' ? statutConfirme : v);
  }

  Widget _carteSolution(_PlanningData d, SolutionAlternative sol) {
    final enfant = d.enfant(sol.enfantId);
    return Card(
      child: ListTile(
        leading: Icon(_iconeSolution(sol.type), color: Colors.indigo),
        title: Text(
          '${enfant == null ? '?' : nomComplet(enfant.nom, enfant.prenom)}'
          '  ·  ${libelleSolution(sol.type)}',
        ),
        subtitle: Text(
          sol.details == null
              ? periodeFr(sol.debut, sol.fin)
              : '${periodeFr(sol.debut, sol.fin)} · ${sol.details}',
        ),
        trailing: IconButton(
          tooltip: 'Supprimer',
          icon: const Icon(Icons.delete_outline),
          onPressed: () async {
            final db = context.read<AppDatabase>();
            final messenger = ScaffoldMessenger.of(context);
            await (db.delete(
              db.solutionsAlternatives,
            )..where((t) => t.id.equals(sol.id))).go();
            messenger.showSnackBar(
              SnackBar(
                content: const Text('Solution supprimée.'),
                action: SnackBarAction(
                  label: 'Annuler',
                  onPressed: () => db.reinsererSolution(sol),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _proposer() async {
    final ids = await Navigator.of(context).push<List<int>>(
      MaterialPageRoute(builder: (_) => const PropositionPage()),
    );
    if (!mounted || ids == null || ids.isEmpty) return;
    final db = context.read<AppDatabase>();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${ids.length} relais proposé(s) — à confirmer dans le planning.',
        ),
        action: SnackBarAction(
          label: 'Annuler',
          onPressed: () =>
              (db.delete(db.affectations)..where((t) => t.id.isIn(ids))).go(),
        ),
      ),
    );
  }

  Future<void> _nouveauRelais() async {
    final d = await _PlanningData.charger(context.read<AppDatabase>());
    if (!mounted) return;
    if (d.enfants.isEmpty || d.accueillants.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Ajoutez au moins un enfant et un accueillant avant de planifier.',
          ),
        ),
      );
      return;
    }
    await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => _AffectationEditor(data: d)),
    );
    // Le flux réactif rafraîchit automatiquement.
  }
}

class _AffectationEditor extends StatefulWidget {
  final _PlanningData data;
  final int? enfantInitial;
  final int? accueillantInitial;
  final DateTimeRange? periodeInitiale;
  const _AffectationEditor({
    required this.data,
    this.enfantInitial,
    this.accueillantInitial,
    this.periodeInitiale,
  });

  @override
  State<_AffectationEditor> createState() => _AffectationEditorState();
}

class _AffectationEditorState extends State<_AffectationEditor> {
  int? _enfantId;
  int? _accueillantId;
  DateTimeRange? _periode;
  List<Conflit> _conflits = const [];

  _PlanningData get d => widget.data;

  @override
  void initState() {
    super.initState();
    _enfantId = widget.enfantInitial;
    _accueillantId = widget.accueillantInitial;
    _periode = widget.periodeInitiale;
    _conflits = _calculer();
  }

  List<Conflit> _calculer() {
    final e = _enfantId == null ? null : d.enfant(_enfantId!);
    final a = _accueillantId == null ? null : d.accueillant(_accueillantId!);
    if (e == null || a == null || _periode == null) return const [];
    return analyserAffectation(
      enfant: e,
      accueillant: a,
      debut: _periode!.start,
      fin: _periode!.end,
      affectations: d.affectations,
      disponibilites: d.dispos.where((x) => x.accueillantId == a.id).toList(),
      indisponibilites: d.indispos
          .where((x) => x.accueillantId == a.id)
          .toList(),
      incompatibilites: d.incompatibilites,
      enfants: d.enfants,
      fratries: d.fratries,
      preferences: d.preferences,
      solutions: d.solutions,
    );
  }

  void _recalculer() => setState(() => _conflits = _calculer());

  bool get _peutEnregistrer =>
      _enfantId != null &&
      _accueillantId != null &&
      _periode != null &&
      !_conflits.any((c) => c.estBloquant);

  Future<void> _enregistrer() async {
    if (!_peutEnregistrer) return;
    final db = context.read<AppDatabase>();
    await db
        .into(db.affectations)
        .insert(
          AffectationsCompanion.insert(
            enfantId: _enfantId!,
            accueillantId: _accueillantId!,
            debut: _periode!.start,
            fin: _periode!.end,
          ),
        );
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nouveau relais')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _peutEnregistrer ? _enregistrer : null,
        backgroundColor: _peutEnregistrer
            ? null
            : Theme.of(context).disabledColor,
        icon: const Icon(Icons.save),
        label: const Text('Enregistrer'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 96),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<int>(
                  initialValue: _enfantId,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Enfant',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    for (final e in d.enfants)
                      DropdownMenuItem(
                        value: e.id,
                        child: Text(
                          '${nomComplet(e.nom, e.prenom)} (${libelleSexe(e.sexe).toLowerCase()})',
                        ),
                      ),
                  ],
                  onChanged: (v) {
                    _enfantId = v;
                    _recalculer();
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  initialValue: _accueillantId,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Accueillant',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    for (final a in d.accueillants)
                      DropdownMenuItem(
                        value: a.id,
                        child: Text(
                          '${nomComplet(a.nom, a.prenom)} · ${a.nbPlaces} place(s)',
                        ),
                      ),
                  ],
                  onChanged: (v) {
                    _accueillantId = v;
                    _recalculer();
                  },
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () async {
                    final p = await choisirPeriode(context, initiale: _periode);
                    if (p != null) {
                      _periode = p;
                      _recalculer();
                    }
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Période du relais',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(
                      _periode == null
                          ? 'Choisir une période…'
                          : '${periodeFr(_periode!.start, _periode!.end)}  '
                                '(${nbJours(_periode!.start, _periode!.end)} jour(s))',
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  color: _conflits.any((c) => c.estBloquant)
                      ? Theme.of(context).colorScheme.errorContainer
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Vérification',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 12),
                        if (_enfantId == null ||
                            _accueillantId == null ||
                            _periode == null)
                          const Text(
                            'Choisissez un enfant, un accueillant et une période.',
                          )
                        else
                          ConflitsView(_conflits),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String libelleSolution(String type) {
  switch (type) {
    case solColonie:
      return 'Colonie de vacances';
    case solTiers:
      return 'Accueil par un tiers';
    default:
      return 'Autre solution';
  }
}

IconData _iconeSolution(String type) {
  switch (type) {
    case solColonie:
      return Icons.beach_access_outlined;
    case solTiers:
      return Icons.diversity_3_outlined;
    default:
      return Icons.more_horiz;
  }
}

class _ItemAction extends StatelessWidget {
  final IconData icone;
  final String texte;
  const _ItemAction(this.icone, this.texte);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [Icon(icone, size: 20), const SizedBox(width: 12), Text(texte)],
    );
  }
}

// Un créneau à afficher sur la frise (relais ou solution alternative).
class _BarreCal {
  final DateTime debut;
  final DateTime fin;
  final String label;
  final String tooltip;
  final Color couleur;
  int lane = 0;
  _BarreCal(this.debut, this.fin, this.label, this.tooltip, this.couleur);
}

class _LigneCal {
  final String nom;
  final bool special; // ligne « Hors relais »
  final List<_BarreCal> barres;
  final double hauteur;
  _LigneCal(this.nom, this.barres, this.hauteur, {this.special = false});
}

// Vue calendrier « type Skello » : accueillants en lignes (ordre alphabétique),
// créneaux colorés par type (relais / colonie / tiers), sur une frise étendue
// vers les mois passés et à venir (bandeau mois + année).
class _VueCalendrier extends StatefulWidget {
  final _PlanningData d;
  const _VueCalendrier(this.d);

  @override
  State<_VueCalendrier> createState() => _VueCalendrierState();
}

class _VueCalendrierState extends State<_VueCalendrier> {
  final ScrollController _hCtrl = ScrollController();
  bool _saut = false;

  static const double _dayW = 40;
  static const double _barH = 26;
  static const double _gap = 5;
  static const double _nameW = 190;
  static const double _monthBandH = 22;
  static const double _dayBandH = 44;
  static const double _headerH = _monthBandH + _dayBandH;

  static const _coulRelais = Color(0xFF156F6C);
  static const _coulColonie = Color(0xFFC2710C);
  static const _coulTiers = Color(0xFF7C3AED);
  static const _coulAutre = Color(0xFF6B7280);

  Color _coulSolution(String type) => switch (type) {
    solColonie => _coulColonie,
    solTiers => _coulTiers,
    _ => _coulAutre,
  };

  @override
  void dispose() {
    _hCtrl.dispose();
    super.dispose();
  }

  double _assignerLanes(List<_BarreCal> barres) {
    barres.sort((a, b) => a.debut.compareTo(b.debut));
    final laneFin = <DateTime>[];
    for (final b in barres) {
      final deb = jour(b.debut);
      var lane = 0;
      while (lane < laneFin.length && !deb.isAfter(laneFin[lane])) {
        lane++;
      }
      if (lane == laneFin.length) {
        laneFin.add(jour(b.fin));
      } else {
        laneFin[lane] = jour(b.fin);
      }
      b.lane = lane;
    }
    final nb = laneFin.isEmpty ? 1 : laneFin.length;
    return nb * (_barH + _gap) + _gap;
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.d;
    final cs = Theme.of(context).colorScheme;
    final affs = d.affectations;
    final sols = d.solutions;

    // Plage : autour des données ET d'aujourd'hui, étendue de plusieurs mois.
    final today = jour(DateTime.now());
    var dmin = today, dmax = today;
    for (final a in affs) {
      if (jour(a.debut).isBefore(dmin)) dmin = jour(a.debut);
      if (jour(a.fin).isAfter(dmax)) dmax = jour(a.fin);
    }
    for (final s in sols) {
      if (jour(s.debut).isBefore(dmin)) dmin = jour(s.debut);
      if (jour(s.fin).isAfter(dmax)) dmax = jour(s.fin);
    }
    final start = DateTime(dmin.year, dmin.month - 6, 1);
    final end = DateTime(dmax.year, dmax.month + 13, 0); // fin du mois +12
    final nbJoursTotal = end.difference(start).inDays + 1;
    final totalW = nbJoursTotal * _dayW;
    int indexDe(DateTime dt) => jour(dt).difference(start).inDays;

    // Mois (pour le bandeau et les séparateurs).
    final mois = <(DateTime, int)>[];
    final debutsMois = <int>{};
    var m = DateTime(start.year, start.month, 1);
    while (!m.isAfter(end)) {
      final suivant = DateTime(m.year, m.month + 1, 1);
      mois.add((m, suivant.difference(m).inDays));
      debutsMois.add(indexDe(m));
      m = suivant;
    }

    // Lignes : accueillants (relais) + une ligne « Hors relais » (solutions).
    final accs = [...d.accueillants]
      ..sort(
        (a, b) => nomComplet(
          a.nom,
          a.prenom,
        ).toLowerCase().compareTo(nomComplet(b.nom, b.prenom).toLowerCase()),
      );
    final lignes = <_LigneCal>[];
    for (final acc in accs) {
      final barres = <_BarreCal>[];
      for (final a in affs.where(
        (x) => x.accueillantId == acc.id && relaisActif(x.statut),
      )) {
        final e = d.enfant(a.enfantId);
        final nom = e == null ? '?' : nomComplet(e.nom, e.prenom);
        barres.add(
          _BarreCal(
            a.debut,
            a.fin,
            nom,
            '$nom · ${periodeFr(a.debut, a.fin)}',
            _coulRelais,
          ),
        );
      }
      final h = _assignerLanes(barres);
      lignes.add(_LigneCal(nomComplet(acc.nom, acc.prenom), barres, h));
    }
    if (sols.isNotEmpty) {
      final barres = <_BarreCal>[];
      for (final s in sols) {
        final e = d.enfant(s.enfantId);
        final nom = e == null ? '?' : nomComplet(e.nom, e.prenom);
        barres.add(
          _BarreCal(
            s.debut,
            s.fin,
            nom,
            '$nom · ${libelleSolution(s.type)} · ${periodeFr(s.debut, s.fin)}',
            _coulSolution(s.type),
          ),
        );
      }
      final h = _assignerLanes(barres);
      lignes.add(_LigneCal('Hors relais', barres, h, special: true));
    }

    // Hauteurs cumulées des lignes.
    final tops = <double>[];
    var y = 0.0;
    for (final l in lignes) {
      tops.add(y);
      y += l.hauteur;
    }
    final totalRowsH = y;

    // Saut automatique sur la période actuelle (une seule fois).
    final cibleOffset = ((today.difference(start).inDays) - 1) * _dayW;
    if (!_saut) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_hCtrl.hasClients) return;
        _hCtrl.jumpTo(cibleOffset.clamp(0.0, _hCtrl.position.maxScrollExtent));
        _saut = true;
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _legende(cs),
        Expanded(
          child: SingleChildScrollView(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Colonne des noms (fixe horizontalement).
                Column(
                  children: [
                    SizedBox(
                      height: _headerH,
                      child: _celluleNom('', _headerH, cs, entete: true),
                    ),
                    for (final l in lignes)
                      _celluleNom(l.nom, l.hauteur, cs, special: l.special),
                  ],
                ),
                // Frise (défilement horizontal).
                Expanded(
                  child: SingleChildScrollView(
                    controller: _hCtrl,
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: totalW,
                      child: Column(
                        children: [
                          _entete(mois, nbJoursTotal, start, cs),
                          SizedBox(
                            width: totalW,
                            height: totalRowsH,
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: CustomPaint(
                                    painter: _GrillePainter(
                                      nbJours: nbJoursTotal,
                                      dayW: _dayW,
                                      start: start,
                                      separateursY: [
                                        for (var i = 1; i < tops.length; i++)
                                          tops[i],
                                        totalRowsH,
                                      ],
                                      debutsMois: debutsMois,
                                      ligne: cs.outlineVariant,
                                      faible: cs.outlineVariant.withValues(
                                        alpha: 0.4,
                                      ),
                                      weekend: cs.onSurface.withValues(
                                        alpha: 0.03,
                                      ),
                                    ),
                                  ),
                                ),
                                for (var i = 0; i < lignes.length; i++)
                                  for (final b in lignes[i].barres)
                                    Positioned(
                                      left: indexDe(b.debut) * _dayW + 2,
                                      top:
                                          tops[i] +
                                          b.lane * (_barH + _gap) +
                                          _gap,
                                      width:
                                          nbJours(b.debut, b.fin) * _dayW - 4,
                                      height: _barH,
                                      child: _barre(b),
                                    ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _entete(
    List<(DateTime, int)> mois,
    int nbJours,
    DateTime start,
    ColorScheme cs,
  ) {
    return Column(
      children: [
        // Bandeau mois + année.
        SizedBox(
          height: _monthBandH,
          child: Row(
            children: [
              for (final (m, jours) in mois)
                Container(
                  width: jours * _dayW,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(color: cs.outlineVariant),
                      bottom: BorderSide(
                        color: cs.outlineVariant.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                  child: Text(
                    moisAnneeFr(m),
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
        // Bandeau jours.
        SizedBox(
          height: _dayBandH,
          child: Row(
            children: [
              for (var i = 0; i < nbJours; i++)
                _celluleJour(start.add(Duration(days: i)), cs),
            ],
          ),
        ),
      ],
    );
  }

  Widget _legende(ColorScheme cs) {
    Widget item(Color c, String t) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: c,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(t, style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant)),
      ],
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Wrap(
        spacing: 18,
        runSpacing: 6,
        children: [
          item(_coulRelais, 'Relais'),
          item(_coulColonie, 'Colonie de vacances'),
          item(_coulTiers, 'Accueil par un tiers'),
        ],
      ),
    );
  }

  Widget _celluleNom(
    String texte,
    double h,
    ColorScheme cs, {
    bool entete = false,
    bool special = false,
  }) {
    return Container(
      width: _nameW,
      height: h,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: cs.outlineVariant)),
      ),
      child: Text(
        texte,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: special ? FontWeight.w500 : FontWeight.w600,
          fontStyle: special ? FontStyle.italic : FontStyle.normal,
          fontSize: 14,
          color: special ? cs.onSurfaceVariant : cs.onSurface,
        ),
      ),
    );
  }

  Widget _celluleJour(DateTime d, ColorScheme cs) {
    const lettres = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
    final we = d.weekday >= DateTime.saturday;
    return Container(
      width: _dayW,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: we ? cs.onSurface.withValues(alpha: 0.04) : null,
        border: Border(
          right: BorderSide(
            color: cs.outlineVariant.withValues(alpha: 0.5),
            width: 0.5,
          ),
          bottom: BorderSide(color: cs.outlineVariant),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            lettres[d.weekday - 1],
            style: TextStyle(fontSize: 10, color: cs.onSurfaceVariant),
          ),
          Text(
            '${d.day}',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _barre(_BarreCal b) {
    return Tooltip(
      message: b.tooltip,
      child: Container(
        decoration: BoxDecoration(
          color: b.couleur,
          borderRadius: BorderRadius.circular(7),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        alignment: Alignment.centerLeft,
        child: Text(
          b.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _GrillePainter extends CustomPainter {
  final int nbJours;
  final double dayW;
  final DateTime start;
  final List<double> separateursY;
  final Set<int> debutsMois;
  final Color ligne;
  final Color faible;
  final Color weekend;

  _GrillePainter({
    required this.nbJours,
    required this.dayW,
    required this.start,
    required this.separateursY,
    required this.debutsMois,
    required this.ligne,
    required this.faible,
    required this.weekend,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final pWe = Paint()..color = weekend;
    for (var i = 0; i < nbJours; i++) {
      if (start.add(Duration(days: i)).weekday >= DateTime.saturday) {
        canvas.drawRect(Rect.fromLTWH(i * dayW, 0, dayW, size.height), pWe);
      }
    }
    final pJour = Paint()
      ..color = faible
      ..strokeWidth = 0.5;
    final pMois = Paint()
      ..color = ligne
      ..strokeWidth = 1;
    for (var i = 1; i < nbJours; i++) {
      final x = i * dayW;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        debutsMois.contains(i) ? pMois : pJour,
      );
    }
    final pSep = Paint()
      ..color = faible
      ..strokeWidth = 0.5;
    for (final yy in separateursY) {
      canvas.drawLine(Offset(0, yy), Offset(size.width, yy), pSep);
    }
  }

  @override
  bool shouldRepaint(covariant _GrillePainter old) =>
      old.nbJours != nbJours || old.separateursY.length != separateursY.length;
}
