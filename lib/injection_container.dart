import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/dio_client.dart';
import 'features/weather/data/datasources/geocoding_remote_data_source.dart';
import 'features/weather/data/datasources/location_local_data_source.dart';
import 'features/weather/data/datasources/weather_remote_data_source.dart';
import 'features/weather/data/repositories/location_repository_impl.dart';
import 'features/weather/data/repositories/weather_repository_impl.dart';
import 'features/weather/domain/repositories/location_repository.dart';
import 'features/weather/domain/repositories/weather_repository.dart';
import 'features/weather/domain/usecases/get_last_location.dart';
import 'features/weather/domain/usecases/get_weather.dart';
import 'features/weather/domain/usecases/save_last_location.dart';
import 'features/weather/domain/usecases/search_locations.dart';
import 'features/weather/presentation/bloc/city_search/city_search_bloc.dart';
import 'features/weather/presentation/bloc/weather/weather_bloc.dart';

/// Service locator — единственное место, где собираются все зависимости.
/// Слои получают зависимости через конструкторы и не создают их сами.
final sl = GetIt.instance;

Future<void> initDependencies() async {
  final preferences = await SharedPreferences.getInstance();

  sl
    // Внешние зависимости
    ..registerLazySingleton<SharedPreferences>(() => preferences)
    ..registerLazySingleton<Dio>(createDio)

    // Data: источники данных
    ..registerLazySingleton<WeatherRemoteDataSource>(
      () => WeatherRemoteDataSourceImpl(sl()),
    )
    ..registerLazySingleton<GeocodingRemoteDataSource>(
      () => GeocodingRemoteDataSourceImpl(sl()),
    )
    ..registerLazySingleton<LocationLocalDataSource>(
      () => LocationLocalDataSourceImpl(sl()),
    )

    // Data: реализации репозиториев регистрируются под интерфейсами domain
    ..registerLazySingleton<WeatherRepository>(
      () => WeatherRepositoryImpl(sl()),
    )
    ..registerLazySingleton<LocationRepository>(
      () => LocationRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
      ),
    )

    // Domain: use case'ы
    ..registerLazySingleton(() => GetWeather(sl()))
    ..registerLazySingleton(() => SearchLocations(sl()))
    ..registerLazySingleton(() => GetLastLocation(sl()))
    ..registerLazySingleton(() => SaveLastLocation(sl()))

    // Presentation: BLoC создаётся заново для каждого экрана (factory)
    ..registerFactory(
      () => WeatherBloc(
        getWeather: sl(),
        getLastLocation: sl(),
        saveLastLocation: sl(),
      ),
    )
    ..registerFactory(() => CitySearchBloc(searchLocations: sl()));
}
