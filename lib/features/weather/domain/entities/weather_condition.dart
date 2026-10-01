/// Погодные условия. Domain-слой не знает о числовых кодах API:
/// перевод кодов в эти значения выполняется в слое данных.
enum WeatherCondition {
  clear,
  mainlyClear,
  partlyCloudy,
  overcast,
  fog,
  drizzle,
  freezingDrizzle,
  rain,
  freezingRain,
  snow,
  snowGrains,
  rainShowers,
  snowShowers,
  thunderstorm,
  thunderstormWithHail,
  unknown,
}
