import 'package:equatable/equatable.dart';

import '../result/result.dart';

/// Базовый контракт сценария использования (use case).
/// Каждый use case выполняет одно действие бизнес-логики.
abstract interface class UseCase<T, Params> {
  Future<Result<T>> call(Params params);
}

/// Параметры для use case, которому ничего не нужно на вход.
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
