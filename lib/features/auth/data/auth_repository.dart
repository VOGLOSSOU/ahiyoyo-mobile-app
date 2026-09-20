import 'package:dio/dio.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/errors/app_exception.dart';
import '../domain/auth_session.dart';
import '../domain/referral_check_result.dart';
import '../domain/user.dart';

/// Repository d'authentification : traduction directe du contrat
/// `docs-from-api/01_AUTHENTIFICATION_FLUTTER.md` en appels Dio.
class AuthRepository {
  final Dio _dio;

  AuthRepository(this._dio);

  /// Vérifie un code de parrainage avant inscription. Ne lance jamais
  /// d'exception : un code absent/invalide/introuvable retourne simplement
  /// `valid: false` avec un message à afficher.
  Future<ReferralCheckResult> verifyReferralCode(String code) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.verifyReferralCode,
        queryParameters: {'code': code},
      );
      final data = response.data as Map<String, dynamic>;
      return ReferralCheckResult(
        valid: data['valid'] as bool? ?? true,
        parrainNomPublic: data['parrainNomPublic'] as String?,
      );
    } on DioException catch (e) {
      final appException = e.error is AppException ? e.error as AppException : AppException.unknown();
      return ReferralCheckResult(valid: false, message: appException.message);
    }
  }

  /// Inscription classique. Ne connecte jamais automatiquement l'utilisateur
  /// et ne retourne aucun JWT : navigue vers l'activation par email ensuite.
  Future<int> register({
    required String nom,
    required String prenom,
    required String email,
    required String motDePasse,
    required String numero,
    required String codePays,
    String? codeParrainage,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.register,
      data: {
        'nom': nom,
        'prenom': prenom,
        'email': email,
        'mot_de_passe': motDePasse,
        'numero': numero,
        'code_pays': codePays,
        if (codeParrainage != null && codeParrainage.isNotEmpty) 'code_parrainage': codeParrainage,
      },
    );
    return (response.data as Map<String, dynamic>)['userId'] as int;
  }

  Future<void> activateAccount({required String email, required String code}) async {
    await _dio.post(
      ApiEndpoints.activateEmail,
      data: {'email': email, 'code': code},
    );
  }

  /// Retourne le `ttl_hours` fourni par le serveur (jamais codé en dur).
  Future<int> resendActivationCode({required String email}) async {
    final response = await _dio.post(
      ApiEndpoints.resendActivation,
      data: {'email': email},
    );
    return (response.data as Map<String, dynamic>)['ttl_hours'] as int? ?? 24;
  }

  Future<AuthSession> login({required String email, required String motDePasse}) async {
    final response = await _dio.post(
      ApiEndpoints.login,
      data: {'email': email, 'mot_de_passe': motDePasse},
    );
    return AuthSession.fromJson(response.data as Map<String, dynamic>);
  }

  /// [idToken] provient du SDK Google natif — jamais décodé côté mobile.
  Future<AuthSession> loginWithGoogle({required String idToken, String? codeParrainage}) async {
    final response = await _dio.post(
      ApiEndpoints.loginGoogle,
      data: {
        'id_token': idToken,
        if (codeParrainage != null && codeParrainage.isNotEmpty) 'code_parrainage': codeParrainage,
      },
    );
    return AuthSession.fromJson(response.data as Map<String, dynamic>);
  }

  /// Retourne le `ttl_seconds` fourni par le serveur (compte à rebours UI).
  Future<int> forgotPassword({required String email}) async {
    final response = await _dio.post(
      ApiEndpoints.forgotPassword,
      data: {'email': email},
    );
    return (response.data as Map<String, dynamic>)['ttl_seconds'] as int? ?? 600;
  }

  /// Ne connecte pas automatiquement l'utilisateur : redirection vers le
  /// login attendue après succès.
  Future<void> resetPassword({
    required String email,
    required String code,
    required String nouveauMotDePasse,
  }) async {
    await _dio.post(
      ApiEndpoints.resetPassword,
      data: {'email': email, 'code': code, 'nouveau_mot_de_passe': nouveauMotDePasse},
    );
  }

  /// Source de vérité pour restaurer/rafraîchir l'utilisateur courant.
  Future<User> getMe() async {
    final response = await _dio.get(ApiEndpoints.me);
    return User.fromJson(response.data as Map<String, dynamic>);
  }

  /// Seuls `prenom` et `nom` sont modifiables via cette route.
  Future<User> updateProfile({String? prenom, String? nom}) async {
    final response = await _dio.patch(
      ApiEndpoints.updateProfile,
      data: {
        'prenom': ?prenom,
        'nom': ?nom,
      },
    );
    return User.fromJson(response.data as Map<String, dynamic>);
  }

  /// L'API ne retourne pas de nouveau JWT après ce changement : le jeton
  /// courant reste valable jusqu'à expiration ou déconnexion locale.
  Future<void> changePassword({required String currentPassword, required String newPassword}) async {
    await _dio.post(
      ApiEndpoints.changePassword,
      data: {'currentPassword': currentPassword, 'newPassword': newPassword},
    );
  }
}
