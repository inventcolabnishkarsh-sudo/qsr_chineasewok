import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../order_summary_controller.dart';
import 'package:confetti/confetti.dart';

class BillSummary extends StatelessWidget {
  const BillSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderSummaryController>();

    return Obx(() {
      return Stack(
        alignment: Alignment.topCenter,
        children: [
          /// 🧾 YOUR EXISTING SUMMARY CARD
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
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE67E22),
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
                  padding: const EdgeInsets.all(16),
                  child: controller.isCouponApplied.value
                      ? _AppliedCoupon(controller)
                      : _CouponInput(controller),
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
                    vertical: 14,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Payable Amount',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFE67E22),
                        ),
                      ),
                      Text(
                        '₹${controller.payableAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFE67E22),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          child: TextField(
            controller: controller.couponController,
            onChanged: controller.onCouponChanged,
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
        const SizedBox(width: 12),

        /// ✅ THIS IS THE KEY FIX
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
            foregroundColor: Colors.deepOrange,
            textStyle: const TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          child: const Text('🗑️ Remove Coupon'),
        ),

      ],
    );
  }
}
