/// Constantes de routes pour GoRouter.
abstract class AppRoutes {
  // --- Routes spéciales ---
  static const String splash = '/';

  // --- Onglets du ShellRoute (Bottom Navigation) ---
  static const String home = '/home';
  static const String parcels = '/parcels';
  static const String orders = '/orders';
  static const String notifications = '/notifications';
  static const String profile = '/profile';

  // --- Routes Top-Level (Hors ShellRoute) ---
  static const String tracking = '/tracking';
  static const String parcelDetail = '/parcels/:id';
  static const String newParcel = '/new-parcel';
  static const String quoteDetail = '/quotes/:id';
  static const String newQuote = '/new-quote';
  static const String invoiceDetail = '/invoices/:id';
  static const String orderDetail = '/orders/:id';
  static const String seaGroupageDetail = '/sea-groupage/:id';
  static const String airOfferDetail = '/air-offers/:id';
  static const String tariffs = '/tariffs';
  static const String freightCalculator = '/freight-calculator';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
}
