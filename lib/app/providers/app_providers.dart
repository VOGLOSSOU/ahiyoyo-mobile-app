import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api/api_client.dart';
import '../../core/storage/local_cache.dart';
import '../../core/storage/secure_storage.dart';

/// Provider pour le stockage sécurisé des jetons
final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

/// Provider pour le cache local (TTL / stale-while-error)
final localCacheProvider = Provider<LocalCacheService>((ref) {
  return LocalCacheService();
});

/// Provider du client API unifié
final apiClientProvider = Provider<ApiClient>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return ApiClient(
    secureStorage: storage,
    onSessionExpired: () {
      // Pourra invalider l'état d'auth et rediriger vers le login
    },
  );
});

/// Provider de l'instance Dio configurée
final dioProvider = Provider<Dio>((ref) {
  return ref.watch(apiClientProvider).dio;
});

/// Placeholder de l'état de connexion en attendant le vrai contrôleur de
/// session du Lot 1 (Authentification). Toujours `false` pour l'instant :
/// à remplacer par un vrai AuthController basé sur le SecureStorageService.
final isAuthenticatedProvider = StateProvider<bool>((ref) => false);
