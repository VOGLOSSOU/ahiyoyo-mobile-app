/// Modèles du suivi public colis/commande.
/// Contrat : docs-from-api/04_SUIVI_PUBLIC_COLIS_COMMANDES_MOBILE.md
library;

double? _parseNum(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

String? _nonEmpty(dynamic value) {
  if (value is! String) return null;
  return value.trim().isEmpty ? null : value;
}

class TrackingArticle {
  final String? id;
  final String description;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final String? imageUrl;
  final String? purchaseLink;

  const TrackingArticle({
    this.id,
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    this.imageUrl,
    this.purchaseLink,
  });

  factory TrackingArticle.fromJson(Map<String, dynamic> json) {
    return TrackingArticle(
      id: json['id'] as String?,
      description: json['description'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      unitPrice: _parseNum(json['unitPrice']) ?? 0,
      totalPrice: _parseNum(json['totalPrice']) ?? 0,
      imageUrl: _nonEmpty(json['imageUrl']),
      purchaseLink: _nonEmpty(json['purchaseLink']),
    );
  }
}

/// Historique automatique et minimal des changements de statut (backbone
/// garanti de la timeline, y compris le statut initial).
class StatusHistoryEntry {
  final String status;
  final DateTime createdAt;

  const StatusHistoryEntry({required this.status, required this.createdAt});

  factory StatusHistoryEntry.fromJson(Map<String, dynamic> json) {
    return StatusHistoryEntry(
      status: json['status'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

/// Historique enrichi (commentaires, fichiers) produit par les opérations
/// administratives. Peut représenter les mêmes changements que
/// [StatusHistoryEntry] : ne jamais concaténer naïvement les deux listes.
class HistoriqueEntry {
  final String statut;
  final String? commentaire;
  final String? fichierUrl;
  final String? fichierNom;
  final String? adminNom;
  final DateTime date;

  const HistoriqueEntry({
    required this.statut,
    this.commentaire,
    this.fichierUrl,
    this.fichierNom,
    this.adminNom,
    required this.date,
  });

  factory HistoriqueEntry.fromJson(Map<String, dynamic> json) {
    return HistoriqueEntry(
      statut: json['statut'] as String? ?? '',
      commentaire: _nonEmpty(json['commentaire']),
      fichierUrl: _nonEmpty(json['fichierUrl']),
      fichierNom: _nonEmpty(json['fichierNom']),
      adminNom: _nonEmpty(json['adminNom']),
      date: DateTime.parse(json['date'] as String),
    );
  }
}

class TrackingLigneTarifaire {
  final String paysDepart;
  final String villeDepart;
  final String paysDestination;
  final String villeDestination;
  final String modeTransport;

  const TrackingLigneTarifaire({
    required this.paysDepart,
    required this.villeDepart,
    required this.paysDestination,
    required this.villeDestination,
    required this.modeTransport,
  });

  factory TrackingLigneTarifaire.fromJson(Map<String, dynamic> json) {
    return TrackingLigneTarifaire(
      paysDepart: json['paysDepart'] as String? ?? '',
      villeDepart: json['villeDepart'] as String? ?? '',
      paysDestination: json['paysDestination'] as String? ?? '',
      villeDestination: json['villeDestination'] as String? ?? '',
      modeTransport: json['modeTransport'] as String? ?? '',
    );
  }
}

class TrackingFacture {
  final String? numero;
  final String? nomArticle;
  final double? montantTotal;
  final String? delaiEstimatif;
  final TrackingLigneTarifaire? ligneTarifaire;

  const TrackingFacture({
    this.numero,
    this.nomArticle,
    this.montantTotal,
    this.delaiEstimatif,
    this.ligneTarifaire,
  });

  factory TrackingFacture.fromJson(Map<String, dynamic> json) {
    return TrackingFacture(
      numero: _nonEmpty(json['numero']),
      nomArticle: _nonEmpty(json['nomArticle']),
      montantTotal: _parseNum(json['montantTotal']),
      delaiEstimatif: _nonEmpty(json['delaiEstimatif']),
      ligneTarifaire: json['ligneTarifaire'] is Map<String, dynamic>
          ? TrackingLigneTarifaire.fromJson(json['ligneTarifaire'] as Map<String, dynamic>)
          : null,
    );
  }
}

/// Un résultat de recherche est soit un colis (présence de `trackingNumber`),
/// soit une commande (absence de `trackingNumber`, présence de `reference`).
/// Ne jamais se baser sur le préfixe saisi par l'utilisateur.
sealed class TrackingResult {
  factory TrackingResult.fromJson(Map<String, dynamic> json) {
    if (json['trackingNumber'] != null) {
      return ColisTrackingResult.fromJson(json);
    }
    return CommandeTrackingResult.fromJson(json);
  }
}

class ColisTrackingResult implements TrackingResult {
  final String trackingNumber;
  final String? carrierTrackingNumber;
  final String originCountry;
  final String originCity;
  final String destinationCountry;
  final String destinationCity;
  final String shippingMode;
  final double? volumeValue;
  final String? volumeUnit;
  final String status;
  final DateTime? estimatedDeliveryAt;
  final String? documentsUrl;
  final DateTime createdAt;
  final List<TrackingArticle> articles;
  final List<StatusHistoryEntry> statusHistory;
  final List<HistoriqueEntry> historique;

  const ColisTrackingResult({
    required this.trackingNumber,
    this.carrierTrackingNumber,
    required this.originCountry,
    required this.originCity,
    required this.destinationCountry,
    required this.destinationCity,
    required this.shippingMode,
    this.volumeValue,
    this.volumeUnit,
    required this.status,
    this.estimatedDeliveryAt,
    this.documentsUrl,
    required this.createdAt,
    required this.articles,
    required this.statusHistory,
    required this.historique,
  });

  factory ColisTrackingResult.fromJson(Map<String, dynamic> json) {
    return ColisTrackingResult(
      trackingNumber: json['trackingNumber'] as String,
      carrierTrackingNumber: _nonEmpty(json['carrierTrackingNumber']),
      originCountry: json['originCountry'] as String? ?? '',
      originCity: json['originCity'] as String? ?? '',
      destinationCountry: json['destinationCountry'] as String? ?? '',
      destinationCity: json['destinationCity'] as String? ?? '',
      shippingMode: json['shippingMode'] as String? ?? '',
      volumeValue: _parseNum(json['volumeValue']),
      volumeUnit: _nonEmpty(json['volumeUnit']),
      status: json['status'] as String? ?? '',
      estimatedDeliveryAt: json['estimatedDeliveryAt'] != null ? DateTime.tryParse(json['estimatedDeliveryAt'] as String) : null,
      documentsUrl: _nonEmpty(json['documentsUrl']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      articles: (json['articles'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(TrackingArticle.fromJson)
          .toList(),
      statusHistory: (json['statusHistory'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(StatusHistoryEntry.fromJson)
          .toList(),
      historique: (json['historique'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(HistoriqueEntry.fromJson)
          .toList(),
    );
  }
}

class CommandeTrackingResult implements TrackingResult {
  final String reference;
  final String statut;
  final DateTime createdAt;
  final DateTime? paiementConfirmeAt;
  final TrackingFacture? facture;
  final List<HistoriqueEntry> historique;

  const CommandeTrackingResult({
    required this.reference,
    required this.statut,
    required this.createdAt,
    this.paiementConfirmeAt,
    this.facture,
    required this.historique,
  });

  factory CommandeTrackingResult.fromJson(Map<String, dynamic> json) {
    return CommandeTrackingResult(
      reference: json['reference'] as String? ?? '',
      statut: json['statut'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      paiementConfirmeAt:
          json['paiementConfirmeAt'] != null ? DateTime.tryParse(json['paiementConfirmeAt'] as String) : null,
      facture: json['facture'] is Map<String, dynamic> ? TrackingFacture.fromJson(json['facture'] as Map<String, dynamic>) : null,
      historique: (json['historique'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(HistoriqueEntry.fromJson)
          .toList(),
    );
  }
}

/// Libellés publics recommandés par la doc (section 8).
const Map<String, String> colisStatusLabels = {
  'EN_ATTENTE_CONFIRMATION': 'En attente de confirmation',
  'RECU_AU_CARGO': 'Reçu au cargo',
  'ENVOI_EN_COURS': 'Envoi en cours',
  'EN_ATTENTE_RETRAIT': 'En attente de retrait',
  'RETRAIT_EFFECTUE': 'Retrait effectué',
  'EN_TRANSIT': 'En transit',
  'ARRIVE_A_DESTINATION': 'Arrivé à destination',
  'LIVRE': 'Livré',
  'ANNULE': 'Annulé',
};

/// Libellés publics recommandés par la doc (section 12).
const Map<String, String> commandeStatusLabels = {
  'EN_ATTENTE_VALIDATION': 'En attente de validation',
  'EN_ATTENTE_PAIEMENT': 'En attente de paiement',
  'COMMANDE_EN_COURS': 'Commande en cours de traitement',
  'ENVOYEE_AU_CARGO': 'Envoyée au cargo',
  'RECUE_AU_CARGO': 'Reçue au cargo',
  'ENVOI_EN_COURS': 'Envoi en cours',
  'FORMALITES_EN_COURS': 'Formalités en cours',
  'DISPONIBLE_ENTREPOT': 'Disponible en entrepôt',
};

/// Un statut inconnu ne doit jamais masquer le résultat : on affiche une
/// version lisible de sa valeur brute plutôt qu'un texte vide.
String _humanizeStatus(String raw) {
  if (raw.isEmpty) return raw;
  return raw
      .toLowerCase()
      .split('_')
      .where((w) => w.isNotEmpty)
      .map((w) => w[0].toUpperCase() + w.substring(1))
      .join(' ');
}

String colisStatusLabel(String status) => colisStatusLabels[status] ?? _humanizeStatus(status);

String commandeStatusLabel(String status) => commandeStatusLabels[status] ?? _humanizeStatus(status);

const Map<String, String> shippingModeLabels = {
  'bateau': 'Maritime',
  'avion': 'Aérien',
  'express': 'Aérien express',
  'terrestre': 'Routier',
};

String shippingModeLabel(String mode) => shippingModeLabels[mode] ?? _humanizeStatus(mode);
