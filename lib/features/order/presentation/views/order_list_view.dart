import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:canteen_mangement/features/order/presentation/controllers/order_controller.dart';
import 'package:canteen_mangement/features/order/domain/entities/order_entity.dart';
import 'package:canteen_mangement/core/utils/responsive.dart';
import 'package:shimmer/shimmer.dart';
import 'package:canteen_mangement/core/widgets/common_app_bar.dart';
import 'package:flutter_animate/flutter_animate.dart';

class OrderListView extends StatefulWidget {
  const OrderListView({super.key});

  @override
  State<OrderListView> createState() => _OrderListViewState();
}

class _OrderListViewState extends State<OrderListView> {
  final OrderController _orderController = Get.find<OrderController>();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: CommonAppBar(
          title: "My Orders",
          bottom: TabBar(
            tabs: const [Tab(text: "Active"), Tab(text: "Past")],
            isScrollable: false,
            tabAlignment: TabAlignment.fill,
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withValues(alpha: 0.7),
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Obx(() {
          if (_orderController.isLoading.value) {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              itemCount: 5,
              itemBuilder:
                  (_, __) => const Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: OrderCardSkeleton(),
                  ),
            );
          }

          final allOrders = _orderController.myOrders;

          final activeOrders =
              allOrders.where((o) => o.queuePosition != null).toList();

          final pastOrders =
              allOrders.where((o) => o.queuePosition == null).toList();

          if (allOrders.isEmpty) {
            return const Center(
              child: Text(
                "No orders found",
                style: TextStyle(color: Color(0xFF94A3B8), fontSize: 16),
              ),
            );
          }

          return TabBarView(
            children: [
              _buildOrderList(activeOrders, "No active orders"),
              _buildOrderList(pastOrders, "No past orders"),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildOrderList(List<OrderEntity> orders, String emptyMessage) {
    if (orders.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 16),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = Responsive.isDesktop(context);
        if (isDesktop) {
          return GridView.builder(
            padding: const EdgeInsets.all(24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
            ),
            itemCount: orders.length,
            itemBuilder:
                (context, index) => _buildActiveOrderCard(orders[index], index),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: orders.length,
          itemBuilder:
              (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildActiveOrderCard(orders[index], index),
              ),
        );
      },
    );
  }

  // ── Status helpers ──────────────────────────────────────────────

  // ────────────────────────────────────────────────────────────────
  Widget _buildActiveOrderCard(OrderEntity order, int index) {
    final status = order.status?.toUpperCase() ?? 'PENDING';
    final style = statusStyles[status] ?? statusStyles['PENDING']!;
    final chipFg = style.color;
    final chipBg = style.bgColor;
    final chipIcon = style.icon;
    final chipLabel = style.label;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      //  width: 100,
                      child: Text(
                        '#${order.id}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatDateTime(order.createdAt),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF94A3B8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: chipBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: chipFg.withValues(alpha: 0.25)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(chipIcon, size: 14, color: chipFg),
                    const SizedBox(width: 6),
                    Text(
                      chipLabel,
                      style: TextStyle(
                        color: chipFg,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 16),
          ...?order.items?.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0EA5E9).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: const Color(0xFF0EA5E9).withOpacity(0.2),
                      ),
                    ),
                    child: Text(
                      '${item.quantity}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0EA5E9),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF334155),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (order.queuePosition != null)
                Row(
                  children: [
                    const Text(
                      'QUEUE POS',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF94A3B8),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '#${order.queuePosition ?? '0'}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF475569),
                      ),
                    ),
                  ],
                )
              else
                const SizedBox(),
              Text(
                '₹${(order.totalPrice ?? 0.0).toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0EA5E9),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fade().slideY(
      begin: 0.05,
      duration: 300.ms,
      delay: (index * 50).ms,
    );
  }

  String _formatDateTime(DateTime? dt) {
    if (dt == null) return 'N/A';

    // Convert to local time
    final localDt = dt.toLocal();
    final now = DateTime.now();

    // Create Date-only versions for accurate day comparison
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final itemDate = DateTime(localDt.year, localDt.month, localDt.day);

    String dayPrefix = '';
    if (itemDate == today) {
      dayPrefix = 'Today';
    } else if (itemDate == yesterday) {
      dayPrefix = 'Yesterday';
    } else {
      dayPrefix = '${localDt.day}/${localDt.month}';
    }

    final hour =
        localDt.hour > 12
            ? localDt.hour - 12
            : (localDt.hour == 0 ? 12 : localDt.hour);
    final period = localDt.hour >= 12 ? 'PM' : 'AM';
    final minute = localDt.minute.toString().padLeft(2, '0');

    return '$dayPrefix • $hour:$minute $period';
  }
}

class OrderCardSkeleton extends StatelessWidget {
  const OrderCardSkeleton({super.key});

  Widget box({double? width, double? height, double radius = 8}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  box(width: 80, height: 24),
                  const SizedBox(height: 4),
                  box(width: 120, height: 14),
                ],
              ),
              box(width: 70, height: 32, radius: 20),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 16),
          // Simulate 2 items
          box(width: double.infinity, height: 15),
          const SizedBox(height: 12),
          box(width: 200, height: 15),
          const SizedBox(height: 20),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [box(width: 100, height: 16), box(width: 90, height: 26)],
          ),
        ],
      ),
    );
  }
}

class OrderStatusStyle {
  final Color color;
  final Color bgColor;
  final IconData icon;
  final String label;

  const OrderStatusStyle({
    required this.color,
    required this.bgColor,
    required this.icon,
    required this.label,
  });
}

const Map<String, OrderStatusStyle> statusStyles = {
  'READY': OrderStatusStyle(
    color: Color(0xFF22C55E),
    bgColor: Color(0xFFDCFCE7),
    icon: Icons.check_circle_rounded,
    label: 'READY',
  ),

  'PREPARING': OrderStatusStyle(
    color: Color(0xFFFB923C),
    bgColor: Color(0xFFFFF7ED),
    icon: Icons.restaurant_rounded,
    label: 'IN KITCHEN',
  ),

  'COOKING': OrderStatusStyle(
    color: Color(0xFFFB923C),
    bgColor: Color(0xFFFFF7ED),
    icon: Icons.restaurant_rounded,
    label: 'IN KITCHEN',
  ),

  'PENDING': OrderStatusStyle(
    color: Color(0xFF0EA5E9),
    bgColor: Color(0xFFE0F2FE),
    icon: Icons.hourglass_top_rounded,
    label: 'PENDING',
  ),

  'CANCELLED': OrderStatusStyle(
    color: Color(0xFFB71C1C),
    bgColor: Color(0xFFFFEBEE),
    icon: Icons.cancel_rounded,
    label: 'CANCELLED',
  ),
};
