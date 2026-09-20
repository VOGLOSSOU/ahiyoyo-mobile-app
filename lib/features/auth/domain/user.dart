/// Entité utilisateur du parcours client Ahiyoyo.
///
/// Le parcours mobile n'accepte que le rôle `USER` : aucun écran ou
/// comportement administratif ne doit être proposé, même si l'API retourne
/// un autre rôle.
class User {
  final int id;
  final String nom;
  final String prenom;
  final String email;
  final String? numero;
  final String? codePays;
  final String? avatarUrl;
  final bool phoneVerified;
  final bool emailVerified;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    this.numero,
    this.codePays,
    this.avatarUrl,
    required this.phoneVerified,
    required this.emailVerified,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  String get fullName => '$prenom $nom'.trim();

  bool get isUser => role == 'USER';

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      nom: json['nom'] as String? ?? '',
      prenom: json['prenom'] as String? ?? '',
      email: json['email'] as String,
      numero: json['numero'] as String?,
      codePays: json['code_pays'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      phoneVerified: json['phone_verified'] as bool? ?? false,
      emailVerified: json['email_verified'] as bool? ?? false,
      role: json['role'] as String? ?? 'USER',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
