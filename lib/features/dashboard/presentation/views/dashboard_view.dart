import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:canteen_mangement/core/utils/responsive.dart';
import 'package:canteen_mangement/core/constants/app_routes.dart';
import 'package:canteen_mangement/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:canteen_mangement/features/cart/presentation/controllers/cart_controller.dart';
import 'package:canteen_mangement/features/order/presentation/controllers/order_controller.dart';
import 'package:canteen_mangement/features/home/presentation/views/home_view.dart';
import 'package:canteen_mangement/features/cart/presentation/views/cart_view.dart';
import 'package:canteen_mangement/features/order/presentation/views/order_list_view.dart';
import 'package:canteen_mangement/features/auth/presentation/views/profile_view.dart';
import 'package:canteen_mangement/features/dashboard/presentation/views/qr_view.dart';
import 'package:canteen_mangement/features/menu/presentation/views/menu_detail_view.dart';
import 'package:canteen_mangement/features/menu/domain/entities/menu_item_entity.dart';
import 'package:canteen_mangement/features/order/presentation/views/widgets/order_timer.dart';
import 'package:canteen_mangement/features/dashboard/presentation/views/widgets/dashboard_desktop_sidebar.dart';
import 'package:canteen_mangement/features/dashboard/presentation/views/widgets/dashboard_order_ready_dialog.dart';
import 'package:canteen_mangement/features/dashboard/presentation/views/widgets/dashboard_mobile_fab.dart';
import 'package:canteen_mangement/features/dashboard/presentation/views/widgets/dashboard_mobile_bottom_nav.dart';
import 'package:canteen_mangement/features/dashboard/presentation/views/widgets/dashboard_mobile_layout_helper.dart';

/// Main dashboard view with bottom navigation.
///
/// Manages:
/// - Navigation between main app sections
/// - Nested navigation for each section
/// - Cart bottom bar visibility
/// - Order timer bar visibility
/// - Order ready notifications
///
/// Supports both mobile and desktop layouts.
/// Follows Flutter Playbook standards with clean architecture.
class DashboardView extends StatefulWidget {
  final int index;

  const DashboardView({this.index = 0, super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final DashboardController controller = Get.find<DashboardController>();
  final CartController cartController = Get.find<CartController>();
  final OrderController orderController = Get.find<OrderController>();
  final scrollController = ScrollController();

  late List<Widget> pages;
  final Map<String, String> _previousOrderStatuses = {};

  @override
  void initState() {
    super.initState();
    _setupOrderStatusListener();
    _initializePages();
    _handleInitialNavigation();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  /// Sets up listener for order status changes to show ready notifications.
  void _setupOrderStatusListener() {
    ever(orderController.myOrders, (orders) {
      log('_previousOrderStatuses  $_previousOrderStatuses');
      final newlyReady = <ActiveOrderInfo>[];

      // Check each order for status change to 'ready'
      for (final order in orders) {
        final id = order.id ?? '';
        final status = order.status ?? '';
        final prev = _previousOrderStatuses[id];

        if (prev != null && prev != 'ready' && status == 'ready') {
          newlyReady.add(
            ActiveOrderInfo(
              orderId: id,
              estimatedWaitMinutes: order.estimatedWaitMinutes ?? 0,
              status: status,
              itemName: _itemSummary(order.items),
            ),
          );
        }
        _previousOrderStatuses[id] = status;
      }

      // Show dialog if any orders became ready
      if (newlyReady.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            showOrderReadyDialog(context, newlyReady);
          }
        });
      }
    });
  }

  /// Initializes page list with nested navigators.
  void _initializePages() {
    pages = [
      _buildNavigator(0, HomeView(scrollController)),
      _buildNavigator(1, CartView()),
      _buildNavigator(2, const QrScannerView()),
      _buildNavigator(3, const OrderListView()),
      _buildNavigator(4, ProfileView()),
    ];
  }

  /// Handles initial navigation from route arguments.
  void _handleInitialNavigation() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      orderController.fetchMyOrders();
      controller.changeIndex(widget.index);

