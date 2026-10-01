import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/location.dart';
import '../entities/weather.dart';
import '../repositories/weather_repository.dart';

/// Получить погоду для города.
class GetWeather implements UseCase<Weather, Location> {
  const GetWeather(this._repository);

  final WeatherRepository _repository;

  @override
  Future<Result<Weather>> call(Location location) {
    return _repository.getWeather(location);
  }
}
