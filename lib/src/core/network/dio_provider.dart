import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add auth token if needed
        // final token = ref.read(authProvider).token;
        // if (token != null) {
        //   options.headers['Authorization'] = 'Bearer $token';
        // }
        // print('Request: ${options.method} ${options.path}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        // print('Response: ${response.statusCode}');
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        // print('Error: ${e.message}');
        // Wrap DioException in custom ApiException or just pass it through
        // Here we just let it propagate, but the repo layer should catch it
        // using ApiException.fromDioException(e)
        return handler.next(e);
      },
    ),
  );

  return dio;
});
