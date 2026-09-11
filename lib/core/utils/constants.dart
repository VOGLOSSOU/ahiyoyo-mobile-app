/// Constantes globales de l'application Ahiyoyo.
abstract class AppConstants {
  static const String appName = 'Ahiyoyo';
  static const String appTagline = 'Commerce international & Logistique intelligente';

  // --- Minimums d'expédition imposés par les règles métier ---
  /// Minimum maritime : 0.5 CBM (sur expédition client) / 0.1 CBM (facturation générale)
  static const double minSeaShippingCbm = 0.5;
  static const double minSeaBillingCbm = 0.1;

  /// Minimum aérien : 1.0 KG
  static const double minAirShippingKg = 1.0;

  /// Capacité nominale d'un conteneur 40 pieds
  static const double containerReferenceCapacityCbm = 68.0;

  /// Frais forfaitaires de traitement manuel si omission d'enregistrement préalable
  static const int manualProcessingFee = 10000; // 10 000 FCFA

  // --- Support & Liens officiels ---
  static const String logoUrl = 'https://ahiyoyo.com/ahiyoyo.png';
  static const String websiteUrl = 'https://ahiyoyo.com';
  static const String cguUrl = 'https://ahiyoyo.com/cgu';
  static const String privacyPolicyUrl = 'https://ahiyoyo.com/confidentialite';
  static const String contactEmail = 'contact@ahiyoyo.com';
  static const String whatsappNumber = '+22900000000'; // À configurer
}
