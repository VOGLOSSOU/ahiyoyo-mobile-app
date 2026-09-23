import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers/app_providers.dart';
import '../../data/parcels_repository.dart';
import '../../domain/colis_route_line.dart';

final parcelsRepositoryProvider = Provider<ParcelsRepository>((ref) {
  return ParcelsRepository(ref.watch(dioProvider));
});

/// Route publique : corridors et services disponibles pour le formulaire
/// classique d'enregistrement de colis.
final colisRoutesProvider = FutureProvider<ColisRoutesData>((ref) {
  return ref.watch(parcelsRepositoryProvider).getRoutesDisponibles();
});
