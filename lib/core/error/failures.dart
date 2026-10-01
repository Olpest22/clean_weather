import 'package:equatable/equatable.dart';

/// Описание ошибки для слоёв domain и presentation.
/// Sealed-класс позволяет обработать все варианты в switch.
sealed class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

final class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

final class CacheFailure extends Failure {
  const CacheFailure(super.message);
}
