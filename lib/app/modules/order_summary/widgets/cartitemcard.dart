import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../order_summary_controller.dart';

class CartItemCard extends StatelessWidget {
  final item;
  const CartItemCard(this.item);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderSummaryController>();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            /// NAME
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹${item.price}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            /// QTY CONTROLS
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () =>
                      controller.decreaseItem(item),
                ),
                Text(
                  '${item.quantity}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () =>
                      controller.increaseItem(item),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
