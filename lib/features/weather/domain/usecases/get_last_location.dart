import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/location.dart';
import '../repositories/location_repository.dart';

/// Получить последний выбранный город (для показа при запуске).
class GetLastLocation implements UseCase<Location?, NoParams> {
  const GetLastLocation(this._repository);

  final LocationRepository _repository;

  @override
  Future<Result<Location?>> call(NoParams params) {
    return _repository.getLastLocation();
  }
}
