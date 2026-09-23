/// Points de terminaison (endpoints) de l'API Ahiyoyo.
abstract class ApiEndpoints {
  /// Base URL par défaut (configurable par variable d'environnement ou override)
  static const String defaultBaseUrl = 'https://orchid-jellyfish-551876.hostingersite.com';

  // --- Authentification & Utilisateur (contrat docs-from-api/01_AUTHENTIFICATION_FLUTTER.md) ---
  static const String register = '/api/register';
  static const String verifyReferralCode = '/api/parrainage/verifier';
  static const String activateEmail = '/api/email/activate';
  static const String resendActivation = '/api/email/resend-activation';
  static const String login = '/api/login';
  static const String loginGoogle = '/api/auth/google';
  static const String forgotPassword = '/api/password/forgot';
  static const String resetPassword = '/api/password/reset';
  static const String me = '/api/me';
  static const String updateProfile = '/api/me/profile';
  static const String changePassword = '/api/auth/change-password';

  // --- Suivi Public & Tracking (contrat docs-from-api/04_SUIVI_PUBLIC_COLIS_COMMANDES_MOBILE.md) ---
  /// Route publique, sans authentification requise.
  static const String track = '/api/tracking';

  // --- Colis & Expéditions (contrat docs-from-api/03_ENREGISTREMENT_COLIS_MOBILE.md) ---
  /// Route publique, sans authentification requise.
  static const String colisRoutesDisponibles = '/api/colis/routes-disponibles';

  /// Création d'un colis. Nécessite un Bearer client, format multipart.
  static const String colis = '/api/colis';

  // Liste/détail des colis d'un client : non couverts par le contrat actuel,
  // chemins encore à confirmer avec l'équipe backend.
  static const String parcels = '/parcels';
  static String parcelDetail(String id) => '/parcels/$id';

  /// Offres de groupage ouvertes, routes publiques.
  static const String maritimeContainers = '/api/maritime/containers';
  static String maritimeContainerDetail(String id) => '/api/maritime/containers/$id';
  static const String airGroupageOffers = '/api/air-groupage/offers';
  static String airGroupageOfferDetail(String id) => '/api/air-groupage/offers/$id';

  // --- Devis (Quotes) ---
  static const String quotes = '/quotes';
  static String quoteDetail(String id) => '/quotes/$id';
  static const String quoteVerifyPromo = '/quotes/verify-promo';

  // --- Factures Proforma ---
  static const String invoices = '/invoices';
  static String invoiceDetail(String id) => '/invoices/$id';
  static String acceptInvoice(String id) => '/invoices/$id/accept';

  // --- Commandes ---
  static const String orders = '/orders';
  static String orderDetail(String id) => '/orders/$id';
  static String orderManualPaymentProof(String id) => '/orders/$id/payment-proof';

  // --- Groupage & Offres Spéciales ---
  static const String seaGroupage = '/groupage/sea';
  static String seaGroupageDetail(String id) => '/groupage/sea/$id';
  static const String airOffers = '/offers/air';
  static String airOfferDetail(String id) => '/offers/air/$id';

  // --- Tarifs & Adresses (contrat docs-from-api/MOBILE_GUIDE_TARIFS_ADRESSES.md) ---
  /// Route publique, sans authentification requise.
  static const String tariffsPublic = '/api/tarifs/public';

  // --- Parrainage (tableau de bord "Gagner de l'argent", Lot 3) ---
  static const String referral = '/referral';
  static const String referralEarnings = '/referral/earnings';

  // --- Notifications ---
  static const String notifications = '/notifications';
  static String markNotificationRead(String id) => '/notifications/$id/read';
  static const String markAllNotificationsRead = '/notifications/read-all';
}