      final args = Get.arguments;
      if (args is Map && args.containsKey('index')) {
        controller.changeIndex(args['index']);
      }
    });
  }

  /// Builds nested navigator for each page.
  ///
  /// Enables deep navigation within each section while maintaining
  /// bottom navigation state.
  Widget _buildNavigator(int id, Widget child) {
    return Navigator(
      key: Get.nestedKey(id),
      observers: [GetObserver(), HeroController()],
      onGenerateRoute: (settings) {
        Widget page = child;

        // Handle menu detail route
        if (settings.name == AppRoutes.menuDetail) {
          final args = settings.arguments;
          if (args is MenuItemEntity) {
            page = MenuDetailView(item: args);
          } else {
            page = const MenuDetailView();
          }
        }

        return GetPageRoute(page: () => page, settings: settings);
      },
    );
  }

  /// Creates summary text for order items.
  String _itemSummary(List<dynamic>? items) {
    if (items == null || items.isEmpty) return 'Your order';
    if (items.length == 1) return items.first.name ?? 'Your order';
    if (items.length == 2) return '${items[0].name} & ${items[1].name}';
    return '${items.first.name} + ${items.length - 1} more';
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: _handleBackNavigation,
      child: Responsive.isDesktop(context)
          ? _buildDesktopLayout()
          : _buildMobileLayout(),
    );
  }

  /// Handles back button navigation.
  ///
  /// Priority:
  /// 1. Pop nested navigator if possible
  /// 2. Navigate to home tab if on other tab
  /// 3. Exit app if on home tab
  void _handleBackNavigation(bool didPop, dynamic result) {
    if (didPop) return;

    final navigator =
        Get.nestedKey(controller.currentIndex.value)?.currentState;

    if (navigator != null && navigator.canPop()) {
      navigator.pop();
    } else if (controller.currentIndex.value != 0) {
      controller.changeIndex(0);
    } else {
      Get.back();
    }
  }

  /// Builds desktop layout with sidebar navigation.
  Widget _buildDesktopLayout() {
    return Obx(() {
      final idx = controller.currentIndex.value;

      return Scaffold(
        backgroundColor: const Color(0xFFF1F5F9),
        body: Row(
          children: [
            DashboardDesktopSidebar(
              currentIndex: idx,
              cartController: cartController,
              onTap: (i) => controller.changeIndex(i),
            ),
            Expanded(
              child: Stack(
                children: [
                  pages[idx],
                  _buildDesktopOrderTimer(idx),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  /// Builds order timer bar for desktop layout.
  Widget _buildDesktopOrderTimer(int idx) {
    return Obx(() {
      final activeOrders = _getActiveOrders();

      // Only show on home and profile tabs
      if (activeOrders.isEmpty || (idx != 0 && idx != 4)) {
        return const SizedBox.shrink();
      }

      return Positioned(
        left: 16,
        right: 16,
        bottom: 16,
        child: OrderTimerBar(
          onOrderExpired: () => orderController.fetchMyOrders(),
          onOrderExpiredWithInfo: (_) => orderController.fetchMyOrders(),
          activeOrders: activeOrders,
          onTap: () => controller.changeIndex(3),
        ),
      );
    });
  }

  /// Builds mobile layout with bottom navigation.
  Widget _buildMobileLayout() {
    return Obx(
      () => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        extendBody: true,
        body: Stack(
          children: [
            pages[controller.currentIndex.value],
            DashboardMobileLayoutHelper.buildCartBar(
              context,
              cartController,
              controller,
            ),
            DashboardMobileLayoutHelper.buildOrderTimer(
              context,
              orderController,
              cartController,
              controller,
              _getActiveOrders,
            ),
          ],
        ),
        floatingActionButton: DashboardMobileFab(
          onTap: () => controller.changeIndex(2),
        ),
        floatingActionButtonLocation: const LoweredCenterDocked(),
        bottomNavigationBar: DashboardMobileBottomNav(
          controller: controller,
          cartController: cartController,
        ),
      ),
    );
  }

  /// Gets list of active orders (pending or preparing).
  List<ActiveOrderInfo> _getActiveOrders() {
    return DashboardMobileLayoutHelper.getActiveOrders(
      orderController,
      _itemSummary,
    );
  }
}
