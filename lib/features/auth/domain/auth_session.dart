import 'user.dart';

/// Résultat d'une connexion (classique ou Google) : jeton unique, sans
/// refresh token (l'API Ahiyoyo n'en fournit pas).
class AuthSession {
  final String token;
  final DateTime expiresAt;
  final User user;

  const AuthSession({
    required this.token,
    required this.expiresAt,
    required this.user,
  });

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    return AuthSession(
      token: json['token'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}
