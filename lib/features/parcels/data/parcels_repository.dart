import 'dart:convert';

import 'package:cross_file/cross_file.dart';
import 'package:dio/dio.dart';
import '../../../core/api/api_endpoints.dart';
import '../domain/colis_route_line.dart';
import '../domain/created_parcel.dart';

class ParcelsRepository {
  final Dio _dio;

  ParcelsRepository(this._dio);

  /// Route publique, sans authentification.
  Future<ColisRoutesData> getRoutesDisponibles() async {
    final response = await _dio.get(ApiEndpoints.colisRoutesDisponibles);
    return ColisRoutesData.fromJson(response.data as Map<String, dynamic>);
  }

  /// Création d'un colis. Format multipart : le JSON métier est placé dans
  /// le champ texte `payload`, les images/documents en parties séparées.
  /// [articleImages] associe un identifiant local d'article à son image
  /// (nommé `images[<id>]` comme demandé par le contrat).
  Future<CreatedParcel> createParcel({
    required Map<String, dynamic> payload,
    Map<String, XFile> articleImages = const {},
    XFile? articlesFile,
  }) async {
    final formData = FormData();
    formData.fields.add(MapEntry('payload', jsonEncode(payload)));

    for (final entry in articleImages.entries) {
      final bytes = await entry.value.readAsBytes();
      formData.files.add(
        MapEntry(
          'images[${entry.key}]',
          MultipartFile.fromBytes(bytes, filename: entry.value.name),
        ),
      );
    }

    if (articlesFile != null) {
      final bytes = await articlesFile.readAsBytes();
      formData.files.add(
        MapEntry('articlesFile', MultipartFile.fromBytes(bytes, filename: articlesFile.name)),
      );
    }

    final response = await _dio.post(ApiEndpoints.colis, data: formData);
    return CreatedParcel.fromJson(response.data as Map<String, dynamic>);
  }
}
