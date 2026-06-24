import '../data/database.dart';
import 'conflits.dart';
import 'dates.dart';

// Une « cible » : une période à couvrir pour un enfant (un trou non encore assuré).
class Cible {
  final Enfant enfant;
  final DateTime debut;
  final DateTime fin;
  final int besoinId;
  const Cible({
    required this.enfant,
    required this.debut,
    required this.fin,
    required this.besoinId,
  });
}

// Une affectation proposée par le moteur.
class Proposition {
  final Enfant enfant;
  final Accueillant accueillant;
  final DateTime debut;
  final DateTime fin;
  final int besoinId;
  const Proposition({
    required this.enfant,
    required this.accueillant,
    required this.debut,
    required this.fin,
    required this.besoinId,
  });
}

class ResultatProposition {
  final List<Proposition> propositions;
  final List<Cible> nonPlaces;
  final bool limiteAtteinte; // la recherche a été tronquée (problème trop gros)
  const ResultatProposition({
    required this.propositions,
    required this.nonPlaces,
    this.limiteAtteinte = false,
  });
}

// Calcule, sur [debut, fin], les sous-périodes non couvertes par l'union des
// [couvertures] (affectations ET/OU solutions alternatives).
List<(DateTime, DateTime)> trousNonCouverts(
  DateTime debut,
  DateTime fin,
  List<(DateTime, DateTime)> couvertures,
) {
  final res = <(DateTime, DateTime)>[];
  DateTime? debutTrou;
  var d = jour(debut);
  final f = jour(fin);
  while (!d.isAfter(f)) {
    final couvert = couvertures.any(
      (c) => !d.isBefore(jour(c.$1)) && !d.isAfter(jour(c.$2)),
    );
    if (!couvert) {
      debutTrou ??= d;
    } else if (debutTrou != null) {
      res.add((debutTrou, d.subtract(const Duration(days: 1))));
      debutTrou = null;
    }
    d = d.add(const Duration(days: 1));
  }
  if (debutTrou != null) res.add((debutTrou, f));
  return res;
}

// Couvertures (intervalles) d'un enfant : ses affectations + ses solutions.
List<(DateTime, DateTime)> couverturesEnfant(
  int enfantId,
  List<Affectation> affectations,
  List<SolutionAlternative> solutions,
) => [
  for (final a in affectations)
    if (a.enfantId == enfantId && relaisActif(a.statut)) (a.debut, a.fin),
  for (final s in solutions)
    if (s.enfantId == enfantId) (s.debut, s.fin),
];

// Fusionne une liste d'intervalles [debut, fin] (bornes incluses) en intervalles
// disjoints et triés (les périodes qui se chevauchent ou sont contiguës d'un jour
// sont réunies). Sert à éviter de générer deux cibles qui se recoupent pour un
// même enfant lorsque ses besoins se chevauchent.
List<(DateTime, DateTime)> fusionnerPeriodes(List<(DateTime, DateTime)> xs) {
  final valides = [
    for (final (d1, f1) in xs)
      if (!jour(f1).isBefore(jour(d1))) (jour(d1), jour(f1)),
  ]..sort((a, b) => a.$1.compareTo(b.$1));
  if (valides.isEmpty) return const [];
  final res = <(DateTime, DateTime)>[];
  var debut = valides.first.$1;
  var fin = valides.first.$2;
  for (final (d, f) in valides.skip(1)) {
    // Chevauchant ou contigu (le jour suivant la fin courante) : on étend.
    if (!d.isAfter(fin.add(const Duration(days: 1)))) {
      if (f.isAfter(fin)) fin = f;
    } else {
      res.add((debut, fin));
      debut = d;
      fin = f;
    }
  }
  res.add((debut, fin));
  return res;
}

const int _capNoeuds = 200000;

