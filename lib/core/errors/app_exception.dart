class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Unauthorized'])
      : super(statusCode: 401);
}

class ServerException extends AppException {
  const ServerException([super.message = 'Server error']);
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'Network error']);
}
