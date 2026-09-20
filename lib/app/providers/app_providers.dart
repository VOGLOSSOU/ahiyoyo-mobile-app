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
  return ApiClient(secureStorage: storage);
});

/// Provider de l'instance Dio configurée
final dioProvider = Provider<Dio>((ref) {
  return ref.watch(apiClientProvider).dio;
});
