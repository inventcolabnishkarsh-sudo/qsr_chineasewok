class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data; // optional response body

  ApiException(
      this.message, {
        this.statusCode,
        this.data,
      });

  @override
  String toString() {
    if (statusCode != null) {
      return '[$statusCode] $message';
    }
    return message;
  }
}
