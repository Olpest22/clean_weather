import '../../domain/entities/weather.dart';
import '../mappers/weather_code_mapper.dart';

/// Модель ответа Forecast API Open-Meteo.
///
/// Почасовые и дневные данные приходят «столбцами» — параллельными
/// массивами (`time`, `temperature_2m`, ...), поэтому собираем объекты
/// по индексу.
class WeatherModel extends Weather {
  const WeatherModel({
    required super.current,
    required super.hourly,
    required super.daily,
  });

  /// Сколько часов почасового прогноза показывать.
  static const hourlyForecastLength = 24;

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final current = _parseCurrent(json['current'] as Map<String, dynamic>);
    return WeatherModel(
      current: current,
      hourly: _parseHourly(
        json['hourly'] as Map<String, dynamic>,
        startingFrom: current.time,
      ),
      daily: _parseDaily(json['daily'] as Map<String, dynamic>),
    );
  }

  static CurrentWeather _parseCurrent(Map<String, dynamic> json) {
    return CurrentWeather(
      // timezone=auto: время приходит уже в часовом поясе города.
      time: DateTime.parse(json['time'] as String),
      temperature: (json['temperature_2m'] as num).toDouble(),
      apparentTemperature: (json['apparent_temperature'] as num).toDouble(),
      humidity: (json['relative_humidity_2m'] as num).round(),
      windSpeed: (json['wind_speed_10m'] as num).toDouble(),
      condition: weatherConditionFromWmoCode(
        (json['weather_code'] as num?)?.toInt(),
      ),
      isDay: json['is_day'] == 1,
    );
  }

  /// API отдаёт почасовой прогноз на всю неделю, начиная с полуночи.
  /// Берём только ближайшие [hourlyForecastLength] часов, начиная с текущего.
  static List<HourlyForecast> _parseHourly(
    Map<String, dynamic> json, {
    required DateTime startingFrom,
  }) {
    final times = json['time'] as List<dynamic>;
    final temperatures = json['temperature_2m'] as List<dynamic>;
    final codes = json['weather_code'] as List<dynamic>;
    final currentHour = DateTime(
      startingFrom.year,
      startingFrom.month,
      startingFrom.day,
      startingFrom.hour,
    );

    final forecast = <HourlyForecast>[];
    for (var i = 0;
        i < times.length && forecast.length < hourlyForecastLength;
        i++) {
      final time = DateTime.parse(times[i] as String);
      if (time.isBefore(currentHour)) continue;

      forecast.add(HourlyForecast(
        time: time,
        temperature: (temperatures[i] as num).toDouble(),
        condition: weatherConditionFromWmoCode((codes[i] as num?)?.toInt()),
      ));
    }
    return forecast;
  }

  static List<DailyForecast> _parseDaily(Map<String, dynamic> json) {
    final dates = json['time'] as List<dynamic>;
    final maxTemperatures = json['temperature_2m_max'] as List<dynamic>;
    final minTemperatures = json['temperature_2m_min'] as List<dynamic>;
    final codes = json['weather_code'] as List<dynamic>;
    final precipitation =
        json['precipitation_probability_max'] as List<dynamic>?;

    return List.generate(
      dates.length,
      (i) => DailyForecast(
        date: DateTime.parse(dates[i] as String),
        maxTemperature: (maxTemperatures[i] as num).toDouble(),
        minTemperature: (minTemperatures[i] as num).toDouble(),
        condition: weatherConditionFromWmoCode((codes[i] as num?)?.toInt()),
        precipitationProbability: (precipitation?[i] as num?)?.round(),
      ),
      growable: false,
    );
  }
}
