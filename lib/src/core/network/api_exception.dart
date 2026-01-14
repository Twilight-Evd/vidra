import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException({required this.message, this.statusCode});

  factory ApiException.fromDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.cancel:
        return ApiException(message: "Request to server was cancelled");
      case DioExceptionType.connectionTimeout:
        return ApiException(message: "Connection timeout with server");
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: "Receive timeout in connection with server",
        );
      case DioExceptionType.sendTimeout:
        return ApiException(message: "Send timeout in connection with server");
      case DioExceptionType.connectionError:
        return ApiException(message: "No internet connection");
      case DioExceptionType.badResponse:
        return ApiException.fromResponse(error.response);
      case DioExceptionType.badCertificate:
        return ApiException(message: "Bad certificate");
      case DioExceptionType.unknown:
        if (error.message?.contains("SocketException") ?? false) {
          return ApiException(message: "No internet connection");
        }
        return ApiException(message: "Unexpected error occurred");
    }
  }

  factory ApiException.fromResponse(Response? response) {
    if (response == null) {
      return ApiException(message: "No response from server");
    }

    final statusCode = response.statusCode;

    // Check if API returns specific error message in body
    final dynamic data = response.data;
    String? apiMessage;
    if (data is Map<String, dynamic> && data.containsKey('message')) {
      apiMessage = data['message'];
    }

    switch (statusCode) {
      case 400:
        return ApiException(
          message: apiMessage ?? "Bad request",
          statusCode: statusCode,
        );
      case 401:
        return ApiException(
          message: apiMessage ?? "Unauthorized",
          statusCode: statusCode,
        );
      case 403:
        return ApiException(
          message: apiMessage ?? "Forbidden",
          statusCode: statusCode,
        );
      case 404:
        return ApiException(
          message: apiMessage ?? "Resource not found",
          statusCode: statusCode,
        );
      case 500:
        return ApiException(
          message: apiMessage ?? "Internal server error",
          statusCode: statusCode,
        );
      case 502:
        return ApiException(
          message: apiMessage ?? "Bad gateway",
          statusCode: statusCode,
        );
      case 503:
        return ApiException(
          message: apiMessage ?? "Service unavailable",
          statusCode: statusCode,
        );
      default:
        return ApiException(
          message: apiMessage ?? "Received invalid status code: $statusCode",
          statusCode: statusCode,
        );
    }
  }

  @override
  String toString() => message;
}
