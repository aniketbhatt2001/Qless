import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:canteen_mangement/features/cart/presentation/controllers/cart_controller.dart';
import 'package:canteen_mangement/features/menu/domain/entities/menu_item_entity.dart';
import 'package:canteen_mangement/features/menu/presentation/views/menu_detail_view.dart';
import 'package:canteen_mangement/core/utils/responsive.dart';
import 'package:shimmer/shimmer.dart';
import 'package:canteen_mangement/core/widgets/bouncing_widget.dart';
import 'package:flutter_animate/flutter_animate.dart';

String? _categoryIcon(String category) {
  switch (category.toLowerCase()) {
    case 'drink':
    case 'drinks':
      return 'assets/drinks.png';
    case 'snack':
    case 'snacks':
      return 'assets/snacks.png';
    case 'main':
    case 'main food':
      return 'assets/main-food.png';
    case 'beverage':
    case 'beverages':
      return 'assets/beverage.png';
    case 'dessert':
    case 'desserts':
      return 'assets/dessert.png';
    default:
      return null;
  }
}

Color _categoryColor(String category) {
  switch (category.toLowerCase()) {
    case 'drink':
    case 'drinks':
      return const Color(0xFF6366F1); // indigo
    case 'main':
    case 'main food':
      return const Color(0xFFE11D8F); // hot pink
    case 'snack':
    case 'snacks':
      return const Color(0xFFF97316); // orange
    case 'beverage':
    case 'beverages':
      return const Color(0xFFB45309); // amber-brown
    case 'dessert':
    case 'desserts':
      return const Color(0xFF0EA5E9); // sky blue
    default:
      return const Color(0xFF64748B);
  }
}

class MenuItemCard extends StatelessWidget {
  final MenuItemEntity item;
  final int index;

