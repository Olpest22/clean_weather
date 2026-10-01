import 'package:equatable/equatable.dart';

/// Город (населённый пункт) с координатами.
/// Сущность domain-слоя: не знает ни об API, ни о хранилище.
class Location extends Equatable {
  const Location({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.country = '',
    this.region = '',
    this.countryCode = '',
  });

  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final String country;

  /// Область, штат или провинция.
  final String region;

  /// Код страны ISO 3166-1 alpha-2, например «RU».
  final String countryCode;

  @override
  List<Object?> get props =>
      [id, name, latitude, longitude, country, region, countryCode];
}
