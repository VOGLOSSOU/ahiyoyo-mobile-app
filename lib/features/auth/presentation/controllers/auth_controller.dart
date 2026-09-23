import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers/app_providers.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../data/auth_repository.dart';
import '../../domain/auth_session.dart';
import '../../domain/user.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(dioProvider));
});

/// État de session : `user == null` signifie "non connecté". `isInitializing`
/// couvre la restauration de session au démarrage (lecture du stockage sécurisé
/// puis confirmation via `GET /api/me`).
class AuthState {
  final bool isInitializing;
  final User? user;

  const AuthState({this.isInitializing = true, this.user});

  bool get isAuthenticated => user != null;

  AuthState copyWith({bool? isInitializing, User? user, bool clearUser = false}) {
    return AuthState(
      isInitializing: isInitializing ?? this.isInitializing,
      user: clearUser ? null : (user ?? this.user),
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  final SecureStorageService _secureStorage;

  AuthController(this._repository, this._secureStorage) : super(const AuthState()) {
    _restoreSession();
  }

  /// Étape de démarrage de l'app : vérifie l'expiration locale d'abord, puis
  /// confirme via `GET /api/me`. Une erreur réseau ne doit jamais être
  /// confondue avec une session expirée (on garde la session locale).
  Future<void> _restoreSession() async {
    final token = await _secureStorage.getAccessToken();
    final expiresAt = await _secureStorage.getExpiresAt();

    if (token == null || token.isEmpty || expiresAt == null) {
      state = state.copyWith(isInitializing: false);
      return;
    }

    if (DateTime.now().isAfter(expiresAt)) {
      await _secureStorage.clearSession();
      state = state.copyWith(isInitializing: false);
      return;
    }

    try {
      final user = await _repository.getMe();
      state = AuthState(isInitializing: false, user: user);
    } on AppException catch (e) {
      if (e.statusCode == 401) {
        await _secureStorage.clearSession();
        state = const AuthState(isInitializing: false, user: null);
      } else {
        // Panne réseau/serveur temporaire : on ne déconnecte pas l'utilisateur.
        state = state.copyWith(isInitializing: false);
      }
    } catch (_) {
      state = state.copyWith(isInitializing: false);
    }
  }

  Future<void> onAuthenticated(AuthSession session) async {
    await _secureStorage.saveSession(accessToken: session.token, expiresAt: session.expiresAt);
    state = AuthState(isInitializing: false, user: session.user);
  }

  Future<User> refreshProfile() async {
    final user = await _repository.getMe();
    state = state.copyWith(user: user);
    return user;
  }

  /// `PATCH /api/me/profile` retourne déjà le profil actualisé : inutile de
  /// refaire un `GET /api/me` derrière.
  Future<User> updateProfile({String? prenom, String? nom}) async {
    final user = await _repository.updateProfile(prenom: prenom, nom: nom);
    state = state.copyWith(user: user);
    return user;
  }

  Future<void> logout() async {
    await _secureStorage.clearSession();
    state = const AuthState(isInitializing: false, user: null);
  }

  /// Appelé par l'`AuthInterceptor` (via [ApiClient.setOnSessionExpired])
  /// sur un vrai 401 : la session locale est déjà nettoyée par
  /// l'intercepteur, on aligne juste l'état en mémoire.
  void handleSessionExpired() {
    state = state.copyWith(isInitializing: false, clearUser: true);
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  final apiClient = ref.watch(apiClientProvider);

  final controller = AuthController(repository, secureStorage);
  apiClient.setOnSessionExpired(controller.handleSessionExpired);
  return controller;
});

/// Dérivé pratique pour les écrans qui n'ont besoin que du booléen.
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authControllerProvider).isAuthenticated;
});
