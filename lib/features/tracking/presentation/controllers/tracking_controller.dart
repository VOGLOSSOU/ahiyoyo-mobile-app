import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers/app_providers.dart';
import '../../../../core/errors/app_exception.dart';
import '../../data/tracking_repository.dart';
import '../../domain/tracking_result.dart';

final trackingRepositoryProvider = Provider<TrackingRepository>((ref) {
  return TrackingRepository(ref.watch(dioProvider));
});

sealed class TrackingSearchState {
  const TrackingSearchState();
}

class TrackingIdle extends TrackingSearchState {
  const TrackingIdle();
}

class TrackingLoading extends TrackingSearchState {
  const TrackingLoading();
}

/// Résultat fonctionnel "introuvable" (404) : ce n'est pas une panne.
class TrackingNotFound extends TrackingSearchState {
  const TrackingNotFound();
}

class TrackingError extends TrackingSearchState {
  final String message;
  const TrackingError(this.message);
}

class TrackingSuccess extends TrackingSearchState {
  final TrackingResult result;
  const TrackingSuccess(this.result);
}

class TrackingController extends StateNotifier<TrackingSearchState> {
  final TrackingRepository _repository;
  int _requestId = 0;

  TrackingController(this._repository) : super(const TrackingIdle());

  Future<void> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;

    final requestId = ++_requestId;
    state = const TrackingLoading();

    try {
      final result = await _repository.search(trimmed);
      if (requestId != _requestId) return; // une recherche plus récente a été lancée entretemps
      state = TrackingSuccess(result);
    } on AppException catch (e) {
      if (requestId != _requestId) return;
      state = e.statusCode == 404 ? const TrackingNotFound() : TrackingError(e.message);
    } catch (_) {
      if (requestId != _requestId) return;
      state = const TrackingError('Une erreur inattendue est survenue.');
    }
  }

  void reset() {
    _requestId++;
    state = const TrackingIdle();
  }
}

final trackingControllerProvider =
    StateNotifierProvider.autoDispose<TrackingController, TrackingSearchState>((ref) {
  return TrackingController(ref.watch(trackingRepositoryProvider));
});
