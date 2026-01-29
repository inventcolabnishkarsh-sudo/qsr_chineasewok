import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

    // Rotation animation
    rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    );
    rotationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(rotationController);
    rotationController.repeat();

    // Ad slider
    adPageController = PageController(viewportFraction: 1.0);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    adTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!adPageController.hasClients) return;

      if (currentAdIndex < ads.length - 1) {
        currentAdIndex++;

        adPageController.animateToPage(
          currentAdIndex,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      } else {
        currentAdIndex = 0;
        adPageController.jumpToPage(0);
      }
    });
  }

  @override
  void onClose() {
    rotationController.dispose();
    adPageController.dispose();
    adTimer?.cancel();
    super.onClose();
  }
}
