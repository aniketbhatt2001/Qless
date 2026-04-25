import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:canteen_mangement/features/cart/presentation/controllers/cart_controller.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Desktop sidebar navigation widget for dashboard.
///
/// Displays:
/// - App logo and branding
/// - Navigation items with icons
/// - Active state highlighting
/// - Cart badge counter
/// - Version information
///
/// Follows Flutter Playbook standards with clean separation of concerns.
class DashboardDesktopSidebar extends StatelessWidget {
  final int currentIndex;
  final CartController cartController;
  final void Function(int) onTap;

  const DashboardDesktopSidebar({
    super.key,
    required this.currentIndex,
    required this.cartController,
    required this.onTap,
  });

  static const _primary = Color(0xFF0EA5E9);

  @override
  Widget build(BuildContext context) {
    final items = [
      const _NavItem(LucideIcons.home, 'Home', 0),
      const _NavItem(LucideIcons.shoppingCart, 'Cart', 1),
      const _NavItem(LucideIcons.scanLine, 'Scan QR', 2),
      const _NavItem(LucideIcons.clipboardList, 'Orders', 3),
      const _NavItem(LucideIcons.user, 'Profile', 4),
    ];

    return Container(
      width: 220,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: items.map((item) {
                final isActive = currentIndex == item.index;
                // Cart item needs badge counter
                if (item.index == 1) {
                  return Obx(() {
                    final count = cartController.totalItems;
                    return _SidebarTile(
                      item: item,
                      isActive: isActive,
                      badge: count > 0 ? count.toString() : null,
                      onTap: onTap,
                    );
                  });
                }
                return _SidebarTile(item: item, isActive: isActive, onTap: onTap);
              }).toList(),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          _buildFooter(),
        ],
      ),
    );
  }

  /// Builds header with app logo and branding.
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              LucideIcons.utensilsCrossed,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'QuickerQ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: _primary,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds footer with version information.
  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        'v1.0.0',
        style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
      ),
    );
  }
}

/// Navigation item data model.
class _NavItem {
  final IconData icon;
  final String label;
  final int index;

  const _NavItem(this.icon, this.label, this.index);
}

/// Sidebar navigation tile widget.
class _SidebarTile extends StatelessWidget {
  final _NavItem item;
  final bool isActive;
  final String? badge;
  final void Function(int) onTap;

  const _SidebarTile({
    required this.item,
    required this.isActive,
    required this.onTap,
    this.badge,
  });

  static const _primary = Color(0xFF0EA5E9);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: InkWell(
        onTap: () => onTap(item.index),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isActive
                ? _primary.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                item.icon,
                size: 20,
                color: isActive ? _primary : const Color(0xFF94A3B8),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    color: isActive ? _primary : const Color(0xFF475569),
                  ),
                ),
              ),
              if (badge != null) _buildBadge(),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds badge counter for cart items.
  Widget _buildBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        badge!,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
