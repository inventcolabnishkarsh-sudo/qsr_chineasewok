import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/modules/order_summary/order_summary_controller.dart';

class NumericKeypad extends StatelessWidget {
  final TextEditingController controller;
  final int maxLength;

  const NumericKeypad({
    super.key,
    required this.controller,
    required this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    final orderController = Get.find<OrderSummaryController>();

    return Padding(
      padding: const EdgeInsets.only(top: 28),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 12,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 18,
          mainAxisSpacing: 18,
          childAspectRatio: 2.2,
        ),
        itemBuilder: (context, index) {
          /// CLEAR
          if (index == 9) {
            return _actionKey(
              label: 'C',
              color: Colors.red,
              onTap: () {
                controller.clear();
                orderController.onCouponChanged('');
              },
            );
          }

          /// BACKSPACE
          if (index == 11) {
            return _iconKey(
              icon: Icons.backspace_outlined,
              color: Colors.red,
              onTap: () {
                if (controller.text.isNotEmpty) {
                  controller.text = controller.text.substring(
                    0,
                    controller.text.length - 1,
                  );
                  orderController.onCouponChanged(controller.text);
                }
              },
            );
          }

          /// NUMBERS
          final number = index == 10 ? '0' : '${index + 1}';

          return _numberKey(
            label: number,
            onTap: () {
              if (controller.text.length < maxLength) {
                controller.text += number;
                orderController.onCouponChanged(controller.text);
              }
            },
          );
        },
      ),
    );
  }

  // ---------------- UI KEYS ----------------

  Widget _numberKey({required String label, required VoidCallback onTap}) {
    return _baseKey(
      onTap: onTap,
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: Color(0xFF3B4654),
        ),
      ),
    );
  }

  Widget _actionKey({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return _baseKey(
      color: color.withOpacity(0.06),
      borderColor: color.withOpacity(0.3),
      shadowColor: color.withOpacity(0.25),
      onTap: onTap,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w900,
          color: color,
        ),
      ),
    );
  }

  Widget _iconKey({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return _baseKey(
      color: color.withOpacity(0.06),
      borderColor: color.withOpacity(0.3),
      shadowColor: color.withOpacity(0.25),
      onTap: onTap,
      child: Icon(icon, size: 32, color: color),
    );
  }

  Widget _baseKey({
    required Widget child,
    required VoidCallback onTap,
    Color color = Colors.white,
    Color borderColor = const Color(0xFFE0E5EE),
    Color shadowColor = const Color(0xFFD0D7E2),
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
