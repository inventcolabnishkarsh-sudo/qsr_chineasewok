import 'package:dio/dio.dart';
import 'api_exception.dart';
import 'network_checker.dart';

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

    // Add headers dynamically
    options.headers.addAll({
      'Accept-Language': 'en', // later from LanguageService
      'Device-Type': 'kiosk',
    });

    handler.next(options);
  }

  @override
  void onResponse(
      Response response,
      ResponseInterceptorHandler handler,
      ) {
    handler.next(response);
  }

  @override
  void onError(
      DioException err,
      ErrorInterceptorHandler handler,
      ) {
    final message = err.error is ApiException
        ? (err.error as ApiException).message
        : 'Something went wrong';

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: ApiException(message, statusCode: err.response?.statusCode),
      ),
    );
  }
}
