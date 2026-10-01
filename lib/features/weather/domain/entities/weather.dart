import 'package:equatable/equatable.dart';

import 'weather_condition.dart';

/// Погода в выбранном городе: сейчас, по часам и по дням.
class Weather extends Equatable {
  const Weather({
    required this.current,
    required this.hourly,
    required this.daily,
  });

  final CurrentWeather current;
  final List<HourlyForecast> hourly;
  final List<DailyForecast> daily;

  @override
  List<Object?> get props => [current, hourly, daily];
}

class CurrentWeather extends Equatable {
  const CurrentWeather({
    required this.time,
    required this.temperature,
    required this.apparentTemperature,
    required this.humidity,
    required this.windSpeed,
    required this.condition,
    required this.isDay,
  });

  /// Время наблюдения по местному времени города.
  final DateTime time;
  final double temperature;
  final double apparentTemperature;

  /// Относительная влажность, %.
  final int humidity;

  /// Скорость ветра, м/с.
  final double windSpeed;
  final WeatherCondition condition;
  final bool isDay;

  @override
  List<Object?> get props => [
        time,
        temperature,
        apparentTemperature,
        humidity,
        windSpeed,
        condition,
        isDay,
      ];
}

class HourlyForecast extends Equatable {
  const HourlyForecast({
    required this.time,
    required this.temperature,
    required this.condition,
  });

  final DateTime time;
  final double temperature;
  final WeatherCondition condition;

  @override
  List<Object?> get props => [time, temperature, condition];
}

class DailyForecast extends Equatable {
  const DailyForecast({
    required this.date,
    required this.maxTemperature,
    required this.minTemperature,
    required this.condition,
    this.precipitationProbability,
  });

  final DateTime date;
  final double maxTemperature;
  final double minTemperature;
  final WeatherCondition condition;

  /// Максимальная вероятность осадков за день, % (может отсутствовать).
  final int? precipitationProbability;

  @override
  List<Object?> get props => [
        date,
        maxTemperature,
        minTemperature,
        condition,
        precipitationProbability,
      ];
}
