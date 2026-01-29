import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'group_menu_controller.dart';
import 'widgets/serversheader.dart';

class GroupMenuView extends GetView<GroupMenuController> {
  const GroupMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    const Color kPrimaryOrange = Color(0xFFE67E30);
    const Color kBorderLight = Color(0xFFE0E0E0);

    return Scaffold(
      backgroundColor: Colors.white,

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
                              () => _GroupCard(
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
                  child: Obx(() {
                    controller.selectedCategoryIndex.value;
                    controller.selectedGroupIndex.value;
                    final categories = controller.categories;

                    if (categories.isEmpty) {
                      return const Center(child: Text('No items available'));
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 15),

                        /// 🏷️ CATEGORY TAGS
                        SizedBox(
                          height: 64,
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                categories.length + 1, // All + categories
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 18),
                            itemBuilder: (context, index) {
                              final bool isAll = index == 0;
                              final int actualIndex = index - 1;

                              final bool isSelected = isAll
                                  ? controller.selectedCategoryIndex.value == -1
                                  : controller.selectedCategoryIndex.value ==
                                        actualIndex;

                              final String title = isAll
                                  ? 'All'
                                  : categories[actualIndex]['CategoryName'] ??
                                        '';

                              return GestureDetector(
                                onTap: () {
                                  if (isAll) {
                                    controller.selectedCategoryIndex.value = -1;
                                  } else {
                                    controller.onCategorySelected(actualIndex);
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

                                    /// 🔥 INNER ORANGE SHADOW (only when NOT selected)
                                    boxShadow: isSelected
                                        ? []
                                        : [
                                            BoxShadow(
                                              color: kPrimaryOrange.withOpacity(
                                                0.35,
                                              ),
                                              offset: const Offset(0, 4),
                                              blurRadius: 6,
                                              spreadRadius:
                                                  -4, // 👈 creates inset effect
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

                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
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
                                    (maxWidth - ((columns - 1) * 16)) / columns;

                                final grouped =
                                    controller.menuItemsGroupedByServes;

                                return Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: grouped.entries.map((entry) {
                                    final serves = entry.key;
                                    final items = entry.value;

                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        /// 🟠 SERVES HEADER
                                        ServesHeader(serves: serves),

                                        /// 🧩 ITEMS GRID
                                        Wrap(
                                          spacing: 16,
                                          runSpacing: 16,
                                          children: items.map((item) {
                                            final menu = item['Menu'];

                                            return SizedBox(
                                              width: itemWidth,
                                              child: _MenuItemCard(menu: menu),
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
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  final String title;
  final Uint8List? imageBytes;
  final bool isSelected;
  final VoidCallback onTap;

  const _GroupCard({
    required this.title,
    required this.onTap,
    required this.isSelected,
    this.imageBytes,
  });

  @override
  Widget build(BuildContext context) {
    const Color kOrange = Color(0xFFE67E30);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF3E8) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? kOrange : Colors.grey.shade300,
            width: 1.3,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// 🖼 IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: imageBytes != null
                  ? Image.memory(
                      imageBytes!,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/images/menu_placeholder.png',
                      width: 56,
                      height: 56,
                    ),
            ),

            const SizedBox(height: 10),

            /// 📝 NAME
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: Colors.black,
                height: 1.2,
              ),
            ),

            /// 🟠 ACTIVE INDICATOR
            if (isSelected) ...[
              const SizedBox(height: 8),
              Container(
                width: 28,
                height: 4,
                decoration: BoxDecoration(
                  color: kOrange,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MenuItemCard extends StatelessWidget {
  final Map<String, dynamic> menu;

  const _MenuItemCard({required this.menu});

  @override
  Widget build(BuildContext context) {
    final bool isVeg = menu['VegNonVeg'] == 1;

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
              _VegNonVegIcon(isVeg: isVeg),

              Expanded(
                child: Text(
                  menu['ComboTitle'] ?? '',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF243A8F), // dark blue
                  ),
                ),
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
          Text(
            '₹${menu['Price']}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Colors.deepOrange,
            ),
          ),

          const SizedBox(height: 10),

          /// ➕ ADD BUTTON
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Add to cart
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF6C343), // yellow
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Add',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VegNonVegIcon extends StatelessWidget {
  final bool isVeg;

  const _VegNonVegIcon({required this.isVeg});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        border: Border.all(color: isVeg ? Colors.green : Colors.red, width: 2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: isVeg ? Colors.green : Colors.red,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
