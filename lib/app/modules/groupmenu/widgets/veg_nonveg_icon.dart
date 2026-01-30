import 'package:flutter/material.dart';

class VegNonVegIcon extends StatelessWidget {
  final bool isVeg;

  const VegNonVegIcon({required this.isVeg});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        border: Border.all(color: isVeg ? Colors.green : Colors.red, width: 2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: isVeg ? Colors.green : Colors.red,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
