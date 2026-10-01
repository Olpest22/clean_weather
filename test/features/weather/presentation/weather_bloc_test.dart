import 'package:bloc_test/bloc_test.dart';
import 'package:clean_weather/core/error/failures.dart';
import 'package:clean_weather/core/result/result.dart';
import 'package:clean_weather/core/usecase/usecase.dart';
import 'package:clean_weather/features/weather/domain/entities/location.dart';
import 'package:clean_weather/features/weather/domain/usecases/get_last_location.dart';
import 'package:clean_weather/features/weather/domain/usecases/get_weather.dart';
import 'package:clean_weather/features/weather/domain/usecases/save_last_location.dart';
import 'package:clean_weather/features/weather/presentation/bloc/weather/weather_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../fixtures.dart';

class MockGetWeather extends Mock implements GetWeather {}

class MockGetLastLocation extends Mock implements GetLastLocation {}

class MockSaveLastLocation extends Mock implements SaveLastLocation {}

void main() {
  late MockGetWeather getWeather;
  late MockGetLastLocation getLastLocation;
  late MockSaveLastLocation saveLastLocation;

  setUp(() {
    getWeather = MockGetWeather();
    getLastLocation = MockGetLastLocation();
    saveLastLocation = MockSaveLastLocation();
    when(() => saveLastLocation(tLocation))
        .thenAnswer((_) async => const Success<void>(null));
  });

  WeatherBloc buildBloc() => WeatherBloc(
        getWeather: getWeather,
        getLastLocation: getLastLocation,
        saveLastLocation: saveLastLocation,
      );

  test('начальное состояние — город не выбран', () {
    expect(buildBloc().state, const WeatherState());
  });

  blocTest<WeatherBloc, WeatherState>(
    'при запуске без сохранённого города возвращается в initial',
    setUp: () => when(() => getLastLocation(const NoParams()))
        .thenAnswer((_) async => const Success<Location?>(null)),
    build: buildBloc,
    act: (bloc) => bloc.add(const WeatherStarted()),
    expect: () => const [
      WeatherState(status: WeatherStatus.loading),
      WeatherState(),
    ],
  );

  blocTest<WeatherBloc, WeatherState>(
    'при запуске загружает погоду в сохранённом городе',
    setUp: () {
      when(() => getLastLocation(const NoParams()))
          .thenAnswer((_) async => const Success<Location?>(tLocation));
      when(() => getWeather(tLocation))
          .thenAnswer((_) async => Success(tWeather));
    },
    build: buildBloc,
    act: (bloc) => bloc.add(const WeatherStarted()),
    expect: () => [
      const WeatherState(status: WeatherStatus.loading),
      WeatherState(
        status: WeatherStatus.success,
        location: tLocation,
        weather: tWeather,
      ),
    ],
  );

  blocTest<WeatherBloc, WeatherState>(
    'при выборе города сохраняет его и загружает погоду',
    setUp: () => when(() => getWeather(tLocation))
        .thenAnswer((_) async => Success(tWeather)),
    build: buildBloc,
    act: (bloc) => bloc.add(const WeatherLocationSelected(tLocation)),
    expect: () => [
      const WeatherState(status: WeatherStatus.loading, location: tLocation),
      WeatherState(
        status: WeatherStatus.success,
        location: tLocation,
        weather: tWeather,
      ),
    ],
    verify: (_) => verify(() => saveLastLocation(tLocation)).called(1),
  );

  blocTest<WeatherBloc, WeatherState>(
    'ошибка загрузки переводит в failure с сообщением',
    setUp: () => when(() => getWeather(tLocation)).thenAnswer(
      (_) async => const Failed(NetworkFailure('Нет сети')),
    ),
    build: buildBloc,
    act: (bloc) => bloc.add(const WeatherLocationSelected(tLocation)),
    expect: () => const [
      WeatherState(status: WeatherStatus.loading, location: tLocation),
      WeatherState(
        status: WeatherStatus.failure,
        location: tLocation,
        errorMessage: 'Нет сети',
      ),
    ],
  );

  blocTest<WeatherBloc, WeatherState>(
    'при ошибке обновления прежний прогноз остаётся на экране',
    setUp: () => when(() => getWeather(tLocation)).thenAnswer(
      (_) async => const Failed(ServerFailure('Ошибка сервера')),
    ),
    build: buildBloc,
    seed: () => WeatherState(
      status: WeatherStatus.success,
      location: tLocation,
      weather: tWeather,
    ),
    act: (bloc) => bloc.add(const WeatherRefreshRequested()),
    expect: () => [
      WeatherState(
        status: WeatherStatus.loading,
        location: tLocation,
        weather: tWeather,
      ),
      WeatherState(
        status: WeatherStatus.failure,
        location: tLocation,
        weather: tWeather,
        errorMessage: 'Ошибка сервера',
      ),
    ],
  );
}
