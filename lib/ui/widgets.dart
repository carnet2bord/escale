import 'package:flutter/material.dart';

import '../data/database.dart';
import '../domain/conflits.dart';

String libelleSexe(String s) => s == sexeFille ? 'Fille' : 'Garçon';

// Libellé et couleur du statut d'un relais (affectation).
String libelleStatut(String s) => switch (s) {
  statutPropose => 'Proposé',
  statutRealise => 'Réalisé',
  statutAnnule => 'Annulé',
  _ => 'Confirmé',
};

Color couleurStatut(String s) => switch (s) {
  statutPropose => const Color(0xFFC2710C), // ambre
  statutRealise => const Color(0xFF4B5563), // gris ardoise
  statutAnnule => const Color(0xFF9CA3AF), // gris
  _ => const Color(0xFF156F6C), // teal = confirmé
};

// Couleur conventionnelle par sexe (utilisée pour les fiches et le calendrier).
const Color couleurGarcon = Color(0xFF2F6BB2);
const Color couleurFille = Color(0xFFB23A6B);
Color couleurSexe(String s) => s == sexeFille ? couleurFille : couleurGarcon;

String libelleRestriction(String r) {
  switch (r) {
    case restrictionGarcon:
      return 'Garçons uniquement';
    case restrictionFille:
      return 'Filles uniquement';
    default:
      return 'Aucune';
  }
}

String nomComplet(String nom, String prenom) =>
    prenom.isEmpty ? nom : '$prenom $nom';

// Sélecteur de période (date de début et de fin) en français.
Future<DateTimeRange?> choisirPeriode(
  BuildContext context, {
  DateTimeRange? initiale,
}) {
  final now = DateTime.now();
  return showDateRangePicker(
    context: context,
    firstDate: DateTime(now.year - 2),
    lastDate: DateTime(now.year + 5),
    initialDateRange: initiale,
    helpText: 'Choisir la période',
    saveText: 'Valider',
    locale: const Locale('fr', 'FR'),
  );
}

// Affiche une liste de conflits avec un style selon la gravité.
class ConflitsView extends StatelessWidget {
  final List<Conflit> conflits;
  const ConflitsView(this.conflits, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (conflits.isEmpty) {
      return Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green.shade600, size: 20),
          const SizedBox(width: 8),
          const Expanded(child: Text('Aucun conflit détecté.')),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final c in conflits)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  c.estBloquant ? Icons.error : Icons.warning_amber_rounded,
                  size: 20,
                  color: c.estBloquant
                      ? theme.colorScheme.error
                      : Colors.orange.shade700,
                ),
                const SizedBox(width: 8),
                Expanded(child: Text(c.message)),
              ],
            ),
          ),
      ],
    );
  }
}

// Petite pastille colorée pour les états.
class Pastille extends StatelessWidget {
  final String texte;
  final Color couleur;
  final IconData? icone;
  const Pastille(this.texte, {required this.couleur, this.icone, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: couleur.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: couleur.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icone != null) ...[
            Icon(icone, size: 14, color: couleur),
            const SizedBox(width: 5),
          ],
          Text(
            texte,
            style: TextStyle(
              color: couleur,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// Carte « bloc de formulaire » avec titre, sous-titre et action optionnels.
class FormBloc extends StatelessWidget {
  final String titre;
  final String? sousTitre;
  final Widget? action;
  final List<Widget> enfants;
  const FormBloc({
    required this.titre,
    required this.enfants,
    this.sousTitre,
    this.action,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle(titre, sousTitre: sousTitre, action: action),
            const SizedBox(height: 4),
            ...enfants,
          ],
        ),
      ),
    );
  }
}

// Encart d'astuce / information.
class Astuce extends StatelessWidget {
  final String texte;
  const Astuce(this.texte, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(texte)),
          ],
        ),
      ),
    );
  }
}

// Champ de recherche stylé.
class SearchBarChamp extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;
  const SearchBarChamp({
    required this.hint,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search, size: 20),
        isDense: true,
      ),
    );
  }
}

// Pastille ronde avec une initiale.
class Avatar extends StatelessWidget {
  final String initiale;
  final Color? couleur;
  const Avatar({required this.initiale, this.couleur, super.key});

  @override
  Widget build(BuildContext context) {
    final c = couleur ?? Theme.of(context).colorScheme.primary;
    return Container(
      width: 42,
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Text(
        initiale,
        style: TextStyle(color: c, fontWeight: FontWeight.w700),
      ),
    );
  }
}

// État vide soigné : icône dans une pastille douce, titre, sous-titre, action.
class EmptyState extends StatelessWidget {
  final IconData icone;
  final String titre;
  final String? sousTitre;
  final Widget? action;
  const EmptyState({
    required this.icone,
    required this.titre,
    this.sousTitre,
    this.action,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: cs.primaryContainer.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(icone, size: 34, color: cs.primary),
              ),
              const SizedBox(height: 20),
              Text(
                titre,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              if (sousTitre != null) ...[
                const SizedBox(height: 6),
                Text(
                  sousTitre!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              if (action != null) ...[const SizedBox(height: 20), action!],
            ],
          ),
        ),
      ),
    );
  }
}

// Titre de section avec sous-titre optionnel et action à droite.
class SectionTitle extends StatelessWidget {
  final String titre;
  final String? sousTitre;
  final Widget? action;
  const SectionTitle(this.titre, {this.sousTitre, this.action, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titre,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (sousTitre != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      sousTitre!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
              ],
            ),
          ),
          ?action,
        ],
      ),
    );
  }
}

// Affiche une boîte de dialogue de confirmation. Retourne true si confirmé.
Future<bool> confirmer(
  BuildContext context, {
  required String titre,
  required String message,
  String confirmer = 'Supprimer',
}) async {
  final res = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(titre),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Annuler'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(confirmer),
        ),
      ],
    ),
  );
  return res ?? false;
}
