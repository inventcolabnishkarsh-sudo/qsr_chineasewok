import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';

enum OrderType { takeaway, dineIn }

class HomeController extends GetxController with SingleGetTickerProviderMixin {
  late AnimationController rotationController;
  late Animation<double> rotationAnimation;

  late PageController adPageController;
  Timer? adTimer;
  int currentAdIndex = 0;

  final List<String> ads = [
    'assets/images/ads/ads.png',
    'assets/images/ads/ads2.jpg',
    'assets/images/ads/ads3.jpg',
  ];

  @override
  void onInit() {
    super.onInit();

    // Create animation controller (DO NOT START YET)
    rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    );

    rotationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(rotationController);

    // Create PageController only
    adPageController = PageController(viewportFraction: 1.0);
  }

  @override
  void onReady() {
    super.onReady();

    // ✅ Start animations AFTER first frame
    rotationController.repeat();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    adTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!adPageController.hasClients) return;

      currentAdIndex = (currentAdIndex + 1) % ads.length;

      // ✅ NO animation → zero frame pressure
      adPageController.jumpToPage(currentAdIndex);
    });
  }

  void onOrderSelected(OrderType type) {
    // ✅ Stop heavy animations BEFORE navigation
    rotationController.stop();
    adTimer?.cancel();

    Get.toNamed(AppRoutes.groupMenu, arguments: type);
  }

  @override
  void onClose() {
    adTimer?.cancel();
    rotationController.stop();
    rotationController.dispose();
    adPageController.dispose();
    super.onClose();
  }
}
