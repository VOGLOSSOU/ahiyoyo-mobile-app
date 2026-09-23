/// Résultat de `POST /api/colis` (201).
/// Contrat : docs-from-api/03_ENREGISTREMENT_COLIS_MOBILE.md
library;

class CreatedParcelArticle {
  final String? id;
  final String description;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final String? purchaseLink;
  final String? imageUrl;

  const CreatedParcelArticle({
    this.id,
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    this.purchaseLink,
    this.imageUrl,
  });

  factory CreatedParcelArticle.fromJson(Map<String, dynamic> json) {
    return CreatedParcelArticle(
      id: json['id'] as String?,
      description: json['description'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0,
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0,
      purchaseLink: json['purchaseLink'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );
  }
}

class CreatedParcel {
  final String id;
  final String trackingNumber;
  final String originCountry;
  final String originCity;
  final String destinationCountry;
  final String destinationCity;
  final String shippingMode;
  final double volumeValue;
  final String volumeUnit;
  final String ownerType;
  final String status;
  final String? documentsUrl;
  final List<CreatedParcelArticle> articles;
  final DateTime createdAt;

  const CreatedParcel({
    required this.id,
    required this.trackingNumber,
    required this.originCountry,
    required this.originCity,
    required this.destinationCountry,
    required this.destinationCity,
    required this.shippingMode,
    required this.volumeValue,
    required this.volumeUnit,
    required this.ownerType,
    required this.status,
    this.documentsUrl,
    required this.articles,
    required this.createdAt,
  });

  factory CreatedParcel.fromJson(Map<String, dynamic> json) {
    return CreatedParcel(
      id: json['id'] as String,
      trackingNumber: json['trackingNumber'] as String,
      originCountry: json['originCountry'] as String? ?? '',
      originCity: json['originCity'] as String? ?? '',
      destinationCountry: json['destinationCountry'] as String? ?? '',
      destinationCity: json['destinationCity'] as String? ?? '',
      shippingMode: json['shippingMode'] as String? ?? '',
      volumeValue: (json['volumeValue'] as num?)?.toDouble() ?? 0,
      volumeUnit: json['volumeUnit'] as String? ?? '',
      ownerType: json['ownerType'] as String? ?? 'self',
      status: json['status'] as String? ?? '',
      documentsUrl: json['documentsUrl'] as String?,
      articles: (json['articles'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(CreatedParcelArticle.fromJson)
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
