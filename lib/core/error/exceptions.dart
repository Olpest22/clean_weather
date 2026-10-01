/// Исключения слоя данных (data).
///
/// Они не выходят за пределы репозиториев: репозиторий перехватывает их
/// и превращает в [Failure], с которыми работают domain и presentation.
class ServerException implements Exception {
  const ServerException([this.message = 'Ошибка сервера. Попробуйте позже.']);

  final String message;
}

class NetworkException implements Exception {
  const NetworkException([
    this.message = 'Нет подключения к интернету или сервер недоступен.',
  ]);

  final String message;
}

class CacheException implements Exception {
  const CacheException([this.message = 'Ошибка локального хранилища.']);

  final String message;
}
