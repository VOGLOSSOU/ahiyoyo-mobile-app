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

      // 3. Extraction des détails de validation
      if (data['details'] is Map<String, dynamic>) {
        details = data['details'] as Map<String, dynamic>;
      } else if (data['errors'] is Map<String, dynamic>) {
        details = data['errors'] as Map<String, dynamic>;
      }
    } else if (data is String && data.isNotEmpty) {
      message = data;
    }

    switch (statusCode) {
      case 400:
        return AppException.validation(message: message, details: details);
      case 401:
        return AppException.unauthorized(message);
      case 403:
        return AppException.forbidden(message);
      case 404:
        return AppException.notFound(message);
      case 422:
        return AppException.validation(message: message, details: details);
      case 500:
      case 502:
      case 503:
      case 504:
        return AppException.server(message, statusCode);
      default:
        return AppException(message: message, code: code, statusCode: statusCode, details: details);
    }
  }
}
