import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/result/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../../domain/entities/location.dart';
import '../../../domain/entities/weather.dart';
import '../../../domain/usecases/get_last_location.dart';
import '../../../domain/usecases/get_weather.dart';
import '../../../domain/usecases/save_last_location.dart';

part 'weather_event.dart';
part 'weather_state.dart';

/// BLoC главного экрана. Зависит только от use case'ов (domain),
/// ничего не знает о Dio, JSON и shared_preferences.
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc({
    required GetWeather getWeather,
    required GetLastLocation getLastLocation,
    required SaveLastLocation saveLastLocation,
  })  : _getWeather = getWeather,
        _getLastLocation = getLastLocation,
        _saveLastLocation = saveLastLocation,
        super(const WeatherState()) {
    on<WeatherStarted>(_onStarted, transformer: droppable());
    // restartable: если пользователь быстро выбрал другой город,
    // обработка предыдущего выбора отменяется.
    on<WeatherLocationSelected>(
      _onLocationSelected,
      transformer: restartable(),
    );
    // droppable: повторные нажатия «обновить» во время загрузки игнорируются.
    on<WeatherRefreshRequested>(
      _onRefreshRequested,
      transformer: droppable(),
    );
  }

  final GetWeather _getWeather;
  final GetLastLocation _getLastLocation;
  final SaveLastLocation _saveLastLocation;

  Future<void> _onStarted(
    WeatherStarted event,
    Emitter<WeatherState> emit,
  ) async {
    emit(const WeatherState(status: WeatherStatus.loading));

    final result = await _getLastLocation(const NoParams());
    // Ошибка чтения кэша не критична: просто предлагаем выбрать город.
    final savedLocation = switch (result) {
      Success(:final data) => data,
      Failed() => null,
    };

    if (savedLocation == null) {
      emit(const WeatherState());
      return;
    }
    await _loadWeather(savedLocation, emit);
  }

  Future<void> _onLocationSelected(
    WeatherLocationSelected event,
    Emitter<WeatherState> emit,
  ) async {
    emit(WeatherState(status: WeatherStatus.loading, location: event.location));
    // Запоминаем город для следующего запуска. Если сохранить не удалось,
    // прогноз всё равно показываем.
    await _saveLastLocation(event.location);
    await _loadWeather(event.location, emit);
  }

  Future<void> _onRefreshRequested(
    WeatherRefreshRequested event,
    Emitter<WeatherState> emit,
  ) async {
    final location = state.location;
    if (location == null) return;

    // Старый прогноз остаётся на экране, пока грузится новый.
    emit(WeatherState(
      status: WeatherStatus.loading,
      location: location,
      weather: state.weather,
    ));
    await _loadWeather(location, emit);
  }

  Future<void> _loadWeather(
    Location location,
    Emitter<WeatherState> emit,
  ) async {
    final result = await _getWeather(location);

    switch (result) {
      case Success(:final data):
        emit(WeatherState(
          status: WeatherStatus.success,
          location: location,
          weather: data,
        ));
      case Failed(:final failure):
        emit(WeatherState(
          status: WeatherStatus.failure,
          location: location,
          weather: state.weather,
          errorMessage: failure.message,
        ));
    }
  }
}
