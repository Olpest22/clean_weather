import 'package:flutter/material.dart';

import '../../domain/entities/location.dart';
import '../../domain/entities/weather.dart';
import 'current_weather_card.dart';
import 'daily_forecast_list.dart';
import 'hourly_forecast_strip.dart';

/// Прогноз целиком. На узком экране блоки идут столбцом,
/// на широком (планшет, альбомная ориентация) — в две колонки.
class WeatherView extends StatelessWidget {
  const WeatherView({
    super.key,
    required this.location,
    required this.weather,
    required this.isRefreshing,
    required this.onRefresh,
  });

  static const _wideLayoutBreakpoint = 840.0;

  final Location location;
  final Weather weather;
  final bool isRefreshing;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final currentCard =
        CurrentWeatherCard(location: location, current: weather.current);
    final hourlyStrip = HourlyForecastStrip(hourly: weather.hourly);
    final dailyList = DailyForecastList(
      days: weather.daily,
      today: weather.current.time,
    );

    return Column(
      children: [
        SizedBox(
          height: 4,
          child: isRefreshing ? const LinearProgressIndicator() : null,
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: onRefresh,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= _wideLayoutBreakpoint;

                return ListView(
                  // Нужно, чтобы «потянуть для обновления» работало всегда.
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  children: [
                    Center(
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints(maxWidth: isWide ? 1100 : 640),
                        child: isWide
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        currentCard,
                                        const SizedBox(height: 16),
                                        hourlyStrip,
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(child: dailyList),
                                ],
                              )
                            : Column(
                                children: [
                                  currentCard,
                                  const SizedBox(height: 16),
                                  hourlyStrip,
                                  const SizedBox(height: 16),
                                  dailyList,
                                ],
                              ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
