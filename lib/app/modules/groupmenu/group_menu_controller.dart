import 'dart:convert';
import 'dart:typed_data';
import 'package:get/get.dart';
import '../home/home_controller.dart';
import '../splash/menu_data_service.dart';

class GroupMenuController extends GetxController {
  late final OrderType orderType;

  final RxInt selectedGroupIndex = 0.obs;
  final RxInt selectedCategoryIndex = (-1).obs; // -1 = ALL

  late final List<Map<String, dynamic>> groups;

  final Map<int, Uint8List> groupImages = {};

  @override
  void onInit() {
    super.onInit();

    orderType = Get.arguments as OrderType;

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

  void onGroupSelected(int index) {
    selectedGroupIndex.value = index;
    selectedCategoryIndex.value = -1; // 🔥 All selected
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
}
