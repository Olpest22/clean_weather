import '../error/failures.dart';

/// Результат операции: либо данные ([Success]), либо ошибка ([Failed]).
///
/// Use case'ы и репозитории возвращают Result вместо выбрасывания
/// исключений, поэтому вызывающий код обязан обработать оба варианта:
///
/// ```dart
/// switch (result) {
///   case Success(:final data): ...
///   case Failed(:final failure): ...
/// }
/// ```
sealed class Result<T> {
  const Result();
}

final class Success<T> extends Result<T> {
  const Success(this.data);

  final T data;
}

final class Failed<T> extends Result<T> {
  const Failed(this.failure);

  final Failure failure;
}
