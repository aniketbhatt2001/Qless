import 'package:canteen_mangement/features/home/presentation/views/home_view.dart';
import 'package:canteen_mangement/core/utils/responsive.dart';
import 'package:canteen_mangement/features/home/presentation/views/widgets/home_custom_painters.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:canteen_mangement/features/menu/presentation/controllers/search_controller.dart';
import 'package:canteen_mangement/features/home/presentation/views/widgets/menu_item_card.dart';
import 'package:canteen_mangement/core/widgets/common_app_bar.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SearchMealsView extends StatefulWidget {
  const SearchMealsView({super.key});

  @override
  State<SearchMealsView> createState() => _SearchMealsViewState();
}

class _SearchMealsViewState extends State<SearchMealsView> {
  final MealSearchController controller = Get.put(
    MealSearchController(getMenuItemsUseCase: Get.find()),
  );
  final clr = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CommonAppBar(title: 'Search Meals'),

      body: Column(
        children: [
          // ── Search text field ──────────────────────────
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0EA5E9), Color(0xFF38BDF8)],
              ),
            ),

            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                autofocus: true,
                controller: clr,
                onChanged: (value) => controller.searchQuery.value = value,
                style: const TextStyle(fontSize: 15, color: Color(0xFF1E293B)),
                decoration: InputDecoration(
                  hintText: 'Search meals, categories...',
                  hintStyle: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 15,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF0EA5E9),
                  ),
                  suffixIcon: Obx(() {
                    if (controller.searchQuery.value.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return IconButton(
                      icon: const Icon(Icons.close, color: Color(0xFF94A3B8)),
                      onPressed: () {
                        controller.searchQuery.value = '';
                        clr.clear();
                      },
                    );
                  }),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ),

          // ── Results ────────────────────────────────────
          Expanded(
            child: Obx(() {
              // Loading state
              if (controller.isLoading.value && controller.allItems.isEmpty) {
                return _buildSkeleton();
              }

              // Empty results
              if (controller.filteredItems.isEmpty) {
                return _buildEmptyState(controller.searchQuery.value);
              }

              return LayoutBuilder(builder: (context, constraints) {
                if (Responsive.isDesktop(context)) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(24),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 2.6,
                    ),
                    itemCount: controller.filteredItems.length,
                    itemBuilder: (context, index) => MenuItemCard(
                      item: controller.filteredItems[index],
                      index: index,
                    ).animate().fade().slideY(
                          begin: 0.1,
                          duration: 300.ms,
                          delay: (index * 40).ms,
                        ),
                  );
                }
                return ListView.separated(
                  separatorBuilder: (context, index) => const DashedDivider(),
                  itemCount: controller.filteredItems.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: MenuItemCard(
                        item: controller.filteredItems[index],
                        index: index,
                      ).animate().fade().slideY(
                        begin: 0.1,
                        duration: 300.ms,
                        delay: (index * 50).ms,
                      ),
                    );
                  },
                );
              });
            }),
          ),
        ],
      ),
    );
  }

  // ── Skeleton loader ──────────────────────────────────────
  Widget _buildSkeleton() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 6,
      itemBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: MenuItemCardSkeleton(),
        );
      },
    );
  }

  // ── Empty / no-results state ─────────────────────────────
  Widget _buildEmptyState(String query) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Icon(
              query.isEmpty ? LucideIcons.utensils : LucideIcons.searchX,
              size: 64,
              color: Colors.grey[300],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            query.isEmpty
                ? 'Start typing to search'
                : 'No results for "$query"',
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            query.isEmpty
                ? 'Discover meals, categories and more'
                : 'Try a different keyword',
            style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
          ),
        ],
      ),
    ).animate().fade().slideY(begin: 0.1, duration: 400.ms);
  }

  @override
  void dispose() {
    // controller.dispose();
    super.dispose();
  }
}
