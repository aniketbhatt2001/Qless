import 'package:canteen_mangement/features/home/presentation/views/home_view.dart';
import 'package:canteen_mangement/core/utils/responsive.dart';
import 'package:canteen_mangement/features/home/presentation/views/widgets/home_custom_painters.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:canteen_mangement/features/menu/presentation/controllers/category_controller.dart';
import 'package:canteen_mangement/features/home/presentation/views/widgets/menu_item_card.dart';
import 'package:canteen_mangement/core/widgets/common_app_bar.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CategoryProductsView extends StatefulWidget {
  final String category;

  const CategoryProductsView({super.key, required this.category});

  @override
  State<CategoryProductsView> createState() => _CategoryProductsViewState();
}

class _CategoryProductsViewState extends State<CategoryProductsView> {
  late CategoryController controller;

  @override
  void initState() {
    super.initState();
    // Putting the controller into memory with the specific category
    controller = Get.put(
      CategoryController(
        category: widget.category,
        getMenuByCategoryUseCase: Get.find(),
      ),
      tag: widget.category,
    );
  }

  @override
  void dispose() {
    // Destroying the controller when the view is disposed
    Get.delete<CategoryController>(tag: widget.category);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(title: '${widget.category} Items'),

      body: Obx(() {
        if (controller.isLoading.value && controller.categoryItems.isEmpty) {
          return _buildSkeleton();
        }

        if (controller.categoryItems.isEmpty) {
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
                    LucideIcons.utensils,
                    size: 64,
                    color: Colors.grey[300],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'No ${widget.category} items found',
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Try checking another category',
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchCategoryItems(),
          child: LayoutBuilder(
            builder: (context, constraints) {
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
                  itemCount: controller.categoryItems.length,
                  itemBuilder: (context, index) => MenuItemCard(
                    item: controller.categoryItems[index],
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
                itemCount: controller.categoryItems.length,
                itemBuilder: (context, index) {
                  return MenuItemCard(
                    item: controller.categoryItems[index],
                    index: index,
                  ).animate().fade().slideY(
                    begin: 0.1,
                    duration: 300.ms,
                    delay: (index * 50).ms,
                  );
                },
              );
            },
          ),
        );
      }),
    );
  }

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
}
