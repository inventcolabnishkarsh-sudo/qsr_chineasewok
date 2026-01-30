import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qsr_chineasewok_kiosk/app/modules/order_summary/widgets/bill_summary.dart';
import 'package:qsr_chineasewok_kiosk/app/modules/order_summary/widgets/cartitemcard.dart';
import 'package:qsr_chineasewok_kiosk/app/modules/order_summary/widgets/header.dart';
import 'order_summary_controller.dart';

class OrderSummaryView extends GetView<OrderSummaryController> {
  const OrderSummaryView({super.key});

  @override
  Widget build(BuildContext context) {
    final orderType = controller.orderType;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          /// 🔝 HEADER
          Header(orderType),

          /// 🧾 ITEMS
          Expanded(
            child: Obx(() {
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.items.length,
                itemBuilder: (context, index) {
                  final item = controller.items[index];
                  return CartItemCard(item);
                },
              );
            }),
          ),

          /// ➕ ADD MORE
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton.icon(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.add),
              label: const Text('Add more items'),
            ),
          ),

          /// 💰 BILL SUMMARY
          BillSummary(),
        ],
      ),
    );
  }
}
