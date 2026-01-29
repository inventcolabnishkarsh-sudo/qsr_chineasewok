class AppLogger {
  static void log(dynamic message) {
    // ignore: avoid_print
    print('[LOG] $message');
  }

  static void error(dynamic message) {
    // ignore: avoid_print
    print('[ERROR] $message');
  }
}
