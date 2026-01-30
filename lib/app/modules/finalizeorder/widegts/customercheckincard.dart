import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/globalwidgets/numerickeyboard.dart';
import '../finalize_order_controller.dart';

class CustomerCheckInCard extends GetView<FinalizeOrderController> {
  const CustomerCheckInCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxWidth: 520),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// 🧾 TITLE
            const Text(
              'Customer Check-In',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1E2430),
              ),
            ),

            const SizedBox(height: 10),

            /// 🟧 UNDERLINE
            Container(
              width: 160,
              height: 6,
              decoration: BoxDecoration(
                color: const Color(0xFFE67E22),
                borderRadius: BorderRadius.circular(4),
              ),
            ),

            const SizedBox(height: 36),

            /// 🏷️ TAG NUMBER
            GestureDetector(
              onTap: () => controller.activeTarget.value = InputTarget.tag,
              child: Obx(
                () => _inputBox(
                  hint: 'Enter Tag Number',
                  controller: controller.tagController,
                  isActive: controller.activeTarget.value == InputTarget.tag,
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// 📱 MOBILE NUMBER
            GestureDetector(
              onTap: () => controller.activeTarget.value = InputTarget.mobile,
              child: Obx(
                () => _inputBox(
                  hint: 'Enter Mobile Number',
                  controller: controller.mobileController,
                  isActive: controller.activeTarget.value == InputTarget.mobile,
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// 🔢 NUMERIC KEYPAD
            Obx(
              () => NumericKeypad(
                controller: controller.activeController,
                maxLength: controller.maxLength,
              ),
            ),

            const SizedBox(height: 28),

            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: controller.canSubmit
                      ? () {
                          // controller.submitCheckIn();
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: controller.canSubmit
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
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 18),

            /// ➕ ADD MORE / ❌ CANCEL
            Row(
              children: [
                /// ➕ ADD MORE ITEMS
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

                /// ❌ CANCEL
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Optional: confirmation dialog
                      Get.back();
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade400, width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
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
    );
  }

  static Widget _inputBox({
    required String hint,
    required TextEditingController controller,
    bool isActive = false,
  }) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? const Color(0xFFE67E22) : const Color(0xFFE0E5EE),
          width: 2.5,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: const Color(0xFFE67E22).withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: controller,
        readOnly: true,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade500,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
