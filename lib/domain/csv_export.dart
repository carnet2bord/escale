import '../data/database.dart';
import 'dates.dart';

// Export CSV (séparateur « ; », ouvrable directement par Excel en français).

String _c(String s) => '"${s.replaceAll('"', '""')}"';

String _statut(String s) => switch (s) {
  statutPropose => 'Proposé',
  statutRealise => 'Réalisé',
  statutAnnule => 'Annulé',
  _ => 'Confirmé',
};

String _nom(String nom, String prenom) => prenom.isEmpty ? nom : '$prenom $nom';

// CSV détaillé des relais (une ligne par affectation).
String csvRelais({
  required List<Affectation> affectations,
  required Map<int, Enfant> enfants,
  required Map<int, Accueillant> accueillants,
}) {
  final lignes = <String>['Enfant;Accueillant;Début;Fin;Jours;Statut'];
  final tri = [...affectations]..sort((a, b) => a.debut.compareTo(b.debut));
  for (final a in tri) {
    final e = enfants[a.enfantId];
    final acc = accueillants[a.accueillantId];
    lignes.add(
      [
        _c(e == null ? '?' : _nom(e.nom, e.prenom)),
        _c(acc == null ? '?' : _nom(acc.nom, acc.prenom)),
        _c(dateFr(a.debut)),
        _c(dateFr(a.fin)),
        '${nbJours(a.debut, a.fin)}',
        _c(_statut(a.statut)),
      ].join(';'),
    );
  }
  return lignes.join('\r\n');
}
