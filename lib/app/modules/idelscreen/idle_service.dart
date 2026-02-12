import 'dart:async';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class IdleService extends GetxService {
  Timer? _timer;

  final Duration idleDuration = const Duration(minutes: 1);

  void startTimer() {
    _timer?.cancel();
    _timer = Timer(idleDuration, _goToIdle);
  }

  void resetTimer() {
    startTimer();
  }

  void _goToIdle() {
    if (Get.currentRoute != AppRoutes.idleScreen) {
      Get.offAllNamed(AppRoutes.idleScreen);
    }
  }

  void stopTimer() {
    _timer?.cancel();
  }
}
