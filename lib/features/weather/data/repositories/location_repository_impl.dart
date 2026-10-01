import '../../../../core/result/guard_result.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/location.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/geocoding_remote_data_source.dart';
import '../datasources/location_local_data_source.dart';
import '../models/location_model.dart';

/// Объединяет два источника: поиск — из сети, последний город — локально.
class LocationRepositoryImpl implements LocationRepository {
  LocationRepositoryImpl({
    required GeocodingRemoteDataSource remoteDataSource,
    required LocationLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  final GeocodingRemoteDataSource _remoteDataSource;
  final LocationLocalDataSource _localDataSource;

  @override
  Future<Result<List<Location>>> searchLocations(String query) {
    return guardResult<List<Location>>(
      () => _remoteDataSource.searchLocations(query),
    );
  }

  @override
  Future<Result<Location?>> getLastLocation() {
    return guardResult<Location?>(_localDataSource.getLastLocation);
  }

  @override
  Future<Result<void>> saveLastLocation(Location location) {
    return guardResult<void>(
      () => _localDataSource.saveLastLocation(
        LocationModel.fromEntity(location),
      ),
    );
  }
}
