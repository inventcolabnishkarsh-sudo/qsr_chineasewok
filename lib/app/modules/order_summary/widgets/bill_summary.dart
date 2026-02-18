import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../../core/globalwidgets/numerickeyboard.dart';
import '../order_summary_controller.dart';
import 'package:confetti/confetti.dart';

import 'coupendialog.dart';

class BillSummary extends StatelessWidget {
  const BillSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderSummaryController>();

    return Obx(() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => Get.back(),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xffc7834e)),
                  color: Colors.white, // 👈 important difference
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.add, color: Color(0xffc7834e), size: 20),
                    SizedBox(width: 6),
                    Text(
                      'Add more items',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xffc7834e),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /// 🟧 HEADER
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),

                  decoration: const BoxDecoration(
                    color: Color(0xffc7834e),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(14),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Cart Summary',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),

                _row('Total', controller.subTotal.toDouble()),
                _row('Tax', controller.gstAmount, subLabel: 'GST (5%)'),
                _row(
                  'Discount Total',
                  controller.couponDiscount.toDouble(),
                  isNegative: true,
                ),

                const Divider(height: 1),

                /// 🎟️ COUPON INPUT / STATUS
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                  child: Column(
                    children: [
                      controller.isCouponApplied.value
                          ? _AppliedCoupon(controller)
                          : _CouponInput(controller),
                    ],
                  ),
                ),

                if (controller.isCouponApplied.value)
                  _row(
                    'Coupon Discount (${controller.appliedCoupon})',
                    controller.couponDiscount.toDouble(),
                    isNegative: true,
                    highlight: true,
                  ),

                const Divider(height: 1),

                /// 💰 PAYABLE
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Payable Amount',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Color(0xffc7834e),
                        ),
                      ),
                      Text(
                        '₹${controller.payableAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Color(0xffc7834e),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                /// 🔐 AUTHORIZATION TEXT
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),

                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'By placing this order, you confirm the items and prices shown above.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                /// ✅ ACTION BUTTONS
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
                  child: Row(
                    children: [
                      /// ❌ CANCEL BUTTON
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // Optional: confirmation dialog
                            Get.back(); // or controller.clearCart();
                          },
                          style: OutlinedButton.styleFrom(
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
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      /// ✅ PLACE ORDER BUTTON
                      Expanded(
                        child: ElevatedButton(
                          onPressed: controller.items.isEmpty
                              ? null
                              : controller.placeOrder,

                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffc7834e),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 3,
                          ),
                          child: const Text(
                            'Place Order',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// 🎉 CONFETTI OVERLAY
          ConfettiWidget(
            confettiController: controller.confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            emissionFrequency: 0.05,
            numberOfParticles: 25,
            gravity: 0.3,
            colors: const [
              Colors.green,
              Colors.orange,
              Colors.blue,
              Colors.pink,
            ],
          ),
        ],
      );
    });
  }

  Widget _row(
    String label,
    double value, {
    String? subLabel,
    bool isNegative = false,
    bool highlight = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (subLabel != null)
                Text(
                  subLabel,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
            ],
          ),
          Text(
            '${isNegative ? '-' : ''} ₹${value.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: highlight ? 17 : 16,
              fontWeight: FontWeight.w700,
              color: isNegative ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _CouponInput extends StatelessWidget {
  final OrderSummaryController controller;
  const _CouponInput(this.controller);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _openCouponDialog(),
            child: AbsorbPointer(
              child: TextField(
                controller: controller.couponController,
                readOnly: true,
                showCursor: true,
                decoration: InputDecoration(
                  hintText: 'Enter coupon',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),

        Obx(() {
          return ElevatedButton(
            onPressed: controller.isApplyEnabled.value
                ? controller.applyCoupon
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: controller.isApplyEnabled.value
                  ? Colors.black
                  : Colors.grey.shade400,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Apply',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          );
        }),
      ],
    );
  }

  /// 🔔 OPEN DIALOG
  void _openCouponDialog() {
    Get.dialog(CouponDialog(controller), barrierDismissible: true);
  }
}

class _AppliedCoupon extends StatelessWidget {
  final OrderSummaryController controller;
  const _AppliedCoupon(this.controller);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          '🎉 HURRAY! Coupon Applied!',
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.w700),
        ),
        const Spacer(),
        TextButton(
          onPressed: controller.removeCoupon,
          style: TextButton.styleFrom(
            foregroundColor: Color(0xffc7834e),
            textStyle: const TextStyle(fontWeight: FontWeight.w700),
          ),
          child: const Text('🗑️ Remove Coupon'),
        ),
      ],
    );
  }
}
