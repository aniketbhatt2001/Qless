import 'package:flutter/material.dart' hide MenuController;
import 'package:get/get.dart';
import 'package:canteen_mangement/core/utils/responsive.dart';
import 'package:canteen_mangement/features/auth/presentation/controllers/auth_controller.dart';
import 'package:canteen_mangement/features/cart/presentation/controllers/cart_controller.dart';
import 'package:canteen_mangement/features/home/presentation/views/category_products_view.dart';
import 'package:canteen_mangement/features/home/presentation/views/home_skeleton.dart';
import 'package:canteen_mangement/features/home/presentation/views/widgets/home_category_filter_chips.dart';
import 'package:canteen_mangement/features/home/presentation/views/widgets/home_category_section.dart';
import 'package:canteen_mangement/features/home/presentation/views/widgets/home_custom_painters.dart';
import 'package:canteen_mangement/features/home/presentation/views/widgets/home_greeting_header.dart';
import 'package:canteen_mangement/features/home/presentation/views/widgets/home_promo_carousel.dart';
import 'package:canteen_mangement/features/home/presentation/views/widgets/home_search_bar.dart';
import 'package:canteen_mangement/features/home/presentation/views/widgets/menu_item_card.dart';
import 'package:canteen_mangement/features/menu/presentation/controllers/menu_controller.dart';

/// Home view displaying menu items, categories, and promotional content.
///
/// Main landing screen after login showing:
/// - Personalized greeting
/// - Search functionality
/// - Promotional carousel
/// - Category navigation
/// - Menu items list/grid
///
/// Supports both mobile and desktop responsive layouts.
/// Follows Flutter Playbook standards: < 300 lines, well-documented, modular.
class HomeView extends StatefulWidget {
  final ScrollController scrollClr;

