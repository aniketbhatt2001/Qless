import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:canteen_mangement/features/menu/domain/entities/menu_item_entity.dart';
import 'package:canteen_mangement/core/theme/custom%20theme_tokens.dart';

/// Hero image widget for menu detail view.
///
/// Displays large product image with:
/// - Gradient scrim overlay
/// - Price badge
/// - Back button with blur effect
/// - Placeholder for missing images
class MenuDetailHeroImage extends StatelessWidget {
  final MenuItemEntity item;
  final bool hasImage;

  const MenuDetailHeroImage({
    super.key,
    required this.item,
    required this.hasImage,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Stack(
      children: [
        // Hero image with rounded bottom corners
        Hero(
          tag: 'product_image_${item.id}',
          child: Container(
            width: double.infinity,
            height: 380,
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              image: hasImage
                  ? DecorationImage(
                      image: NetworkImage(item.imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: !hasImage ? _buildPlaceholder(context) : null,
          ),
        ),

        // Bottom gradient scrim for better text readability
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 160,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  cs.onSurface.withValues(alpha: 0.50),
                ],
              ),
            ),
          ),
        ),

        // Price badge positioned at bottom right
        Positioned(
          bottom: 24,
          right: 24,
          child: _buildPriceBadge(context),
        ),

        // Navigation overlay with back button
        Positioned(
          top: MediaQuery.of(context).padding.top + 10,
          left: 20,
          right: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCircleButton(
                context,
                icon: Icons.arrow_back_ios_new_rounded,
                onTap: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds placeholder when image is not available.
  Widget _buildPlaceholder(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 0.8,
              colors: [
                cs.primary.withValues(alpha: 0.10),
                cs.secondary.withValues(alpha: 0.20),
              ],
            ),
          ),
        ),
        const Center(
          child: Text('🍽️', style: TextStyle(fontSize: 90)),
        ),
      ],
    );
  }

  /// Builds price badge with primary color background.
  Widget _buildPriceBadge(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tokens = context.tokens;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: cs.primary,
        borderRadius: BorderRadius.circular(tokens.rFull),
        boxShadow: tokens.buttonShadow,
      ),
      child: Text(
        '₹${item.price.toStringAsFixed(0)}',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: cs.onPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
      ),
    );
  }

  /// Builds circular button with blur effect.
  Widget _buildCircleButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.85),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.6),
                width: 1,
              ),
            ),
            child: Icon(icon, size: 20),
          ),
        ),
      ),
    );
  }
}
