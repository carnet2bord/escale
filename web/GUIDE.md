# Guide des testeurs — Escale

> La version interactive de ce guide est intégrée à l'application, à l'adresse
> **`/guide`** (accessible sans connexion). Partagez ce lien aux testeurs.

Escale organise les **relais d'accueil familial** : placer temporairement un
enfant chez un assistant familial « accueillant » quand son assistant familial
habituel est indisponible.

> ⚠️ **Données fictives uniquement** tant que le DPO n'a pas validé la mise en
> ligne de données réelles.

## Connexion
Ouvrir l'adresse fournie → saisir le **mot de passe partagé**. Session de 12 h.

## Parcours en 4 étapes
1. **Accueillants** — créer, puis renseigner sur leur fiche les **disponibilités**
   d'accueil et les indisponibilités (congés).
2. **Enfants** — créer, puis renseigner les **besoins de relais** (périodes à
   couvrir) ; au besoin fratrie, incompatibilités, favoris/à éviter, solutions.
3. **Proposition** — le moteur place les besoins non couverts sans conflit
   bloquant ; valider un relais ou tous.
4. **Planning** — vues Liste / Calendrier ; changer le statut, voir les alertes.

## Import
Menu **Import** : fichier `.csv` (Excel → « Enregistrer sous » → CSV).
- Accueillants : `nom, prenom, places, restriction, secteur, notes`
- Enfants : `nom, prenom, sexe, date de naissance, secteur, notes`

## Documents
Fiche de liaison (planning), planning accueillant, parcours enfant, bilan
(tableau de bord). Variante **anonymisée** (initiales) pour chacun.

## Alertes
- **Bloquant** (rouge) : empêche le relais (sexe, AF habituel, « à éviter »,
  indisponibilité, capacité, incompatibilité, fratrie à séparer).
- **Avertissement** (orange) : point d'attention (âge, agrément, secteur, plafond).

## Confidentialité (Paramètres)
Journal d'audit · registre des traitements (PDF) · purge des dossiers clos
(anonymisation irréversible).
