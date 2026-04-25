import 'package:canteen_mangement/features/cart/presentation/controllers/cart_controller.dart';
import 'package:canteen_mangement/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:canteen_mangement/features/order/presentation/controllers/order_controller.dart';
import 'package:canteen_mangement/core/utils/responsive.dart';
import 'package:canteen_mangement/features/cart/presentation/views/order_success_animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:canteen_mangement/features/home/presentation/views/widgets/menu_item_card.dart';
import 'package:canteen_mangement/core/widgets/common_app_bar.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:canteen_mangement/core/widgets/bouncing_widget.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CartView extends StatelessWidget {
  final CartController _cartController = Get.find<CartController>();
  final OrderController _orderController = Get.find<OrderController>();

  CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: "Cart"),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Obx(() {
        if (_orderController.isLoading.value) {
          return Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          );
        }
        if (_cartController.isLoading.value) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 5,
            itemBuilder: (_, __) => const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: MenuItemCardSkeleton(),
            ),
          );
        }
        final cart = _cartController.cart.value;
        if (cart == null || cart.items.isEmpty) {
          return _buildEmptyCart();
        }
        return Responsive.isDesktop(context)
            ? _buildDesktopLayout(context, cart)
            : _buildMobileLayout(context, cart);
      }),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, dynamic cart) {
    final primary = Theme.of(context).colorScheme.primary;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left: cart items list
        Expanded(
          flex: 3,
          child: ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: cart.items.length,
            itemBuilder: (context, index) {
              final item = cart.items[index];
              return _CartItemTile(
                item: item,
                onAdd: () => _cartController.addItem(item.menuItem.id, 1,
                    showLoading: false, showSnackbar: false),
                onRemove: () {
                  if (item.quantity > 1) {
                    _cartController.updateItem(
                        item.menuItem.id, item.quantity - 1,
                        showLoading: false, showSnackbar: false);
                  } else {
                    _cartController.removeItem(item.menuItem.id);
                  }
                },
                onDelete: () => _cartController.removeItem(item.menuItem.id),
              ).animate().fade().slideX(
                    begin: 0.1,
                    duration: 300.ms,
                    delay: (index * 50).ms,
                  );
            },
          ),
        ),
        // Right: order summary panel
        Container(
          width: 320,
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Order Summary',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B))),
              const SizedBox(height: 20),
              ...cart.items.map<Widget>((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${item.menuItem.name} x${item.quantity}',
                            style: const TextStyle(
                                fontSize: 14, color: Color(0xFF475569)),
                          ),
                        ),
                        Text(
                          '₹${(item.menuItem.price * item.quantity).toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E293B)),
                        ),
                      ],
                    ),
                  )),
              const Divider(color: Color(0xFFF1F5F9)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E293B))),
                  Text(
                    '₹${cart.items.fold(0.0, (s, e) => s + e.menuItem.price * e.quantity).toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: primary),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () async {
                    bool success =
                        await _orderController.placeOrderFromCart();
                    if (success) {
                      Get.to(() => const OrderSuccessAnimation());
                    }
                  },
                  child: const Text('Place Order',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context, dynamic cart) {
    return Stack(
      children: [
        Column(
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: cart.items.length,
                itemBuilder: (context, index) {
                  final item = cart.items[index];
                  return _CartItemTile(
                    item: item,
                    onAdd: () => _cartController.addItem(item.menuItem.id, 1,
                        showLoading: false, showSnackbar: false),
                    onRemove: () {
                      if (item.quantity > 1) {
                        _cartController.updateItem(
                            item.menuItem.id, item.quantity - 1,
                            showLoading: false, showSnackbar: false);
                      } else {
                        _cartController.removeItem(item.menuItem.id);
                      }
                    },
                    onDelete: () =>
                        _cartController.removeItem(item.menuItem.id),
                  ).animate().fade().slideX(
                        begin: 0.1,
                        duration: 300.ms,
                        delay: (index * 50).ms,
                      );
                },
              ),
            ),
            _buildOrderSummary(),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyCart() {
    return Builder(
      builder: (context) {
        final primary = Theme.of(context).colorScheme.primary;
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    LucideIcons.shoppingBag,
                    size: 80,
                    color: primary.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  "Your cart is empty",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Looks like you haven't made your choice yet. Go back and explore our delicious menu!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blueGrey.shade400,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    Get.find<DashboardController>().changeIndex(0);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Explore Menu",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ).animate().fade().slideY(begin: 0.1);
      },
    );
  }

  Widget _buildOrderSummary() {
    return Builder(
      builder: (context) {
        final primary = Theme.of(context).colorScheme.primary;
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: SafeArea(
            top: false,
            minimum: const EdgeInsets.only(bottom: 72),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Text(
                    "₹ ${_cartController.cart.value!.items.fold(0.0, (previousValue, element) => previousValue + (element.menuItem.price * element.quantity))}",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: primary),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () async {
                        bool success = await _orderController.placeOrderFromCart();
                        if (success) {
                          Get.to(() => const OrderSuccessAnimation());
                        }
                      },
                      child: const Text(
                        "Place Order",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ).animate().fade().slideY(begin: 0.2);
      },
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final dynamic item; // Replace with your CartItem model
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final VoidCallback onDelete;

  const _CartItemTile({
    required this.item,
    required this.onAdd,
    required this.onRemove,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              item.menuItem.imageUrl ?? 'https://via.placeholder.com/80',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade200,
                  width: 80,
                  height: 80,
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          // Details Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "NMIMS CAMPUS CANTEEN", // Static or dynamic canteen name
                      style: TextStyle(
                        color: Colors.blueGrey.shade300,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    BouncingWidget(
                      onTap: onDelete,
                      child: Icon(
                        Icons.delete_outline,
                        color: Colors.blueGrey.shade300,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.menuItem.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\₹${item.menuItem.price.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    // Quantity Controller
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          _buildQtyBtn(context, Icons.remove, onRemove),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              "${item.quantity}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          _buildQtyBtn(context, Icons.add, onAdd),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQtyBtn(BuildContext context, IconData icon, VoidCallback onTap) {
    return BouncingWidget(
      onTap: onTap,
      scaleFactor: 0.8,
      child: Container(
        padding: const EdgeInsets.all(4),
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }
}
