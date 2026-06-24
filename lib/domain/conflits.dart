import '../data/database.dart';
import 'dates.dart';

enum Severite { bloquant, avertissement }

class Conflit {
  final Severite severite;
  final String message;
  const Conflit(this.severite, this.message);

  bool get estBloquant => severite == Severite.bloquant;
}

String _nomEnfant(Enfant e) =>
    e.prenom.isEmpty ? e.nom : '${e.prenom} ${e.nom}';

String _libelleSexe(String s) => s == sexeFille ? 'fille' : 'garçon';

String _libelleSolution(String type) {
  switch (type) {
    case solColonie:
      return 'en colonie de vacances';
    case solTiers:
      return 'accueilli(e) par un tiers';
    default:
      return 'pris(e) en charge (autre solution)';
  }
}

// Analyse une affectation proposée et retourne la liste des conflits détectés.
// [affectationExclueId] permet d'ignorer l'affectation en cours de modification.
List<Conflit> analyserAffectation({
  required Enfant enfant,
  required Accueillant accueillant,
  required DateTime debut,
  required DateTime fin,
  required List<Affectation> affectations,
  required List<DisponibiliteAccueil> disponibilites,
  required List<Indisponibilite> indisponibilites,
  required List<Incompatibilite> incompatibilites,
  required List<Enfant> enfants,
  List<Fratrie> fratries = const [],
  List<PreferenceAccueil> preferences = const [],
  List<SolutionAlternative> solutions = const [],
  int? affectationExclueId,
}) {
  final conflits = <Conflit>[];

  // 0. Cohérence des dates.
  if (jour(fin).isBefore(jour(debut))) {
    conflits.add(
      const Conflit(
        Severite.bloquant,
        'La date de fin est avant la date de début.',
      ),
    );
    return conflits; // inutile d'aller plus loin
  }

  final parId = {for (final e in enfants) e.id: e};

  // 1. Restriction de sexe de l'accueillant.
  if (accueillant.restrictionSexe != restrictionAucune &&
      accueillant.restrictionSexe != enfant.sexe) {
    conflits.add(
      Conflit(
        Severite.bloquant,
        '${accueillant.nom} n\'accueille que des '
        '${_libelleSexe(accueillant.restrictionSexe)}s, '
        'or ${_nomEnfant(enfant)} est un(e) ${_libelleSexe(enfant.sexe)}.',
      ),
    );
  }

  // 2. Ne pas placer un enfant chez son assistant familial habituel.
  if (enfant.afHabituelId == accueillant.id) {
    conflits.add(
      Conflit(
        Severite.bloquant,
        '${_nomEnfant(enfant)} serait placé(e) chez son propre assistant '
        'familial habituel.',
      ),
    );
  }

  // 2b. Accueillant à éviter pour cet enfant (préférence « à éviter »).
  if (preferences.any(
    (p) =>
        p.enfantId == enfant.id &&
        p.accueillantId == accueillant.id &&
        p.type == prefExclu,
  )) {
    conflits.add(
      Conflit(
        Severite.bloquant,
        '${accueillant.nom} fait partie des accueillants à éviter pour '
        '${_nomEnfant(enfant)}.',
      ),
    );
  }

  // 3. Disponibilité : si des périodes d'accueil sont définies, le besoin
  //    doit être entièrement couvert par ces périodes.
  if (disponibilites.isNotEmpty) {
    if (!_periodeCouverte(debut, fin, disponibilites)) {
      conflits.add(
        Conflit(
          Severite.bloquant,
          '${accueillant.nom} n\'est pas déclaré(e) disponible sur toute la '
          'période (${periodeFr(debut, fin)}).',
        ),
      );
    }
  }

  // 4. Indisponibilités (vacances de l'accueillant).
  for (final ind in indisponibilites) {
    if (periodesSeChevauchent(debut, fin, ind.debut, ind.fin)) {
      final motif = ind.motif == null ? '' : ' (${ind.motif})';
      conflits.add(
        Conflit(
          Severite.bloquant,
          '${accueillant.nom} est indisponible ${periodeFr(ind.debut, ind.fin)}'
          '$motif.',
        ),
      );
    }
  }

  // Affectations existantes qui chevauchent la période proposée.
  final chevauchantes = affectations
      .where(
        (a) =>
            a.id != affectationExclueId &&
            periodesSeChevauchent(debut, fin, a.debut, a.fin),
      )
      .toList();

  // 5. L'enfant est-il déjà placé ailleurs sur cette période ?
  for (final a in chevauchantes.where((a) => a.enfantId == enfant.id)) {
    conflits.add(
      Conflit(
        Severite.bloquant,
        '${_nomEnfant(enfant)} est déjà affecté(e) ${periodeFr(a.debut, a.fin)}.',
      ),
    );
  }

  // 5b. L'enfant est-il déjà pris en charge hors relais (colonie, accueil par
  //     un tiers…) sur cette période ?
  for (final s in solutions) {
    if (s.enfantId == enfant.id &&
        periodesSeChevauchent(debut, fin, s.debut, s.fin)) {
      conflits.add(
        Conflit(
          Severite.bloquant,
          '${_nomEnfant(enfant)} est déjà ${_libelleSolution(s.type)} '
          '${periodeFr(s.debut, s.fin)}.',
        ),
      );
    }
  }

  // Affectations chez CET accueillant (hors l'enfant lui-même).
  final chezCetAccueillant = chevauchantes
      .where(
        (a) => a.accueillantId == accueillant.id && a.enfantId != enfant.id,
      )
      .toList();

  // 6. Capacité : pic d'occupation simultanée <= nombre de places.
  final pic = _picOccupation(
    debut: debut,
    fin: fin,
    intervalles: chezCetAccueillant.map((a) => (a.debut, a.fin)).toList(),
  );
  if (pic + 1 > accueillant.nbPlaces) {
    conflits.add(
      Conflit(
        Severite.bloquant,
        'Capacité dépassée : ${pic + 1} enfant(s) en même temps pour '
        '${accueillant.nbPlaces} place(s).',
      ),
    );
  }

  // 7. Incompatibilités : un enfant à séparer est-il présent au même endroit ?
  final incompatiblesIds = <int>{};
  for (final inc in incompatibilites) {
    if (inc.enfantAId == enfant.id) incompatiblesIds.add(inc.enfantBId);
    if (inc.enfantBId == enfant.id) incompatiblesIds.add(inc.enfantAId);
  }
  for (final a in chezCetAccueillant) {
    if (incompatiblesIds.contains(a.enfantId)) {
      final autre = parId[a.enfantId];
      conflits.add(
        Conflit(
          Severite.bloquant,
          '${_nomEnfant(enfant)} ne doit pas être avec '
          '${autre == null ? 'un enfant incompatible' : _nomEnfant(autre)} '
          '(${periodeFr(a.debut, a.fin)}).',
        ),
      );
    }
  }

  // 8. Fratrie : selon la politique de regroupement de la fratrie.
  if (enfant.fratrieId != null) {
    final politique = {
      for (final f in fratries) f.id: f.regroupement,
    }[enfant.fratrieId];
    final fratrieIds = enfants
        .where((e) => e.fratrieId == enfant.fratrieId && e.id != enfant.id)
        .map((e) => e.id)
        .toSet();
    for (final a in chevauchantes.where(
      (a) => fratrieIds.contains(a.enfantId),
    )) {
      final frere = parId[a.enfantId];
      final nomFrere = frere == null ? 'un frère/une sœur' : _nomEnfant(frere);
      final memeLieu = a.accueillantId == accueillant.id;
      if (politique == regroupementSepares && memeLieu) {
        conflits.add(
          Conflit(
            Severite.bloquant,
            'Fratrie à séparer : $nomFrere est accueilli(e) au même endroit '
            'sur cette période.',
          ),
        );
      } else if (politique == regroupementEnsemble && !memeLieu) {
        conflits.add(
          Conflit(
            Severite.avertissement,
            'Fratrie séparée : $nomFrere est accueilli(e) ailleurs sur cette '
            'période.',
          ),
        );
      }
    }
  }

  return conflits;
}

