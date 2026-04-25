import 'package:flutter/material.dart';
import 'package:canteen_mangement/features/order/presentation/views/widgets/order_timer.dart';

/// Order ready dialog widget for dashboard.
///
/// Displays a modal dialog when one or more orders are ready for pickup.
/// Shows:
/// - Success icon
/// - Order count
/// - Order IDs and item names
/// - Confirmation button
///
/// Cannot be dismissed by tapping outside (barrierDismissible: false).
class DashboardOrderReadyDialog extends StatelessWidget {
  final List<ActiveOrderInfo> orders;

  const DashboardOrderReadyDialog({
    super.key,
    required this.orders,
  });

  @override
  Widget build(BuildContext context) {
    final isSingle = orders.length == 1;

    return PopScope(
      canPop: false,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSuccessIcon(),
              const SizedBox(height: 20),
              _buildTitle(isSingle),
              const SizedBox(height: 12),
              ..._buildOrderList(),
              const SizedBox(height: 8),
              _buildSubtitle(isSingle),
              const SizedBox(height: 28),
              _buildConfirmButton(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds success icon with green background.
  Widget _buildSuccessIcon() {
    return Container(
      width: 72,
      height: 72,
      decoration: const BoxDecoration(
        color: Color(0xFFDCFCE7),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.check_circle_rounded,
        color: Color(0xFF22C55E),
        size: 40,
      ),
    );
  }

  /// Builds dialog title based on order count.
  Widget _buildTitle(bool isSingle) {
    return Text(
      isSingle ? 'Order Ready!' : '${orders.length} Orders Ready!',
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        color: Color(0xFF1A1A2E),
      ),
    );
  }

  /// Builds list of order information.
  List<Widget> _buildOrderList() {
    return orders.map((order) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          children: [
            Text(
              'Order #${order.orderId}',
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              order.itemName ?? 'Your order',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF334155),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }).toList();
  }

  /// Builds subtitle text based on order count.
  Widget _buildSubtitle(bool isSingle) {
    return Text(
      isSingle ? 'is ready for pickup.' : 'are ready for pickup.',
      style: const TextStyle(
        fontSize: 14,
        color: Color(0xFF94A3B8),
      ),
    );
  }

  /// Builds confirmation button.
  Widget _buildConfirmButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => Navigator.of(context).pop(),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF22C55E),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Text(
          'Got it',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

/// Shows order ready dialog.
///
/// Displays a modal dialog when orders are ready for pickup.
/// Cannot be dismissed by tapping outside.
void showOrderReadyDialog(
  BuildContext context,
  List<ActiveOrderInfo> orders,
) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => DashboardOrderReadyDialog(orders: orders),
  );
}
