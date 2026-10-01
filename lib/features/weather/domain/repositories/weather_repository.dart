import '../../../../core/result/result.dart';
import '../entities/location.dart';
import '../entities/weather.dart';

/// Контракт получения прогноза. Domain определяет интерфейс,
/// а слой data предоставляет реализацию (принцип инверсии зависимостей).
abstract interface class WeatherRepository {
  Future<Result<Weather>> getWeather(Location location);
}
