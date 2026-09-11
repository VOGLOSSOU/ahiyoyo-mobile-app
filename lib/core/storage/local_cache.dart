import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Service de cache local avec support du pattern `stale-while-error`.
/// Permet de stocker des réponses JSON avec timestamp et durée de validité (TTL).
class LocalCacheService {
  SharedPreferences? _prefs;

  Future<SharedPreferences> get _instance async {
    return _prefs ??= await SharedPreferences.getInstance();
  }

  static const String _prefix = 'ahiyoyo_cache_';

  /// Sauvegarde une donnée avec le timestamp actuel
  Future<void> save(String key, dynamic data) async {
    final prefs = await _instance;
    final payload = {
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'data': data,
    };
    await prefs.setString('$_prefix$key', jsonEncode(payload));
  }

  /// Récupère la donnée en cache si elle n'est pas expirée (selon [maxAge])
  Future<dynamic> get(String key, {Duration? maxAge}) async {
    final prefs = await _instance;
    final raw = prefs.getString('$_prefix$key');
    if (raw == null) return null;

    try {
      final Map<String, dynamic> decoded = jsonDecode(raw);
      final timestamp = decoded['timestamp'] as int?;
      if (timestamp == null) return null;

      if (maxAge != null) {
        final age = DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(timestamp));
        if (age > maxAge) {
          return null; // Expiré
        }
      }

      return decoded['data'];
    } catch (_) {
      return null;
    }
  }

  /// Récupère la donnée en cache même si elle est expirée (pour stale-while-error)
  Future<dynamic> getStale(String key) async {
    final prefs = await _instance;
    final raw = prefs.getString('$_prefix$key');
    if (raw == null) return null;

    try {
      final Map<String, dynamic> decoded = jsonDecode(raw);
      return decoded['data'];
    } catch (_) {
      return null;
    }
  }

  /// Supprime une entrée du cache
  Future<void> remove(String key) async {
    final prefs = await _instance;
    await prefs.remove('$_prefix$key');
  }

  /// Vide l'intégralité du cache applicatif
  Future<void> clearAll() async {
    final prefs = await _instance;
    final keys = prefs.getKeys().where((k) => k.startsWith(_prefix));
    for (final key in keys) {
      await prefs.remove(key);
    }
  }
}
