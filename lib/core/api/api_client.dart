import 'package:dio/dio.dart';
import '../storage/secure_storage.dart';
import 'api_endpoints.dart';
import 'auth_interceptor.dart';
import 'error_interceptor.dart';

/// Client HTTP unifié Dio configuré pour l'API Ahiyoyo.
class ApiClient {
  late final Dio dio;

  ApiClient({
    required SecureStorageService secureStorage,
    String? baseUrl,
    void Function()? onSessionExpired,
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

    // Ordre des intercepteurs :
    // 1. AuthInterceptor (injection token et retry sur refresh)
    // 2. ErrorInterceptor (mapping des erreurs en AppException)
    dio.interceptors.addAll([
      AuthInterceptor(
        secureStorage: secureStorage,
        dio: dio,
        onSessionExpired: onSessionExpired,
      ),
      ErrorInterceptor(),
    ]);
  }
}
