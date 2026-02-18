import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qsr_chineasewok_kiosk/app/modules/order_summary/widgets/bill_summary.dart';
import 'package:qsr_chineasewok_kiosk/app/modules/order_summary/widgets/cartitemcard.dart';
import 'package:qsr_chineasewok_kiosk/app/modules/order_summary/widgets/header.dart';
import '../../../core/globalwidgets/promo_video_box.dart';
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
          Divider(height: 1, thickness: 1.5, color: Color(0xffc7834e)),

          /// 🎥 Image BOX (ONLY IF ITEMS < 3)
          Obx(() {
            return Visibility(
              visible: controller.items.length < 3,
              maintainState: true,
              maintainAnimation: true,
              maintainSize: false,
              child: Image.asset(
                'assets/images/ban2.png',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            );
          }),


          /// 🧾 ITEMS
          Expanded(
            child: Obx(() {
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                itemCount: controller.items.length,

                itemBuilder: (context, index) {
                  final item = controller.items[index];
                  return CartItemCard(item);
                },
              );
            }),
          ),

          /// 💰 BILL SUMMARY
          BillSummary(),
        ],
      ),
    );
  }
}
