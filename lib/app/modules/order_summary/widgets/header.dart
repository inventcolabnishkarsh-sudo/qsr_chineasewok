import 'package:flutter/material.dart';

import '../../home/home_controller.dart';

class Header extends StatelessWidget {
  final OrderType orderType;
  const Header(this.orderType);

  @override
  Widget build(BuildContext context) {
    final isDineIn = orderType == OrderType.dineIn;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset('assets/images/logo/homelogo.png', height: 48),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isDineIn ? Colors.green : Colors.orange,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isDineIn ? 'DINE IN' : 'TAKEAWAY',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
