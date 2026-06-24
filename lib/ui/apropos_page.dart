import 'package:flutter/material.dart';

import 'logo.dart';

// Version courante et auteur de l'application.
const String versionEscale = '1.6.0';
const String auteurEscale = 'Christopher Fortier';
const String emailEscale = 'chris@carnet2bord.fr';

class VersionEscale {
  final String numero;
  final String titre;
  final List<String> points;
  const VersionEscale(this.numero, this.titre, this.points);
}

// Historique des versions (changelog), de la plus récente à la plus ancienne.
const List<VersionEscale> changelogEscale = [
  VersionEscale('1.6.0', 'Distances & adresses', [
    'Adresse + coordonnées des accueillants et des enfants.',
    'Calcul de la distance enfant ↔ relais (local).',
    'Géocodage optionnel via la BAN (data.gouv.fr).',
    'La proposition privilégie le relais le plus proche ; alerte « éloigné » (seuil réglable).',
  ]),
  VersionEscale('1.5.0', 'Conformité & RGPD', [
    'Verrouillage de l\'application par mot de passe (+ auto-verrouillage).',
    'Anonymisation des exports (initiales).',
    'Registre des traitements RGPD (PDF).',
  ]),
  VersionEscale('1.4.0', 'Qualité & sécurité du placement', [
    'Volet santé et contact d\'urgence de l\'enfant.',
    'Tranche d\'âge, échéance d\'agrément, plafond de jours, secteur.',
    'Transport du jour J ; détection des trous de couverture.',
    'Proposition automatique « explicable ».',
  ]),
  VersionEscale('1.3.0', 'Documents', [
    'Paramètres de structure (en-tête des documents).',
    'Fiche de liaison, plannings individuels, bilan d\'activité (PDF).',
    'Export CSV des relais.',
  ]),
  VersionEscale('1.2.0', 'Pilotage', [
    'Taux de couverture des besoins.',
    'Relais à confirmer, urgences, annulation (undo).',
  ]),
  VersionEscale('1.1.0', 'Cycle de vie des relais', [
    'Statut proposé / confirmé / réalisé / annulé.',
    'Dupliquer un relais ; avertissement de sauvegarde.',
  ]),
  VersionEscale('1.0.0', 'Première version', [
    'Accueillants, enfants, fratries, incompatibilités, préférences.',
    'Détection de conflits et proposition automatique.',
    'Planning (liste + calendrier), solutions alternatives.',
    'Import Excel, export PDF.',
  ]),
];

class AproposPage extends StatelessWidget {
  const AproposPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('À propos')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Center(child: LogoLockup(height: 64)),
          const SizedBox(height: 12),
          Center(
            child: Text(
              'Version $versionEscale',
              style: TextStyle(color: cs.onSurfaceVariant),
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: Text(
              'Créé par $auteurEscale — $emailEscale',
              style: TextStyle(
                color: cs.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            'Historique des versions',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          for (final v in changelogEscale)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'v${v.numero}',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: cs.primary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            v.titre,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    for (final p in v.points)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('•  ', style: TextStyle(color: cs.primary)),
                            Expanded(child: Text(p)),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
