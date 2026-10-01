part of 'weather_bloc.dart';

sealed class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object?> get props => [];
}

/// Запуск приложения: показать погоду в последнем выбранном городе.
final class WeatherStarted extends WeatherEvent {
  const WeatherStarted();
}

/// Пользователь выбрал город в поиске.
final class WeatherLocationSelected extends WeatherEvent {
  const WeatherLocationSelected(this.location);

  final Location location;

  @override
  List<Object?> get props => [location];
}

/// Обновить прогноз для текущего города (pull-to-refresh, «Повторить»).
final class WeatherRefreshRequested extends WeatherEvent {
  const WeatherRefreshRequested();
}
