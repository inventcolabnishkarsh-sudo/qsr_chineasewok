import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../core/utils/receipt_widget.dart';
import '../order_summary/order_summary_controller.dart';

enum InputTarget { tag, mobile }

class FinalizeOrderController extends GetxController {
  final tagController = TextEditingController();
  final mobileController = TextEditingController();

  final Rx<InputTarget> activeTarget = InputTarget.tag.obs;
  final RxBool canSubmit = false.obs;
  final RxBool isMobileVisible = false.obs;
  final RxString mobileText = ''.obs;

  late Razorpay _razorpay;

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

  @override
  void onInit() {
    super.onInit();

    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void openCheckout(double payableAmount) {
    final amountInPaise = (payableAmount * 100).round();

    var options = {
      'key': 'rzp_test_LTysJoN6nEVmkt', // 🔴 replace in production
      'amount': amountInPaise,
      'currency': 'INR',
      'name': 'HOME ESSENTIALS PVT LTD',
      'description': 'Order Payment',
      'prefill': {
        'contact': mobileController.text,
        'email': 'test@razorpay.com',
      },
      'theme': {'color': '#c7834e'},
      'modal': {'escape': false, 'confirm_close': true},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      Get.snackbar(
        "Payment Error",
        "Unable to open payment gateway",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void completeOrder() async {
    final orderController = Get.find<OrderSummaryController>();

    Get.dialog(
      Dialog(
        elevation: 12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// 🎉 SUCCESS ICON
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 70,
                ),
              ),

              const SizedBox(height: 24),

              /// 🏆 TITLE
              const Text(
                "Order Placed Successfully",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 12),

              /// 📝 SUBTITLE
              const Text(
                "Your order has been processed.\nWould you like a receipt?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 32),

              /// 🔘 ACTION BUTTONS
              Row(
                children: [
                  /// YES (Primary)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        _showReceipt(orderController);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffc7834e),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 4,
                      ),
                      child: const Text(
                        "View Receipt",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  /// NO (Secondary)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _finishAndGoHome(orderController);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.grey.shade400, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "No, Thank You",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void _showReceipt(OrderSummaryController orderController) {
    Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 40),
        child: ReceiptWidget(orderController: orderController),
      ),
      barrierDismissible: false,
    );

    Future.delayed(const Duration(seconds: 5), () {
      _finishAndGoHome(orderController);
    });
  }

  void _finishAndGoHome(OrderSummaryController orderController) {
    orderController.groupController.clearCart(); // 🔥 clear cart
    Get.offAllNamed("/home");
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    Get.dialog(
      Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.symmetric(horizontal: 40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 80),
              SizedBox(height: 16),
              Text(
                "Payment Successful!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    await Future.delayed(const Duration(seconds: 2));

    Get.offAllNamed("/home"); // or your order success route
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Get.snackbar(
      "Payment Failed",
      response.message ?? "Please try again",
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {}

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
    final isMobileValid = RegExp(
      r'^[6-9]\d{9}$',
    ).hasMatch(mobileController.text);

    canSubmit.value = isMobileValid;
  }

  @override
  void onClose() {
    _razorpay.clear();
    tagController.dispose();
    mobileController.dispose();
    super.onClose();
  }
}
