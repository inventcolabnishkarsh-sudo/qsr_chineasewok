import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/modules/order_summary/order_summary_controller.dart';
import 'package:intl/intl.dart';

class CustomPaymentPopup extends StatefulWidget {
  const CustomPaymentPopup({super.key});

  @override
  State<CustomPaymentPopup> createState() => _CustomPaymentPopupState();
}

class _CustomPaymentPopupState extends State<CustomPaymentPopup> {
  bool _isProcessing = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isProcessing = false;
      });

      Future.delayed(const Duration(seconds: 5), () {
        final orderController = Get.find<OrderSummaryController>();
        orderController.groupController.clearCart();
        Get.offAllNamed("/home");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: SizedBox(
        width: 520,
        height: 700,
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: _isProcessing
              ? _buildProcessingView()
              : _buildSuccessReceiptView(),
        ),
      ),
    );
  }

  /// 🔄 Processing View
  Widget _buildProcessingView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        CircularProgressIndicator(
          strokeWidth: 4,
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xffc7834e)),
        ),
        SizedBox(height: 30),
        Text(
          "Processing Payment...",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  /// ✅ Success + Receipt
  Widget _buildSuccessReceiptView() {
    final orderController = Get.find<OrderSummaryController>();
    final items = orderController.items;
    final now = DateTime.now();
    final formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(now);
    final orderId = now.millisecondsSinceEpoch.toString().substring(7);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ✅ Success Header
          const Center(
            child: Icon(Icons.check_circle, color: Colors.green, size: 70),
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              "Payment Successful",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
          ),

          const SizedBox(height: 20),
          const Divider(),

          /// 🏢 Store Info
          const Center(
            child: Text(
              "CHINESE WOK",
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
            ),
          ),
          const SizedBox(height: 6),

          _infoRow("Order ID", "#$orderId"),
          _infoRow("Date", formattedDate),

          const SizedBox(height: 12),
          const Divider(),

          /// 🛒 Items
          const Text(
            "Items",
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
          const SizedBox(height: 10),

          ...items.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(flex: 4, child: Text(item.name)),
                  Expanded(
                    child: Text(
                      "x${item.quantity}",
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
          const Divider(),

          _amountRow("Subtotal", orderController.subTotal),
          _amountRow("Discount", -orderController.couponDiscount),
          _amountRow("GST (5%)", orderController.gstAmount),

          const SizedBox(height: 6),
          const Divider(),

          _amountRow("TOTAL", orderController.payableAmount, isBold: true),

          const SizedBox(height: 20),

          const Center(
            child: Text(
              "Returning to home in 5 seconds...",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(title), Text(value)],
      ),
    );
  }

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
}
