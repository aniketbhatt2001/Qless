import 'package:flutter/material.dart';

/// Category filter chips widget for filtering menu items.
///
/// Displays horizontal scrollable chips for category filtering.
/// Allows users to filter menu items by category (All, Main, Drink, Snack).
class HomeCategoryFilterChips extends StatelessWidget {
  final String? selectedCategory;
  final ValueChanged<String?> onCategorySelected;

  const HomeCategoryFilterChips({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final chips = [
      {'label': 'All', 'asset': null, 'color': null},
      {
        'label': 'Main',
        'asset': 'assets/main-food.png',
        'color': const Color(0xFFE11D8F),
      },
      {
        'label': 'Drink',
        'asset': 'assets/drinks.png',
        'color': const Color(0xFF6366F1),
      },
      {
        'label': 'Snack',
        'asset': 'assets/snacks.png',
        'color': const Color(0xFFF97316),
      },
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: chips.map((chip) {
            final label = chip['label'] as String;
            final asset = chip['asset'] as String?;
            final chipColor = chip['color'] as Color?;
            final isAll = label == 'All';
            final isSelected =
                isAll ? selectedCategory == null : selectedCategory == label;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () {
                  onCategorySelected(isAll ? null : label);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (asset != null)
                        Image.asset(
                          asset,
                          width: 14,
                          height: 14,
                          color: isSelected ? Colors.white : chipColor,
                        )
                      else
                        Icon(
                          Icons.restaurant_menu_rounded,
                          size: 14,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF475569),
                        ),
                      const SizedBox(width: 6),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF475569),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
