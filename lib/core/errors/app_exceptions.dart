class AppException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic details;

  AppException(this.message, {this.statusCode, this.details});

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  NetworkException([super.message = 'No internet connection. Please check your network.']);
}

class UnauthorizedException extends AppException {
  UnauthorizedException([super.message = 'Session expired. Please log in again.'])
      : super(statusCode: 401);
}

class ForbiddenException extends AppException {
  ForbiddenException([super.message = 'You do not have permission to access this resource.'])
      : super(statusCode: 403);
}

class NotFoundException extends AppException {
  NotFoundException([super.message = 'The requested resource was not found.'])
      : super(statusCode: 404);
}

class ValidationException extends AppException {
  final Map<String, List<String>>? fieldErrors;

  ValidationException(super.message, {this.fieldErrors})
      : super(statusCode: 422);
}

class ServerException extends AppException {
  ServerException([super.message = 'Internal server error. Please try again later.'])
      : super(statusCode: 500);
}
