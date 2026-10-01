part of 'weather_bloc.dart';

enum WeatherStatus {
  /// Город ещё не выбран.
  initial,
  loading,
  success,
  failure,
}

/// Одно состояние со статусом (а не набор отдельных классов): при обновлении
/// и при ошибке обновления нужно продолжать показывать прежний прогноз.
final class WeatherState extends Equatable {
  const WeatherState({
    this.status = WeatherStatus.initial,
    this.location,
    this.weather,
    this.errorMessage,
  });

  final WeatherStatus status;
  final Location? location;
  final Weather? weather;
  final String? errorMessage;

  /// Идёт обновление, а на экране уже есть прогноз.
  bool get isRefreshing => status == WeatherStatus.loading && weather != null;

  @override
  List<Object?> get props => [status, location, weather, errorMessage];
}
