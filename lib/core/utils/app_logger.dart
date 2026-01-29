import 'dart:convert';

class AppLogger {
  static void log(dynamic message) {
    // ignore: avoid_print
    print('[LOG] $message');
  }

  static void error(dynamic message) {
    // ignore: avoid_print
    print('[ERROR] $message');
  }

  /// 🧾 Pretty JSON log (for API responses)
  static void json(dynamic data) {
    try {
      const encoder = JsonEncoder.withIndent('  ');
      final pretty = encoder.convert(data);
      log(pretty);
    } catch (e) {
      log(data);
    }
  }

  /// 🔹 Section divider (clean console)
  static void divider(String title) {
    log('================ $title ================');
  }
}
