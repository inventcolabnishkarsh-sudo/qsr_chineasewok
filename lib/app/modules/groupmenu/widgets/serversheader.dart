import 'package:flutter/material.dart';

class ServesHeader extends StatelessWidget {
  final int serves;

  const ServesHeader({super.key, required this.serves});

  @override
  Widget build(BuildContext context) {
    const Color orange = Color(0xFFE67E30);

    if (serves <= 0) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1.5,
              color: orange.withOpacity(0.35),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 14),
            padding: const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: orange, width: 2),
              boxShadow: [
                BoxShadow(
                  color: orange.withOpacity(0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              servesLabel(serves),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 1.5,
              color: orange.withOpacity(0.35),
            ),
          ),
        ],
      ),
    );
  }
}

String servesLabel(int serves) {
  switch (serves) {
    case 1:
      return 'SERVES 1';
    case 2:
      return 'SERVES 1–2';
    case 3:
      return 'SERVES 2';
    case 4:
      return 'SERVES 2–3';
    case 5:
      return 'SERVES 3';
    case 6:
      return 'SERVES 3+';
    default:
      return '';
  }
}

