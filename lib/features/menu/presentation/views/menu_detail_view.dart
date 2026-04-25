import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:canteen_mangement/core/utils/responsive.dart';
import 'package:canteen_mangement/features/cart/presentation/controllers/cart_controller.dart';
import 'package:canteen_mangement/features/menu/domain/entities/menu_item_entity.dart';
import 'package:canteen_mangement/features/menu/presentation/views/widgets/menu_detail_content.dart';
import 'package:canteen_mangement/features/menu/presentation/views/widgets/menu_detail_hero_image.dart';

/// Menu detail view displaying full information about a menu item.
///
/// Shows:
/// - Hero image with price badge
/// - Item name and meta information
/// - Add to cart / quantity controls
/// - Description with expand/collapse
///
/// Supports both mobile and desktop responsive layouts.
/// Follows Flutter Playbook standards: < 300 lines, well-documented, modular.
class MenuDetailView extends StatefulWidget {
  final MenuItemEntity? item;

  const MenuDetailView({super.key, this.item});

  @override
  State<MenuDetailView> createState() => _MenuDetailViewState();
}

class _MenuDetailViewState extends State<MenuDetailView>
    with TickerProviderStateMixin {
  final CartController _cartController = Get.find<CartController>();
  late final MenuItemEntity item;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    // Get item from widget or route arguments
    item = widget.item ?? Get.arguments as MenuItemEntity;

    // Initialize animations for smooth entrance
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnim = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );
    _scaleAnim = Tween<double>(begin: 0.96, end: 1.0).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    // Start animations
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = item.imageUrl != null && item.imageUrl!.isNotEmpty;

    // Responsive layout selection
    if (Responsive.isDesktop(context)) {
      return _buildDesktopLayout(context, hasImage);
    }
    return _buildMobileLayout(context, hasImage);
  }

  /// Desktop layout with side-by-side image and content.
  Widget _buildDesktopLayout(BuildContext context, bool hasImage) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF0EA5E9),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          item.name,
          style: const TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: image
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: hasImage
                    ? Image.network(
                        item.imageUrl!,
                        fit: BoxFit.cover,
                        height: double.infinity,
                        errorBuilder: (_, __, ___) =>
                            _buildPlaceholderImage(context),
                      )
                    : _buildPlaceholderImage(context),
              ),
            ),
          ),
          // Right: content
          SizedBox(
            width: 420,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(0, 32, 32, 32),
              child: SlideTransition(
                position: _slideAnim,
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: MenuDetailContent(
                    item: item,
                    cartController: _cartController,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Mobile layout with vertical scroll.
  Widget _buildMobileLayout(BuildContext context, bool hasImage) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero image section
            MenuDetailHeroImage(
              item: item,
              hasImage: hasImage,
            ),
            // Content section with animations
            SlideTransition(
              position: _slideAnim,
              child: ScaleTransition(
                scale: _scaleAnim,
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: MenuDetailContent(
                    item: item,
                    cartController: _cartController,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  /// Builds placeholder image for desktop layout.
  Widget _buildPlaceholderImage(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            cs.primary.withValues(alpha: 0.10),
            cs.secondary.withValues(alpha: 0.20),
          ],
        ),
      ),
      child: const Center(
        child: Text('🍽️', style: TextStyle(fontSize: 90)),
      ),
    );
  }
}
