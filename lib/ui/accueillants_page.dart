import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';

import '../data/database.dart';
import '../domain/dates.dart';
import '../domain/pdf_export.dart';
import 'apercu_pdf_page.dart';
import 'widgets.dart';

class AccueillantsPage extends StatefulWidget {
  const AccueillantsPage({super.key});

  @override
  State<AccueillantsPage> createState() => _AccueillantsPageState();
}

class _AccueillantsPageState extends State<AccueillantsPage> {
  String _query = '';

  void _ouvrirEditeur(Accueillant? a) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => _AccueillantEditor(accueillant: a)),
    );
  }

  Future<void> _planningPdf(Accueillant a) async {
    final db = context.read<AppDatabase>();
    final affsAll = await db.toutesAffectations();
    final enfantsAll = await db.tousEnfants();
    final reglages = await db.lireReglages();
    final logo = (await rootBundle.load(
      'assets/icon/logo_escale.png',
    )).buffer.asUint8List();
    if (!mounted) return;
    final affs = affsAll
        .where((x) => x.accueillantId == a.id && relaisActif(x.statut))
        .toList();
    final enfants = {for (final e in enfantsAll) e.id: e};
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ApercuPdfPage(
          titre: 'Planning — ${nomComplet(a.nom, a.prenom)}',
          fichier: 'planning-${a.nom.toLowerCase()}.pdf',
          builder: (format) => genererPdfPlanningAccueillant(
            structure: InfosStructure.depuisReglages(reglages),
            logo: logo,
            date: DateTime.now(),
            accueillant: a,
            affectations: affs,
            enfants: enfants,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final db = context.read<AppDatabase>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueillants'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: FilledButton.icon(
              onPressed: () => _ouvrirEditeur(null),
              icon: const Icon(Icons.add),
              label: const Text('Nouvel accueillant'),
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<Accueillant>>(
        stream: db.watchAccueillants(),
        builder: (context, snap) {
          final tous = snap.data ?? [];
          if (tous.isEmpty) {
            return EmptyState(
              icone: Icons.home_outlined,
              titre: 'Aucun accueillant pour l\'instant',
              sousTitre:
                  'Ajoutez les assistants familiaux qui peuvent recevoir des enfants en relais.',
              action: FilledButton.icon(
                onPressed: () => _ouvrirEditeur(null),
                icon: const Icon(Icons.add),
                label: const Text('Nouvel accueillant'),
              ),
            );
          }
          final liste = _query.isEmpty
              ? tous
              : tous
                    .where(
                      (a) => nomComplet(
                        a.nom,
                        a.prenom,
                      ).toLowerCase().contains(_query.toLowerCase()),
                    )
                    .toList();
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                child: SearchBarChamp(
                  hint: 'Rechercher un accueillant…',
                  onChanged: (v) => setState(() => _query = v),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 96),
                  itemCount: liste.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final a = liste[i];
                    return Card(
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: Avatar(
                          initiale: a.nom.isNotEmpty
                              ? a.nom[0].toUpperCase()
                              : '?',
                        ),
                        title: Text(
                          nomComplet(a.nom, a.prenom),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              Pastille(
                                '${a.nbPlaces} place(s)',
                                couleur: Theme.of(context).colorScheme.primary,
                                icone: Icons.event_seat,
                              ),
                              if (a.restrictionSexe != restrictionAucune)
                                Pastille(
                                  libelleRestriction(a.restrictionSexe),
                                  couleur: Colors.indigo,
                                  icone: Icons.wc,
                                ),
                            ],
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: 'Planning (PDF)',
                              icon: const Icon(Icons.picture_as_pdf_outlined),
                              onPressed: () => _planningPdf(a),
                            ),
                            IconButton(
                              tooltip: 'Modifier',
                              icon: const Icon(Icons.edit_outlined),
                              onPressed: () => _ouvrirEditeur(a),
                            ),
                            IconButton(
                              tooltip: 'Supprimer',
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () async {
                                if (await confirmer(
                                  context,
                                  titre: 'Supprimer cet accueillant ?',
                                  message:
                                      'Ses périodes et ses affectations seront aussi supprimées.',
                                )) {
                                  await (db.delete(
                                    db.accueillants,
                                  )..where((t) => t.id.equals(a.id))).go();
                                }
                              },
                            ),
                          ],
                        ),
                        onTap: () => _ouvrirEditeur(a),
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

class _AccueillantEditor extends StatefulWidget {
  final Accueillant? accueillant;
  const _AccueillantEditor({this.accueillant});

  @override
  State<_AccueillantEditor> createState() => _AccueillantEditorState();
}

class _AccueillantEditorState extends State<_AccueillantEditor> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nom;
  late final TextEditingController _prenom;
  late final TextEditingController _notes;
  late int _nbPlaces;
  late String _restriction;
  int? _id;

  @override
  void initState() {
    super.initState();
    final a = widget.accueillant;
    _id = a?.id;
    _nom = TextEditingController(text: a?.nom ?? '');
    _prenom = TextEditingController(text: a?.prenom ?? '');
    _notes = TextEditingController(text: a?.notes ?? '');
    _nbPlaces = a?.nbPlaces ?? 1;
    _restriction = a?.restrictionSexe ?? restrictionAucune;
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
          .into(db.accueillants)
          .insert(
            AccueillantsCompanion.insert(
              nom: _nom.text.trim(),
              prenom: Value(_prenom.text.trim()),
              nbPlaces: Value(_nbPlaces),
              restrictionSexe: Value(_restriction),
              notes: Value(
                _notes.text.trim().isEmpty ? null : _notes.text.trim(),
              ),
            ),
          );
      setState(() => _id = id);
    } else {
      await (db.update(db.accueillants)..where((t) => t.id.equals(_id!))).write(
        AccueillantsCompanion(
          nom: Value(_nom.text.trim()),
          prenom: Value(_prenom.text.trim()),
          nbPlaces: Value(_nbPlaces),
          restrictionSexe: Value(_restriction),
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _id == null ? 'Nouvel accueillant' : 'Modifier l\'accueillant',
        ),
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
                          SizedBox(
                            width: 190,
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'Nombre de places',
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: _nbPlaces > 1
                                        ? () => setState(() => _nbPlaces--)
                                        : null,
                                  ),
                                  Text(
                                    '$_nbPlaces',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () =>
                                        setState(() => _nbPlaces++),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: _restriction,
                              decoration: const InputDecoration(
                                labelText: 'Restriction d\'accueil',
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: restrictionAucune,
                                  child: Text('Aucune'),
                                ),
                                DropdownMenuItem(
                                  value: restrictionGarcon,
                                  child: Text('Garçons uniquement'),
                                ),
                                DropdownMenuItem(
                                  value: restrictionFille,
                                  child: Text('Filles uniquement'),
                                ),
                              ],
                              onChanged: (v) => setState(
                                () => _restriction = v ?? restrictionAucune,
                              ),
                            ),
                          ),
                        ],
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
                      'Enregistrez d\'abord pour ajouter ses périodes de disponibilité et de vacances.',
                    )
                  else ...[
                    _SectionPeriodes(
                      titre: 'Périodes où il/elle peut accueillir',
                      sousTitre:
                          'Si vide, l\'accueillant est considéré disponible sauf pendant ses vacances.',
                      stream: context.read<AppDatabase>().watchDisponibilitesDe(
                        _id!,
                      ),
                      onAjouter: () async {
                        final db = context.read<AppDatabase>();
                        final p = await choisirPeriode(context);
                        if (p == null) return;
                        await db
                            .into(db.disponibilitesAccueil)
                            .insert(
                              DisponibilitesAccueilCompanion.insert(
                                accueillantId: _id!,
                                debut: p.start,
                                fin: p.end,
                              ),
                            );
                      },
                      onSupprimer: (id) async {
                        final db = context.read<AppDatabase>();
                        await (db.delete(
                          db.disponibilitesAccueil,
                        )..where((t) => t.id.equals(id))).go();
                      },
                    ),
                    const SizedBox(height: 16),
                    _SectionPeriodes(
                      titre: 'Vacances / indisponibilités',
                      sousTitre:
                          'L\'accueillant ne peut recevoir personne sur ces périodes.',
                      avecMotif: true,
                      stream: context
                          .read<AppDatabase>()
                          .watchIndisponibilitesDe(_id!),
                      onAjouter: () async {
                        final db = context.read<AppDatabase>();
                        final p = await choisirPeriode(context);
                        if (p == null) return;
                        await db
                            .into(db.indisponibilites)
                            .insert(
                              IndisponibilitesCompanion.insert(
                                accueillantId: _id!,
                                debut: p.start,
                                fin: p.end,
                              ),
                            );
                      },
                      onSupprimer: (id) async {
                        final db = context.read<AppDatabase>();
                        await (db.delete(
                          db.indisponibilites,
                        )..where((t) => t.id.equals(id))).go();
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionPeriodes extends StatelessWidget {
  final String titre;
  final String sousTitre;
  final bool avecMotif;
  final Stream<List<dynamic>> stream;
  final Future<void> Function() onAjouter;
  final Future<void> Function(int id) onSupprimer;

  const _SectionPeriodes({
    required this.titre,
    required this.sousTitre,
    required this.stream,
    required this.onAjouter,
    required this.onSupprimer,
    this.avecMotif = false,
  });

  @override
  Widget build(BuildContext context) {
    return FormBloc(
      titre: titre,
      sousTitre: sousTitre,
      action: TextButton.icon(
        onPressed: onAjouter,
        icon: const Icon(Icons.add, size: 18),
        label: const Text('Ajouter'),
      ),
      enfants: [
        StreamBuilder<List<dynamic>>(
          stream: stream,
          builder: (context, snap) {
            final liste = snap.data ?? [];
            if (liste.isEmpty) {
              return Text(
                'Aucune période enregistrée.',
                style: Theme.of(context).textTheme.bodySmall,
              );
            }
            return Column(
              children: [
                for (final p in liste)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    leading: const Icon(Icons.event, size: 20),
                    title: Text(
                      periodeFr(p.debut as DateTime, p.fin as DateTime),
                    ),
                    subtitle: avecMotif && (p.motif as String?) != null
                        ? Text(p.motif as String)
                        : null,
                    trailing: IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () => onSupprimer(p.id as int),
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
