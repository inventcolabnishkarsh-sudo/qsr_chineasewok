import 'dart:typed_data';

import 'package:flutter/material.dart';

class GroupCard extends StatelessWidget {
  final String title;
  final Uint8List? imageBytes;
  final bool isSelected;
  final VoidCallback onTap;

  const GroupCard({
    required this.title,
    required this.onTap,
    required this.isSelected,
    this.imageBytes,
  });

  @override
  Widget build(BuildContext context) {
    const Color kOrange = Color(0xFFE67E30);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF3E8) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? kOrange : Colors.grey.shade300,
            width: 1.3,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// 🖼 IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: imageBytes != null
                  ? Image.memory(
                imageBytes!,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
              )
                  : Image.asset(
                'assets/images/menu_placeholder.png',
                width: 56,
                height: 56,
              ),
            ),

            const SizedBox(height: 10),

            /// 📝 NAME
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: Colors.black,
                height: 1.2,
              ),
            ),

            /// 🟠 ACTIVE INDICATOR
            if (isSelected) ...[
              const SizedBox(height: 8),
              Container(
                width: 28,
                height: 4,
                decoration: BoxDecoration(
                  color: kOrange,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
