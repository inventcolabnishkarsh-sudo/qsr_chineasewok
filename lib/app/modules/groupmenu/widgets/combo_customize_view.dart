import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../group_menu_controller.dart';
import '../model/cart_item.dart';

class ComboCustomizeView extends StatefulWidget {
  final Map<String, dynamic> comboItem;
  final List<Map<String, dynamic>> bases;
  final CartItem? editingItem; // 👈 ADD THIS

  const ComboCustomizeView({
    super.key,
    required this.comboItem,
    required this.bases,
    this.editingItem,
  });

  @override
  State<ComboCustomizeView> createState() => _ComboCustomizeViewState();
}

class _ComboCustomizeViewState extends State<ComboCustomizeView> {
  int selectedBaseIndex = 0;
  final Map<int, int> selections = {};

  /// baseId -> selectedMenu
  bool get isValid => selections.length == widget.bases.length;
  @override
  void initState() {
    super.initState();

    if (widget.editingItem != null) {
      _prefillSelections();
    }
  }

  void _prefillSelections() {
    final selectedNames = widget.editingItem!.comboItems;

    for (final base in widget.bases) {
      final int baseId = base['BaseId'];

      final menus = List<Map<String, dynamic>>.from(
        base['BaseMenus']['\$values'],
      );

      for (final menu in menus) {
        if (selectedNames.contains(menu['MenuItemName'])) {
          selections[baseId] = menu['Id'];
          break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final base = widget.bases[selectedBaseIndex];
    final menus = List<Map<String, dynamic>>.from(
      base['BaseMenus']['\$values'],
    );

    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias, // 🔥 IMPORTANT
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16), // 🔥 MUST MATCH
        child: SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.9,
          child: Column(
            children: [
              _Header(),

              /// 🧾 SUMMARY
              _SelectionSummary(),
              Expanded(
                child: Row(
                  children: [
                    _BaseList(),

                    /// VERTICAL DIVIDER
                    Container(
                      width: 1,
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      color: Colors.grey.shade300,
                    ),

                    _MenuOptions(base, menus),
                  ],
                ),
              ),

              /// 🔘 ACTIONS
              _Footer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _Header() {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: Color(0xFF1C1C1C),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Customize Combo',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Choose 1 item from each section',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          InkWell(
            onTap: Get.back,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.close, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _BaseList() {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Choose Base',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 14),

          Expanded(
            // 👈 KEY FIX
            child: Scrollbar(
              thumbVisibility: true,
              child: ListView.builder(
                itemCount: widget.bases.length,
                itemBuilder: (context, i) {
                  final base = widget.bases[i];
                  final isCompleted = selections.containsKey(base['BaseId']);
                  final isActive = selectedBaseIndex == i;

                  return GestureDetector(
                    onTap: () => setState(() => selectedBaseIndex = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isActive ? Colors.orange.shade100 : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isCompleted || isActive
                              ? const Color(0xffc7834e)
                              : Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: isCompleted
                                ? Colors.green
                                : Colors.grey.shade300,
                            child: Icon(
                              isCompleted ? Icons.check : Icons.circle_outlined,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              base['BaseName'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _SelectionSummary() {
    if (selections.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(
          top: BorderSide(color: Colors.grey.shade300),
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Selection',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),

          ...widget.bases.map((base) {
            final int baseId = base['BaseId'];
            final int? menuId = selections[baseId];

            if (menuId == null) return const SizedBox.shrink();

            final menus = List<Map<String, dynamic>>.from(
              base['BaseMenus']['\$values'],
            );

            final selectedMenu = menus.firstWhere((m) => m['Id'] == menuId);

            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 18,
                    color: Colors.green, // ✔ tick only, not border
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: '${base['BaseName']}: ',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          TextSpan(
                            text: selectedMenu['MenuItemName'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _MenuOptions(
    Map<String, dynamic> base,
    List<Map<String, dynamic>> menus,
  ) {
    final int baseId = base['BaseId'];
    final int? selectedMenuId = selections[baseId];

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              base['BaseName'],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            const Text(
              'Select one option',
              style: TextStyle(
                fontSize: 14,
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              // 👈 KEY FIX
              child: Scrollbar(
                thumbVisibility: true,
                child: ListView.builder(
                  itemCount: menus.length,
                  itemBuilder: (context, index) {
                    final menu = menus[index];
                    final isSelected = selectedMenuId == menu['Id'];

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selections[baseId] = menu['Id'];
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.orange.shade50
                              : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xffc7834e)
                                : Colors.grey.shade300,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isSelected
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_unchecked,
                              color: isSelected
                                  ? const Color(0xffc7834e)
                                  : Colors.grey,
                              size: 26,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                menu['MenuItemName'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _Footer() {
    final controller = Get.find<GroupMenuController>();
    final theme = Theme.of(context);
    final bool isEditMode = widget.editingItem != null;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: theme.dividerColor)),
      ),
      child: Row(
        children: [
          /// ❌ CANCEL
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: Get.back,
              child: Text(
                'Cancel',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          /// ✅ APPLY / UPDATE
          Expanded(
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>((
                  states,
                ) {
                  return Colors.white; // Always white
                }),
                foregroundColor: MaterialStateProperty.resolveWith<Color>((
                  states,
                ) {
                  return Colors.green;
                }),
                side: MaterialStateProperty.all(
                  const BorderSide(color: Colors.green, width: 2),
                ),
                elevation: MaterialStateProperty.all(0),
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(vertical: 16),
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              onPressed: isValid
                  ? () {
                      if (isEditMode) {
                        controller.updateExistingCombo(
                          widget.editingItem!,
                          selections,
                        );
                      } else {
                        controller.addComboToCart(widget.comboItem, selections);
                      }
                      Get.back();
                    }
                  : null,
              child: Text(
                isEditMode ? 'Update Combo' : 'Add to Cart',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
