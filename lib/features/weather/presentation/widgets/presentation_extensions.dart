import '../../domain/entities/location.dart';
import '../../domain/entities/weather_condition.dart';

/// Отображение погодных условий — забота слоя presentation,
/// поэтому тексты и иконки живут здесь, а не в domain.
extension WeatherConditionPresentation on WeatherCondition {
  String get description => switch (this) {
        WeatherCondition.clear => 'Ясно',
        WeatherCondition.mainlyClear => 'Преимущественно ясно',
        WeatherCondition.partlyCloudy => 'Переменная облачность',
        WeatherCondition.overcast => 'Пасмурно',
        WeatherCondition.fog => 'Туман',
        WeatherCondition.drizzle => 'Морось',
        WeatherCondition.freezingDrizzle => 'Ледяная морось',
        WeatherCondition.rain => 'Дождь',
        WeatherCondition.freezingRain => 'Ледяной дождь',
        WeatherCondition.snow => 'Снег',
        WeatherCondition.snowGrains => 'Снежная крупа',
        WeatherCondition.rainShowers => 'Ливень',
        WeatherCondition.snowShowers => 'Снегопад',
        WeatherCondition.thunderstorm => 'Гроза',
        WeatherCondition.thunderstormWithHail => 'Гроза с градом',
        WeatherCondition.unknown => 'Нет данных',
      };

  String emoji({bool isDay = true}) => switch (this) {
        WeatherCondition.clear => isDay ? '☀️' : '🌙',
        WeatherCondition.mainlyClear => isDay ? '🌤️' : '🌙',
        WeatherCondition.partlyCloudy => '⛅',
        WeatherCondition.overcast => '☁️',
        WeatherCondition.fog => '🌫️',
        WeatherCondition.drizzle ||
        WeatherCondition.rainShowers =>
          '🌦️',
        WeatherCondition.freezingDrizzle ||
        WeatherCondition.rain ||
        WeatherCondition.freezingRain =>
          '🌧️',
        WeatherCondition.snow => '❄️',
        WeatherCondition.snowGrains ||
        WeatherCondition.snowShowers =>
          '🌨️',
        WeatherCondition.thunderstorm ||
        WeatherCondition.thunderstormWithHail =>
          '⛈️',
        WeatherCondition.unknown => '🌡️',
      };
}

extension LocationPresentation on Location {
  /// «Московская область, Россия».
  String get subtitle => [region, country]
      .where((part) => part.isNotEmpty && part != name)
      .join(', ');

  /// Флаг страны из кода ISO: «RU» → 🇷🇺.
  String get flagEmoji {
    final code = countryCode.toUpperCase();
    final isValid = code.length == 2 &&
        code.codeUnits.every((unit) => unit >= 65 && unit <= 90);
    if (!isValid) return '📍';
    const regionalIndicatorA = 0x1F1E6;
    return String.fromCharCodes(
      code.codeUnits.map((unit) => regionalIndicatorA + unit - 65),
    );
  }
}

/// Приблизительно определяет светлое время суток для почасовых иконок.
bool isDaytimeHour(DateTime time) => time.hour >= 6 && time.hour < 21;

/// «12°», «−3°».
String formatTemperature(double value) => '${value.round()}°';
