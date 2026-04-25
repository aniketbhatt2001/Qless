import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:canteen_mangement/features/cart/presentation/controllers/cart_controller.dart';
import 'package:canteen_mangement/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:canteen_mangement/core/theme/custom%20theme_tokens.dart';

/// Cart action widget for menu detail view.
///
/// Displays either:
/// - "Add to Cart" button when item not in cart
/// - Quantity selector + "View Cart" button when item in cart
///
/// Animated transition between states for smooth UX.
class MenuDetailCartAction extends StatelessWidget {
  final String itemId;
  final CartController cartController;

  const MenuDetailCartAction({
    super.key,
    required this.itemId,
    required this.cartController,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tokens = context.tokens;
    final textTheme = Theme.of(context).textTheme;

    return Obx(() {
      final cartQty = cartController.getItemQuantity(itemId);
      final isInCart = cartQty > 0;

      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 320),
        transitionBuilder: (child, anim) => FadeTransition(
          opacity: anim,
          child: ScaleTransition(
            scale: Tween(begin: 0.95, end: 1.0).animate(anim),
            child: child,
          ),
        ),
        child: isInCart
            ? _buildInCartState(context, cartQty, cs, tokens, textTheme)
            : _buildAddToCartButton(context, cs, tokens, textTheme),
      );
    });
  }

  /// Builds state when item is in cart (quantity selector + view cart button).
  Widget _buildInCartState(
    BuildContext context,
    int cartQty,
    ColorScheme cs,
    dynamic tokens,
    TextTheme textTheme,
  ) {
    return Row(
      key: const ValueKey('in_cart'),
      children: [
        _buildQuantitySelector(context, cartQty, cs, tokens, textTheme),
        const SizedBox(width: 14),
        Expanded(
          child: GestureDetector(
            onTap: () => Get.find<DashboardController>().changeIndex(1),
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                border: Border.all(color: cs.primary, width: 2),
                borderRadius: BorderRadius.circular(tokens.rFull),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    color: cs.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'VIEW CART',
                    style: textTheme.titleSmall?.copyWith(
                      color: cs.primary,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds "Add to Cart" button when item not in cart.
  Widget _buildAddToCartButton(
    BuildContext context,
    ColorScheme cs,
    dynamic tokens,
    TextTheme textTheme,
  ) {
    return GestureDetector(
      key: const ValueKey('add_to_cart'),
      onTap: () => cartController.addItem(itemId, 1),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: cs.primary,
          borderRadius: BorderRadius.circular(tokens.rFull),
          boxShadow: tokens.buttonShadow,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_shopping_cart_rounded,
              color: cs.onPrimary,
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(
              'ADD TO CART',
              style: textTheme.titleSmall?.copyWith(
                color: cs.onPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds quantity selector with increment/decrement buttons.
  Widget _buildQuantitySelector(
    BuildContext context,
    int cartQty,
    ColorScheme cs,
    dynamic tokens,
    TextTheme textTheme,
  ) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(tokens.rFull),
        border: Border.all(color: tokens.borderLight, width: 1.5),
        boxShadow: tokens.cardShadow,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildQtyButton(
            context,
            icon: Icons.remove_rounded,
            onTap: () {
              // Remove item if quantity is 1, otherwise decrement
              if (cartQty > 1) {
                cartController.updateItem(itemId, cartQty - 1);
              } else {
                cartController.removeItem(itemId);
              }
            },
            cs: cs,
            tokens: tokens,
          ),
          SizedBox(
            width: 46,
            child: Center(
              child: Text(
                '$cartQty',
                style: textTheme.titleLarge?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          _buildQtyButton(
            context,
            icon: Icons.add_rounded,
            onTap: () => cartController.updateItem(itemId, cartQty + 1),
            cs: cs,
            tokens: tokens,
          ),
        ],
      ),
    );
  }

  /// Builds circular quantity adjustment button.
  Widget _buildQtyButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
    required ColorScheme cs,
    required dynamic tokens,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 46,
        height: 46,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: cs.primary,
          shape: BoxShape.circle,
          boxShadow: tokens.buttonShadow,
        ),
        child: Icon(icon, color: cs.onPrimary, size: 22),
      ),
    );
  }
}
