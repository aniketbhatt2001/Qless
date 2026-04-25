import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:canteen_mangement/features/cart/presentation/controllers/cart_controller.dart';
import 'package:canteen_mangement/features/dashboard/presentation/controllers/dashboard_controller.dart';

class CartBottomBar extends StatelessWidget {
  final List<dynamic> items;
  final double totalPrice;

  const CartBottomBar({
    super.key,
    required this.items,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    final DashboardController dashController = Get.find<DashboardController>();

    final itemCount = items.isNotEmpty ? items.length : 0;
    final firstItem = items.isNotEmpty ? items.first : null;

    return Material(
      child: GestureDetector(
        onTap: () => dashController.changeIndex(1),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.18),
                  width: 1,
                ),
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.10),
                    Colors.white.withValues(alpha: 0.04),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  _buildItemPreview(),

                  const SizedBox(width: 12),

                  Expanded(
                    child:
                        itemCount == 1
                            ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  firstItem.menuItem.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '₹${totalPrice.toStringAsFixed(0)} · $itemCount item',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.65),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            )
                            : Text(
                              '₹${totalPrice.toStringAsFixed(0)} · $itemCount items',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                  ),

                  const SizedBox(width: 8),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0EA5E9), Color(0xFF38BDF8)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'View Cart',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                          size: 13,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 10),

                  GestureDetector(
                    onTap: () => Get.find<CartController>().clearCart(),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        color: Colors.white.withValues(alpha: 0.7),
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItemPreview() {
    if (items.length == 1) {
      final item = items.first;

      return Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: NetworkImage(item.menuItem.imageUrl ?? ''),

            //   image: NetworkImage(item.menuItem.imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    final previewItems = items.take(3).toList();
    final extraCount = items.length - 3;

    return SizedBox(
      width: 70,
      height: 42,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ...List.generate(previewItems.length, (index) {
            final item = previewItems[index];

            return Positioned(
              left: index * 17,
              child: Container(
                width: 42,
                height: 42,

                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white, width: 2),
                  image: DecorationImage(
                    image: NetworkImage(item.menuItem.imageUrl ?? ''),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          }),

          if (extraCount > 0)
            Positioned(
              left: 4 * 14,
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "+$extraCount",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
