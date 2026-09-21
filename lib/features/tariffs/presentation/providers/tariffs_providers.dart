import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers/app_providers.dart';
import '../../data/tariffs_repository.dart';
import '../../domain/tariff_line.dart';

final tariffsRepositoryProvider = Provider<TariffsRepository>((ref) {
  return TariffsRepository(ref.watch(dioProvider));
});

/// Chargement unique (pas de pagination) des lignes tarifaires publiques.
final tariffsProvider = FutureProvider<List<TariffLine>>((ref) {
  return ref.watch(tariffsRepositoryProvider).getPublicTariffs();
});
