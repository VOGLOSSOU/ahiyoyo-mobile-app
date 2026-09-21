import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

/// Une ligne tarifaire publique : un trajet + un mode de transport + un prix.
///
/// `tarifParKg` / `tarifParCbm` arrivent parfois en `String`, parfois en
/// `num`, et peuvent être `null` si ce mode de tarification ne s'applique
/// pas à la ligne (ex. une ligne maritime a typiquement `tarifParKg: null`).
class TariffLine {
  final int id;
  final String villeDepart;
  final String paysDepart;
  final String villeDestination;
  final String paysDestination;
  final String modeTransport;
  final String? typeService;
  final String? categorie;
  final double? tarifParKg;
  final double? tarifParCbm;
  final int? delaiJours;
  final String? adressePhysique;
  final String? contactNom;
  final String? contactTelephone;
  final String? instructionsClient;

  const TariffLine({
    required this.id,
    required this.villeDepart,
    required this.paysDepart,
    required this.villeDestination,
    required this.paysDestination,
    required this.modeTransport,
    this.typeService,
    this.categorie,
    this.tarifParKg,
    this.tarifParCbm,
    this.delaiJours,
    this.adressePhysique,
    this.contactNom,
    this.contactTelephone,
    this.instructionsClient,
  });

  factory TariffLine.fromJson(Map<String, dynamic> json) {
    return TariffLine(
      id: json['id'] as int,
      villeDepart: json['villeDepart'] as String? ?? '',
      paysDepart: json['paysDepart'] as String? ?? '',
      villeDestination: json['villeDestination'] as String? ?? '',
      paysDestination: json['paysDestination'] as String? ?? '',
      modeTransport: json['modeTransport'] as String? ?? '',
      typeService: _nonEmpty(json['typeService']),
      categorie: _nonEmpty(json['categorie']),
      tarifParKg: _parseNum(json['tarifParKg']),
      tarifParCbm: _parseNum(json['tarifParCbm']),
      delaiJours: json['delaiJours'] as int?,
      adressePhysique: _nonEmpty(json['adressePhysique']),
      contactNom: _nonEmpty(json['contactNom']),
      contactTelephone: _nonEmpty(json['contactTelephone']),
      instructionsClient: _nonEmpty(json['instructionsClient']),
    );
  }

  static double? _parseNum(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static String? _nonEmpty(dynamic value) {
    if (value is! String) return null;
    return value.trim().isEmpty ? null : value;
  }
}

/// Filtres client (une seule requête, filtrage local).
enum TariffFilter { all, air, maritime, routier }

extension TariffFilterX on TariffFilter {
  String get label {
    switch (this) {
      case TariffFilter.all:
        return 'Tous';
      case TariffFilter.air:
        return 'Aérien';
      case TariffFilter.maritime:
        return 'Maritime';
      case TariffFilter.routier:
        return 'Routier';
    }
  }

  bool matches(TariffLine line) {
    switch (this) {
      case TariffFilter.all:
        return true;
      case TariffFilter.air:
        return line.modeTransport.startsWith('air');
      case TariffFilter.maritime:
        return line.modeTransport == 'maritime';
      case TariffFilter.routier:
        return line.modeTransport == 'routier';
    }
  }
}

/// Libellé + icône du mode de transport. `typeService` prime toujours sur le
/// libellé par défaut du mode quand il est renseigné. Un mode inconnu
/// retombe sur un badge neutre (`typeService` ou le code brut) avec l'icône
/// Truck — ne jamais masquer la ligne ni planter sur un mode inattendu.
class TransportModeInfo {
  final String label;
  final IconData icon;
  const TransportModeInfo(this.label, this.icon);
}

const Map<String, TransportModeInfo> _transportModeTable = {
  'air_standard': TransportModeInfo('Aérien standard', LucideIcons.plane),
  'air_economie': TransportModeInfo('Aérien économie', LucideIcons.plane),
  'air_express': TransportModeInfo('Aérien express', LucideIcons.plane),
  'maritime': TransportModeInfo('Maritime groupage', LucideIcons.ship),
  'routier': TransportModeInfo('Transport routier', LucideIcons.truck),
};

TransportModeInfo transportModeInfo(TariffLine line) {
  final known = _transportModeTable[line.modeTransport];
  final label = line.typeService ?? known?.label ?? line.modeTransport;
  final icon = known?.icon ?? LucideIcons.truck;
  return TransportModeInfo(label, icon);
}

/// Minimum d'expédition déduit du mode de transport (pas une donnée serveur).
/// Logique par mots-clés (et non un simple mapping des codes connus) pour
/// rester robuste si un nouveau code de mode apparaît côté backend.
String? minimumForMode(String modeTransport) {
  final mode = modeTransport.toLowerCase();
  if (mode.startsWith('air') || mode.contains('avion') || mode.contains('aérien')) {
    return '1 kg';
  }
  if (mode.contains('maritime') || mode.contains('bateau') || mode.contains('navire')) {
    return '0,5 CBM';
  }
  return null;
}
