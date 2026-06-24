// Version courante et auteur de l'application (partagé avec la version desktop).
export const VERSION_ESCALE = '1.5.0';
export const AUTEUR_ESCALE = 'Christopher Fortier';
export const EMAIL_ESCALE = 'chris@carnet2bord.fr';

export interface VersionEscale {
  numero: string;
  titre: string;
  points: string[];
}

// Historique des versions, de la plus récente à la plus ancienne.
export const CHANGELOG: VersionEscale[] = [
  {
    numero: '1.5.0',
    titre: 'Conformité & RGPD',
    points: [
      "Verrouillage de l'application par mot de passe (+ auto-verrouillage).",
      'Anonymisation des exports (initiales).',
      'Registre des traitements RGPD (PDF).',
    ],
  },
  {
    numero: '1.4.0',
    titre: 'Qualité & sécurité du placement',
    points: [
      "Volet santé et contact d'urgence de l'enfant.",
      "Tranche d'âge, échéance d'agrément, plafond de jours, secteur.",
      'Transport du jour J ; détection des trous de couverture.',
      'Proposition automatique « explicable ».',
    ],
  },
  {
    numero: '1.3.0',
    titre: 'Documents',
    points: [
      'Paramètres de structure (en-tête des documents).',
      "Fiche de liaison, plannings individuels, bilan d'activité (PDF).",
      'Export CSV des relais.',
    ],
  },
  {
    numero: '1.2.0',
    titre: 'Pilotage',
    points: [
      'Taux de couverture des besoins.',
      'Relais à confirmer, urgences, annulation (undo).',
    ],
  },
  {
    numero: '1.1.0',
    titre: 'Cycle de vie des relais',
    points: [
      'Statut proposé / confirmé / réalisé / annulé.',
      'Dupliquer un relais ; avertissement de sauvegarde.',
    ],
  },
  {
    numero: '1.0.0',
    titre: 'Première version',
    points: [
      'Accueillants, enfants, fratries, incompatibilités, préférences.',
      'Détection de conflits et proposition automatique.',
      'Planning (liste + calendrier), solutions alternatives.',
      'Import Excel, export PDF.',
    ],
  },
];
