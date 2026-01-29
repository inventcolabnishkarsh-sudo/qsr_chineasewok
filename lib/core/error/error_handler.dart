import '../network/api_exception.dart';

class ErrorHandler {
  static String getMessage(dynamic error) {
    if (error is ApiException) {
      return error.message;
    }
    return 'Something went wrong. Please try again.';
  }
}
