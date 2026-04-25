import 'dart:developer';

import 'package:canteen_mangement/features/order/presentation/controllers/order_controller.dart';
import 'package:canteen_mangement/core/utils/responsive.dart';
import 'package:canteen_mangement/features/cart/presentation/views/widgets/cart_bottom_bar.dart';
import 'package:canteen_mangement/features/order/presentation/views/widgets/order_timer.dart';
import 'package:canteen_mangement/features/dashboard/presentation/views/qr_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:canteen_mangement/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:canteen_mangement/features/cart/presentation/controllers/cart_controller.dart';
import 'package:canteen_mangement/features/home/presentation/views/home_view.dart';
import 'package:canteen_mangement/features/cart/presentation/views/cart_view.dart';
import 'package:canteen_mangement/features/order/presentation/views/order_list_view.dart';
import 'package:canteen_mangement/features/auth/presentation/views/profile_view.dart';
import 'package:canteen_mangement/core/constants/app_routes.dart';
import 'package:canteen_mangement/features/menu/presentation/views/menu_detail_view.dart';
import 'package:canteen_mangement/features/menu/domain/entities/menu_item_entity.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

class DashboardView extends StatefulWidget {
  final int index;
  const DashboardView({this.index = 0, super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final DashboardController controller = Get.find<DashboardController>();
  final CartController cartController = Get.find<CartController>();
  final CartController _cartController = Get.find<CartController>();
  final OrderController orderController = Get.find<OrderController>();
  final scrollController = ScrollController();

  late List<Widget> pages;
  final Map<String, String> _previousOrderStatuses = {};

  @override
  void initState() {
    super.initState();
    ever(orderController.myOrders, (orders) {
      log('_previousOrderStatuses  $_previousOrderStatuses');
      final newlyReady = <ActiveOrderInfo>[];
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
      if (newlyReady.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _showOrderReadyDialog(newlyReady);
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      orderController.fetchMyOrders();
      controller.changeIndex(widget.index);
      final args = Get.arguments;
      if (args is Map && args.containsKey('index')) {
        controller.changeIndex(args['index']);
      }
    });

    pages = [
      _buildNavigator(0, HomeView(scrollController)),
      _buildNavigator(1, CartView()),
      _buildNavigator(2, const QrScannerView()),
      _buildNavigator(3, const OrderListView()),
      _buildNavigator(4, ProfileView()),
    ];
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Widget _buildNavigator(int id, Widget child) {
    return Navigator(
      key: Get.nestedKey(id),
      observers: [GetObserver(), HeroController()],
      onGenerateRoute: (settings) {
        Widget page = child;
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
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        final navigator = Get.nestedKey(controller.currentIndex.value)?.currentState;
        if (navigator != null && navigator.canPop()) {
          navigator.pop();
        } else if (controller.currentIndex.value != 0) {
          controller.changeIndex(0);
        } else {
          Get.back();
        }
      },
      child: Responsive.isDesktop(context) ? _buildDesktopLayout() : _buildMobileLayout(),
    );
  }

  void _showOrderReadyDialog(List<ActiveOrderInfo> orders) {
    final isSingle = orders.length == 1;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDCFCE7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle_rounded, color: Color(0xFF22C55E), size: 40),
                ),
                const SizedBox(height: 20),
                Text(
                  isSingle ? 'Order Ready!' : '${orders.length} Orders Ready!',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1A1A2E)),
                ),
                const SizedBox(height: 12),
                ...orders.map(
                  (order) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Column(
                      children: [
                        Text(
                          'Order #${order.orderId}',
                          style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          order.itemName ?? 'Your order',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isSingle ? 'is ready for pickup.' : 'are ready for pickup.',
                  style: const TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF22C55E),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Got it', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Obx(() {
      final idx = controller.currentIndex.value;
      return Scaffold(
        backgroundColor: const Color(0xFFF1F5F9),
        body: Row(
          children: [
            _DesktopSidebar(
              currentIndex: idx,
              cartController: cartController,
              onTap: (i) => controller.changeIndex(i),
            ),
            Expanded(
              child: Stack(
                children: [
                  pages[idx],
                  Obx(() {
                    final orders = orderController.myOrders;
                    final activeOrders = orders
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
                            itemName: _itemSummary(o.items),
                          ),
                        )
                        .toList();
                    if (activeOrders.isEmpty || (idx != 0 && idx != 4)) return const SizedBox.shrink();
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
                  }),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildMobileLayout() {
    return Obx(
      () => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        extendBody: true,
        body: Stack(
          children: [
            pages[controller.currentIndex.value],
            Obx(() {
              final cart = _cartController.cart.value;
              final hasItems = cart != null && cart.items.isNotEmpty;
              final navBarHeight = 64.0 + MediaQuery.of(context).padding.bottom;
              return AnimatedPositioned(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                left: 12,
                right: 12,
                bottom: hasItems &&
                        (controller.currentIndex.value == 0 ||
                            controller.currentIndex.value == 4)
                    ? navBarHeight + 8
                    : -100,
                child: CartBottomBar(
                  items: cart?.items ?? [],
                  totalPrice: cart?.totalPrice ?? 0,
                ),
              );
            }),
            Obx(() {
              final orders = orderController.myOrders;
              final activeOrders = orders
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
                      itemName: _itemSummary(o.items),
                    ),
                  )
                  .toList();
              final navBarHeight = 64.0 + MediaQuery.of(context).padding.bottom;
              final cartIsVisible =
                  (_cartController.cart.value?.items.isNotEmpty ?? false) &&
                  controller.currentIndex.value != 1 &&
                  controller.currentIndex.value != 2;
              final showTimer = activeOrders.isNotEmpty &&
                  (controller.currentIndex.value == 0 || controller.currentIndex.value == 4);
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
                        onTap: () => controller.changeIndex(3),
                      )
                    : const SizedBox.shrink(),
              );
            }),
          ],
        ),
        floatingActionButton: GestureDetector(
          onTap: () => controller.changeIndex(2),
          child: Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
            child: Center(
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFF0EA5E9), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0EA5E9).withValues(alpha: 0.2),
                      blurRadius: 12,
                      spreadRadius: 1,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(LucideIcons.scanLine, color: Color(0xFF0EA5E9), size: 26),
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: const _LoweredCenterDocked(),
        bottomNavigationBar: AnimatedBottomNavigationBar.builder(
          itemCount: 4,
          activeIndex: controller.currentIndex.value == 2
              ? -1
              : (controller.currentIndex.value > 2
                  ? controller.currentIndex.value - 1
                  : controller.currentIndex.value),
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
          onTap: (index) {
            final mapped = index >= 2 ? index + 1 : index;
            controller.changeIndex(mapped);
          },
          tabBuilder: (int index, bool isActive) {
            final scannerOpen = controller.currentIndex.value == 2;
            if (scannerOpen) isActive = false;

            const icons = [
              LucideIcons.home,
              LucideIcons.shoppingCart,
              LucideIcons.clipboardList,
              LucideIcons.user,
            ];
            const labels = ['Home', 'Cart', 'Orders', 'Profile'];
            const activeColor = Color(0xFF0EA5E9);
            const inactiveColor = Color(0xFFB0BEC5);
            final color = isActive ? activeColor : inactiveColor;

            Widget iconWidget = isActive
                ? Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: activeColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icons[index], size: 20, color: activeColor),
                  )
                : Icon(icons[index], size: 22, color: inactiveColor);

            if (index == 1) {
              iconWidget = Obx(() {
                final hasItems = cartController.totalItems > 0;
                final inner = isActive
                    ? Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: activeColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(icons[index], size: 20, color: activeColor),
                      )
                    : Icon(icons[index], size: 22, color: inactiveColor);
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
          },
        ),
      ),
    );
  }
}

class _DesktopSidebar extends StatelessWidget {
  final int currentIndex;
  final CartController cartController;
  final void Function(int) onTap;

  const _DesktopSidebar({
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
          Padding(
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
                  child: const Icon(LucideIcons.utensilsCrossed, color: Colors.white, size: 20),
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
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: items.map((item) {
                final isActive = currentIndex == item.index;
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
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text('v1.0.0', style: TextStyle(fontSize: 11, color: Colors.grey.shade400)),
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final int index;
  const _NavItem(this.icon, this.label, this.index);
}

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
            color: isActive ? _primary.withValues(alpha: 0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(item.icon, size: 20, color: isActive ? _primary : const Color(0xFF94A3B8)),
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
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    badge!,
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoweredCenterDocked extends FloatingActionButtonLocation {
  const _LoweredCenterDocked();

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final base = FloatingActionButtonLocation.centerDocked.getOffset(scaffoldGeometry);
    return Offset(base.dx, base.dy + 10.0);
  }
}