  const HomeView(this.scrollClr, {super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final MenuController _menuController = Get.find<MenuController>();
  final AuthController _authController = Get.find<AuthController>();
  final CartController _cartController = Get.find<CartController>();

  String? _selectedCategory; // null = All categories

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Show skeleton loader while initial data loads
      if (_menuController.isLoading.value &&
          _menuController.menuItems.isEmpty) {
        return const HomeSkeleton();
      }

      final items = _menuController.menuItems;

      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: RefreshIndicator(
          triggerMode: RefreshIndicatorTriggerMode.onEdge,
          onRefresh: () => _menuController.fetchMenuItems(),
          child: Obx(() {
            final cart = _cartController.cart.value;
            final hasItems = cart != null && cart.items.isNotEmpty;
            
            // Filter items by selected category
            final filtered = _selectedCategory == null
                ? items
                : items
                    .where((i) =>
                        i.category?.toLowerCase() ==
                        _selectedCategory!.toLowerCase())
                    .toList();

            // Responsive layout selection
            if (Responsive.isDesktop(context)) {
              return _buildDesktopLayout(context, filtered, hasItems);
            }
            return _buildMobileLayout(context, filtered, hasItems);
          }),
        ),
      );
    });
  }

  /// Desktop layout with sidebar and grid view.
  Widget _buildDesktopLayout(
    BuildContext context,
    List filtered,
    bool hasItems,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left sidebar: categories + promo links
        SizedBox(
          width: 280,
          child: Container(
            color: const Color(0xFFF8FAFC),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  HomeGreetingHeader(
                    userName: _authController.user.value?.name ?? "",
                    isDesktop: true,
                  ),
                  const SizedBox(height: 20),
                  const HomeCategorySection(),
                  const SizedBox(height: 20),
                  const Text(
                    'Explore',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0EA5E9),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ..._buildDesktopPromoTiles(context),
                ],
              ),
            ),
          ),
        ),

        // Right content: search + menu grid
        Expanded(
          child: CustomScrollView(
            controller: widget.scrollClr,
            slivers: [
              SliverAppBar(
                pinned: true,
                toolbarHeight: 10,
                flexibleSpace: Container(color: Colors.white),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: HomeSearchBarDelegate(),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 8)),
              SliverToBoxAdapter(
                child: HomeCategoryFilterChips(
                  selectedCategory: _selectedCategory,
                  onCategorySelected: (category) {
                    setState(() => _selectedCategory = category);
                  },
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 8)),
              const SliverToBoxAdapter(child: PopularMealsDivider()),
              const SliverToBoxAdapter(child: SizedBox(height: 8)),
              _buildMenuGrid(filtered),
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          ),
        ),
      ],
    );
  }

  /// Mobile layout with vertical scroll.
  Widget _buildMobileLayout(
    BuildContext context,
    List filtered,
    bool hasItems,
  ) {
    return CustomScrollView(
      controller: widget.scrollClr,
      slivers: [
        SliverAppBar(
          pinned: true,
          toolbarHeight: 10,
          flexibleSpace: Container(color: Colors.white),
        ),
        SliverToBoxAdapter(
          child: HomeGreetingHeader(
            userName: _authController.user.value?.name ?? "",
          ),
        ),
        SliverPersistentHeader(
          pinned: true,
          delegate: HomeSearchBarDelegate(),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 2)),
        const SliverToBoxAdapter(child: HomePromoCarousel()),
        const SliverToBoxAdapter(child: SizedBox(height: 12)),
        const SliverToBoxAdapter(child: HomeCategorySection()),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
        const SliverToBoxAdapter(child: PopularMealsDivider()),
        SliverToBoxAdapter(
          child: HomeCategoryFilterChips(
            selectedCategory: _selectedCategory,
            onCategorySelected: (category) {
              setState(() => _selectedCategory = category);
            },
          ),
        ),
        _buildMenuList(filtered),
        SliverToBoxAdapter(
          child: SizedBox(height: hasItems ? 170 : 140),
        ),
      ],
    );
  }

  /// Builds responsive menu grid for desktop.
  Widget _buildMenuGrid(List filtered) {
    if (filtered.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Center(
            child: Text(
              'No items available',
              style: TextStyle(color: Color(0xFF94A3B8)),
            ),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverLayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.crossAxisExtent;
          
          // Responsive grid columns based on width
          int crossAxisCount;
          double aspectRatio;

          if (width >= 1400) {
            crossAxisCount = 5;
            aspectRatio = 1.4;
          } else if (width >= 1100) {
            crossAxisCount = 4;
            aspectRatio = 1.3;
          } else if (width >= 800) {
            crossAxisCount = 3;
            aspectRatio = 1.2;
          } else if (width >= 500) {
            crossAxisCount = 2;
            aspectRatio = 1.1;
          } else {
            crossAxisCount = 1;
            aspectRatio = 1.0;
          }

          return SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: aspectRatio,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => MenuItemCard(
                item: filtered[index],
                index: index,
              ),
              childCount: filtered.length,
            ),
          );
        },
      ),
    );
  }

  /// Builds menu list for mobile with dashed dividers.
  Widget _buildMenuList(List filtered) {
    if (filtered.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Center(
            child: Text(
              'No items available',
              style: TextStyle(color: Color(0xFF94A3B8)),
            ),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          // Alternate between menu items and dividers
          if (index.isOdd) return const DashedDivider();
          final itemIndex = index ~/ 2;
          return MenuItemCard(item: filtered[itemIndex], index: itemIndex);
        },
        childCount: filtered.length * 2 - 1,
      ),
    );
  }

  /// Builds desktop promo tiles for sidebar.
  List<Widget> _buildDesktopPromoTiles(BuildContext context) {
    final categories = [
      {'name': 'Main', 'color': const Color(0xFFE11D8F)},
      {'name': 'Snack', 'color': const Color(0xFFF97316)},
      {'name': 'Drink', 'color': const Color(0xFF6366F1)},
      {'name': 'Beverage', 'color': const Color(0xFF0EA5E9)},
      {'name': 'Dessert', 'color': const Color(0xFFD97706)},
    ];

    return categories.map((cat) {
      final name = cat['name'] as String;
      final color = cat['color'] as Color;

      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => CategoryProductsView(category: name),
            ),
          ),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.restaurant_menu_rounded, color: color, size: 18),
                const SizedBox(width: 10),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                const Spacer(),
                Icon(Icons.chevron_right_rounded, color: color, size: 18),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }
}
