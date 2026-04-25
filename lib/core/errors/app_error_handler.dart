import 'package:dio/dio.dart';
import 'app_exception.dart';

class AppErrorHandler {
  static AppException handle(dynamic error) {
    if (error is DioException) {
      if (error.response != null && error.response!.data != null) {
        final data = error.response!.data;

        if (data is Map && data.containsKey('errors') && data['errors'] is List) {
          final List errors = data['errors'];
          if (errors.isNotEmpty && errors[0] is Map && errors[0].containsKey('msg')) {
            return ServerException(errors[0]['msg'].toString());
          }
        }

        if (data is Map) {
          if (data.containsKey('message')) return ServerException(data['message'].toString());
          if (data.containsKey('msg')) return ServerException(data['msg'].toString());
        }

        if (error.response!.statusCode == 401) {
          return const UnauthorizedException();
        }
      }

      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return const NetworkException('Connection timed out');
        case DioExceptionType.sendTimeout:
          return const NetworkException('Send timeout');
        case DioExceptionType.receiveTimeout:
          return const NetworkException('Receive timeout');
        case DioExceptionType.connectionError:
          return const NetworkException('Connection error');
        case DioExceptionType.cancel:
          return const ServerException('Request cancelled');
        default:
          return const ServerException('Something went wrong. Please try again.');
      }
    }
    return ServerException(error.toString());
  }

  static String getMessage(dynamic error) => handle(error).message;
}
