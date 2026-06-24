import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/database.dart';
import '../domain/dates.dart';
import 'planning_page.dart';
import 'widgets.dart';

Color _couleurSexe(String sexe) =>
    sexe == sexeFille ? const Color(0xFFB23A6B) : const Color(0xFF2F6BB2);

List<DropdownMenuItem<String>> optionsRegroupement() => const [
  DropdownMenuItem(
    value: regroupementEnsemble,
    child: Text('À garder ensemble'),
  ),
  DropdownMenuItem(value: regroupementSepares, child: Text('À séparer')),
  DropdownMenuItem(value: regroupementIndifferent, child: Text('Indifférent')),
];

class EnfantsPage extends StatefulWidget {
  const EnfantsPage({super.key});

  @override
  State<EnfantsPage> createState() => _EnfantsPageState();
}

class _EnfantsPageState extends State<EnfantsPage> {
  String _query = '';

  void _ouvrirEditeur(Enfant? e) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => _EnfantEditor(enfant: e)));
  }

  @override
  Widget build(BuildContext context) {
    final db = context.read<AppDatabase>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enfants'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: FilledButton.icon(
              onPressed: () => _ouvrirEditeur(null),
              icon: const Icon(Icons.add),
              label: const Text('Nouvel enfant'),
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<Enfant>>(
        stream: db.watchEnfants(),
        builder: (context, snap) {
          final tous = snap.data ?? [];
          if (tous.isEmpty) {
            return EmptyState(
              icone: Icons.child_care_outlined,
              titre: 'Aucun enfant pour l\'instant',
              sousTitre:
                  'Ajoutez les enfants à placer en relais, avec leurs besoins et leurs incompatibilités.',
              action: FilledButton.icon(
                onPressed: () => _ouvrirEditeur(null),
                icon: const Icon(Icons.add),
                label: const Text('Nouvel enfant'),
              ),
            );
          }
          final liste = _query.isEmpty
              ? tous
              : tous
                    .where(
                      (e) => nomComplet(
                        e.nom,
                        e.prenom,
                      ).toLowerCase().contains(_query.toLowerCase()),
                    )
                    .toList();
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                child: SearchBarChamp(
                  hint: 'Rechercher un enfant…',
                  onChanged: (v) => setState(() => _query = v),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 96),
                  itemCount: liste.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final e = liste[i];
                    final age = ageAnnees(e.dateNaissance);
                    final couleur = _couleurSexe(e.sexe);
                    return Card(
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: Avatar(
                          initiale: e.nom.isNotEmpty
                              ? e.nom[0].toUpperCase()
                              : '?',
                          couleur: couleur,
                        ),
                        title: Text(
                          nomComplet(e.nom, e.prenom),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              Pastille(
                                libelleSexe(e.sexe),
                                couleur: couleur,
                                icone: e.sexe == sexeFille
                                    ? Icons.female
                                    : Icons.male,
                              ),
                              if (age != null)
                                Pastille(
                                  '$age ans',
                                  couleur: Theme.of(
                                    context,
                                  ).colorScheme.primary,
                                  icone: Icons.cake_outlined,
                                ),
                            ],
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: 'Modifier',
                              icon: const Icon(Icons.edit_outlined),
                              onPressed: () => _ouvrirEditeur(e),
                            ),
                            IconButton(
                              tooltip: 'Supprimer',
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () async {
                                if (await confirmer(
                                  context,
                                  titre: 'Supprimer cet enfant ?',
                                  message:
                                      'Ses besoins et affectations seront aussi supprimés.',
                                )) {
                                  await (db.delete(
                                    db.enfants,
                                  )..where((t) => t.id.equals(e.id))).go();
                                }
                              },
                            ),
                          ],
                        ),
                        onTap: () => _ouvrirEditeur(e),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _EnfantEditor extends StatefulWidget {
  final Enfant? enfant;
  const _EnfantEditor({this.enfant});

  @override
  State<_EnfantEditor> createState() => _EnfantEditorState();
}

class _EnfantEditorState extends State<_EnfantEditor> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nom;
  late final TextEditingController _prenom;
  late final TextEditingController _notes;
  late String _sexe;
  DateTime? _naissance;
  int? _afHabituelId;
  int? _fratrieId;
  int? _id;

  @override
  void initState() {
    super.initState();
    final e = widget.enfant;
    _id = e?.id;
    _nom = TextEditingController(text: e?.nom ?? '');
    _prenom = TextEditingController(text: e?.prenom ?? '');
    _notes = TextEditingController(text: e?.notes ?? '');
    _sexe = e?.sexe ?? sexeGarcon;
    _naissance = e?.dateNaissance;
    _afHabituelId = e?.afHabituelId;
    _fratrieId = e?.fratrieId;
  }

  @override
  void dispose() {
    _nom.dispose();
    _prenom.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _enregistrer() async {
    if (!_formKey.currentState!.validate()) return;
    final db = context.read<AppDatabase>();
    if (_id == null) {
      final id = await db
          .into(db.enfants)
          .insert(
            EnfantsCompanion.insert(
              nom: _nom.text.trim(),
              prenom: Value(_prenom.text.trim()),
              sexe: Value(_sexe),
              dateNaissance: Value(_naissance),
              afHabituelId: Value(_afHabituelId),
              fratrieId: Value(_fratrieId),
              notes: Value(
                _notes.text.trim().isEmpty ? null : _notes.text.trim(),
              ),
            ),
          );
      setState(() => _id = id);
    } else {
      await (db.update(db.enfants)..where((t) => t.id.equals(_id!))).write(
        EnfantsCompanion(
          nom: Value(_nom.text.trim()),
          prenom: Value(_prenom.text.trim()),
          sexe: Value(_sexe),
          dateNaissance: Value(_naissance),
          afHabituelId: Value(_afHabituelId),
          fratrieId: Value(_fratrieId),
          notes: Value(_notes.text.trim().isEmpty ? null : _notes.text.trim()),
        ),
      );
    }
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Enregistré.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = context.read<AppDatabase>();
    return Scaffold(
      appBar: AppBar(
        title: Text(_id == null ? 'Nouvel enfant' : 'Modifier l\'enfant'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _enregistrer,
        icon: const Icon(Icons.save),
        label: const Text('Enregistrer'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 96),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FormBloc(
                    titre: 'Informations',
                    enfants: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _nom,
                              decoration: const InputDecoration(
                                labelText: 'Nom',
                              ),
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Nom obligatoire'
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _prenom,
                              decoration: const InputDecoration(
                                labelText: 'Prénom',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: _sexe,
                              decoration: const InputDecoration(
                                labelText: 'Sexe',
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: sexeGarcon,
                                  child: Text('Garçon'),
                                ),
                                DropdownMenuItem(
                                  value: sexeFille,
                                  child: Text('Fille'),
                                ),
                              ],
                              onChanged: (v) =>
                                  setState(() => _sexe = v ?? sexeGarcon),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () async {
                                final now = DateTime.now();
                                final d = await showDatePicker(
                                  context: context,
                                  initialDate:
                                      _naissance ?? DateTime(now.year - 8),
                                  firstDate: DateTime(now.year - 25),
                                  lastDate: now,
                                  locale: const Locale('fr', 'FR'),
                                );
                                if (d != null) setState(() => _naissance = d);
                              },
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'Date de naissance',
                                ),
                                child: Text(
                                  _naissance == null
                                      ? '—'
                                      : dateFr(_naissance!),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      StreamBuilder<List<Accueillant>>(
                        stream: db.watchAccueillants(),
                        builder: (context, snap) {
                          final acc = snap.data ?? [];
                          return DropdownButtonFormField<int?>(
                            initialValue: _afHabituelId,
                            isExpanded: true,
                            decoration: const InputDecoration(
                              labelText: 'Assistant familial habituel',
                            ),
                            items: [
                              const DropdownMenuItem(
                                value: null,
                                child: Text('— aucun —'),
                              ),
                              for (final a in acc)
                                DropdownMenuItem(
                                  value: a.id,
                                  child: Text(nomComplet(a.nom, a.prenom)),
                                ),
                            ],
                            onChanged: (v) => setState(() => _afHabituelId = v),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      StreamBuilder<List<Fratrie>>(
                        stream: db.watchFratries(),
                        builder: (context, snap) {
                          final fratries = snap.data ?? [];
                          Fratrie? trouvee;
                          for (final f in fratries) {
                            if (f.id == _fratrieId) trouvee = f;
                          }
                          final fratrieSel = trouvee;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: DropdownButtonFormField<int?>(
                                      initialValue: _fratrieId,
                                      isExpanded: true,
                                      decoration: const InputDecoration(
                                        labelText: 'Fratrie',
                                      ),
                                      items: [
                                        const DropdownMenuItem(
                                          value: null,
                                          child: Text('— aucune —'),
                                        ),
                                        for (final f in fratries)
                                          DropdownMenuItem(
                                            value: f.id,
                                            child: Text(f.nom),
                                          ),
                                      ],
                                      onChanged: (v) =>
                                          setState(() => _fratrieId = v),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton.filledTonal(
                                    tooltip: 'Créer une fratrie',
                                    icon: const Icon(Icons.group_add),
                                    onPressed: _creerFratrie,
                                  ),
                                ],
                              ),
                              if (fratrieSel != null) ...[
                                const SizedBox(height: 12),
                                DropdownButtonFormField<String>(
                                  initialValue: fratrieSel.regroupement,
                                  decoration: const InputDecoration(
                                    labelText: 'En relais, les frères/sœurs…',
                                  ),
                                  items: optionsRegroupement(),
                                  onChanged: (v) {
                                    if (v == null) return;
                                    (db.update(db.fratries)..where(
                                          (t) => t.id.equals(fratrieSel.id),
                                        ))
                                        .write(
                                          FratriesCompanion(
                                            regroupement: Value(v),
                                          ),
                                        );
                                  },
                                ),
                              ],
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _notes,
                        maxLines: 2,
                        decoration: const InputDecoration(labelText: 'Notes'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (_id == null)
                    const Astuce(
                      'Enregistrez d\'abord pour ajouter ses besoins de relais et ses incompatibilités.',
                    )
                  else ...[
                    _SectionBesoins(enfantId: _id!),
                    const SizedBox(height: 16),
                    _SectionPreferences(enfantId: _id!),
                    const SizedBox(height: 16),
                    _SectionIncompatibilites(enfantId: _id!),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _creerFratrie() async {
    final db = context.read<AppDatabase>();
    final ctrl = TextEditingController();
    var regroupement = regroupementEnsemble;
    final cree = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: const Text('Nouvelle fratrie'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: ctrl,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Nom de la fratrie (ex. Famille Martin)',
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: regroupement,
                decoration: const InputDecoration(
                  labelText: 'En relais, les enfants…',
                ),
                items: optionsRegroupement(),
                onChanged: (v) =>
                    setLocal(() => regroupement = v ?? regroupementEnsemble),
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
              child: const Text('Créer'),
            ),
          ],
        ),
      ),
    );
    if (cree != true || ctrl.text.trim().isEmpty) return;
    final id = await db
        .into(db.fratries)
        .insert(
          FratriesCompanion.insert(
            nom: ctrl.text.trim(),
            regroupement: Value(regroupement),
          ),
        );
    if (!mounted) return;
    setState(() => _fratrieId = id);
  }
}

class _SectionBesoins extends StatelessWidget {
  final int enfantId;
  const _SectionBesoins({required this.enfantId});

  @override
  Widget build(BuildContext context) {
    final db = context.read<AppDatabase>();
    return FormBloc(
      titre: 'Besoins de relais',
      sousTitre: 'Périodes pendant lesquelles l\'enfant doit être accueilli.',
      action: TextButton.icon(
        onPressed: () async {
          final p = await choisirPeriode(context);
          if (p == null) return;
          await db
              .into(db.besoinsRelais)
              .insert(
                BesoinsRelaisCompanion.insert(
                  enfantId: enfantId,
                  debut: p.start,
                  fin: p.end,
                ),
              );
        },
        icon: const Icon(Icons.add, size: 18),
        label: const Text('Ajouter'),
      ),
      enfants: [
        StreamBuilder<List<BesoinRelais>>(
          stream: db.watchBesoinsDe(enfantId),
          builder: (context, snap) {
            final liste = snap.data ?? [];
            if (liste.isEmpty) {
              return Text(
                'Aucun besoin enregistré.',
                style: Theme.of(context).textTheme.bodySmall,
              );
            }
            return Column(
              children: [
                for (final b in liste)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    leading: const Icon(Icons.event_available, size: 20),
                    title: Text(periodeFr(b.debut, b.fin)),
                    subtitle: Text('${nbJours(b.debut, b.fin)} jour(s)'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton.icon(
                          onPressed: () => creerRelaisPourBesoin(
                            context,
                            enfantId: enfantId,
                            debut: b.debut,
                            fin: b.fin,
                          ),
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Planifier'),
                        ),
                        IconButton(
                          tooltip: 'Supprimer le besoin',
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () => (db.delete(
                            db.besoinsRelais,
                          )..where((t) => t.id.equals(b.id))).go(),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _SectionPreferences extends StatelessWidget {
  final int enfantId;
  const _SectionPreferences({required this.enfantId});

  @override
  Widget build(BuildContext context) {
    final db = context.read<AppDatabase>();
    return FormBloc(
      titre: 'Accueillants favoris / à éviter',
      sousTitre:
          'Privilégier certains accueillants, ou en interdire d\'autres pour cet enfant.',
      action: TextButton.icon(
        onPressed: () => _ajouter(context),
        icon: const Icon(Icons.add, size: 18),
        label: const Text('Ajouter'),
      ),
      enfants: [
        StreamBuilder<List<PreferenceAccueil>>(
          stream: db.watchPreferencesDe(enfantId),
          builder: (context, snapP) {
            final prefs = snapP.data ?? [];
            return StreamBuilder<List<Accueillant>>(
              stream: db.watchAccueillants(),
              builder: (context, snapA) {
                final parId = {for (final a in snapA.data ?? []) a.id: a};
                if (prefs.isEmpty) {
                  return Text(
                    'Aucune préférence.',
                    style: Theme.of(context).textTheme.bodySmall,
                  );
                }
                return Column(
                  children: [
                    for (final p in prefs)
                      Builder(
                        builder: (context) {
                          final acc = parId[p.accueillantId];
                          final favori = p.type == prefFavori;
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            leading: Icon(
                              favori ? Icons.star : Icons.block,
                              size: 20,
                              color: favori
                                  ? Colors.amber.shade700
                                  : Theme.of(context).colorScheme.error,
                            ),
                            title: Text(
                              acc == null
                                  ? 'Accueillant supprimé'
                                  : nomComplet(acc.nom, acc.prenom),
                            ),
                            subtitle: Text(favori ? 'Favori' : 'À éviter'),
                            trailing: IconButton(
                              icon: const Icon(Icons.close, size: 18),
                              onPressed: () => (db.delete(
                                db.preferencesAccueil,
                              )..where((t) => t.id.equals(p.id))).go(),
                            ),
                          );
                        },
                      ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }

  Future<void> _ajouter(BuildContext context) async {
    final db = context.read<AppDatabase>();
    final accs = await db.tousAccueillants();
    if (!context.mounted) return;
    if (accs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ajoutez d\'abord des accueillants.')),
      );
      return;
    }
    int accId = accs.first.id;
    var type = prefFavori;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: const Text('Préférence d\'accueil'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<int>(
                initialValue: accId,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Accueillant'),
                items: [
                  for (final a in accs)
                    DropdownMenuItem(
                      value: a.id,
                      child: Text(nomComplet(a.nom, a.prenom)),
                    ),
                ],
                onChanged: (v) => accId = v ?? accId,
              ),
              const SizedBox(height: 16),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    value: prefFavori,
                    label: Text('Favori'),
                    icon: Icon(Icons.star),
                  ),
                  ButtonSegment(
                    value: prefExclu,
                    label: Text('À éviter'),
                    icon: Icon(Icons.block),
                  ),
                ],
                selected: {type},
                onSelectionChanged: (s) => setLocal(() => type = s.first),
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
              child: const Text('Ajouter'),
            ),
          ],
        ),
      ),
    );
    if (ok != true) return;
    // Une seule préférence par couple (enfant, accueillant) : on retire toute
    // préférence existante pour ce couple avant d'enregistrer le nouveau choix.
    // Évite les doublons et les contradictions favori + à éviter.
    await (db.delete(db.preferencesAccueil)
          ..where((t) => t.enfantId.equals(enfantId))
          ..where((t) => t.accueillantId.equals(accId)))
        .go();
    await db
        .into(db.preferencesAccueil)
        .insert(
          PreferencesAccueilCompanion.insert(
            enfantId: enfantId,
            accueillantId: accId,
            type: type,
          ),
        );
  }
}

class _SectionIncompatibilites extends StatelessWidget {
  final int enfantId;
  const _SectionIncompatibilites({required this.enfantId});

  @override
  Widget build(BuildContext context) {
    final db = context.read<AppDatabase>();
    return FormBloc(
      titre: 'Incompatibilités',
      sousTitre:
          'Enfants à ne jamais accueillir au même endroit en même temps.',
      action: TextButton.icon(
        onPressed: () => _ajouter(context),
        icon: const Icon(Icons.add, size: 18),
        label: const Text('Ajouter'),
      ),
      enfants: [
        StreamBuilder<List<Incompatibilite>>(
          stream: db.watchIncompatibilitesDe(enfantId),
          builder: (context, snapInc) {
            final incs = snapInc.data ?? [];
            return StreamBuilder<List<Enfant>>(
              stream: db.watchEnfants(),
              builder: (context, snapEnf) {
                final parId = {for (final e in snapEnf.data ?? []) e.id: e};
                if (incs.isEmpty) {
                  return Text(
                    'Aucune incompatibilité.',
                    style: Theme.of(context).textTheme.bodySmall,
                  );
                }
                return Column(
                  children: [
                    for (final inc in incs)
                      Builder(
                        builder: (context) {
                          final autreId = inc.enfantAId == enfantId
                              ? inc.enfantBId
                              : inc.enfantAId;
                          final autre = parId[autreId];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            leading: Icon(
                              Icons.block,
                              size: 20,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            title: Text(
                              autre == null
                                  ? 'Enfant supprimé'
                                  : nomComplet(autre.nom, autre.prenom),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.close, size: 18),
                              onPressed: () => (db.delete(
                                db.incompatibilites,
                              )..where((t) => t.id.equals(inc.id))).go(),
                            ),
                          );
                        },
                      ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }

  Future<void> _ajouter(BuildContext context) async {
    final db = context.read<AppDatabase>();
    final tous = await db.tousEnfants();
    final incs = await db.toutesIncompatibilites();
    final dejaIds = <int>{};
    for (final i in incs) {
      if (i.enfantAId == enfantId) dejaIds.add(i.enfantBId);
      if (i.enfantBId == enfantId) dejaIds.add(i.enfantAId);
    }
    final candidats = tous
        .where((e) => e.id != enfantId && !dejaIds.contains(e.id))
        .toList();
    if (!context.mounted) return;
    if (candidats.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aucun autre enfant disponible.')),
      );
      return;
    }
    final choisi = await showDialog<Enfant>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Incompatible avec…'),
        children: [
          for (final e in candidats)
            SimpleDialogOption(
              onPressed: () => Navigator.pop(ctx, e),
              child: Text(nomComplet(e.nom, e.prenom)),
            ),
        ],
      ),
    );
    if (choisi == null) return;
    await db
        .into(db.incompatibilites)
        .insert(
          IncompatibilitesCompanion.insert(
            enfantAId: enfantId,
            enfantBId: choisi.id,
          ),
        );
  }
}
