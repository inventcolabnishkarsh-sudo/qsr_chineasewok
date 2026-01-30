import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FinalizeOrderController extends GetxController {
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController tagController = TextEditingController();

  /// 🔥 Track active input
  final Rx<InputTarget> activeTarget = InputTarget.mobile.obs;

  /// ✅ Validation
  bool get isTagValid => tagController.text.length == 4;

  bool get isMobileValid =>
      RegExp(r'^[6-9]\d{9}$').hasMatch(mobileController.text);

  bool get canSubmit => isTagValid && isMobileValid;

  /// 🔢 Current controller for keypad
  TextEditingController get activeController =>
      activeTarget.value == InputTarget.tag ? tagController : mobileController;

  /// 🔢 Max length
  int get maxLength => activeTarget.value == InputTarget.tag ? 4 : 10;

  @override
  void onClose() {
    mobileController.dispose();
    tagController.dispose();
    super.onClose();
  }
}

enum InputTarget { tag, mobile }
