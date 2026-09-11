import 'dart:async';
import 'package:dio/dio.dart';
import '../storage/secure_storage.dart';
import 'api_endpoints.dart';

/// Intercepteur gérant l'injection du Bearer token et le refresh token mutualisé.
class AuthInterceptor extends Interceptor {
  final SecureStorageService _secureStorage;
  final Dio _dio;
  final void Function()? onSessionExpired;

  /// Future partagé garantissant qu'un burst de requêtes sur 401 ne lance qu'un seul refresh
  Future<String?>? _refreshTokenFuture;

  AuthInterceptor({
    required SecureStorageService secureStorage,
    required Dio dio,
    this.onSessionExpired,
  })  : _secureStorage = secureStorage,
        _dio = dio;

  /// Routes publiques qui ne nécessitent pas d'injection de token d'authentification
  final List<String> _publicRoutes = [
    ApiEndpoints.login,
    ApiEndpoints.register,
    ApiEndpoints.loginGoogle,
    ApiEndpoints.verifyOtp,
    ApiEndpoints.forgotPassword,
    ApiEndpoints.resetPassword,
    ApiEndpoints.refreshToken,
    ApiEndpoints.track,
  ];

  bool _isPublicRoute(String path) {
    return _publicRoutes.any((route) => path.contains(route));
  }

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (!_isPublicRoute(options.path)) {
      final token = await _secureStorage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    options.headers['Accept'] = 'application/json';
    return handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    // Si l'erreur est un 401 et qu'il ne s'agit pas d'une route publique / refresh
    if (err.response?.statusCode == 401 && !_isPublicRoute(err.requestOptions.path)) {
      try {
        final newAccessToken = await _performTokenRefresh();
        if (newAccessToken != null) {
          // Rejouer la requête d'origine avec le nouveau token
          final options = err.requestOptions;
          options.headers['Authorization'] = 'Bearer $newAccessToken';

          final response = await _dio.fetch(options);
          return handler.resolve(response);
        }
      } on DioException catch (refreshErr) {
        // Déconnexion UNIQUEMENT sur une vraie erreur d'auth (401 / 403), jamais sur erreur réseau
        final status = refreshErr.response?.statusCode;
        if (status == 401 || status == 403) {
          await _secureStorage.clearSession();
          onSessionExpired?.call();
        }
        return handler.next(err);
      } catch (_) {
        return handler.next(err);
      }
    }

    return handler.next(err);
  }

  /// Exécute le refresh de token de manière mutualisée
  Future<String?> _performTokenRefresh() async {
    if (_refreshTokenFuture != null) {
      return await _refreshTokenFuture;
    }

    _refreshTokenFuture = _executeRefresh();
    try {
      final token = await _refreshTokenFuture;
      return token;
    } finally {
      _refreshTokenFuture = null;
    }
  }

  Future<String?> _executeRefresh() async {
    final currentRefreshToken = await _secureStorage.getRefreshToken();
    if (currentRefreshToken == null || currentRefreshToken.isEmpty) {
      await _secureStorage.clearSession();
      onSessionExpired?.call();
      return null;
    }

    // Utilisation d'un client Dio isolé pour éviter les boucles d'interception
    final tokenDio = Dio(
      BaseOptions(
        baseUrl: _dio.options.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );

    final response = await tokenDio.post(
      ApiEndpoints.refreshToken,
      data: {'refresh_token': currentRefreshToken},
    );

    if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
      final newAccess = response.data['access_token'] as String?;
      final newRefresh = response.data['refresh_token'] as String?;

      if (newAccess != null) {
        await _secureStorage.saveTokens(
          accessToken: newAccess,
          refreshToken: newRefresh ?? currentRefreshToken,
        );
        return newAccess;
      }
    }

    return null;
  }
}
