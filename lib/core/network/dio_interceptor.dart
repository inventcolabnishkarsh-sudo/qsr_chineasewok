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
    final hasInternet = await NetworkChecker.hasInternet();
    if (!hasInternet) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: ApiException('No internet connection'),
          type: DioExceptionType.connectionError,
        ),
      );
      return;
    }

    options.headers.addAll({'Accept-Language': 'en', 'Device-Type': 'kiosk'});

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.error('Dio error: ${err.type}');

    // ✅ Normalize ALL errors into ApiException
    if (err.error is ApiException) {
      handler.reject(err); // already normalized
      return;
    }

    String message = 'Something went wrong';

    if (err.type == DioExceptionType.connectionError) {
      message = 'No internet connection';
    } else if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      message = 'Connection timeout';
    } else if (err.response != null) {
      message = 'Server error (${err.response?.statusCode})';
    }

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: ApiException(message, statusCode: err.response?.statusCode),
      ),
    );
  }
}
