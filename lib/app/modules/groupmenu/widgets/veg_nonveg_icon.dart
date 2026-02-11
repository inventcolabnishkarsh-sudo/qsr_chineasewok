import 'package:flutter/material.dart';

class VegNonVegIcon extends StatelessWidget {
  final bool? isVeg;

  const VegNonVegIcon({required this.isVeg, super.key});

  @override
  Widget build(BuildContext context) {
    if (isVeg == null) {
      return const SizedBox.shrink();
    }

    final color = isVeg! ? Colors.green : Colors.red;

    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
      ),
    );
  }
}
