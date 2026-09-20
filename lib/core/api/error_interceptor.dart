import 'package:dio/dio.dart';
import '../errors/app_exception.dart';

/// Intercepteur Dio transformant les DioException en AppException unifiée.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final appException = _mapDioException(err);
    // On passe une DioException enrichie de l'AppException comme custom error
    final newErr = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: appException,
      message: appException.message,
    );
    handler.next(newErr);
  }

  AppException _mapDioException(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return AppException.timeout();

      case DioExceptionType.connectionError:
        return AppException.network();

      case DioExceptionType.badResponse:
        return _extractExceptionFromResponse(err.response);

      case DioExceptionType.cancel:
        return const AppException(message: 'La requête a été annulée.', code: 'CANCELLED');

      case DioExceptionType.badCertificate:
        return const AppException(message: 'Certificat SSL non valide.', code: 'BAD_CERTIFICATE');

      case DioExceptionType.unknown:
      default:
        return AppException.unknown(err.message);
    }
  }

  AppException _extractExceptionFromResponse(Response? response) {
    if (response == null) {
      return AppException.server();
    }

    final statusCode = response.statusCode ?? 500;
    final data = response.data;

    String message = 'Une erreur est survenue ($statusCode).';
    String? code;
    Map<String, dynamic>? details;

    if (data is Map<String, dynamic>) {
      // 1. Extraction du code
      if (data['code'] is String) {
        code = data['code'] as String;
      } else if (data['error'] is Map && (data['error'] as Map)['code'] is String) {
        code = (data['error'] as Map)['code'] as String;
      }

      // 2. Extraction du message
      final rawMessage = data['message'] ?? data['error'];
      if (rawMessage is String) {
        message = rawMessage;
      } else if (rawMessage is List) {
        message = rawMessage.join('\n');
      } else if (rawMessage is Map && rawMessage['message'] is String) {
        message = rawMessage['message'] as String;
      }

      // 3. Extraction des erreurs de champ. L'API Ahiyoyo retourne
      // `errors: [{ msg, path }, ...]` (une LISTE, pas une map) — on la
      // convertit en `{ path: msg }` pour un lookup direct côté formulaires.
      if (data['errors'] is List) {
        final fieldErrors = <String, dynamic>{};
        for (final entry in data['errors'] as List) {
          if (entry is Map && entry['path'] is String && entry['msg'] is String) {
            fieldErrors[entry['path'] as String] = entry['msg'] as String;
          }
        }
        if (fieldErrors.isNotEmpty) details = fieldErrors;
      } else if (data['errors'] is Map<String, dynamic>) {
        details = data['errors'] as Map<String, dynamic>;
      } else if (data['details'] is Map<String, dynamic>) {
        details = data['details'] as Map<String, dynamic>;
      }
    } else if (data is String && data.isNotEmpty) {
      message = data;
    }

    // On construit toujours l'exception via le constructeur de base pour ne
    // jamais perdre `code` (ex. GOOGLE_ONLY_ACCOUNT sur un 401) ni `details`.
    switch (statusCode) {
      case 400:
      case 422:
        return AppException(
          message: message,
          code: code ?? 'VALIDATION_ERROR',
          statusCode: statusCode,
          details: details,
        );
      case 401:
        return AppException(message: message, code: code ?? 'UNAUTHORIZED', statusCode: 401, details: details);
      case 403:
        return AppException(message: message, code: code ?? 'FORBIDDEN', statusCode: 403, details: details);
      case 404:
        return AppException(message: message, code: code ?? 'NOT_FOUND', statusCode: 404, details: details);
      case 429:
        return AppException(message: message, code: code ?? 'TOO_MANY_REQUESTS', statusCode: 429, details: details);
      case 500:
      case 502:
      case 503:
      case 504:
        return AppException(message: message, code: code ?? 'SERVER_ERROR', statusCode: statusCode, details: details);
      default:
        return AppException(message: message, code: code, statusCode: statusCode, details: details);
    }
  }
}
