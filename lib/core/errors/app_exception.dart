/// Exception métier et technique unifiée pour l'ensemble de l'application Ahiyoyo.
class AppException implements Exception {
  final String message;
  final String? code;
  final int? statusCode;
  final Map<String, dynamic>? details;

  const AppException({
    required this.message,
    this.code,
    this.statusCode,
    this.details,
  });

  factory AppException.network([String? message]) => AppException(
        message: message ?? 'Erreur de connexion. Vérifiez votre connexion Internet.',
        code: 'NETWORK_ERROR',
      );

  factory AppException.timeout([String? message]) => AppException(
        message: message ?? 'Le délai d\'attente a expiré. Veuillez réessayer.',
        code: 'TIMEOUT_ERROR',
      );

  factory AppException.unauthorized([String? message]) => AppException(
        message: message ?? 'Session expirée ou non autorisée. Veuillez vous reconnecter.',
        code: 'UNAUTHORIZED',
        statusCode: 401,
      );

  factory AppException.forbidden([String? message]) => AppException(
        message: message ?? 'Accès refusé.',
        code: 'FORBIDDEN',
        statusCode: 403,
      );

  factory AppException.notFound([String? message]) => AppException(
        message: message ?? 'Ressource introuvable.',
        code: 'NOT_FOUND',
        statusCode: 404,
      );

  factory AppException.server([String? message, int? statusCode]) => AppException(
        message: message ?? 'Une erreur serveur est survenue. Veuillez réessayer plus tard.',
        code: 'SERVER_ERROR',
        statusCode: statusCode ?? 500,
      );

  factory AppException.validation({required String message, Map<String, dynamic>? details}) => AppException(
        message: message,
        code: 'VALIDATION_ERROR',
        statusCode: 422,
        details: details,
      );

  factory AppException.unknown([String? message]) => AppException(
        message: message ?? 'Une erreur inattendue est survenue.',
        code: 'UNKNOWN_ERROR',
      );

  @override
  String toString() => 'AppException(code: $code, statusCode: $statusCode, message: $message)';
}
