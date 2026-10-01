import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../error/exceptions.dart';

/// Общий HTTP-клиент приложения.
Dio createDio() {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      responseType: ResponseType.json,
    ),
  );
  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(
        requestHeader: false,
        responseHeader: false,
        responseBody: false,
        logPrint: (message) => debugPrint(message.toString()),
      ),
    );
  }
  return dio;
}

extension DioJsonRequests on Dio {
  /// GET-запрос, ожидающий JSON-объект в ответе.
  /// Ошибки Dio превращаются в исключения слоя данных.
  Future<Map<String, dynamic>> getJson(
    String url, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await get<Map<String, dynamic>>(
        url,
        queryParameters: queryParameters,
      );
      final data = response.data;
      if (data == null) throw const ServerException('Сервер вернул пустой ответ.');
      return data;
    } on DioException catch (exception) {
      throw _mapDioException(exception);
    }
  }
}

Exception _mapDioException(DioException exception) {
  return switch (exception.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.transformTimeout =>          
      const NetworkException('Сервер слишком долго не отвечает.'),
    DioExceptionType.connectionError ||
    DioExceptionType.unknown =>
      const NetworkException(),
    DioExceptionType.badResponse => ServerException(
        'Ошибка сервера (код ${exception.response?.statusCode}).',
      ),
    DioExceptionType.badCertificate =>
      const ServerException('Не удалось установить защищённое соединение.'),
    DioExceptionType.cancel => const NetworkException('Запрос отменён.'),
  };
}

/// Разбирает JSON. Если структура ответа неожиданная (ошибка приведения
/// типов), выбрасывает [ServerException] вместо падения приложения.
T parseJsonOrThrow<T>(T Function() parse) {
  try {
    return parse();
  } on TypeError {
    throw const ServerException('Сервер вернул данные в неожиданном формате.');
  }
}
