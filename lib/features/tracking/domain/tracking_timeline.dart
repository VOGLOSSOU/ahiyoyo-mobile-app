import 'tracking_result.dart';

/// Une étape de la timeline principale, construite à partir de
/// [StatusHistoryEntry] (garantit la chronologie, y compris le statut
/// initial) et enrichie par l'entrée [HistoriqueEntry] correspondante quand
/// elle existe.
class MergedTimelineStep {
  final String status;
  final DateTime date;
  final String? commentaire;
  final String? fichierUrl;
  final String? fichierNom;
  final String? adminNom;

  const MergedTimelineStep({
    required this.status,
    required this.date,
    this.commentaire,
    this.fichierUrl,
    this.fichierNom,
    this.adminNom,
  });
}

class MergedTimeline {
  /// Backbone chronologique (statuts), trié du plus ancien au plus récent.
  final List<MergedTimelineStep> steps;

  /// Entrées de `historique` qui ne correspondent à aucune étape de
  /// `statusHistory` : présentées à part pour ne pas créer de doublons.
  final List<HistoriqueEntry> extra;

  const MergedTimeline({required this.steps, required this.extra});
}

/// Fusionne `statusHistory` et `historique` d'un colis suivant la règle de
/// la doc : le backbone vient de `statusHistory`, une entrée `historique` de
/// même statut l'enrichit, le reste va dans une section séparée.
MergedTimeline buildColisTimeline(List<StatusHistoryEntry> statusHistory, List<HistoriqueEntry> historique) {
  final usedIndexes = <int>{};
  final steps = <MergedTimelineStep>[];

  for (final entry in statusHistory) {
    int? matchIndex;
    for (var i = 0; i < historique.length; i++) {
      if (usedIndexes.contains(i)) continue;
      if (historique[i].statut == entry.status) {
        matchIndex = i;
        break;
      }
    }
    final match = matchIndex != null ? historique[matchIndex] : null;
    if (matchIndex != null) usedIndexes.add(matchIndex);

    steps.add(MergedTimelineStep(
      status: entry.status,
      date: entry.createdAt,
      commentaire: match?.commentaire,
      fichierUrl: match?.fichierUrl,
      fichierNom: match?.fichierNom,
      adminNom: match?.adminNom,
    ));
  }
  steps.sort((a, b) => a.date.compareTo(b.date));

  final extra = <HistoriqueEntry>[
    for (var i = 0; i < historique.length; i++)
      if (!usedIndexes.contains(i)) historique[i],
  ]..sort((a, b) => a.date.compareTo(b.date));

  return MergedTimeline(steps: steps, extra: extra);
}
