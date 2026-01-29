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
  }

  /// ✅ SAFE PLACE FOR API + NAVIGATION
  @override
  void onReady() {
    super.onReady();
    _fetchOutletMenu();
  }

  Future<void> _fetchOutletMenu() async {
    final menuService = Get.find<MenuDataService>();

    // ✅ CACHE CHECK
    if (menuService.hasData) {
      AppLogger.log('Menu data already available → skipping API');

      isLoading.value = false;

      // 🔐 SAFE NAVIGATION
      _goHome();
      return;
    }

    try {
      final url = '${ApiConstants.manageOutlet}=1';

      AppLogger.divider('API REQUEST');
      AppLogger.log('GET ${ApiConstants.baseUrl}$url');

      final response = await _dioClient.dio.get(url);

      AppLogger.divider('API RESPONSE');
      AppLogger.log('Status Code: ${response.statusCode}');
      AppLogger.json(response.data);

      if (response.statusCode == 200) {
        await menuService.setData(response.data);
        AppLogger.log('Menu data saved in cache');

        isLoading.value = false;
        _goHome();
      } else {
        throw ApiException(
          'Failed to load outlet data',
          statusCode: response.statusCode,
        );
      }
    } catch (e, stack) {
      AppLogger.divider('API ERROR');
      AppLogger.error(e);
      AppLogger.error(stack);
      _handleError(e);
    }
  }

  /// 🧭 NAVIGATION (POST FRAME)
  void _goHome() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.offAllNamed('/home');
    });
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
