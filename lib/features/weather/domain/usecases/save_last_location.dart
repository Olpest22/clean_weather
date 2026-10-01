import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/location.dart';
import '../repositories/location_repository.dart';

/// Запомнить выбранный город.
class SaveLastLocation implements UseCase<void, Location> {
  const SaveLastLocation(this._repository);

  final LocationRepository _repository;

  @override
  Future<Result<void>> call(Location location) {
    return _repository.saveLastLocation(location);
  }
}
