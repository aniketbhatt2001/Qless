import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:canteen_mangement/core/widgets/bouncing_widget.dart';
import 'package:canteen_mangement/features/home/presentation/views/category_products_view.dart';

/// Category section widget displaying food category icons.
///
/// Shows horizontal scrollable list of category items with icons and labels.
/// Each category is tappable and navigates to filtered category view.
class HomeCategorySection extends StatelessWidget {
  const HomeCategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        children: [
          // Section header
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  'Explore Categories',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0EA5E9),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Category items horizontal scroll
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCategoryItem(
                  context,
                  fit: BoxFit.fill,
                  icon: LucideIcons.soup,
                  label: 'Main',
                  imagePath: 'assets/Main_category.png',
                  color: const Color(0xFFF59E0B),
                ),
                const SizedBox(width: 15),
                _buildCategoryItem(
                  context,
                  fit: BoxFit.fill,
                  icon: Icons.coffee,
                  imagePath: 'assets/drink_category.png',
                  label: 'Drink',
                  color: const Color(0xFFD97706),
                ),
                const SizedBox(width: 15),
                _buildCategoryItem(
                  context,
                  icon: LucideIcons.croissant,
                  imagePath: 'assets/Snack_category.png',
                  label: 'Snack',
                  color: const Color(0xFFEC4899),
                ),
                const SizedBox(width: 15),
                _buildCategoryItem(
                  context,
                  icon: LucideIcons.coffee,
                  label: 'Beverage',
                  imagePath: 'assets/Beverage_category.png',
                  color: const Color(0xFFB45309),
                ),
                const SizedBox(width: 15),
                _buildCategoryItem(
                  context,
                  icon: LucideIcons.cake,
                  imagePath: 'assets/Dessert_image.png',
                  label: 'Dessert',
                  color: const Color(0xFF0EA5E9),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds individual category item with image and label.
  Widget _buildCategoryItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required String imagePath,
    BoxFit fit = BoxFit.cover,
  }) {
    return BouncingWidget(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CategoryProductsView(category: label),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            width: 75,
            height: 75,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                width: 2,
              ),
              image: DecorationImage(
                fit: fit,
                image: AssetImage(imagePath),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF475569),
            ),
          ),
        ],
      ),
    );
  }
}
