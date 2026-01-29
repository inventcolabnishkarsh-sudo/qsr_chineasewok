import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import 'menu_data_service.dart';
import '../../../core/utils/app_logger.dart';

class SplashController extends GetxController
    with SingleGetTickerProviderMixin {
  late AnimationController animationController;
  late Animation<double> scaleAnimation;
  late Animation<double> fadeAnimation;

  final DioClient _dioClient = DioClient();

  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();

    // 🎞️ Animation
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    scaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOutBack),
    );

    fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeIn),
    );

    animationController.forward();

    // 🚀 Load initial data
    _fetchOutletMenu();
  }

  Future<void> _fetchOutletMenu() async {
    try {
      // 🧠 If already cached, skip API
      final menuService = Get.find<MenuDataService>();
      if (menuService.hasData) {
        AppLogger.log('Menu data already in memory. Skipping API call.');
        isLoading.value = false;
        Get.offAllNamed('/home');
        return;
      }

      final url = '${ApiConstants.manageOutlet}=1';

      // 🔵 REQUEST LOG
      AppLogger.divider('API REQUEST');
      AppLogger.log('GET ${ApiConstants.baseUrl}$url');

      final response = await _dioClient.dio.get(url);

      // 🟢 RESPONSE LOG
      AppLogger.divider('API RESPONSE');
      AppLogger.log('Status Code: ${response.statusCode}');
      AppLogger.log('Headers: ${response.headers.map}');
      AppLogger.log('Body:');
      AppLogger.json(response.data);

      if (response.statusCode == 200) {
        // 🧠 STORE DATA IN MEMORY
        menuService.setData(response.data);
        AppLogger.log('Data stored in MenuDataService (memory)');

        await Future.delayed(const Duration(milliseconds: 500));

        isLoading.value = false;
        Get.offAllNamed('/home');
      } else {
        throw ApiException(
          'Failed to load outlet data',
          statusCode: response.statusCode,
        );
      }
    } catch (e, stack) {
      // 🔴 ERROR LOG
      AppLogger.divider('API ERROR');
      AppLogger.error(e);
      AppLogger.error(stack);

      _handleError(e);
    }
  }

  void _handleError(Object error) {
    isLoading.value = false;

    final message = error is ApiException
        ? error.message
        : 'Unable to load data';

    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red.shade700,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
