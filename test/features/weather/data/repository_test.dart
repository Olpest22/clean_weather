import 'package:clean_weather/core/error/exceptions.dart';
import 'package:clean_weather/core/error/failures.dart';
import 'package:clean_weather/core/result/result.dart';
import 'package:clean_weather/features/weather/data/datasources/weather_remote_data_source.dart';
import 'package:clean_weather/features/weather/data/models/weather_model.dart';
import 'package:clean_weather/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:clean_weather/features/weather/domain/entities/weather.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../fixtures.dart';

class MockWeatherRemoteDataSource extends Mock
    implements WeatherRemoteDataSource {}

void main() {
  late MockWeatherRemoteDataSource remoteDataSource;
  late WeatherRepositoryImpl repository;

  setUp(() {
    remoteDataSource = MockWeatherRemoteDataSource();
    repository = WeatherRepositoryImpl(remoteDataSource);
  });

When<Future<WeatherModel>> stubForecast() => when(
        () => remoteDataSource.getForecast(
          latitude: tLocation.latitude,
          longitude: tLocation.longitude,
        ),
      );

  test('возвращает Success с данными из источника', () async {
    final model = WeatherModel.fromJson(tForecastJson);
    stubForecast().thenAnswer((_) async => model);

    final result = await repository.getWeather(tLocation);

    expect(result, isA<Success<Weather>>());
    expect((result as Success<Weather>).data, model);
  });

  test('NetworkException превращается в NetworkFailure', () async {
    stubForecast().thenThrow(const NetworkException('Нет сети'));

    final result = await repository.getWeather(tLocation);

    expect(
      result,
      isA<Failed<Weather>>().having(
        (r) => r.failure,
        'failure',
        const NetworkFailure('Нет сети'),
      ),
    );
  });

  test('ServerException превращается в ServerFailure', () async {
    stubForecast().thenThrow(const ServerException('Ошибка 500'));

    final result = await repository.getWeather(tLocation);

    expect((result as Failed<Weather>).failure, isA<ServerFailure>());
  });
}
