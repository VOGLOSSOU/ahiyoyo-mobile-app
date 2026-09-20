import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Gestionnaire du stockage sécurisé des jetons et secrets.
/// Respecte strictement la règle de non-fallback en clair sur mobile natif.
class SecureStorageService {
  final FlutterSecureStorage _secureStorage;
  SharedPreferences? _webPrefs;

  SecureStorageService({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(resetOnError: true),
              iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
            );

  static const String _keyAccessToken = 'ahiyoyo_access_token';
  static const String _keyExpiresAt = 'ahiyoyo_expires_at';

  Future<void> _ensureWebPrefs() async {
    if (kIsWeb && _webPrefs == null) {
      _webPrefs = await SharedPreferences.getInstance();
    }
  }

  Future<void> write(String key, String value) async {
    if (kIsWeb) {
      await _ensureWebPrefs();
      await _webPrefs?.setString(key, value);
      return;
    }
    // Mobile natif : aucun fallback non chiffré
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    if (kIsWeb) {
      await _ensureWebPrefs();
      return _webPrefs?.getString(key);
    }
    // Mobile natif : lecture sécurisée uniquement
    return await _secureStorage.read(key: key);
  }

  Future<void> delete(String key) async {
    if (kIsWeb) {
      await _ensureWebPrefs();
      await _webPrefs?.remove(key);
      return;
    }
    await _secureStorage.delete(key: key);
  }

  // --- Helpers dédiés à la session d'authentification ---
  // L'API Ahiyoyo n'utilise ni cookie ni refresh token : un seul jeton,
  // avec une échéance (`expiresAt`) à respecter côté client.
  Future<void> saveSession({required String accessToken, required DateTime expiresAt}) async {
    await write(_keyAccessToken, accessToken);
    await write(_keyExpiresAt, expiresAt.toIso8601String());
  }

  Future<String?> getAccessToken() => read(_keyAccessToken);

  Future<DateTime?> getExpiresAt() async {
    final raw = await read(_keyExpiresAt);
    if (raw == null) return null;
    return DateTime.tryParse(raw);
  }

  Future<void> clearSession() async {
    await delete(_keyAccessToken);
    await delete(_keyExpiresAt);
  }
}
