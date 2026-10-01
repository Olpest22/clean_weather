import 'package:clean_weather/features/weather/domain/entities/location.dart';
import 'package:clean_weather/features/weather/domain/entities/weather.dart';
import 'package:clean_weather/features/weather/domain/entities/weather_condition.dart';

const tLocation = Location(
  id: 524901,
  name: 'Москва',
  latitude: 55.75222,
  longitude: 37.61556,
  country: 'Россия',
  region: 'Москва',
  countryCode: 'RU',
);

final tWeather = Weather(
  current: CurrentWeather(
    time: DateTime(2026, 10, 1, 12, 15),
    temperature: 9.4,
    apparentTemperature: 6.8,
    humidity: 71,
    windSpeed: 3.2,
    condition: WeatherCondition.partlyCloudy,
    isDay: true,
  ),
  hourly: const [],
  daily: const [],
);

/// Ответ Forecast API: почасовые данные с 10:00 до 13:00, два дня прогноза.
const Map<String, dynamic> tForecastJson = {
  'current': {
    'time': '2026-10-01T12:15',
    'temperature_2m': 9.4,
    'relative_humidity_2m': 71,
    'apparent_temperature': 6.8,
    'is_day': 1,
    'weather_code': 2,
    'wind_speed_10m': 3.2,
  },
  'hourly': {
    'time': [
      '2026-10-01T10:00',
      '2026-10-01T11:00',
      '2026-10-01T12:00',
      '2026-10-01T13:00',
    ],
    'temperature_2m': [7.1, 8.0, 9.2, 10],
    'weather_code': [3, 3, 2, 61],
  },
  'daily': {
    'time': ['2026-10-01', '2026-10-02'],
    'weather_code': [2, 63],
    'temperature_2m_max': [11.5, 8.0],
    'temperature_2m_min': [4.2, 3.9],
    'precipitation_probability_max': [10, null],
  },
};
