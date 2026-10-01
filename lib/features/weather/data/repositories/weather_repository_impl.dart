import '../../../../core/result/guard_result.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/location.dart';
import '../../domain/entities/weather.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/weather_remote_data_source.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  WeatherRepositoryImpl(this._remoteDataSource);

  final WeatherRemoteDataSource _remoteDataSource;

  @override
  Future<Result<Weather>> getWeather(Location location) {
    return guardResult<Weather>(
      () => _remoteDataSource.getForecast(
        latitude: location.latitude,
        longitude: location.longitude,
      ),
    );
  }
}
