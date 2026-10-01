import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/location.dart';
import '../repositories/location_repository.dart';

/// Найти города по названию.
///
/// Бизнес-правило: запросы короче [minQueryLength] символов не отправляются,
/// так как по одной букве API вернёт бесполезный результат.
class SearchLocations implements UseCase<List<Location>, String> {
  const SearchLocations(this._repository);

  static const minQueryLength = 2;

  final LocationRepository _repository;

  @override
  Future<Result<List<Location>>> call(String query) async {
    final normalizedQuery = query.trim();
    if (normalizedQuery.length < minQueryLength) {
      return const Success(<Location>[]);
    }
    return _repository.searchLocations(normalizedQuery);
  }
}
