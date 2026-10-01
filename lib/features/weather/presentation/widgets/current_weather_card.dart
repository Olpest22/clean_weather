import 'package:flutter/material.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/location.dart';
import '../../domain/entities/weather.dart';
import 'presentation_extensions.dart';

/// Крупная карточка с погодой «сейчас».
class CurrentWeatherCard extends StatelessWidget {
  const CurrentWeatherCard({
    super.key,
    required this.location,
    required this.current,
  });

  final Location location;
  final CurrentWeather current;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onCardColor = theme.colorScheme.onPrimaryContainer;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              location.name,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(color: onCardColor),
            ),
            if (location.subtitle.isNotEmpty)
              Text(
                location.subtitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(color: onCardColor),
              ),
            const SizedBox(height: 16),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 16,
              children: [
                Text(
                  current.condition.emoji(isDay: current.isDay),
                  style: const TextStyle(fontSize: 64),
                ),
                Text(
                  formatTemperature(current.temperature),
                  style: theme.textTheme.displayLarge?.copyWith(
                    color: onCardColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Text(
              current.condition.description,
              style: theme.textTheme.titleMedium?.copyWith(color: onCardColor),
            ),
            const SizedBox(height: 4),
            Text(
              'Ощущается как ${formatTemperature(current.apparentTemperature)}',
              style: theme.textTheme.bodyMedium?.copyWith(color: onCardColor),
            ),
            const SizedBox(height: 20),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 24,
              runSpacing: 12,
              children: [
                _WeatherDetail(
                  icon: Icons.water_drop_outlined,
                  label: 'Влажность',
                  value: '${current.humidity}%',
                  color: onCardColor,
                ),
                _WeatherDetail(
                  icon: Icons.air,
                  label: 'Ветер',
                  value: '${current.windSpeed.toStringAsFixed(1)} м/с',
                  color: onCardColor,
                ),
                _WeatherDetail(
                  icon: Icons.schedule,
                  label: 'Местное время',
                  value: formatTime(current.time),
                  color: onCardColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WeatherDetail extends StatelessWidget {
  const _WeatherDetail({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 4),
        Text(value, style: textTheme.titleSmall?.copyWith(color: color)),
        Text(label, style: textTheme.labelSmall?.copyWith(color: color)),
      ],
    );
  }
}
