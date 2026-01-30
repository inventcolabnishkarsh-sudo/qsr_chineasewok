import 'package:flutter/material.dart';

import '../../home/home_controller.dart';

class Header extends StatelessWidget {
  final OrderType orderType;
  const Header(this.orderType);

  @override
  Widget build(BuildContext context) {
    final isDineIn = orderType == OrderType.dineIn;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      color: Colors.white,
      child: Row(
        children: [
          /// 🍜 LOGO
          Image.asset(
            'assets/images/logo.png', // 👈 your logo
            height: 40,
          ),

          const Spacer(),

          /// 🍽️ ORDER TYPE CHIP
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: isDineIn ? Colors.green.shade50 : Colors.blue.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDineIn ? Colors.green : Colors.blue,
              ),
            ),
            child: Text(
              isDineIn ? 'DINE IN' : 'TAKEAWAY',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: isDineIn ? Colors.green : Colors.blue,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
