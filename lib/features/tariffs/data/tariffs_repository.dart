import 'package:dio/dio.dart';
import '../../../core/api/api_endpoints.dart';
import '../domain/tariff_line.dart';

class TariffsRepository {
  final Dio _dio;

  TariffsRepository(this._dio);

  /// Route publique, sans authentification. La réponse peut être un tableau
  /// brut ou un objet `{ data: [...] }` — les deux formes sont acceptées
  /// pour éviter un écran vide silencieux si le format venait à changer.
  Future<List<TariffLine>> getPublicTariffs() async {
    final response = await _dio.get(ApiEndpoints.tariffsPublic);
    final data = response.data;

    final List<dynamic> rawList;
    if (data is List) {
      rawList = data;
    } else if (data is Map<String, dynamic> && data['data'] is List) {
      rawList = data['data'] as List;
    } else {
      rawList = const [];
    }

    return rawList
        .whereType<Map<String, dynamic>>()
        .map(TariffLine.fromJson)
        .toList();
  }
}
