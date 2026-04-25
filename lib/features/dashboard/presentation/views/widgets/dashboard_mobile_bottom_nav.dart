import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:canteen_mangement/features/cart/presentation/controllers/cart_controller.dart';
import 'package:canteen_mangement/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

/// Mobile bottom navigation bar widget for dashboard.
///
/// Displays:
/// - 4 navigation items (Home, Cart, Orders, Profile)
/// - Center gap for FAB
/// - Active state highlighting
/// - Cart badge counter
/// - Smooth animations
class DashboardMobileBottomNav extends StatelessWidget {
  final DashboardController controller;
  final CartController cartController;

  const DashboardMobileBottomNav({
    super.key,
    required this.controller,
    required this.cartController,
  });

  static const icons = [
    LucideIcons.home,
    LucideIcons.shoppingCart,
    LucideIcons.clipboardList,
    LucideIcons.user,
  ];

  static const labels = ['Home', 'Cart', 'Orders', 'Profile'];
  static const activeColor = Color(0xFF0EA5E9);
  static const inactiveColor = Color(0xFFB0BEC5);

  @override
  Widget build(BuildContext context) {
    return AnimatedBottomNavigationBar.builder(
      itemCount: 4,
      activeIndex: _calculateActiveIndex(),
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.softEdge,
      leftCornerRadius: 0,
      rightCornerRadius: 0,
      notchMargin: 6,
      backgroundColor: Colors.white,
      splashColor: Colors.transparent,
      splashSpeedInMilliseconds: 0,
      height: 64,
      shadow: const BoxShadow(
        color: Color(0x14000000),
        blurRadius: 20,
        offset: Offset(0, -4),
      ),
      onTap: _handleTap,
      tabBuilder: _buildTab,
    );
  }

  /// Calculates active index accounting for center FAB.
  int _calculateActiveIndex() {
    final currentIndex = controller.currentIndex.value;
    // QR scanner (index 2) is in FAB, so return -1
    if (currentIndex == 2) return -1;
    // Indices after QR scanner need to be shifted down by 1
    return currentIndex > 2 ? currentIndex - 1 : currentIndex;
  }

  /// Handles navigation tap.
  void _handleTap(int index) {
    // Map bottom nav index to actual page index (accounting for FAB)
    final mapped = index >= 2 ? index + 1 : index;
    controller.changeIndex(mapped);
  }

  /// Builds individual navigation tab.
  Widget _buildTab(int index, bool isActive) {
    // Disable active state if QR scanner is open
    final scannerOpen = controller.currentIndex.value == 2;
    if (scannerOpen) isActive = false;

    final color = isActive ? activeColor : inactiveColor;

    Widget iconWidget = _buildNavIcon(
      icons[index],
      isActive,
    );

    // Cart icon needs badge counter
    if (index == 1) {
      iconWidget = Obx(() {
        final hasItems = cartController.totalItems > 0;
        final inner = _buildNavIcon(icons[index], isActive);
        return Badge(
          label: Text(
            cartController.totalItems.toString(),
            style: const TextStyle(color: Colors.white, fontSize: 9),
          ),
          isLabelVisible: hasItems,
          backgroundColor: Colors.redAccent,
          child: inner,
        );
      });
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        iconWidget,
        const SizedBox(height: 3),
        Text(
          labels[index],
          style: TextStyle(
            fontSize: 11,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: color,
          ),
        ),
      ],
    );
  }

  /// Builds navigation icon with active state styling.
  Widget _buildNavIcon(IconData icon, bool isActive) {
    if (isActive) {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: activeColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 20, color: activeColor),
      );
    }
    return Icon(icon, size: 22, color: inactiveColor);
  }
}
