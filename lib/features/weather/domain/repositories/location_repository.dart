import '../../../../core/result/result.dart';
import '../entities/location.dart';

/// Контракт работы с городами: поиск и запоминание последнего выбранного.
abstract interface class LocationRepository {
  Future<Result<List<Location>>> searchLocations(String query);

  /// Последний выбранный город или null, если город ещё не выбирали.
  Future<Result<Location?>> getLastLocation();

  Future<Result<void>> saveLastLocation(Location location);
}
