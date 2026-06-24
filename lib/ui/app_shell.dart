import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';

import '../data/database.dart';
import '../data/demo.dart';
import '../data/excel_import.dart';
import '../domain/pdf_export.dart';
import 'accueillants_page.dart';
import 'apercu_pdf_page.dart';
import 'dashboard_page.dart';
import 'enfants_page.dart';
import 'import_excel_page.dart';
import 'logo.dart';
import 'parametres_page.dart';
import 'planning_page.dart';
import 'theme_controller.dart';
import 'verrou.dart';
import 'widgets.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;
  int _rev = 0; // incrémenté pour forcer le rechargement des écrans

  static const _pages = [
    DashboardPage(),
    AccueillantsPage(),
    EnfantsPage(),
    PlanningPage(),
  ];

  void _rafraichirTout() => setState(() {
    _rev++;
    _index = 0;
  });

  Future<void> _chargerDemo() async {
    final db = context.read<AppDatabase>();
    if (!await confirmer(
      context,
      titre: 'Charger les données de démo ?',
      message:
          'Cela remplacera toutes les données actuelles par un jeu d\'exemple.',
      confirmer: 'Charger',
    )) {
      return;
    }
    await chargerDonneesDemo(db);
    if (!mounted) return;
    _rafraichirTout();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Données de démo chargées.')));
  }

  Future<void> _sauvegarder() async {
    final db = context.read<AppDatabase>();
    if (!await confirmer(
      context,
      titre: 'Sauvegarder les données ?',
      message:
          'Le fichier de sauvegarde (.sqlite) contient les données des enfants '
          'et des accueillants EN CLAIR (non chiffrées). Conservez-le dans un '
          'endroit sécurisé et ne le transmettez pas par un canal non protégé.',
      confirmer: 'Continuer',
    )) {
      return;
    }
    if (!mounted) return;
    final loc = await getSaveLocation(
      suggestedName: 'escale-sauvegarde.sqlite',
    );
    if (loc == null) return;
    await db.sauvegarderVers(loc.path);
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Sauvegarde enregistrée.')));
  }

  Future<void> _restaurer() async {
    final db = context.read<AppDatabase>();
    const groupe = XTypeGroup(
      label: 'Sauvegarde Escale',
      extensions: ['sqlite'],
    );
    final fichier = await openFile(acceptedTypeGroups: [groupe]);
    if (fichier == null || !mounted) return;
    if (!await confirmer(
      context,
      titre: 'Restaurer cette sauvegarde ?',
      message: 'Cela remplacera toutes les données actuelles.',
      confirmer: 'Restaurer',
    )) {
      return;
    }
    await db.restaurerDepuis(fichier.path);
    if (!mounted) return;
    _rafraichirTout();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Données restaurées.')));
  }

  Future<void> _vider() async {
    final db = context.read<AppDatabase>();
    if (!await confirmer(
      context,
      titre: 'Vider toutes les données ?',
      message: 'Cette action est irréversible.',
      confirmer: 'Vider',
    )) {
      return;
    }
    await db.viderTout();
    if (!mounted) return;
    _rafraichirTout();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Données vidées.')));
  }

  void _outil(String v) {
    switch (v) {
      case 'parametres':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ParametresStructurePage()),
        );
      case 'verrouiller':
        final v = context.read<VerrouController>();
        if (v.protege) {
          v.verrouiller();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Définissez d\'abord un mot de passe dans les Paramètres.',
              ),
            ),
          );
        }
      case 'registre':
        _registreRgpd();
      case 'demo':
        _chargerDemo();
      case 'sauver':
        _sauvegarder();
      case 'restaurer':
        _restaurer();
      case 'import_acc':
        _importer(TypeImport.accueillants);
      case 'import_enf':
        _importer(TypeImport.enfants);
      case 'doublons':
        _supprimerDoublons();
      case 'vider':
        _vider();
    }
  }

  Future<void> _importer(TypeImport type) async {
    final r = await Navigator.of(context).push<({int importes, int ignores})>(
      MaterialPageRoute(builder: (_) => ImportExcelPage(type: type)),
    );
    if (!mounted || r == null) return;
    _rafraichirTout();
    final libelle = type == TypeImport.accueillants
        ? 'accueillant(s)'
        : 'enfant(s)';
    final msg = r.ignores > 0
        ? '${r.importes} $libelle importé(s) · ${r.ignores} doublon(s) ignoré(s)'
        : '${r.importes} $libelle importé(s)';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _supprimerDoublons() async {
    final db = context.read<AppDatabase>();
    if (!await confirmer(
      context,
      titre: 'Supprimer les doublons ?',
      message:
          'Les accueillants et enfants en double (même nom et prénom) seront supprimés, en conservant la première fiche de chacun.',
      confirmer: 'Supprimer',
    )) {
      return;
    }
    final n = await db.supprimerDoublons();
    if (!mounted) return;
    _rafraichirTout();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          n == 0 ? 'Aucun doublon trouvé.' : '$n doublon(s) supprimé(s).',
        ),
      ),
    );
  }

  Future<void> _registreRgpd() async {
    final db = context.read<AppDatabase>();
    final reglages = await db.lireReglages();
    final logo = (await rootBundle.load(
      'assets/icon/logo_escale.png',
    )).buffer.asUint8List();
    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ApercuPdfPage(
          titre: 'Registre RGPD',
          fichier: 'registre-rgpd-escale.pdf',
          builder: (format) => genererPdfRegistre(
            structure: InfosStructure.depuisReglages(reglages),
            logo: logo,
            date: DateTime.now(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          _Sidebar(
            index: _index,
            onSelect: (i) => setState(() => _index = i),
            onToggleTheme: () => context.read<ThemeController>().basculer(),
            onOutil: _outil,
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: KeyedSubtree(
              key: ValueKey('$_index-$_rev'),
              child: _pages[_index],
            ),
          ),
        ],
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  final int index;
  final ValueChanged<int> onSelect;
  final VoidCallback onToggleTheme;
  final ValueChanged<String> onOutil;

  const _Sidebar({
    required this.index,
    required this.onSelect,
    required this.onToggleTheme,
    required this.onOutil,
  });

  static const _items = [
    (Icons.dashboard_outlined, Icons.dashboard, 'Tableau de bord'),
    (Icons.home_outlined, Icons.home, 'Accueillants'),
    (Icons.child_care_outlined, Icons.child_care, 'Enfants'),
    (Icons.calendar_month_outlined, Icons.calendar_month, 'Planning'),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final sombre = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 268,
      color: cs.surface,
      child: SafeArea(
        right: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Logo
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 30, 22, 26),
              child: Align(
                alignment: Alignment.centerLeft,
                child: LogoLockup(height: 78),
              ),
            ),
            // Navigation
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  for (var i = 0; i < _items.length; i++)
                    _NavItem(
                      icon: _items[i].$1,
                      iconActif: _items[i].$2,
                      label: _items[i].$3,
                      actif: index == i,
                      onTap: () => onSelect(i),
                    ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Divider(color: cs.outlineVariant, height: 1),
            ),
            // Barre d'outils basse
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Outils',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(letterSpacing: 0.3),
                    ),
                  ),
                  IconButton(
                    tooltip: sombre ? 'Thème clair' : 'Thème sombre',
                    visualDensity: VisualDensity.compact,
                    icon: Icon(
                      sombre
                          ? Icons.light_mode_outlined
                          : Icons.dark_mode_outlined,
                    ),
                    onPressed: onToggleTheme,
                  ),
                  PopupMenuButton<String>(
                    tooltip: 'Données & sauvegarde',
                    icon: const Icon(Icons.more_horiz),
                    onSelected: onOutil,
                    itemBuilder: (_) => const [
                      PopupMenuItem(
                        value: 'parametres',
                        child: _ItemMenu(
                          Icons.tune,
                          'Paramètres de la structure',
                        ),
                      ),
                      PopupMenuItem(
                        value: 'verrouiller',
                        child: _ItemMenu(
                          Icons.lock_outline,
                          'Verrouiller l\'application',
                        ),
                      ),
                      PopupMenuItem(
                        value: 'registre',
                        child: _ItemMenu(
                          Icons.policy_outlined,
                          'Registre RGPD (PDF)',
                        ),
                      ),
                      PopupMenuDivider(),
                      PopupMenuItem(
                        value: 'demo',
                        child: _ItemMenu(
                          Icons.auto_fix_high,
                          'Données de démo',
                        ),
                      ),
                      PopupMenuItem(
                        value: 'sauver',
                        child: _ItemMenu(Icons.save_alt, 'Sauvegarder…'),
                      ),
                      PopupMenuItem(
                        value: 'restaurer',
                        child: _ItemMenu(
                          Icons.settings_backup_restore,
                          'Restaurer…',
                        ),
                      ),
                      PopupMenuDivider(),
                      PopupMenuItem(
                        value: 'import_acc',
                        child: _ItemMenu(
                          Icons.table_view_outlined,
                          'Importer accueillants (Excel)',
                        ),
                      ),
                      PopupMenuItem(
                        value: 'import_enf',
                        child: _ItemMenu(
                          Icons.table_view_outlined,
                          'Importer enfants (Excel)',
                        ),
                      ),
                      PopupMenuItem(
                        value: 'doublons',
                        child: _ItemMenu(
                          Icons.cleaning_services_outlined,
                          'Supprimer les doublons',
                        ),
                      ),
                      PopupMenuDivider(),
                      PopupMenuItem(
                        value: 'vider',
                        child: _ItemMenu(
                          Icons.delete_sweep_outlined,
                          'Vider les données',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData iconActif;
  final String label;
  final bool actif;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.iconActif,
    required this.label,
    required this.actif,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(11),
          hoverColor: cs.onSurface.withValues(alpha: 0.04),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: actif
                  ? cs.primary.withValues(alpha: 0.12)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Row(
              children: [
                Icon(
                  actif ? iconActif : icon,
                  size: 21,
                  color: actif ? cs.primary : cs.onSurfaceVariant,
                ),
                const SizedBox(width: 14),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: actif ? FontWeight.w600 : FontWeight.w500,
                    color: actif ? cs.primary : cs.onSurface,
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

class _ItemMenu extends StatelessWidget {
  final IconData icone;
  final String texte;
  const _ItemMenu(this.icone, this.texte);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [Icon(icone, size: 20), const SizedBox(width: 12), Text(texte)],
    );
  }
}
