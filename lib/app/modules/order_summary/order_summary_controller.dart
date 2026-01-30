import 'package:get/get.dart';
import '../groupmenu/model/cart_item.dart';

class OrderSummaryController extends GetxController {
  late final Map<String, CartItem> cart;

  @override
  void onInit() {
    super.onInit();
    cart = Get.arguments as Map<String, CartItem>;
  }

  int get totalItems => cart.values.fold(0, (sum, item) => sum + item.quantity);

  int get totalAmount => cart.values.fold(0, (sum, item) => sum + item.total);

  List<CartItem> get items => cart.values.toList();
}
