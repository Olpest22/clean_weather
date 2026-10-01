import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../../domain/entities/location.dart';
import '../bloc/city_search/city_search_bloc.dart';
import '../bloc/weather/weather_bloc.dart';
import '../widgets/status_message.dart';
import '../widgets/weather_view.dart';
import 'city_search_page.dart';

/// Главный экран: прогноз погоды в выбранном городе.
class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  /// Открывает поиск. Выбранный город возвращается через Navigator.pop
  /// и передаётся в WeatherBloc событием.
  Future<void> _openCitySearch(BuildContext context) async {
    final weatherBloc = context.read<WeatherBloc>();
    final selectedLocation = await Navigator.of(context).push<Location>(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => sl<CitySearchBloc>(),
          child: const CitySearchPage(),
        ),
      ),
    );
    if (selectedLocation != null) {
      weatherBloc.add(WeatherLocationSelected(selectedLocation));
    }
  }

  /// Для RefreshIndicator: Future завершается, когда BLoC закончил загрузку,
  /// поэтому индикатор крутится ровно столько, сколько идёт запрос.
  Future<void> _refresh(BuildContext context) async {
    final weatherBloc = context.read<WeatherBloc>()
      ..add(const WeatherRefreshRequested());
    await weatherBloc.stream.firstWhere(
      (state) => state.status != WeatherStatus.loading,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Погода'),
        actions: [
          IconButton(
            tooltip: 'Найти город',
            icon: const Icon(Icons.search),
            onPressed: () => _openCitySearch(context),
          ),
        ],
      ),
      body: BlocConsumer<WeatherBloc, WeatherState>(
        // Если обновление не удалось, а прогноз уже есть на экране,
        // показываем ошибку во всплывающем сообщении, не убирая данные.
        listenWhen: (previous, current) =>
            current.status == WeatherStatus.failure && current.weather != null,
        listener: (context, state) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text('Не удалось обновить: ${state.errorMessage}')),
            );
        },
        builder: (context, state) {
          final weather = state.weather;
          final location = state.location;
          if (weather != null && location != null) {
            return WeatherView(
              location: location,
              weather: weather,
              isRefreshing: state.isRefreshing,
              onRefresh: () => _refresh(context),
            );
          }

          return switch (state.status) {
            WeatherStatus.loading =>
              const Center(child: CircularProgressIndicator()),
            WeatherStatus.failure => StatusMessage(
                emoji: '⚠️',
                title: 'Не удалось загрузить прогноз',
                message: state.errorMessage ?? 'Попробуйте ещё раз.',
                actionLabel: 'Повторить',
                onAction: () => context
                    .read<WeatherBloc>()
                    .add(const WeatherRefreshRequested()),
              ),
            WeatherStatus.initial || WeatherStatus.success => StatusMessage(
                emoji: '🌍',
                title: 'Выберите город',
                message:
                    'Найдите город, чтобы увидеть погоду сейчас, по часам и на неделю.',
                actionLabel: 'Найти город',
                actionIcon: Icons.search,
                onAction: () => _openCitySearch(context),
              ),
          };
        },
      ),
    );
  }
}
