import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class PriceOptionCard extends StatelessWidget {
  final String label;
  final int price;
  final int qty;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const PriceOptionCard({
    required this.label,
    required this.price,
    required this.qty,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade500),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          /// TITLE
          Text(
            '$label (₹$price)',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),

          /// ACTION AREA (NO ANIMATION)
          if (qty == 0)
            SizedBox(
              height: 44,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onAdd,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffc7834e),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Add',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
              ),
            )
          else
            Container(
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xffc7834e),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: onRemove,
                    icon: const Icon(Icons.remove),
                  ),
                  Text(
                    '$qty',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  IconButton(onPressed: onAdd, icon: const Icon(Icons.add)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
