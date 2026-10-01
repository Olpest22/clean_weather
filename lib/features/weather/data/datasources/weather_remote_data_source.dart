import 'package:dio/dio.dart';

import '../../../../core/network/dio_client.dart';
import '../models/weather_model.dart';

/// Источник данных: прогноз погоды через Forecast API Open-Meteo.
abstract interface class WeatherRemoteDataSource {
  /// Бросает NetworkException или ServerException.
  Future<WeatherModel> getForecast({
    required double latitude,
    required double longitude,
  });
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  WeatherRemoteDataSourceImpl(this._dio);

  static const _forecastUrl = 'https://api.open-meteo.com/v1/forecast';

  final Dio _dio;

  @override
  Future<WeatherModel> getForecast({
    required double latitude,
    required double longitude,
  }) async {
    final json = await _dio.getJson(
      _forecastUrl,
      queryParameters: {
        'latitude': latitude,
        'longitude': longitude,
        // Запрашиваем только нужные поля, чтобы ответ был компактным.
        'current': 'temperature_2m,relative_humidity_2m,apparent_temperature,'
            'is_day,weather_code,wind_speed_10m',
        'hourly': 'temperature_2m,weather_code',
        'daily': 'weather_code,temperature_2m_max,temperature_2m_min,'
            'precipitation_probability_max',
        'timezone': 'auto',
        'forecast_days': 7,
        'wind_speed_unit': 'ms',
      },
    );
    return parseJsonOrThrow(() => WeatherModel.fromJson(json));
  }
}
