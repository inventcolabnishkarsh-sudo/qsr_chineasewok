import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;

  const OrderCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(26),
      onTap: onTap,
      child: Card(
        color: Colors.white,
        elevation: 12,
        shadowColor: Colors.black38,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26),
          side: BorderSide(
            color: Colors.black.withOpacity(0.35), // subtle border
            width: 0.6, // 👈 VERY THIN
          ),
        ),
        child: SizedBox(
          width: 240,
          height: 340,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(imagePath, width: 170, height: 170),

              const SizedBox(height: 18),

              Divider(thickness: 1, color: Colors.grey.shade400),

              const SizedBox(height: 14),

              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
