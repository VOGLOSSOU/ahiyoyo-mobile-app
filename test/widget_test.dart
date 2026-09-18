import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ahiyoyo/app/providers/app_providers.dart';
import 'package:ahiyoyo/app/router/app_router.dart';
import 'package:ahiyoyo/app/router/app_routes.dart';
import 'package:ahiyoyo/core/storage/local_cache.dart';
import 'package:ahiyoyo/main.dart';

/// Implémentation en mémoire du cache, injectée via Riverpod overrides.
class _MemoryCache extends LocalCacheService {
  final Map<String, dynamic> _store = {};

  @override
  Future<dynamic> get(String key, {Duration? maxAge}) async {
    final entry = _store[key];
    if (entry == null) return null;
    if (entry is Map && entry.containsKey('timestamp') && maxAge != null) {
      final ts = entry['timestamp'] as int?;
      if (ts != null) {
        final age = DateTime.now().difference(
          DateTime.fromMillisecondsSinceEpoch(ts),
        );
        if (age > maxAge) return null;
      }
    }
    return entry is Map ? entry['data'] : entry;
  }

  @override
  Future<dynamic> getStale(String key) async {
    final entry = _store[key];
    return entry is Map ? entry['data'] : entry;
  }

  @override
  Future<void> save(String key, dynamic data) async {
    _store[key] = {
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'data': data,
    };
  }

  @override
  Future<void> remove(String key) async => _store.remove(key);

  @override
  Future<void> clearAll() async => _store.clear();
}

void main() {
  setUp(() {
    // Reset le router global à l'état initial (splash) avant chaque test.
    appRouter.go(AppRoutes.splash);
  });

  testWidgets(
    "Ahiyoyo onboarding test - Affiche l'onboarding si non complété",
    (WidgetTester tester) async {
      final cache = _MemoryCache();
      await cache.save('has_completed_onboarding', false);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [localCacheProvider.overrideWithValue(cache)],
          child: const AhiyoyoApp(),
        ),
      );

      // Le splash dure désormais ~6s (animation + préchargement des images
      // d'onboarding), il faut donc avancer le temps virtuel en conséquence.
      for (int i = 0; i < 24; i++) {
        await tester.pump(const Duration(milliseconds: 300));
      }
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.textContaining('commerce international'), findsOneWidget);
      expect(find.text('Passer'), findsOneWidget);
      expect(find.text('Suivant'), findsOneWidget);
    },
  );

  testWidgets(
    "Ahiyoyo smoke test - l'application démarre et affiche l'accueil",
    (WidgetTester tester) async {
      final cache = _MemoryCache();
      await cache.save('has_completed_onboarding', true);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [localCacheProvider.overrideWithValue(cache)],
          child: const AhiyoyoApp(),
        ),
      );

      for (int i = 0; i < 24; i++) {
        await tester.pump(const Duration(milliseconds: 300));
      }
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('AHIYOYO'), findsOneWidget);
      expect(find.text('Accueil'), findsOneWidget);
      expect(find.text('Mes colis'), findsOneWidget);
      expect(find.text('Commandes'), findsOneWidget);
    },
  );
}
