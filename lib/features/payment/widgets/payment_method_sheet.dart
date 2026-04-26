import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Shows a bottom sheet letting the user choose a payment method.
/// Returns true if the user proceeds with Stripe, false if cancelled.
Future<bool?> showPaymentMethodSheet({
  required BuildContext context,
  required double totalAmount,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _PaymentMethodSheet(totalAmount: totalAmount),
  );
}

class _PaymentMethodSheet extends StatelessWidget {
  final double totalAmount;
  const _PaymentMethodSheet({required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Choose Payment Method',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Total: ₹${totalAmount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 15,
              color: Colors.blueGrey.shade400,
            ),
          ),
          const SizedBox(height: 24),

          // Razorpay option
          _PaymentOption(
            icon: LucideIcons.creditCard,
            label: 'Credit / Debit Card',
            subtitle: 'Powered by Razorpay',
            color: primary,
            onTap: () async {
              Navigator.pop(context, true);
            },
          ).animate().fade(duration: 200.ms).slideY(begin: 0.1),

          const SizedBox(height: 12),

          // Cash on delivery option
          _PaymentOption(
            icon: LucideIcons.banknote,
            label: 'Cash on Delivery',
            subtitle: 'Pay at the counter',
            color: Colors.green.shade600,
            onTap: () => Navigator.pop(context, false),
          ).animate().fade(duration: 200.ms, delay: 80.ms).slideY(begin: 0.1),

          const SizedBox(height: 20),

          // Cancel
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.blueGrey.shade400, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B))),
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: 12, color: Colors.blueGrey.shade400)),
                ],
              ),
            ),
            Icon(LucideIcons.chevronRight,
                color: Colors.blueGrey.shade300, size: 18),
          ],
        ),
      ),
    );
  }
}
