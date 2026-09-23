/// Données de sélection guidée du corridor classique.
/// Contrat : docs-from-api/03_ENREGISTREMENT_COLIS_MOBILE.md
library;

class RouteDepart {
  final String pays;
  final String ville;
  final List<String> categories;

  const RouteDepart({required this.pays, required this.ville, required this.categories});

  factory RouteDepart.fromJson(Map<String, dynamic> json) {
    return RouteDepart(
      pays: json['pays'] as String? ?? '',
      ville: json['ville'] as String? ?? '',
      categories: (json['categories'] as List<dynamic>? ?? []).whereType<String>().toList(),
    );
  }
}

class RouteDestination {
  final String pays;
  final String ville;

  const RouteDestination({required this.pays, required this.ville});

  factory RouteDestination.fromJson(Map<String, dynamic> json) {
    return RouteDestination(
      pays: json['pays'] as String? ?? '',
      ville: json['ville'] as String? ?? '',
    );
  }
}

/// Une ligne = un corridor + un service précis (le formulaire ne doit
/// jamais choisir arbitrairement la première ligne d'un corridor : deux
/// lignes peuvent partager le même corridor et mode avec un `typeService`
/// différent).
class ColisRouteLine {
  final int id;
  final String paysDepart;
  final String villeDepart;
  final String paysDestination;
  final String villeDestination;
  final String modeColis;
  final String modeTransport;
  final String? typeService;
  final String? categorie;
  final String? instructionsClient;
  final bool codeTrackingObligatoire;
  final String? adressePhysique;
  final String? contactNom;
  final String? contactTelephone;

  const ColisRouteLine({
    required this.id,
    required this.paysDepart,
    required this.villeDepart,
    required this.paysDestination,
    required this.villeDestination,
    required this.modeColis,
    required this.modeTransport,
    this.typeService,
    this.categorie,
    this.instructionsClient,
    required this.codeTrackingObligatoire,
    this.adressePhysique,
    this.contactNom,
    this.contactTelephone,
  });

  /// Libellé affiché : `typeService` prime sur le mode brut quand renseigné.
  String get displayLabel => typeService?.isNotEmpty == true ? typeService! : modeColis;

  factory ColisRouteLine.fromJson(Map<String, dynamic> json) {
    return ColisRouteLine(
      id: json['id'] as int,
      paysDepart: json['paysDepart'] as String? ?? '',
      villeDepart: json['villeDepart'] as String? ?? '',
      paysDestination: json['paysDestination'] as String? ?? '',
      villeDestination: json['villeDestination'] as String? ?? '',
      modeColis: json['modeColis'] as String? ?? '',
      modeTransport: json['modeTransport'] as String? ?? '',
      typeService: json['typeService'] as String?,
      categorie: json['categorie'] as String?,
      instructionsClient: json['instructionsClient'] as String?,
      codeTrackingObligatoire: json['codeTrackingObligatoire'] as bool? ?? false,
      adressePhysique: json['adressePhysique'] as String?,
      contactNom: json['contactNom'] as String?,
      contactTelephone: json['contactTelephone'] as String?,
    );
  }
}

class ColisRoutesData {
  final List<RouteDepart> departs;
  final List<RouteDestination> destinations;
  final List<ColisRouteLine> lignes;

  const ColisRoutesData({required this.departs, required this.destinations, required this.lignes});

  factory ColisRoutesData.fromJson(Map<String, dynamic> json) {
    return ColisRoutesData(
      departs: (json['departs'] as List<dynamic>? ?? []).whereType<Map<String, dynamic>>().map(RouteDepart.fromJson).toList(),
      destinations:
          (json['destinations'] as List<dynamic>? ?? []).whereType<Map<String, dynamic>>().map(RouteDestination.fromJson).toList(),
      lignes: (json['lignes'] as List<dynamic>? ?? []).whereType<Map<String, dynamic>>().map(ColisRouteLine.fromJson).toList(),
    );
  }
}

class ShippingModeRule {
  final String unit;
  final String quantityLabel;
  final double minValue;

  const ShippingModeRule({required this.unit, required this.quantityLabel, required this.minValue});
}

/// Règles par mode (section 8 de la doc). Le backend reste la source de
/// vérité ; ceci ne sert qu'à guider et valider localement le formulaire.
const Map<String, ShippingModeRule> parcelModeRules = {
  'bateau': ShippingModeRule(unit: 'CBM', quantityLabel: 'Volume déclaré (CBM)', minValue: 0.5),
  'avion': ShippingModeRule(unit: 'Kg', quantityLabel: 'Poids déclaré (Kg)', minValue: 0.01),
  'express': ShippingModeRule(unit: 'Kg', quantityLabel: 'Poids déclaré (Kg)', minValue: 0.01),
  'terrestre': ShippingModeRule(unit: 'Kg', quantityLabel: 'Quantité déclarée (Kg)', minValue: 0.01),
};
