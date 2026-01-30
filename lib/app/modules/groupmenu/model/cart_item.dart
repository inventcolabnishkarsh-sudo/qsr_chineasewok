class CartItem {
  final int menuId;
  final String name;
  final int price;
  final String portion; // half | full
  int quantity;

  CartItem({
    required this.menuId,
    required this.name,
    required this.price,
    required this.portion,
    this.quantity = 1,
  });

  int get total => price * quantity;
}
