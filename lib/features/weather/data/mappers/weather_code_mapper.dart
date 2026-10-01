import '../../domain/entities/weather_condition.dart';

/// Переводит код погоды WMO из ответа Open-Meteo в [WeatherCondition].
/// Таблица кодов: https://open-meteo.com/en/docs (раздел «WMO Weather interpretation codes»).
WeatherCondition weatherConditionFromWmoCode(int? code) {
  return switch (code) {
    0 => WeatherCondition.clear,
    1 => WeatherCondition.mainlyClear,
    2 => WeatherCondition.partlyCloudy,
    3 => WeatherCondition.overcast,
    45 || 48 => WeatherCondition.fog,
    51 || 53 || 55 => WeatherCondition.drizzle,
    56 || 57 => WeatherCondition.freezingDrizzle,
    61 || 63 || 65 => WeatherCondition.rain,
    66 || 67 => WeatherCondition.freezingRain,
    71 || 73 || 75 => WeatherCondition.snow,
    77 => WeatherCondition.snowGrains,
    80 || 81 || 82 => WeatherCondition.rainShowers,
    85 || 86 => WeatherCondition.snowShowers,
    95 => WeatherCondition.thunderstorm,
    96 || 99 => WeatherCondition.thunderstormWithHail,
    _ => WeatherCondition.unknown,
  };
}
