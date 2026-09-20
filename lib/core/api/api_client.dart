import 'package:dio/dio.dart';
import '../storage/secure_storage.dart';
import 'api_endpoints.dart';
import 'auth_interceptor.dart';
import 'error_interceptor.dart';

/// Client HTTP unifié Dio configuré pour l'API Ahiyoyo.
class ApiClient {
  late final Dio dio;
  late final AuthInterceptor _authInterceptor;

  ApiClient({
    required SecureStorageService secureStorage,
    String? baseUrl,
  }) {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? ApiEndpoints.defaultBaseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 20),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _authInterceptor = AuthInterceptor(secureStorage: secureStorage);

    // Ordre des intercepteurs :
    // 1. AuthInterceptor (injection du Bearer token, déconnexion sur 401)
    // 2. ErrorInterceptor (mapping des erreurs en AppException)
    dio.interceptors.addAll([
      _authInterceptor,
      ErrorInterceptor(),
    ]);
  }

  /// Branche le callback de déconnexion (appelé par [AuthController] pour
  /// éviter une dépendance circulaire entre providers).
  void setOnSessionExpired(void Function() callback) {
    _authInterceptor.onSessionExpired = callback;
  }
}
