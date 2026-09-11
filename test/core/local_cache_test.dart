import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ahiyoyo/core/storage/local_cache.dart';

void main() {
  group('LocalCacheService', () {
    late LocalCacheService cache;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      cache = LocalCacheService();
    });

    test('sauvegarde et récupère une donnée valide', () async {
      await cache.save('test_key', {'name': 'Ahiyoyo', 'version': 2});
      final data = await cache.get('test_key', maxAge: const Duration(minutes: 5));

      expect(data, isNotNull);
      expect(data['name'], 'Ahiyoyo');
      expect(data['version'], 2);
    });

    test('retourne null si la donnée est expirée avec maxAge', () async {
      await cache.save('expired_key', {'status': 'old'});
      // Durée négative pour simuler l'expiration immédiate
      final data = await cache.get('expired_key', maxAge: const Duration(milliseconds: -1));

      expect(data, isNull);
    });

    test('getStale retourne la donnée même si expirée (stale-while-error)', () async {
      await cache.save('stale_key', {'status': 'stale_data'});
      final staleData = await cache.getStale('stale_key');

      expect(staleData, isNotNull);
      expect(staleData['status'], 'stale_data');
    });

    test('supprime une entrée avec succès', () async {
      await cache.save('to_delete', 123);
      await cache.remove('to_delete');
      final data = await cache.get('to_delete');

      expect(data, isNull);
    });
  });
}
