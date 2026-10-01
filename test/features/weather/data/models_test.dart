import 'package:clean_weather/features/weather/data/mappers/weather_code_mapper.dart';
import 'package:clean_weather/features/weather/data/models/location_model.dart';
import 'package:clean_weather/features/weather/data/models/weather_model.dart';
import 'package:clean_weather/features/weather/domain/entities/weather_condition.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fixtures.dart';

void main() {
  group('WeatherModel.fromJson', () {
    final weather = WeatherModel.fromJson(tForecastJson);

    test('парсит текущую погоду', () {
      expect(weather.current.temperature, 9.4);
      expect(weather.current.humidity, 71);
      expect(weather.current.isDay, isTrue);
      expect(weather.current.condition, WeatherCondition.partlyCloudy);
    });

    test('почасовой прогноз начинается с текущего часа', () {
      expect(weather.hourly.map((h) => h.time.hour), [12, 13]);
      expect(weather.hourly.last.temperature, 10.0);
      expect(weather.hourly.last.condition, WeatherCondition.rain);
    });

    test('парсит дневной прогноз и пустую вероятность осадков', () {
      expect(weather.daily, hasLength(2));
      expect(weather.daily.first.precipitationProbability, 10);
      expect(weather.daily.last.precipitationProbability, isNull);
    });
  });

  test('LocationModel: toJson и fromJson дают тот же город', () {
    final restored =
        LocationModel.fromJson(LocationModel.fromEntity(tLocation).toJson());
    // Equatable учитывает тип, поэтому сравниваем значения полей.
    expect(restored.props, tLocation.props);
  });

  test('неизвестный код погоды → unknown', () {
    expect(weatherConditionFromWmoCode(1234), WeatherCondition.unknown);
    expect(weatherConditionFromWmoCode(null), WeatherCondition.unknown);
  });
}
