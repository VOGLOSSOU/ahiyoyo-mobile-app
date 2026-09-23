import 'package:dio/dio.dart';
import '../../../core/api/api_endpoints.dart';
import '../domain/tracking_result.dart';

class TrackingRepository {
  final Dio _dio;

  TrackingRepository(this._dio);

  /// Route publique, sans authentification. `q` est le seul paramètre
  /// accepté (numéro Ahiyoyo, numéro transporteur ou référence de commande).
  Future<TrackingResult> search(String query) async {
    final response = await _dio.get(
      ApiEndpoints.track,
      queryParameters: {'q': query},
    );
    return TrackingResult.fromJson(response.data as Map<String, dynamic>);
  }
}