  const MenuItemCard({super.key, required this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();
    final hasImage = item.imageUrl != null && item.imageUrl!.isNotEmpty;
    final isDesktop = Responsive.isDesktop(context);

    if (isDesktop) {
      return _buildDesktopCard(context, cartController, hasImage);
    }
    return _buildMobileCard(context, cartController, hasImage);
  }

Widget _buildDesktopCard(BuildContext context, CartController cartController, bool hasImage) {
  return BouncingWidget(
    onTap: () {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => MenuDetailView(item: item)),
      );
    },
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(                          // ← vertical, not Row
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Image (fixed height, always fills top) ──
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Hero(
              tag: 'product_image_${item.id}',
              child: Container(
                width: double.infinity,
                height: 130,                 // ← fixed, not double.infinity
                color: const Color(0xFFF3F4F6),
                child: hasImage
                    ? Image.network(
                        item.imageUrl!,
                        fit: BoxFit.fitHeight,
                        width: double.infinity,
                        height: 130,
                      )
                    : const Icon(Icons.fastfood_outlined,
                        color: Color(0xFFCBD5E1), size: 40),
              ),
            ),
          ),

          // ── Content ──
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category badge
                      if (item.category != null)
                        Row(
                          children: [
                            if (_categoryIcon(item.category!) != null) ...[
                              Image.asset(
                                _categoryIcon(item.category!)!,
                                width: 11, height: 11,
                                color: _categoryColor(item.category!),
                              ),
                              const SizedBox(width: 4),
                            ],
                            Flexible(
                              child: Text(
                                item.category!.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.6,
                                  color: _categoryColor(item.category!),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 4),
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1F2937),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '₹${item.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0EA5E9),
                        ),
                      ),
                    ],
                  ),

                  // Bottom: time + add button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (item.timeTaken != null)
                        Row(
                          children: [
                            Image.asset('assets/flash.png',
                                width: 11, height: 11, color: Colors.green),
                            const SizedBox(width: 3),
                            Text("${item.timeTaken}m",
                                style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.green)),
                          ],
                        )
                      else
                        const SizedBox.shrink(),
                      Obx(() {
                        final quantity = cartController.getItemQuantity(item.id);
                        if (quantity == 0) {
                          return BouncingWidget(
                            onTap: () => cartController.addItem(item.id, 1),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0EA5E9),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text("ADD +",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10)),
                            ),
                          );
                        }
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFF0EA5E9)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () => quantity > 1
                                    ? cartController.updateItem(item.id, quantity - 1)
                                    : cartController.removeItem(item.id),
                                child: const Icon(Icons.remove,
                                    size: 13, color: Color(0xFF0EA5E9)),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6),
                                child: Text("$quantity",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 11)),
                              ),
                              GestureDetector(
                                onTap: () => cartController.addItem(item.id, 1),
                                child: const Icon(Icons.add,
                                    size: 13, color: Color(0xFF0EA5E9)),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  )
  .animate()
  .fade(duration: 400.ms)
  .slideY(begin: 0.1, end: 0,
      curve: Curves.easeOutQuad, duration: 400.ms, delay: (index * 50).ms);
}
  Widget _buildMobileCard(BuildContext context, CartController cartController, bool hasImage) {
    return BouncingWidget(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => MenuDetailView(item: item)),
            );
          },
          child: Container(
            padding: const EdgeInsets.only(
              top: 14,
              bottom: 14,
              right: 16,
              left: 25,
            ),

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// LEFT TEXT SECTION
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Veg Icon
                      if (item.category != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              if (_categoryIcon(item.category!) != null) ...[
                                Image.asset(
                                  _categoryIcon(item.category!)!,
                                  width: 14,
                                  height: 14,
                                  color: _categoryColor(item.category!),
                                ),
                                const SizedBox(width: 4),
                              ],
                              Text(
                                item.category!.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.8,
                                  color: _categoryColor(item.category!),
                                ),
                              ),
                            ],
                          ),
                        ),

                      /// Title
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),

                      const SizedBox(height: 6),

                      /// Price
                      Text(
                        '₹${item.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF0EA5E9),
                        ),
                      ),

                      const SizedBox(height: 8),

                      /// Description
                      if (item.description != null)
                        Text(
                          item.description!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF6B7280),
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                      const SizedBox(height: 12),

                      /// Action icons
                      if (item.timeTaken != null)
                        Row(
                          children: [
                            Image.asset(
                              'assets/flash.png',
                              width: 14,
                              height: 14,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "${item.timeTaken} mins",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),

                const SizedBox(width: 18),

                /// RIGHT IMAGE SECTION
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomCenter,
                  children: [
                    /// Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Hero(
                        tag: 'product_image_${item.id}',
                        child: Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 2),
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4,
                                spreadRadius: 2,
                              ),
                            ],
                            color: const Color(0xFFF3F4F6),
                            image:
                                hasImage
                                    ? DecorationImage(
                                      image: NetworkImage(item.imageUrl!),
                                      fit: BoxFit.cover,
                                    )
                                    : null,
                          ),
                          child: null,
                        ),
                      ),
                    ),

                    /// ADD BUTTON
                    Positioned(
                      bottom: -6,
                      child: Obx(() {
                        final quantity = cartController.getItemQuantity(
                          item.id,
                        );

                        if (quantity == 0) {
                          return BouncingWidget(
                            onTap: () => cartController.addItem(item.id, 1),
                            child: Container(
                              width: 90,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xFF0EA5E9),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Text(
                                  "ADD  +",
                                  style: TextStyle(
                                    color: Color(0xFF0EA5E9),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }

                        /// Quantity selector
                        return Container(
                          height: 36,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFF0EA5E9)),
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (quantity > 1) {
                                    cartController.updateItem(
                                      item.id,
                                      quantity - 1,
                                    );
                                  } else {
                                    cartController.removeItem(item.id);
                                  }
                                },
                                child: const Icon(
                                  Icons.remove,
                                  size: 18,
                                  color: Color(0xFF0EA5E9),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Text(
                                  "$quantity",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => cartController.addItem(item.id, 1),
                                child: const Icon(
                                  Icons.add,
                                  size: 18,
                                  color: Color(0xFF0EA5E9),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
        .animate()
        .fade(duration: 400.ms)
        .slideY(
          begin: 0.1,
          end: 0,
          curve: Curves.easeOutQuad,
          duration: 400.ms,
          delay: (index * 50).ms,
        );
  }
}

class MenuItemCardSkeleton extends StatelessWidget {
  const MenuItemCardSkeleton({super.key});

  Widget box({double? width, double? height, double radius = 8}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: box(width: 100, height: 100, radius: 16),
          ),

          const SizedBox(width: 16),

          /// TEXT CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// name + price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    box(width: 140, height: 16),
                    box(width: 40, height: 16),
                  ],
                ),

                const SizedBox(height: 8),

                /// category
                box(width: 80, height: 12),

                const SizedBox(height: 10),

                /// description line1
                box(width: double.infinity, height: 12),

                const SizedBox(height: 6),

                /// description line2
                box(width: 180, height: 12),

                const SizedBox(height: 14),

                /// bottom row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    box(width: 60, height: 12),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
