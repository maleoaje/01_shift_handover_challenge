/// Base class for all application-specific exceptions
abstract class AppException implements Exception {
  final String message;
  final String? details;

  const AppException(this.message, [this.details]);

  @override
  String toString() => message;
}

/// Exception for shift report related errors
class ShiftReportException extends AppException {
  const ShiftReportException(super.message, [super.details]);
}

/// Exception for network-related errors
class NetworkException extends AppException {
  const NetworkException(super.message, [super.details]);
}

/// Exception for validation errors
class ValidationException extends AppException {
  const ValidationException(super.message, [super.details]);
}

/// Utility class for handling and transforming exceptions
class ExceptionHandler {
  /// Converts a generic exception to a more specific application exception
  static AppException handle(Object error) {
    if (error is AppException) return error;

    if (error is NetworkException) {
      return NetworkException(
        'Network error occurred',
        error.toString(),
      );
    }

    return ShiftReportException(
      'An unexpected error occurred',
      error.toString(),
    );
  }
}
