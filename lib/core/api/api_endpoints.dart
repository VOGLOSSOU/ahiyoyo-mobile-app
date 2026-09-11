/// Points de terminaison (endpoints) de l'API Ahiyoyo.
abstract class ApiEndpoints {
  /// Base URL par défaut (configurable par variable d'environnement ou override)
  static const String defaultBaseUrl = 'https://api.ahiyoyo.com/api/v1';

  // --- Authentification & Utilisateur ---
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String loginGoogle = '/auth/google';
  static const String verifyOtp = '/auth/verify-otp';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String refreshToken = '/auth/refresh';
  static const String profile = '/auth/profile';

  // --- Suivi Public & Tracking ---
  static const String track = '/tracking';

  // --- Colis & Expéditions ---
  static const String parcels = '/parcels';
  static String parcelDetail(String id) => '/parcels/$id';

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

  // --- Tarifs & Adresses ---
  static const String tariffs = '/tariffs';

  // --- Parrainage ---
  static const String referral = '/referral';
  static const String referralCheck = '/referral/check';
  static const String referralEarnings = '/referral/earnings';

  // --- Notifications ---
  static const String notifications = '/notifications';
  static String markNotificationRead(String id) => '/notifications/$id/read';
  static const String markAllNotificationsRead = '/notifications/read-all';
}