// La période [debut, fin] est-elle couverte jour par jour par l'union des
// disponibilités fournies ?
bool _periodeCouverte(
  DateTime debut,
  DateTime fin,
  List<DisponibiliteAccueil> dispos,
) {
  var d = jour(debut);
  final f = jour(fin);
  while (!d.isAfter(f)) {
    final couvert = dispos.any(
      (disp) => !d.isBefore(jour(disp.debut)) && !d.isAfter(jour(disp.fin)),
    );
    if (!couvert) return false;
    d = d.add(const Duration(days: 1));
  }
  return true;
}

// Nombre maximal d'enfants présents simultanément sur [debut, fin],
// parmi les intervalles fournis (hors le nouvel enfant).
int _picOccupation({
  required DateTime debut,
  required DateTime fin,
  required List<(DateTime, DateTime)> intervalles,
}) {
  if (intervalles.isEmpty) return 0;
  // Les jours candidats sont les débuts d'intervalles (et le début de la période).
  final candidats = <DateTime>{jour(debut)};
  for (final (d, _) in intervalles) {
    final dd = jour(d);
    if (!dd.isBefore(jour(debut)) && !dd.isAfter(jour(fin))) candidats.add(dd);
  }
  var pic = 0;
  for (final c in candidats) {
    var n = 0;
    for (final (d, f) in intervalles) {
      if (!c.isBefore(jour(d)) && !c.isAfter(jour(f))) n++;
    }
    if (n > pic) pic = n;
  }
  return pic;
}
