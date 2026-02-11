import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qsr_chineasewok_kiosk/app/modules/groupmenu/widgets/combo_customize_view.dart';
import '../../routes/app_routes.dart';
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

  int getComboQuantity(int menuId) {
    return cart.values
        .where((e) => e.menuId == menuId && e.portion == 'combo')
        .fold(0, (sum, e) => sum + e.quantity);
  }

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

  void openComboCustomizer(Map<String, dynamic> item, {CartItem? editingItem}) {
    final basesNode = item['Menu']?['Bases'];

    if (basesNode == null || basesNode['\$values'] == null) return;

    final bases = List<Map<String, dynamic>>.from(basesNode['\$values']);

    Get.dialog(
      ComboCustomizeView(
        comboItem: item,
        bases: bases,
        editingItem: editingItem, // ✅ pass it
      ),
      barrierDismissible: false,
    );
  }

  void addComboToCart(
    Map<String, dynamic> comboItem,
    Map<int, int> selections,
  ) {
    final menu = comboItem['Menu'];
    final int menuId = menu['Id'];
    final String comboName = menu['MenuItemName'];
    final int price = comboItem['Price'];

    final bases = List<Map<String, dynamic>>.from(menu['Bases']['\$values']);
    final value = menu['VegNonVeg'];

    bool? vegFlag;
    if (value == 1) {
      vegFlag = true;
    } else if (value == 2) {
      vegFlag = false;
    } else {
      vegFlag = null;
    }

    /// Resolve selected menu names
    final selectedNames = <String>[];

    for (final base in bases) {
      final int baseId = base['BaseId'];
      final int selectedMenuId = selections[baseId]!;

      final menus = List<Map<String, dynamic>>.from(
        base['BaseMenus']['\$values'],
      );

      final selectedMenu = menus.firstWhere((m) => m['Id'] == selectedMenuId);
      selectedNames.add(selectedMenu['MenuItemName']);
    }

    final key = '${menuId}_combo_${selections.values.join("_")}';

    if (cart.containsKey(key)) {
      /// 🔁 INCREMENT QUANTITY
      cart[key]!.quantity++;
    } else {
      Uint8List? imageBytes;
      final base64 = menu['ImageBase64'];
      if (base64 != null && base64.toString().isNotEmpty) {
        try {
          imageBytes = base64Decode(base64);
        } catch (_) {}
      }

      cart[key] = CartItem(
        menuId: menuId,
        name: comboName,
        price: price,
        portion: 'combo',
        imageBytes: imageBytes,
        serves: menu['Serves'],
       // isVeg: menu['VegNonVeg'] == 1,
        isVeg: vegFlag,
        comboItems: selectedNames,
      );
    }

    /// 🔥 FORCE UI UPDATE
    cart.refresh();
  }

  /// ✏️ UPDATE EXISTING COMBO (MODIFY FLOW)
  void updateExistingCombo(CartItem editingItem, Map<int, int> selections) {
    final comboItem = allMenuItems.firstWhere(
      (e) => e['Menu'] != null && e['Menu']['Id'] == editingItem.menuId,
    );

    final menu = comboItem['Menu'];
    final bases = List<Map<String, dynamic>>.from(menu['Bases']['\$values']);

    final updatedNames = <String>[];

    for (final base in bases) {
      final int baseId = base['BaseId'];
      final int selectedMenuId = selections[baseId]!;

      final menus = List<Map<String, dynamic>>.from(
        base['BaseMenus']['\$values'],
      );

      final selectedMenu = menus.firstWhere((m) => m['Id'] == selectedMenuId);

      updatedNames.add(selectedMenu['MenuItemName']);
    }

    /// ✅ SAFE UPDATE
    editingItem.comboItems = List<String>.from(updatedNames);

    cart.refresh();
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
    final value = menu['VegNonVeg'];

    bool? vegFlag;
    if (value == 1) {
      vegFlag = true;
    } else if (value == 2) {
      vegFlag = false;
    } else {
      vegFlag = null; // drinks / not applicable
    }

    if (cart.containsKey(key)) {
      cart[key]!.quantity++;
      cart.refresh();
    } else {
      Uint8List? imageBytes;
      final base64 = menu['ImageBase64'];
      if (base64 != null && base64.toString().isNotEmpty) {
        try {
          imageBytes = base64Decode(base64);
        } catch (_) {}
      }

      cart[key] = CartItem(
        menuId: menuId,
        name: '$name (${portion.toUpperCase()})',
        price: price,
        portion: portion,
        imageBytes: imageBytes,
        serves: null,
        // isVeg: menu['VegNonVeg'] == 1,
        isVeg: vegFlag,
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

  void removeOneCombo(int menuId) {
    MapEntry<String, CartItem>? comboEntry;

    for (final entry in cart.entries) {
      if (entry.value.menuId == menuId && entry.value.portion == 'combo') {
        comboEntry = entry;
        break;
      }
    }

    if (comboEntry == null) return;

    final key = comboEntry.key;

    if (cart[key]!.quantity > 1) {
      cart[key]!.quantity--;
    } else {
      cart.remove(key); // qty == 1 → clear combo
    }

    cart.refresh();
  }

  /// 🔢 Quantity
  int getQuantity(int menuId, String portion) {
    return cart[_cartKey(menuId, portion)]?.quantity ?? 0;
  }

  /// 🧹 Clear cart
  void clearCart() {
    cart.clear();
  }

  void goToOrderSummary() {
    if (cart.isEmpty) return;

    Get.toNamed(
      AppRoutes.orderSummary,
      arguments: {'orderType': orderType, 'cart': cart},
    );
  }

  void increaseExistingCartItem(String cartKey) {
    if (!cart.containsKey(cartKey)) return;

    cart[cartKey]!.quantity++;
    cart.refresh();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
