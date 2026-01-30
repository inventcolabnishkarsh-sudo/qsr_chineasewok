import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../home/home_controller.dart';
import '../splash/menu_data_service.dart';
import 'model/cart_item.dart';

class GroupMenuController extends GetxController {
  late final OrderType orderType;

  final RxInt selectedGroupIndex = 0.obs;
  final RxInt selectedCategoryIndex = (-1).obs; // -1 = ALL

  late final List<Map<String, dynamic>> groups;

  final Map<int, Uint8List> groupImages = {};

  final ScrollController scrollController = ScrollController();
  final RxBool showTopButton = false.obs;

  /// 🔑 cart key = menuId_portion (e.g. 12_half)
  final RxMap<String, CartItem> cart = <String, CartItem>{}.obs;

  String _cartKey(int menuId, String portion) => '${menuId}_$portion';

  /// 🧮 Cart totals
  int get totalItems => cart.values.fold(0, (sum, item) => sum + item.quantity);

  int get totalAmount => cart.values.fold(0, (sum, item) => sum + item.total);

  bool get hasItems => cart.isNotEmpty;

  @override
  void onInit() {
    super.onInit();

    orderType = Get.arguments as OrderType;
    scrollController.addListener(() {
      showTopButton.value = scrollController.offset > 300;
    });
    final menuService = Get.find<MenuDataService>();
    groups = menuService.groups;

    /// Decode group images once
    for (int i = 0; i < groups.length; i++) {
      final base64Img = groups[i]['GroupImage'];
      if (base64Img != null && base64Img.toString().isNotEmpty) {
        try {
          groupImages[i] = base64Decode(base64Img);
        } catch (_) {}
      }
    }

    /// ✅ Default: first group + ALL categories
    if (groups.isNotEmpty) {
      selectedGroupIndex.value = 0;
      selectedCategoryIndex.value = -1; // 🔥 KEEP ALL
    }
  }

  void scrollToTop() {
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  void onGroupSelected(int index) {
    selectedGroupIndex.value = index;
    scrollToTop();
  }

  void onCategorySelected(int index) {
    selectedCategoryIndex.value = index;
  }

  Map<String, dynamic> get selectedGroup => groups[selectedGroupIndex.value];

  List<Map<String, dynamic>> get categories {
    final node = selectedGroup['Categories'];
    if (node == null || node['\$values'] == null) return [];
    return List<Map<String, dynamic>>.from(node['\$values']);
  }

  Map<String, dynamic>? get selectedCategory {
    if (selectedCategoryIndex.value == -1) return null;
    if (categories.isEmpty) return null;
    return categories[selectedCategoryIndex.value];
  }

  List<Map<String, dynamic>> get allMenuItems {
    final List<Map<String, dynamic>> items = [];

    for (final cat in categories) {
      final outletMenu = cat['OutletMenu'];
      if (outletMenu != null && outletMenu['\$values'] != null) {
        items.addAll(List<Map<String, dynamic>>.from(outletMenu['\$values']));
      }
    }
    return items;
  }

  List<Map<String, dynamic>> get selectedMenuItems {
    // ✅ ALL
    if (selectedCategoryIndex.value == -1) {
      return allMenuItems;
    }

    final cat = selectedCategory;
    if (cat == null) return [];

    final outletMenu = cat['OutletMenu'];
    if (outletMenu == null || outletMenu['\$values'] == null) return [];

    return List<Map<String, dynamic>>.from(outletMenu['\$values']);
  }

  Map<int, List<Map<String, dynamic>>> get menuItemsGroupedByServes {
    final items = selectedMenuItems;

    final Map<int, List<Map<String, dynamic>>> grouped = {};

    for (final item in items) {
      final menu = item['Menu'];
      final int serves = menu['Serves'] ?? 0;

      grouped.putIfAbsent(serves, () => []);
      grouped[serves]!.add(item);
    }

    // sort by serves ascending
    final sortedKeys = grouped.keys.toList()..sort();
    return {for (final k in sortedKeys) k: grouped[k]!};
  }

  bool get shouldShowServesHeader {
    final grouped = menuItemsGroupedByServes;

    // If only one group → no need to show header
    if (grouped.length <= 1) return false;

    // If serves keys are invalid (0 or null)
    final validServes = grouped.keys.where((s) => s > 0).toList();
    return validServes.isNotEmpty;
  }

  /// ➕ ADD (HALF / FULL)
  void addToCart(
    Map<String, dynamic> item, {
    required String portion, // half | full
  }) {
    final menu = item['Menu'];
    final int menuId = menu['Id'];
    final String name = menu['MenuItemName'];

    final int price = portion == 'half' ? item['HalfPrice'] : item['Price'];

    final key = _cartKey(menuId, portion);

    if (cart.containsKey(key)) {
      cart[key]!.quantity++;
      cart.refresh();
    } else {
      cart[key] = CartItem(
        menuId: menuId,
        name: '$name (${portion.toUpperCase()})',
        price: price,
        portion: portion,
      );
    }
  }

  /// ➖ REMOVE
  void removeFromCart(int menuId, String portion) {
    final key = _cartKey(menuId, portion);

    if (!cart.containsKey(key)) return;

    if (cart[key]!.quantity > 1) {
      cart[key]!.quantity--;
      cart.refresh();
    } else {
      cart.remove(key);
    }
  }

  /// 🔢 Quantity
  int getQuantity(int menuId, String portion) {
    return cart[_cartKey(menuId, portion)]?.quantity ?? 0;
  }

  /// 🧹 Clear cart
  void clearCart() {
    cart.clear();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
