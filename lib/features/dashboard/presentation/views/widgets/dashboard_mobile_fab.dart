import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Custom floating action button for mobile dashboard.
///
/// Displays QR scanner button with:
/// - Double circle design
/// - Primary color border
/// - Shadow effect
/// - Scan icon
class DashboardMobileFab extends StatelessWidget {
  final VoidCallback onTap;

  const DashboardMobileFab({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Center(
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                color: const Color(0xFF0EA5E9),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0EA5E9).withValues(alpha: 0.2),
                  blurRadius: 12,
                  spreadRadius: 1,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(
              LucideIcons.scanLine,
              color: Color(0xFF0EA5E9),
              size: 26,
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom floating action button location.
///
/// Positions FAB slightly lower than default centerDocked position
/// to create better visual balance with bottom navigation bar.
class LoweredCenterDocked extends FloatingActionButtonLocation {
  const LoweredCenterDocked();

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final base = FloatingActionButtonLocation.centerDocked
        .getOffset(scaffoldGeometry);
    // Lower the FAB by 10 pixels for better visual balance
    return Offset(base.dx, base.dy + 10.0);
  }
}
