import 'package:dio/dio.dart';

import '../../../../core/network/dio_client.dart';
import '../models/location_model.dart';

/// Источник данных: поиск городов через Geocoding API Open-Meteo.
abstract interface class GeocodingRemoteDataSource {
  /// Бросает NetworkException или ServerException.
  Future<List<LocationModel>> searchLocations(String query);
}

class GeocodingRemoteDataSourceImpl implements GeocodingRemoteDataSource {
  GeocodingRemoteDataSourceImpl(this._dio);

  static const _searchUrl = 'https://geocoding-api.open-meteo.com/v1/search';

  final Dio _dio;

  @override
  Future<List<LocationModel>> searchLocations(String query) async {
    final json = await _dio.getJson(
      _searchUrl,
      queryParameters: {
        'name': query,
        'count': 10,
        'language': 'ru',
        'format': 'json',
      },
    );

    return parseJsonOrThrow(() {
      // Если ничего не найдено, поля results в ответе нет.
      final results = json['results'] as List<dynamic>? ?? const [];
      return results
          .map((item) => LocationModel.fromJson(item as Map<String, dynamic>))
          .toList(growable: false);
    });
  }
}
