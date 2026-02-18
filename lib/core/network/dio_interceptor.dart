import 'package:dio/dio.dart';
import 'api_exception.dart';
import 'network_checker.dart';
import '../utils/app_logger.dart';

class DioInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers.addAll({'Accept-Language': 'en', 'Device-Type': 'kiosk'});

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.error('Dio error: ${err.type}');
    AppLogger.error('URL: ${err.requestOptions.uri}');
    AppLogger.error('Status: ${err.response?.statusCode}');
    AppLogger.json(err.response?.data);

    // If already ApiException, just forward
    if (err.error is ApiException) {
      handler.next(err);
      return;
    }

    String message = 'Something went wrong';

    switch (err.type) {
      case DioExceptionType.connectionError:
        message = 'No internet connection';
        break;

      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        message = 'Connection timeout';
        break;

      case DioExceptionType.badResponse:
        final data = err.response?.data;
        if (data is Map && data['message'] != null) {
          message = data['message'];
        } else {
          message = 'Server error (${err.response?.statusCode})';
        }
        break;

      default:
        message = 'Unexpected error';
    }

    final apiException = ApiException(
      message,
      statusCode: err.response?.statusCode,
    );

    // ✅ Re-create DioException (Dio 5 way)
    final newError = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: apiException,
    );

    handler.next(newError);
  }
}
