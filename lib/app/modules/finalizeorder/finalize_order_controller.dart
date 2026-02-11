import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum InputTarget { tag, mobile }

class FinalizeOrderController extends GetxController {
  final tagController = TextEditingController();
  final mobileController = TextEditingController();

  final Rx<InputTarget> activeTarget = InputTarget.tag.obs;
  final RxBool canSubmit = false.obs;
  final RxBool isMobileVisible = false.obs;
  final RxString mobileText = ''.obs;

  /// 🔴 ERROR MESSAGE
  final RxString errorText = ''.obs;

  bool _autoSwitchedFromTag = false;

  TextEditingController get activeController =>
      activeTarget.value == InputTarget.tag ? tagController : mobileController;

  int get maxLength => activeTarget.value == InputTarget.tag ? 4 : 10;

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
    if (activeTarget.value == InputTarget.tag &&
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
    final isTagValid = tagController.text.length == 4;

    final isMobileValid = RegExp(
      r'^[6-9]\d{9}$',
    ).hasMatch(mobileController.text);

    canSubmit.value = isTagValid && isMobileValid;
  }

  @override
  void onClose() {
    tagController.dispose();
    mobileController.dispose();
    super.onClose();
  }
}
