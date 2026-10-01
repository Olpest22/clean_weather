import '../../domain/entities/location.dart';

/// Модель города для слоя данных: умеет читать и писать JSON.
/// Наследует сущность, поэтому её можно вернуть в domain без копирования.
class LocationModel extends Location {
  const LocationModel({
    required super.id,
    required super.name,
    required super.latitude,
    required super.longitude,
    super.country,
    super.region,
    super.countryCode,
  });

  /// Формат ответа Geocoding API Open-Meteo. Этот же формат используется
  /// для сохранения города в shared_preferences.
  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      country: json['country'] as String? ?? '',
      region: json['admin1'] as String? ?? '',
      countryCode: json['country_code'] as String? ?? '',
    );
  }

  factory LocationModel.fromEntity(Location location) {
    return LocationModel(
      id: location.id,
      name: location.name,
      latitude: location.latitude,
      longitude: location.longitude,
      country: location.country,
      region: location.region,
      countryCode: location.countryCode,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'latitude': latitude,
        'longitude': longitude,
        'country': country,
        'admin1': region,
        'country_code': countryCode,
      };
}
