import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/globalwidgets/custom_keyboard.dart';
import '../../../../core/utils/razorpay_web_screen.dart';
import '../../home/home_controller.dart';
import '../finalize_order_controller.dart';

class CustomerCheckInCard extends GetView<FinalizeOrderController> {
  const CustomerCheckInCard({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final home = Get.find<HomeController>();
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 520, maxHeight: height * 0.9),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Customer Check-In',
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900),
              ),

              const SizedBox(height: 30),

              Obx(() {
                if (home.orderType.value == OrderType.takeaway) {
                  return const SizedBox.shrink();
                }
                return Column(
                  children: [
                    InkWell(
                      onTap: () => controller.setActive(InputTarget.tag),
                      child: Obx(
                        () => _inputBox(
                          hint: 'Enter Tag Number',
                          controller: controller.tagController,
                          isActive:
                              controller.activeTarget.value == InputTarget.tag,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              }),

              /// MOBILE
              InkWell(
                onTap: () => controller.setActive(InputTarget.mobile),
                child: Obx(
                  () => _inputBox(
                    hint: 'Enter Mobile Number',
                    controller: controller.mobileController,
                    isActive:
                        controller.activeTarget.value == InputTarget.mobile,
                    isMobile: true,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              /// 🔴 ERROR MESSAGE
              Obx(() {
                if (controller.errorText.value.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Text(
                  controller.errorText.value,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                );
              }),
              const SizedBox(height: 30),

              /// KEYPAD
              SizedBox(
                height: 280,
                child: QwertyKeyboard(
                  type: KeyboardType.numeric,
                  onKeyTap: controller.onNumericKeyTap,
                  onBackspace: controller.onBackspace,
                  onShift: () {},
                ),
              ),

              const SizedBox(height: 30),

              /// SUBMIT
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: controller.canSubmit.value
                        ? () async {
                            final shouldProceed =
                                await _showOrderTypeConfirmDialog(controller);

                            if (shouldProceed == true) {
                              Get.dialog(const CustomPaymentPopup());
                            }
                          }
                        : null,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: controller.canSubmit.value
                          ? const Color(0xFFE67E22)
                          : Colors.grey.shade400,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// ➕ ADD MORE / ❌ CANCEL
              Row(
                children: [
                  /// ADD MORE ITEMS
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Get.back(); // go back to menu
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color(0xFFE67E22),
                          width: 2,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Add More Items',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFE67E22),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  /// CANCEL ORDER
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Get.back(); // later you can show confirmation dialog
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade400, width: 2),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Cancel Order',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
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
    );
  }

  Future<bool?> _showOrderTypeConfirmDialog(
    FinalizeOrderController controller,
  ) {
    final home = Get.find<HomeController>();
    final isTakeaway = home.orderType.value == OrderType.takeaway;

    return Get.dialog<bool>(
      Dialog(
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// 🏷 Title
              const Text(
                "Confirm Order Type",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),

              const SizedBox(height: 20),

              /// 📌 Current Type
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F4F4),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isTakeaway
                          ? Icons.shopping_bag_outlined
                          : Icons.restaurant_outlined,
                      color: const Color(0xFFE67E22),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      isTakeaway ? "Takeaway Selected" : "Dine-In Selected",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// ❓ Question
              Text(
                isTakeaway
                    ? "Would you like to switch to Dine-In?"
                    : "Would you like to switch to Takeaway?",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, height: 1.4),
              ),

              const SizedBox(height: 30),

              /// 🔘 Buttons
              Row(
                children: [
                  /// Continue (Secondary)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(result: true),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: Colors.grey.shade400),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "Continue",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  /// Change (Primary)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        home.orderType.value = isTakeaway
                            ? OrderType.dineIn
                            : OrderType.takeaway;

                        Get.back(result: true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE67E22),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "Change Order Type",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
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

  static Widget _inputBox({
    required String hint,
    required TextEditingController controller,
    required bool isActive,
    bool isMobile = false,
  }) {
    final finalizeController = Get.find<FinalizeOrderController>();

    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? const Color(0xFFE67E22) : Colors.grey.shade300,
          width: 2.5,
        ),
      ),
      child: Row(
        children: [
          /// TEXT DISPLAY
          Expanded(
            child: isMobile
                ? Obx(() {
                    final originalText = finalizeController.mobileText.value;
                    String displayText = originalText;

                    if (!finalizeController.isMobileVisible.value &&
                        originalText.length >= 4) {
                      final first = originalText.substring(0, 2);
                      final last = originalText.substring(
                        originalText.length - 2,
                      );
                      final masked = '*' * (originalText.length - 4);
                      displayText = '$first$masked$last';
                    }

                    return Text(
                      displayText.isEmpty ? hint : displayText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: displayText.isEmpty ? Colors.grey : Colors.black,
                      ),
                    );
                  })
                : Text(
                    controller.text.isEmpty ? hint : controller.text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: controller.text.isEmpty
                          ? Colors.grey
                          : Colors.black,
                    ),
                  ),
          ),

          /// 👁 EYE BUTTON
          if (isMobile)
            Obx(
              () => IconButton(
                icon: Icon(
                  finalizeController.isMobileVisible.value
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: Colors.grey.shade600,
                ),
                onPressed: () {
                  finalizeController.isMobileVisible.toggle();
                },
              ),
            ),
        ],
      ),
    );
  }
}
