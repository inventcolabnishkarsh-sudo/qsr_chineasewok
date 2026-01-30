import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qsr_chineasewok_kiosk/app/modules/groupmenu/widgets/price_option_card.dart';
import 'package:qsr_chineasewok_kiosk/app/modules/groupmenu/widgets/veg_nonveg_icon.dart';

import '../group_menu_controller.dart';

class MenuItemCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const MenuItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final menu = item['Menu']; // item = OutletMenu

    final bool isVeg = menu['VegNonVeg'] == 1;

    // 🔥 CORRECT KEYS
    final bool isHalfAvailable = item['IsHalfAvailable'] == true;
    final int halfPrice = item['HalfPrice'] ?? 0;
    final int fullPrice = item['Price'] ?? 0;
    final bool showServesHeader =
        Get.find<GroupMenuController>().shouldShowServesHeader;

    final int menuItemType = menu['MenuItemType'] ?? 1;
    final bool isCombo = menuItemType == 2;
    final controller = Get.find<GroupMenuController>();
    final int menuId = menu['Id'];
    Uint8List? imageBytes;
    if (menu['ImageBase64'] != null &&
        menu['ImageBase64'].toString().isNotEmpty) {
      try {
        imageBytes = base64Decode(menu['ImageBase64']);
      } catch (_) {}
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange.shade400, width: 2),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /// 🔝 TOP ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              VegNonVegIcon(isVeg: isVeg),

              Expanded(
                child: (showServesHeader && isCombo)
                    ? Text(
                  menu['ComboTitle'] ?? '',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF243A8F),
                  ),
                )
                    : const SizedBox.shrink(),
              ),

              const Icon(Icons.info_outline, size: 22, color: Colors.black),
            ],
          ),

          const SizedBox(height: 12),

          /// 🖼️ IMAGE
          SizedBox(
            height: 140, // 👈 controls card height safely
            child: Center(
              child: imageBytes != null
                  ? Image.memory(imageBytes!, fit: BoxFit.contain)
                  : Image.asset(
                'assets/images/menu_placeholder.png',
                fit: BoxFit.contain,
              ),
            ),
          ),

          const SizedBox(height: 12),

          /// 🧾 DESCRIPTION STRIP
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF4EFEF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              menu['MenuItemName'] ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF243A8F),
              ),
            ),
          ),

          const SizedBox(height: 10),

          /// 💰 PRICE
          const SizedBox(height: 12),

          if (isHalfAvailable)
            Row(
              children: [
                /// HALF
                Expanded(
                  child: Obx(() {
                    final qty = controller.getQuantity(menuId, 'half');
                    return PriceOptionCard(
                      label: 'Half',
                      price: halfPrice,
                      qty: qty,
                      onAdd: () => controller.addToCart(item, portion: 'half'),
                      onRemove: () => controller.removeFromCart(menuId, 'half'),
                    );
                  }),
                ),

                const SizedBox(width: 12),

                /// FULL
                Expanded(
                  child: Obx(() {
                    final qty = controller.getQuantity(menuId, 'full');
                    return PriceOptionCard(
                      label: 'Full',
                      price: fullPrice,
                      qty: qty,
                      onAdd: () => controller.addToCart(item, portion: 'full'),
                      onRemove: () => controller.removeFromCart(menuId, 'full'),
                    );
                  }),
                ),
              ],
            )
          else
            Column(
              children: [
                /// 💰 PRICE
                Text(
                  '₹$fullPrice',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.deepOrange,
                  ),
                ),
              ],
            ),
          if (!isHalfAvailable)
            Obx(() {
              final qty = controller.getQuantity(menuId, 'full');

              if (qty == 0) {
                return SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () =>
                        controller.addToCart(item, portion: 'full'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF6C343),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Add',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                );
              }

              return Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFF6C343),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () =>
                          controller.removeFromCart(menuId, 'full'),
                      icon: const Icon(Icons.remove),
                    ),
                    Text(
                      '$qty',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    IconButton(
                      onPressed: () =>
                          controller.addToCart(item, portion: 'full'),
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}
