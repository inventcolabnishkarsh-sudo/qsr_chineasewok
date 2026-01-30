import 'dart:typed_data';

class CartItem {
  final int menuId;
  final String name;
  final int price;
  final String portion;
  int quantity;

  final Uint8List? imageBytes;

  final int? serves;
  final bool? isVeg;

  /// ✅ NEW: combo breakdown
  final List<String>? comboItems;

  CartItem({
    required this.menuId,
    required this.name,
    required this.price,
    required this.portion,
    this.quantity = 1,
    this.imageBytes,
    this.serves,
    this.isVeg,
    this.comboItems,
  });

  int get total => price * quantity;
}
