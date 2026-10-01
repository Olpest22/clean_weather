import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../models/location_model.dart';

/// Локальный источник данных: последний выбранный город.
abstract interface class LocationLocalDataSource {
  /// Возвращает null, если город ещё не сохраняли. Бросает CacheException.
  Future<LocationModel?> getLastLocation();

  /// Бросает CacheException.
  Future<void> saveLastLocation(LocationModel location);
}

class LocationLocalDataSourceImpl implements LocationLocalDataSource {
  LocationLocalDataSourceImpl(this._preferences);

  static const _lastLocationKey = 'last_location';

  final SharedPreferences _preferences;

  @override
  Future<LocationModel?> getLastLocation() async {
    final rawJson = _preferences.getString(_lastLocationKey);
    if (rawJson == null) return null;

    try {
      return LocationModel.fromJson(
        jsonDecode(rawJson) as Map<String, dynamic>,
      );
    } on FormatException {
      throw const CacheException('Сохранённый город повреждён.');
    } on TypeError {
      throw const CacheException('Сохранённый город повреждён.');
    }
  }

  @override
  Future<void> saveLastLocation(LocationModel location) async {
    final isSaved = await _preferences.setString(
      _lastLocationKey,
      jsonEncode(location.toJson()),
    );
    if (!isSaved) throw const CacheException('Не удалось сохранить город.');
  }
}
