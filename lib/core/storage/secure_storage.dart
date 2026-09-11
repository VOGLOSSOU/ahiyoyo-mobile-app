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
  static const String _keyRefreshToken = 'ahiyoyo_refresh_token';
  static const String _keyUserId = 'ahiyoyo_user_id';

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

  Future<void> deleteAll() async {
    if (kIsWeb) {
      await _ensureWebPrefs();
      await _webPrefs?.remove(_keyAccessToken);
      await _webPrefs?.remove(_keyRefreshToken);
      await _webPrefs?.remove(_keyUserId);
      return;
    }
    await _secureStorage.deleteAll();
  }

  // --- Helpers dédiés aux Tokens ---
  Future<void> saveTokens({required String accessToken, String? refreshToken}) async {
    await write(_keyAccessToken, accessToken);
    if (refreshToken != null) {
      await write(_keyRefreshToken, refreshToken);
    }
  }

  Future<String?> getAccessToken() => read(_keyAccessToken);

  Future<String?> getRefreshToken() => read(_keyRefreshToken);

  Future<void> saveUserId(String id) => write(_keyUserId, id);

  Future<String?> getUserId() => read(_keyUserId);

  Future<void> clearSession() async {
    await delete(_keyAccessToken);
    await delete(_keyRefreshToken);
    await delete(_keyUserId);
  }
}
