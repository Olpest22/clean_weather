import 'package:flutter/material.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/weather.dart';
import 'presentation_extensions.dart';

/// Прогноз на неделю: день, условия, вероятность осадков, max / min.
class DailyForecastList extends StatelessWidget {
  const DailyForecastList({super.key, required this.days, required this.today});

  final List<DailyForecast> days;

  /// Текущая дата в городе — для подписей «Сегодня» и «Завтра».
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Text(
                'Прогноз на ${days.length} дней',
                style: theme.textTheme.titleMedium,
              ),
            ),
            for (final day in days) _DayRow(day: day, today: today),
          ],
        ),
      ),
    );
  }
}

class _DayRow extends StatelessWidget {
  const _DayRow({required this.day, required this.today});

  final DailyForecast day;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final precipitation = day.precipitationProbability;
    final subtitle = precipitation != null && precipitation > 0
        ? '${day.condition.description} · осадки $precipitation%'
        : day.condition.description;

    return ListTile(
      leading: Text(day.condition.emoji(), style: const TextStyle(fontSize: 28)),
      title: Text(formatDayLabel(day.date, today: today)),
      subtitle: Text(subtitle),
      trailing: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: formatTemperature(day.maxTemperature),
              style: theme.textTheme.titleMedium,
            ),
            TextSpan(
              text: ' / ${formatTemperature(day.minTemperature)}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
