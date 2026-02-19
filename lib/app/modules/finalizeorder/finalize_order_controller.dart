import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../home/home_controller.dart';

enum InputTarget { tag, mobile }

class FinalizeOrderController extends GetxController {
  final tagController = TextEditingController();
  final mobileController = TextEditingController();
  final Rx<OrderType?> orderType = Rx<OrderType?>(null);

  final Rx<InputTarget> activeTarget = InputTarget.tag.obs;
  final RxBool canSubmit = false.obs;
  final RxBool isMobileVisible = false.obs;
  final RxString mobileText = ''.obs;
  final RxDouble payableAmount = 0.0.obs;

  /// 🔴 ERROR MESSAGE
  final RxString errorText = ''.obs;

  bool _autoSwitchedFromTag = false;

  TextEditingController get activeController =>
      activeTarget.value == InputTarget.tag ? tagController : mobileController;

  int get maxLength {
    if (orderType.value == OrderType.takeaway) {
      return 10; // only mobile allowed
    }
    return activeTarget.value == InputTarget.tag ? 4 : 10;
  }

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    if (args is Map) {
      if (args['orderType'] is OrderType) {
        orderType.value = args['orderType'] as OrderType;
      }

      if (args['payableAmount'] != null) {
        payableAmount.value = (args['payableAmount'] as num).toDouble();
      }
    }

    print("OrderType received: ${orderType.value}");
    print("Payable Amount received: ${payableAmount.value}");

    ever(orderType, (type) {
      if (type == OrderType.takeaway) {
        activeTarget.value = InputTarget.mobile;
      } else {
        activeTarget.value = InputTarget.tag;
      }
    });
  }

  void setActive(InputTarget target) {
    activeTarget.value = target;
    errorText.value = ''; // 👈 clear error when switching field
  }

  void onNumericKeyTap(String value) {
    if (!RegExp(r'[0-9]').hasMatch(value)) return;

    final ctrl = activeController;

    /// 🇮🇳 MOBILE FIRST DIGIT VALIDATION
    if (activeTarget.value == InputTarget.mobile &&
        ctrl.text.isEmpty &&
        !RegExp(r'[6-9]').hasMatch(value)) {
      errorText.value =
          'Enter your correct mobile number to receive your bill on the same number.';
      return; // ❌ block input
    }

    if (ctrl.text.length >= maxLength) return;
    ctrl.text += value;

    if (activeTarget.value == InputTarget.mobile) {
      mobileText.value = ctrl.text;
    }

    errorText.value = ''; // ✅ clear error on valid input

    /// 🔄 Auto-switch TAG → MOBILE (only once)
    if (orderType.value == OrderType.dineIn &&
        activeTarget.value == InputTarget.tag &&
        ctrl.text.length == 4 &&
        !_autoSwitchedFromTag) {
      _autoSwitchedFromTag = true;
      activeTarget.value = InputTarget.mobile;
    }

    _validate();
  }

  void onBackspace() {
    final ctrl = activeController;
    if (ctrl.text.isEmpty) return;

    ctrl.text = ctrl.text.substring(0, ctrl.text.length - 1);
    errorText.value = '';
    if (activeTarget.value == InputTarget.mobile) {
      mobileText.value = ctrl.text;
    }

    if (activeTarget.value == InputTarget.tag) {
      _autoSwitchedFromTag = false;
    }

    _validate();
  }

  void _validate() {
    final isMobileValid = RegExp(
      r'^[6-9]\d{9}$',
    ).hasMatch(mobileController.text);

    if (orderType.value == OrderType.takeaway) {
      // 🔥 Takeaway → only mobile required
      canSubmit.value = isMobileValid;
    } else {
      // 🔥 Dine-in → tag + mobile required
      final isTagValid = tagController.text.length == 4;
      canSubmit.value = isTagValid && isMobileValid;
    }
  }

  @override
  void onClose() {
    tagController.dispose();
    mobileController.dispose();
    super.onClose();
  }
}
