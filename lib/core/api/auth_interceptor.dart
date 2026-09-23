import 'package:dio/dio.dart';
import '../storage/secure_storage.dart';
import 'api_endpoints.dart';

/// Intercepteur gérant l'injection du Bearer token et la déconnexion
/// centralisée sur 401. L'API Ahiyoyo n'a ni cookie de session ni refresh
/// token : un jeton expiré ou révoqué impose une reconnexion complète.
class AuthInterceptor extends Interceptor {
  final SecureStorageService _secureStorage;

  /// Callback mutable (branché par [AuthController]) pour propager la
  /// déconnexion à l'état applicatif sans dépendance circulaire entre
  /// providers.
  void Function()? onSessionExpired;

  AuthInterceptor({
    required SecureStorageService secureStorage,
    this.onSessionExpired,
  }) : _secureStorage = secureStorage;

  /// Routes publiques qui ne nécessitent pas d'injection de token d'authentification
  final List<String> _publicRoutes = [
    ApiEndpoints.register,
    ApiEndpoints.verifyReferralCode,
    ApiEndpoints.activateEmail,
    ApiEndpoints.resendActivation,
    ApiEndpoints.login,
    ApiEndpoints.loginGoogle,
    ApiEndpoints.forgotPassword,
    ApiEndpoints.resetPassword,
    ApiEndpoints.track,
    ApiEndpoints.tariffsPublic,
    ApiEndpoints.colisRoutesDisponibles,
    ApiEndpoints.maritimeContainers,
    ApiEndpoints.airGroupageOffers,
  ];

  bool _isPublicRoute(String path) {
    return _publicRoutes.any((route) => path.contains(route));
  }

  // Verrou simple pour éviter plusieurs déconnexions concurrentes si
  // plusieurs requêtes retournent 401 en même temps.
  bool _handlingSessionExpiry = false;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (!_isPublicRoute(options.path)) {
      final token = await _secureStorage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    return handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;
    // Un 401 sur une route protégée = session invalide. Une erreur réseau,
    // un timeout ou un 500 ne doivent jamais être traités comme une
    // expiration de session.
    if (statusCode == 401 && !_isPublicRoute(err.requestOptions.path) && !_handlingSessionExpiry) {
      _handlingSessionExpiry = true;
      await _secureStorage.clearSession();
      onSessionExpired?.call();
      _handlingSessionExpiry = false;
    }
    return handler.next(err);
  }
}
