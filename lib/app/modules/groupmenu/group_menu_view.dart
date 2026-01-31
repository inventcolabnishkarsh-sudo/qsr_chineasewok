import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qsr_chineasewok_kiosk/app/modules/groupmenu/widgets/menu_item_cards.dart';
import 'group_menu_controller.dart';
import 'widgets/group_cards.dart';
import 'widgets/serversheader.dart';
import 'package:collection/collection.dart';

class GroupMenuView extends GetView<GroupMenuController> {
  const GroupMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    const Color kPrimaryOrange = Color(0xFFE67E30);
    const Color kBorderLight = Color(0xFFE0E0E0);

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Obx(() {
        if (!controller.hasItems) return const SizedBox.shrink();

        return Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: const BoxDecoration(color: Color(0xFFF47920)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// 🧾 INFO
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your ${controller.totalItems} item(s) have been added to the cart',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Total Amount: ₹${controller.totalAmount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  /// 🗑️ CLEAR CART
                  InkWell(
                    onTap: controller.clearCart,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.delete, color: Colors.black),
                          SizedBox(width: 8),
                          Text(
                            'Clear Cart',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  /// 🛒 VIEW ORDERS
                  InkWell(
                    onTap: controller.goToOrderSummary,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.shopping_cart, color: Colors.black),
                          SizedBox(width: 8),
                          Text(
                            'View Orders',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),

      body: Column(
        children: [
          /// 🖤 HEADER
          SizedBox(
            height: 120,
            child: Column(
              children: [
                Container(
                  height: 117,
                  width: double.infinity,
                  color: Colors.black,
                  child: Center(
                    child: Image.asset(
                      'assets/images/logo/homelogo.png',
                      height: 60,
                    ),
                  ),
                ),
                Container(height: 3, color: Colors.red),
              ],
            ),
          ),

          /// 🧩 BODY
          Expanded(
            child: Row(
              children: [
                /// ⬅️ LEFT CATEGORY PANEL
                Container(
                  width: 190,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      right: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// 🟠 HEADER
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 22, 20, 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'GROUPS',
                              style: GoogleFonts.pacifico(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.4,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// 📋 GROUP LIST
                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.fromLTRB(14, 16, 14, 24),
                          itemCount: controller.groups.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 14),
                          itemBuilder: (context, index) {
                            final group = controller.groups[index];

                            return Obx(
                              () => GroupCard(
                                title: group['GroupName'] ?? '',
                                imageBytes: controller.groupImages[index],
                                isSelected:
                                    controller.selectedGroupIndex.value ==
                                    index,
                                onTap: () => controller.onGroupSelected(index),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                /// ➡️ RIGHT CONTENT (AUTO UPDATES)
                Expanded(
                  child: Stack(
                    children: [
                      Obx(() {
                        controller.selectedCategoryIndex.value;
                        controller.selectedGroupIndex.value;
                        final categories = controller.categories;

                        if (categories.isEmpty) {
                          return const Center(
                            child: Text('No items available'),
                          );
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 15),

                            /// 🏷️ CATEGORY TAGS
                            SizedBox(
                              height: 64,
                              child: ListView.separated(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                scrollDirection: Axis.horizontal,
                                itemCount: categories.length + 1,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: 18),
                                itemBuilder: (context, index) {
                                  final bool isAll = index == 0;
                                  final int actualIndex = index - 1;

                                  final bool isSelected = isAll
                                      ? controller
                                                .selectedCategoryIndex
                                                .value ==
                                            -1
                                      : controller
                                                .selectedCategoryIndex
                                                .value ==
                                            actualIndex;

                                  final String title = isAll
                                      ? 'All'
                                      : categories[actualIndex]['CategoryName'] ??
                                            '';

                                  return GestureDetector(
                                    onTap: () {
                                      if (isAll) {
                                        controller.selectedCategoryIndex.value =
                                            -1;
                                      } else {
                                        controller.onCategorySelected(
                                          actualIndex,
                                        );
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 28,
                                        vertical: 14,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? kPrimaryOrange
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(32),
                                        border: Border.all(
                                          color: isSelected
                                              ? Colors.transparent
                                              : kBorderLight,
                                        ),
                                        boxShadow: isSelected
                                            ? []
                                            : [
                                                BoxShadow(
                                                  color: kPrimaryOrange
                                                      .withOpacity(0.35),
                                                  offset: const Offset(0, 4),
                                                  blurRadius: 6,
                                                  spreadRadius: -4,
                                                ),
                                              ],
                                      ),
                                      child: Text(
                                        title.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.6,
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 16),

                            /// 📜 SCROLLABLE CONTENT
                            Expanded(
                              child: Scrollbar(
                                controller: controller.scrollController,
                                thumbVisibility:
                                    true, // 👈 always visible (kiosk friendly)
                                thickness: 6,
                                radius: const Radius.circular(8),
                                child: SingleChildScrollView(
                                  controller: controller.scrollController,
                                  padding: const EdgeInsets.fromLTRB(
                                    24,
                                    8,
                                    24,
                                    24,
                                  ),
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      final maxWidth = constraints.maxWidth;

                                      int columns = 1;
                                      if (maxWidth >= 1200) {
                                        columns = 3;
                                      } else if (maxWidth >= 800) {
                                        columns = 2;
                                      }

                                      final itemWidth =
                                          (maxWidth - ((columns - 1) * 16)) /
                                          columns;

                                      final grouped =
                                          controller.menuItemsGroupedByServes;

                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: grouped.entries.map((entry) {
                                          final serves = entry.key;
                                          final items = entry.value;
                                          final showServesHeader =
                                              controller
                                                  .shouldShowServesHeader &&
                                              serves > 0;

                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              if (showServesHeader)
                                                ServesHeader(serves: serves),

                                              Wrap(
                                                spacing: 16,
                                                runSpacing: 16,
                                                children: items.map((item) {
                                                  return SizedBox(
                                                    width: itemWidth,
                                                    child: MenuItemCard(
                                                      item: item,
                                                    ),
                                                  );
                                                }).toList(),
                                              ),

                                              const SizedBox(height: 24),
                                            ],
                                          );
                                        }).toList(),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),

                      /// ⬆️ FLOATING TOP BUTTON
                      Obx(() {
                        if (!controller.showTopButton.value) {
                          return const SizedBox.shrink();
                        }

                        return Positioned(
                          bottom: 24,
                          right: 24,
                          child: FloatingActionButton.extended(
                            onPressed: controller.scrollToTop,
                            backgroundColor: kPrimaryOrange,
                            icon: const Icon(
                              Icons.arrow_upward,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Top',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
