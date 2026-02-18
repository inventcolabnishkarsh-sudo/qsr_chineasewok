import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../groupmenu/model/cart_item.dart';
import '../order_summary_controller.dart';

class CartItemCard extends StatelessWidget {
  final CartItem item;
  const CartItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderSummaryController>();

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              /// 🍱 IMAGE
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 64,
                  width: 64,
                  color: Colors.grey.shade100,
                  child: item.imageBytes != null
                      ? Image.memory(item.imageBytes!, fit: BoxFit.cover)
                      : Image.asset(
                          'assets/images/menu_placeholder.png',
                          fit: BoxFit.cover,
                        ),
                ),
              ),

              const SizedBox(width: 14),

              /// 🧾 NAME + PRICE
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 🍽️ ITEM / COMBO NAME + DETAILS
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        /// 🍽️ ITEM NAME
                        Expanded(
                          child: Text(
                            item.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Text(
                          '₹${item.total}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          height: 40,
                          width: 1,
                          color: Colors.grey.shade400,
                        ),

                        /// │ DIVIDER (ONLY WHEN COMBO)
                        if (item.portion == 'combo') ...[
                          const SizedBox(width: 10),
                          Container(
                            height: 40,
                            width: 1,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(width: 10),

                          /// ✏️ MODIFY BUTTON
                          InkWell(
                            borderRadius: BorderRadius.circular(18),
                            onTap: () {
                              controller.modifyCombo(item);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xffc7834e),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: const Text(
                                'Modify',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(width: 6),

                        /// ➕➖ QUANTITY CONTROL
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xffc7834e),

                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                padding: EdgeInsets.zero,
                                iconSize: 20,
                                color: Colors.white,
                                icon: const Icon(Icons.remove),
                                onPressed: () => controller.decreaseItem(item),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                child: Text(
                                  '${item.quantity}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              IconButton(
                                padding: EdgeInsets.zero,
                                iconSize: 20,
                                icon: const Icon(Icons.add),
                                color: Colors.white,
                                onPressed: () => controller.increaseItem(item),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    if (item.comboItems != null && item.comboItems!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: item.comboItems!
                              .map(
                                (e) => Padding(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  child: Text(
                                    '• $e',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        if (item.portion == 'combo' &&
                            item.serves != null &&
                            item.serves! >= 1)
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'SERVES ${item.serves}',

                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