// Propose des affectations couvrant les besoins non assurés, en respectant
// toutes les contraintes bloquantes. Recherche par backtracking avec
// heuristique « variable la plus contrainte d'abord ».
ResultatProposition proposerAffectations({
  required List<Enfant> enfants,
  required List<Accueillant> accueillants,
  required List<Affectation> affectationsExistantes,
  required List<BesoinRelais> besoins,
  required List<DisponibiliteAccueil> dispos,
  required List<Indisponibilite> indispos,
  required List<Incompatibilite> incompatibilites,
  List<Fratrie> fratries = const [],
  List<PreferenceAccueil> preferences = const [],
  List<SolutionAlternative> solutions = const [],
}) {
  final parEnfant = {for (final e in enfants) e.id: e};
  final politiqueParFratrie = {for (final f in fratries) f.id: f.regroupement};
  final dispoParAcc = <int, List<DisponibiliteAccueil>>{};
  for (final d in dispos) {
    (dispoParAcc[d.accueillantId] ??= []).add(d);
  }
  final indispoParAcc = <int, List<Indisponibilite>>{};
  for (final i in indispos) {
    (indispoParAcc[i.accueillantId] ??= []).add(i);
  }
  // Les relais annulés n'occupent plus de place : on les ignore partout.
  final affsActives = affectationsExistantes
      .where((a) => relaisActif(a.statut))
      .toList();

  // 1. Construire les cibles (trous à combler), en fusionnant d'abord les
  //    besoins de chaque enfant pour ne jamais produire deux cibles qui se
  //    recoupent (sinon la règle « déjà placé » en rejetterait une à tort).
  final besoinsParEnfant = <int, List<BesoinRelais>>{};
  for (final b in besoins) {
    if (parEnfant[b.enfantId] == null) continue;
    (besoinsParEnfant[b.enfantId] ??= []).add(b);
  }
  final cibles = <Cible>[];
  for (final entree in besoinsParEnfant.entries) {
    final enfant = parEnfant[entree.key]!;
    final couvertures = couverturesEnfant(
      enfant.id,
      affectationsExistantes,
      solutions,
    );
    final periodes = fusionnerPeriodes([
      for (final b in entree.value) (b.debut, b.fin),
    ]);
    for (final (bDebut, bFin) in periodes) {
      for (final (debut, fin) in trousNonCouverts(bDebut, bFin, couvertures)) {
        // Rattacher le trou au premier besoin qui le chevauche (suivi/besoinId).
        final source = entree.value.firstWhere(
          (b) => periodesSeChevauchent(b.debut, b.fin, debut, fin),
          orElse: () => entree.value.first,
        );
        cibles.add(
          Cible(enfant: enfant, debut: debut, fin: fin, besoinId: source.id),
        );
      }
    }
  }

  if (cibles.isEmpty) {
    return const ResultatProposition(propositions: [], nonPlaces: []);
  }

  // Vérifie qu'une affectation ne crée aucun conflit bloquant, compte tenu des
  // affectations existantes et des propositions déjà retenues.
  bool sansBloquant(Cible c, Accueillant acc, List<Proposition> retenues) {
    final affs = [
      ...affsActives,
      // ids négatifs DISTINCTS pour les propositions retenues : aucune ne peut
      // être confondue avec une vraie affectation (id >= 1), et même si un
      // affectationExclueId était transmis, il n'en exclurait jamais plusieurs.
      for (final (k, p) in retenues.indexed)
        Affectation(
          id: -(k + 1),
          enfantId: p.enfant.id,
          accueillantId: p.accueillant.id,
          debut: p.debut,
          fin: p.fin,
          besoinId: null,
          statut: statutConfirme,
        ),
    ];
    final conflits = analyserAffectation(
      enfant: c.enfant,
      accueillant: acc,
      debut: c.debut,
      fin: c.fin,
      affectations: affs,
      disponibilites: dispoParAcc[acc.id] ?? const [],
      indisponibilites: indispoParAcc[acc.id] ?? const [],
      incompatibilites: incompatibilites,
      enfants: enfants,
      fratries: fratries,
      preferences: preferences,
      solutions: solutions,
    );
    return !conflits.any((x) => x.estBloquant);
  }

  // Candidats classés : fratrie réunie d'abord, puis charge la plus faible.
  List<Accueillant> candidats(Cible c, List<Proposition> retenues) {
    final faisables = accueillants
        .where((a) => sansBloquant(c, a, retenues))
        .toList();
    int scoreFratrie(Accueillant a) {
      if (c.enfant.fratrieId == null) return 0;
      if (politiqueParFratrie[c.enfant.fratrieId] != regroupementEnsemble) {
        return 0;
      }
      final freres = enfants
          .where(
            (e) => e.fratrieId == c.enfant.fratrieId && e.id != c.enfant.id,
          )
          .map((e) => e.id)
          .toSet();
      // Un frère est-il chez cet accueillant sur la période ?
      final viaExistant = affsActives.any(
        (x) =>
            x.accueillantId == a.id &&
            freres.contains(x.enfantId) &&
            periodesSeChevauchent(c.debut, c.fin, x.debut, x.fin),
      );
      final viaRetenu = retenues.any(
        (p) =>
            p.accueillant.id == a.id &&
            freres.contains(p.enfant.id) &&
            periodesSeChevauchent(c.debut, c.fin, p.debut, p.fin),
      );
      return (viaExistant || viaRetenu) ? 1 : 0;
    }

    int charge(Accueillant a) {
      var n = 0;
      for (final x in affsActives) {
        if (x.accueillantId == a.id &&
            periodesSeChevauchent(c.debut, c.fin, x.debut, x.fin)) {
          n++;
        }
      }
      for (final p in retenues) {
        if (p.accueillant.id == a.id &&
            periodesSeChevauchent(c.debut, c.fin, p.debut, p.fin)) {
          n++;
        }
      }
      return n;
    }

    int scoreFavori(Accueillant a) =>
        preferences.any(
          (p) =>
              p.enfantId == c.enfant.id &&
              p.accueillantId == a.id &&
              p.type == prefFavori,
        )
        ? 1
        : 0;

    // Même secteur que l'enfant privilégié (proximité).
    int scoreSecteur(Accueillant a) {
      final sa = a.secteur?.trim().toLowerCase() ?? '';
      final se = c.enfant.secteur?.trim().toLowerCase() ?? '';
      return (sa.isNotEmpty && sa == se) ? 1 : 0;
    }

    // Accueillant encore sous son plafond annuel (sinon dé-priorisé).
    int souPlafond(Accueillant a) {
      final plafond = a.plafondJoursAn;
      if (plafond == null) return 1;
      final annee = jour(c.debut).year;
      var cumul = nbJours(c.debut, c.fin);
      for (final x in affsActives) {
        if (x.accueillantId == a.id && jour(x.debut).year == annee) {
          cumul += nbJours(x.debut, x.fin);
        }
      }
      for (final p in retenues) {
        if (p.accueillant.id == a.id && jour(p.debut).year == annee) {
          cumul += nbJours(p.debut, p.fin);
        }
      }
      return cumul <= plafond ? 1 : 0;
    }

    faisables.sort((a, b) {
      // Favoris d'abord, puis même secteur, fratrie réunie, sous plafond, charge.
      final fav = scoreFavori(b).compareTo(scoreFavori(a));
      if (fav != 0) return fav;
      final sect = scoreSecteur(b).compareTo(scoreSecteur(a));
      if (sect != 0) return sect;
      final f = scoreFratrie(b).compareTo(scoreFratrie(a));
      if (f != 0) return f;
      final pla = souPlafond(b).compareTo(souPlafond(a));
      if (pla != 0) return pla;
      return charge(a).compareTo(charge(b));
    });
    return faisables;
  }

  // Ordonner les cibles par nombre de candidats croissant (les plus contraintes
  // d'abord), évalué sur les seules affectations existantes.
  final ordre = [...cibles];
  ordre.sort(
    (a, b) =>
        candidats(a, const []).length.compareTo(candidats(b, const []).length),
  );

  final courant = <Proposition>[];
  List<Proposition> meilleur = const [];
  var meilleurNb = -1;
  var meilleurFratrie = -1;
  var noeuds = 0;
  var limite = false;

  int bonusFratrie(List<Proposition> sol) {
    var n = 0;
    for (final p in sol) {
      if (p.enfant.fratrieId == null) continue;
      if (politiqueParFratrie[p.enfant.fratrieId] != regroupementEnsemble) {
        continue;
      }
      final freres = enfants
          .where(
            (e) => e.fratrieId == p.enfant.fratrieId && e.id != p.enfant.id,
          )
          .map((e) => e.id)
          .toSet();
      final avecFrere =
          sol.any(
            (q) =>
                q != p &&
                q.accueillant.id == p.accueillant.id &&
                freres.contains(q.enfant.id) &&
                periodesSeChevauchent(p.debut, p.fin, q.debut, q.fin),
          ) ||
          affsActives.any(
            (x) =>
                x.accueillantId == p.accueillant.id &&
                freres.contains(x.enfantId) &&
                periodesSeChevauchent(p.debut, p.fin, x.debut, x.fin),
          );
      if (avecFrere) n++;
    }
    return n;
  }

  void dfs(int i) {
    if (noeuds > _capNoeuds) {
      limite = true;
      return;
    }
    noeuds++;
    // Élagage : impossible de battre le meilleur nombre de placements déjà trouvé.
    final maxPossible = courant.length + (ordre.length - i);
    if (maxPossible < meilleurNb) return;

    if (i == ordre.length) {
      final nb = courant.length;
      final fr = bonusFratrie(courant);
      if (nb > meilleurNb || (nb == meilleurNb && fr > meilleurFratrie)) {
        meilleur = [...courant];
        meilleurNb = nb;
        meilleurFratrie = fr;
      }
      return;
    }

    final c = ordre[i];
    for (final acc in candidats(c, courant)) {
      courant.add(
        Proposition(
          enfant: c.enfant,
          accueillant: acc,
          debut: c.debut,
          fin: c.fin,
          besoinId: c.besoinId,
        ),
      );
      dfs(i + 1);
      courant.removeLast();
      if (noeuds > _capNoeuds) {
        limite = true;
        return;
      }
    }
    // Option : laisser cette cible non placée.
    dfs(i + 1);
  }

  dfs(0);

  // Clé incluant le besoinId : deux cibles d'un même enfant sur les mêmes dates
  // (besoins en double) restent discernables dans le comptage placés/non placés.
  final placesParCle = {
    for (final p in meilleur)
      '${p.besoinId}|${p.enfant.id}|${p.debut}|${p.fin}': p,
  };
  final nonPlaces = ordre
      .where(
        (c) => !placesParCle.containsKey(
          '${c.besoinId}|${c.enfant.id}|${c.debut}|${c.fin}',
        ),
      )
      .toList();

  return ResultatProposition(
    propositions: meilleur,
    nonPlaces: nonPlaces,
    limiteAtteinte: limite,
  );
}
