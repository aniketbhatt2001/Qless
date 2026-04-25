import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:canteen_mangement/features/cart/presentation/controllers/cart_controller.dart';
import 'package:canteen_mangement/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:canteen_mangement/features/order/presentation/controllers/order_controller.dart';
import 'package:canteen_mangement/features/cart/presentation/views/widgets/cart_bottom_bar.dart';
import 'package:canteen_mangement/features/order/presentation/views/widgets/order_timer.dart';

/// Helper class for building mobile dashboard layout components.
///
/// Provides static methods for building:
/// - Cart bottom bar with animations
/// - Order timer bar with animations
/// - Active order filtering
class DashboardMobileLayoutHelper {
  /// Builds animated cart bottom bar.
  ///
  /// Shows cart summary when:
  /// - Cart has items
  /// - User is on home or profile tab
  static Widget buildCartBar(
    BuildContext context,
    CartController cartController,
    DashboardController dashboardController,
  ) {
    return Obx(() {
      final cart = cartController.cart.value;
      final hasItems = cart != null && cart.items.isNotEmpty;
      final navBarHeight = 64.0 + MediaQuery.of(context).padding.bottom;

      return AnimatedPositioned(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
        left: 12,
        right: 12,
        bottom: hasItems &&
                (dashboardController.currentIndex.value == 0 ||
                    dashboardController.currentIndex.value == 4)
            ? navBarHeight + 8
            : -100,
        child: CartBottomBar(
          items: cart?.items ?? [],
          totalPrice: cart?.totalPrice ?? 0,
        ),
      );
    });
  }

  /// Builds animated order timer bar.
  ///
  /// Shows timer when:
  /// - Active orders exist
  /// - User is on home or profile tab
  /// Positions above cart bar if cart is visible.
  static Widget buildOrderTimer(
    BuildContext context,
    OrderController orderController,
    CartController cartController,
    DashboardController dashboardController,
    List<ActiveOrderInfo> Function() getActiveOrders,
  ) {
    return Obx(() {
      final activeOrders = getActiveOrders();
      final navBarHeight = 64.0 + MediaQuery.of(context).padding.bottom;
      final cartIsVisible =
          (cartController.cart.value?.items.isNotEmpty ?? false) &&
              dashboardController.currentIndex.value != 1 &&
              dashboardController.currentIndex.value != 2;
      final showTimer = activeOrders.isNotEmpty &&
          (dashboardController.currentIndex.value == 0 ||
              dashboardController.currentIndex.value == 4);
      final bottomOffset =
          cartIsVisible ? navBarHeight + 8 + 72 + 8 : navBarHeight + 8;

      return AnimatedPositioned(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
        left: 12,
        right: 12,
        bottom: showTimer ? bottomOffset : -200,
        child: activeOrders.isNotEmpty
            ? OrderTimerBar(
                onOrderExpired: () => orderController.fetchMyOrders(),
                onOrderExpiredWithInfo: (_) => orderController.fetchMyOrders(),
                activeOrders: activeOrders,
                onTap: () => dashboardController.changeIndex(3),
              )
            : const SizedBox.shrink(),
      );
    });
  }

  /// Filters and maps orders to active order info.
  ///
  /// Returns orders that are:
  /// - Pending or preparing status
  /// - Have estimated wait time > 0
  static List<ActiveOrderInfo> getActiveOrders(
    OrderController orderController,
    String Function(List<dynamic>?) itemSummary,
  ) {
    final orders = orderController.myOrders;
    return orders
        .where(
          (o) =>
              (o.status == 'pending' || o.status == 'preparing') &&
              (o.estimatedWaitMinutes ?? 0) > 0,
        )
        .map(
          (o) => ActiveOrderInfo(
            orderId: o.id ?? '',
            estimatedWaitMinutes: o.estimatedWaitMinutes ?? 0,
            status: o.status ?? 'pending',
            itemName: itemSummary(o.items),
          ),
        )
        .toList();
  }
}
