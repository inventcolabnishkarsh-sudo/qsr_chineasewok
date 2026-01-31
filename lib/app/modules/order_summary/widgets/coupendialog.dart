import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../../../core/globalwidgets/custom_keyboard.dart';
import '../order_summary_controller.dart';

class CouponDialog extends StatelessWidget {
  final OrderSummaryController controller;
  final KeyboardType keyboardType;

  const CouponDialog(
    this.controller, {
    super.key,
    this.keyboardType = KeyboardType.alphanumeric,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(maxHeight: constraints.maxHeight * 0.7),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ---------------- TITLE ----------------
                  const Text(
                    'Enter Coupon Code',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                  ),

                  const SizedBox(height: 8),

                  // ---------------- TEXT FIELD ----------------
                  TextField(
                    controller: controller.couponController,
                    readOnly: true,
                    showCursor: true,
                    decoration: InputDecoration(
                      hintText: 'Coupon Code',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ---------------- KEYBOARD ----------------
                  SizedBox(
                    height: keyboardType == KeyboardType.numeric ? 180 : 220,
                    child: QwertyKeyboard(
                      type: keyboardType,
                      onKeyTap: (char) {
                        if (controller.couponController.text.length < 12) {
                          controller.couponController.text += char;
                          controller.onCouponChanged(
                            controller.couponController.text,
                          );
                        }
                      },
                      onBackspace: () {
                        if (controller.couponController.text.isNotEmpty) {
                          controller.couponController.text = controller
                              .couponController
                              .text
                              .substring(
                                0,
                                controller.couponController.text.length - 1,
                              );
                          controller.onCouponChanged(
                            controller.couponController.text,
                          );
                        }
                      },
                      onShift: () {
                        // Optional: uppercase toggle
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ---------------- ACTION BUTTONS ----------------
                  Row(
                    children: [
                      /// ❌ CANCEL (secondary action)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            controller.couponController.clear();
                            controller.onCouponChanged('');
                            Get.back();
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.grey.shade700,
                            side: BorderSide(color: Colors.grey.shade400),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      /// ✅ APPLY (primary action)
                      Expanded(
                        child: Obx(() {
                          final enabled = controller.isApplyEnabled.value;

                          return ElevatedButton(
                            onPressed: enabled
                                ? () {
                                    // 🔐 Safety: force uppercase before apply
                                    controller.couponController.text =
                                        controller.couponController.text
                                            .toUpperCase();

                                    controller.applyCoupon();
                                    Get.back();
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: enabled
                                  ? Colors.black
                                  : Colors.grey.shade400,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: enabled ? 3 : 0,
                            ),
                            child: Text(
                              enabled ? 'Apply Coupon' : 'Enter Coupon',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
