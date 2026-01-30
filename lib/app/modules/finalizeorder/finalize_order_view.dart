import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../home/home_controller.dart';
import '../order_summary/widgets/header.dart'; // for OrderType enum

class FinalizeOrderView extends StatelessWidget {
  const FinalizeOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;

    final OrderType orderType = args?['orderType'] ?? OrderType.dineIn;
    final double payableAmount = args?['payableAmount'] ?? 0;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          /// 🔝 HEADER
          Header(orderType),

          /// 🔴 DIVIDER
          const Divider(height: 1, thickness: 1.5, color: Colors.red),

          /// 📦 CONTENT
          Expanded(
            child: Center(
              child: Text(
                'Finalize Order Screen\n\n₹${payableAmount.toStringAsFixed(2)}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
