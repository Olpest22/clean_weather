import 'package:flutter/material.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/weather.dart';
import 'presentation_extensions.dart';

/// Горизонтальная лента почасового прогноза на ближайшие сутки.
class HourlyForecastStrip extends StatelessWidget {
  const HourlyForecastStrip({super.key, required this.hourly});

  final List<HourlyForecast> hourly;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Высота ленты растёт вместе с системным размером шрифта.
    final textScale =
        MediaQuery.textScalerOf(context).scale(1.0).clamp(1.0, 1.5).toDouble();

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('Почасовой прогноз', style: theme.textTheme.titleMedium),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 100 * textScale,
              // ListView.separated строит только видимые элементы.
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: hourly.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) => _HourTile(
                  forecast: hourly[index],
                  isNow: index == 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HourTile extends StatelessWidget {
  const _HourTile({required this.forecast, required this.isNow});

  final HourlyForecast forecast;
  final bool isNow;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 68,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isNow ? theme.colorScheme.secondaryContainer : null,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            isNow ? 'Сейчас' : formatHour(forecast.time),
            style: theme.textTheme.labelMedium,
          ),
          Text(
            forecast.condition.emoji(isDay: isDaytimeHour(forecast.time)),
            style: const TextStyle(fontSize: 24),
          ),
          Text(
            formatTemperature(forecast.temperature),
            style: theme.textTheme.titleSmall,
          ),
        ],
      ),
    );
  }
}
