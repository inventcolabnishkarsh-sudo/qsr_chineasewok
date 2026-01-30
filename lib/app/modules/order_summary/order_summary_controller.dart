import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';
import '../groupmenu/group_menu_controller.dart';
import '../groupmenu/model/cart_item.dart';
import '../home/home_controller.dart';

class OrderSummaryController extends GetxController {
  late final RxMap<String, CartItem> cart;
  late final GroupMenuController groupController;
  late final OrderType orderType;

  /// 🎟️ COUPON
  final couponController = TextEditingController();
  final RxBool isCouponApplied = false.obs;
  final RxBool isApplyEnabled = false.obs;
  final RxString appliedCoupon = ''.obs;

  /// example flat discount
  final int couponDiscountValue = 10;

  /// 🎉 CONFETTI
  late final ConfettiController confettiController;
  @override
  void onInit() {
    super.onInit();

    groupController = Get.find<GroupMenuController>();
    cart = groupController.cart;
    orderType = groupController.orderType;
    confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
  }

  /// 🧮 CART TOTALS
  int get totalItems => cart.values.fold(0, (sum, item) => sum + item.quantity);

  int get subTotal => cart.values.fold(0, (sum, item) => sum + item.total);

  /// 🎟️ DISCOUNT
  int get couponDiscount => isCouponApplied.value ? couponDiscountValue : 0;

  int get taxableAmount => (subTotal - couponDiscount).clamp(0, subTotal);

  /// 🧾 GST
  double get gstPercent => 5;

  double get gstAmount =>
      double.parse(((taxableAmount * gstPercent) / 100).toStringAsFixed(2));

  /// 💰 FINAL PAYABLE
  double get payableAmount =>
      double.parse((taxableAmount + gstAmount).toStringAsFixed(2));

  List<CartItem> get items => cart.values.toList();

  /// ➕ INCREASE ITEM
  void increaseItem(CartItem item) {
    final entry = groupController.cart.entries.firstWhere(
      (e) => identical(e.value, item),
    );

    groupController.increaseExistingCartItem(entry.key);
  }

  /// ➖ DECREASE ITEM
  void decreaseItem(CartItem item) {
    if (item.portion == 'combo') {
      groupController.removeOneCombo(item.menuId);
    } else {
      groupController.removeFromCart(item.menuId, item.portion);
    }
  }

  /// 🎟️ COUPON
  void onCouponChanged(String value) {
    isApplyEnabled.value = value.trim().isNotEmpty;
  }

  void applyCoupon() {
    if (!isApplyEnabled.value) return;

    appliedCoupon.value = couponController.text.trim();
    isCouponApplied.value = true;
    isApplyEnabled.value = false;

    /// 🎉 CONFETTI BLAST
    confettiController.play();
  }

  void removeCoupon() {
    couponController.clear();
    appliedCoupon.value = '';
    isCouponApplied.value = false;
    isApplyEnabled.value = false;
  }

  /// ✏️ MODIFY COMBO
  void modifyCombo(CartItem item) {
    // 1️⃣ Remove one quantity of this combo
    groupController.removeOneCombo(item.menuId);

    // 2️⃣ Find original combo menu item
    final comboItem = groupController.allMenuItems.firstWhereOrNull(
      (e) =>
          e['Menu'] != null &&
          e['Menu']['Id'] == item.menuId &&
          e['Menu']['Bases'] != null,
    );

    if (comboItem == null) {
      Get.snackbar(
        'Modify Failed',
        'Unable to load combo details',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // 3️⃣ Open combo customizer again
    groupController.openComboCustomizer(comboItem);
  }

  void placeOrder() {
    Get.toNamed(
      AppRoutes.finalizeOrder,
      arguments: {
        'orderType': orderType,
        'cart': cart.values.toList(),
        'subTotal': subTotal,
        'gst': gstAmount,
        'discount': couponDiscount,
        'payableAmount': payableAmount,
      },
    );
  }

  @override
  void onClose() {
    couponController.dispose();
    confettiController.dispose(); // 👈 add this
    super.onClose();
  }
}
