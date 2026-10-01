import '../error/exceptions.dart';
import '../error/failures.dart';
import 'result.dart';

/// Выполняет операцию слоя данных и превращает исключения в [Result].
/// Используется в реализациях репозиториев, чтобы не повторять try/catch.
Future<Result<T>> guardResult<T>(Future<T> Function() action) async {
  try {
    return Success(await action());
  } on NetworkException catch (exception) {
    return Failed(NetworkFailure(exception.message));
  } on ServerException catch (exception) {
    return Failed(ServerFailure(exception.message));
  } on CacheException catch (exception) {
    return Failed(CacheFailure(exception.message));
  }
}
