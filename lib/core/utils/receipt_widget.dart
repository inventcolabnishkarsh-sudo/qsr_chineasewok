import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../app/modules/order_summary/order_summary_controller.dart';

class ReceiptWidget extends StatelessWidget {
  final OrderSummaryController orderController;

  const ReceiptWidget({super.key, required this.orderController});

  @override
  Widget build(BuildContext context) {
    final items = orderController.items;
    final now = DateTime.now();
    final formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(now);
    final orderId = now.millisecondsSinceEpoch.toString().substring(
      7,
    ); // simple order id

    return Container(
      width: 420,
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🏢 HEADER
            const Center(
              child: Text(
                "HOME ESSENTIALS PVT LTD",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
            ),
            const SizedBox(height: 4),
            const Center(
              child: Text(
                "Thank you for your order",
                style: TextStyle(fontSize: 12),
              ),
            ),

            const SizedBox(height: 12),
            _dashedLine(),

            const SizedBox(height: 8),

            /// 🧾 ORDER INFO
            _infoRow("Order ID", "#$orderId"),
            _infoRow("Date", formattedDate),

            const SizedBox(height: 8),
            _dashedLine(),
            const SizedBox(height: 12),

            /// 🛒 ITEMS HEADER
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    "Item",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                Expanded(
                  child: Text(
                    "Qty",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                Expanded(
                  child: Text(
                    "Amount",
                    textAlign: TextAlign.right,
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            /// 🧾 ITEM LIST
            ...items.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(
                        item.name,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "${item.quantity}",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Text("₹${item.total}", textAlign: TextAlign.right),
                    ),
                  ],
                ),
              );
            }).toList(),

            const SizedBox(height: 10),
            _dashedLine(),
            const SizedBox(height: 12),

            /// 💰 BILL SUMMARY
            _amountRow("Subtotal", orderController.subTotal),
            _amountRow("Discount", -orderController.couponDiscount),
            _amountRow("GST (5%)", orderController.gstAmount),

            const SizedBox(height: 6),
            _dashedLine(),
            const SizedBox(height: 10),

            /// 🔥 TOTAL
            _amountRow("TOTAL", orderController.payableAmount, isBold: true),

            const SizedBox(height: 20),

            const Center(
              child: Text(
                "***** Thank You Visit Again *****",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),

            const SizedBox(height: 12),

            const Center(
              child: Text(
                "This is a computer generated receipt.",
                style: TextStyle(fontSize: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Order Info Row
  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 12)),
          Text(value, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  /// 🔹 Amount Row
  Widget _amountRow(String title, dynamic value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w500,
              fontSize: isBold ? 16 : 14,
            ),
          ),
          Text(
            "₹$value",
            style: TextStyle(
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w500,
              fontSize: isBold ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Dashed Divider
  Widget _dashedLine() {
    return const Text(
      "----------------------------------------",
      style: TextStyle(fontSize: 12, letterSpacing: 1),
    );
  }
}
