import 'dart:async';
import 'dart:ui';
import 'package:canteen_mangement/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

class OrderTimerBar extends StatefulWidget {
  final List<ActiveOrderInfo> activeOrders;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onExpandChanged;
  final VoidCallback? onOrderExpired;
  final ValueChanged<ActiveOrderInfo>? onOrderExpiredWithInfo;

  const OrderTimerBar({
    super.key,
    required this.activeOrders,
    this.onTap,
    this.onExpandChanged,
    this.onOrderExpired,
    this.onOrderExpiredWithInfo,
  });

  @override
  State<OrderTimerBar> createState() => _OrderTimerBarState();
}

class ActiveOrderInfo {
  final String orderId;
  final num estimatedWaitMinutes;
  final String status;
  final String? itemName;

  const ActiveOrderInfo({
    required this.orderId,
    required this.estimatedWaitMinutes,
    required this.status,
    this.itemName,
  });
}

class _OrderTimerBarState extends State<OrderTimerBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late Map<String, num> _secondsLeft;
  Timer? _countdown;
  bool _isExpanded = false;
  final Set<String> _expiredNotified = {};
  final DashboardController dashboardController =
      Get.find<DashboardController>();

  @override
  void initState() {
    super.initState();

    _secondsLeft = {
      for (final o in widget.activeOrders)
        o.orderId: o.estimatedWaitMinutes * 60,
    };

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _countdown = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        for (final key in _secondsLeft.keys.toList()) {
          if ((_secondsLeft[key] ?? 0) > 0) {
            _secondsLeft[key] = _secondsLeft[key]! - 1;

            if (_secondsLeft[key] == 0 && !_expiredNotified.contains(key)) {
              _expiredNotified.add(key);
              widget.onOrderExpired?.call();
              final expiredOrder = widget.activeOrders
                  .where((o) => o.orderId == key)
                  .firstOrNull;
              if (expiredOrder != null) {
                widget.onOrderExpiredWithInfo?.call(expiredOrder);
              }
            }
          }
        }
      });
    });
  }

  @override
  void didUpdateWidget(OrderTimerBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    for (final o in widget.activeOrders) {
      if (!_secondsLeft.containsKey(o.orderId)) {
        _secondsLeft[o.orderId] = o.estimatedWaitMinutes * 60;
      }
    }
    final currentIds = widget.activeOrders.map((o) => o.orderId).toSet();
    _secondsLeft.removeWhere((k, _) => !currentIds.contains(k));
    _expiredNotified.removeWhere((k) => !currentIds.contains(k));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _countdown?.cancel();
    super.dispose();
  }

  bool _isExpired(String orderId) => (_secondsLeft[orderId] ?? 0) <= 0;

  String _timeLabel(String orderId) {
    final s = _secondsLeft[orderId] ?? 0;
    final m = s ~/ 60;
    final sec = s % 60;
    if (m > 0) return '${m}m ${sec.toString().padLeft(2, '0')}s';
    return '${sec}s';
  }

  @override
  Widget build(BuildContext context) {
    
    final orders = widget.activeOrders;
    final isMultiple = orders.length > 1;
    //print("dashboardController ${dashboardController.currentIndex.value}");
    return Obx(
      () => BackdropFilter(
        enabled:
            (dashboardController.currentIndex.value == 0 ||
                        dashboardController.currentIndex.value == 4) &&
                    _isExpanded
                ? true
                : false,
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: GestureDetector(
          onTap: () {
            if (isMultiple) {
              setState(() => _isExpanded = !_isExpanded);
              widget.onExpandChanged?.call(_isExpanded);
            } else {
              widget.onTap?.call();
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF0EA5E9).withOpacity(0.25),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0EA5E9).withOpacity(0.12),
                  blurRadius: 16,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Header row ──
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder:
                            (_, __) => Transform.scale(
                              scale: _pulseAnimation.value,
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF0EA5E9,
                                  ).withOpacity(0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  LucideIcons.chefHat,
                                  size: 18,
                                  color: Color(0xFF0EA5E9),
                                ),
                              ),
                            ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              isMultiple
                                  ? '${orders.length} orders in preparation'
                                  : 'Order in preparation',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1A1A2E),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              isMultiple
                                  ? 'Tap to see all timers'
                                  : (_isExpired(orders.first.orderId)
                                      ? 'Please wait, almost ready'
                                      : 'Est. ready in ${_timeLabel(orders.first.orderId)}'),
                              style: TextStyle(
                                fontSize: 11,
                                color:
                                    _isExpired(orders.first.orderId) &&
                                            !isMultiple
                                        ? Colors.orange
                                        : const Color(0xFF64748B),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!isMultiple)
                        _isExpired(orders.first.orderId)
                            ? Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                '• • •',
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 2,
                                ),
                              ),
                            )
                            : Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0EA5E9),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _timeLabel(orders.first.orderId),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  fontFeatures: [FontFeature.tabularFigures()],
                                ),
                              ),
                            ),
                      if (isMultiple) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0EA5E9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${orders.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        AnimatedRotation(
                          turns: _isExpanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 300),
                          child: const Icon(
                            LucideIcons.chevronUp,
                            size: 16,
                            color: Color(0xFFB0BEC5),
                          ),
                        ),
                      ] else ...[
                        const SizedBox(width: 4),
                        const Icon(
                          LucideIcons.chevronRight,
                          size: 16,
                          color: Color(0xFFB0BEC5),
                        ),
                      ],
                    ],
                  ),
                ),

                // ── Animated expanded order list ──
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  child:
                      isMultiple && _isExpanded
                          ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Divider(
                                height: 1,
                                color: Color(0xFFEEF2F7),
                              ),
                              ...orders.asMap().entries.map((entry) {
                                final index = entry.key;
                                final order = entry.value;
                                final expired = _isExpired(order.orderId);

                                return TweenAnimationBuilder<double>(
                                  key: ValueKey(order.orderId),
                                  tween: Tween(begin: 0.0, end: 1.0),
                                  duration: Duration(
                                    milliseconds: 200 + (index * 60),
                                  ),
                                  curve: Curves.easeOutCubic,
                                  builder:
                                      (context, value, child) => Opacity(
                                        opacity: value,
                                        child: Transform.translate(
                                          offset: Offset(0, 8 * (1 - value)),
                                          child: child,
                                        ),
                                      ),
                                  child: GestureDetector(
                                    onTap: widget.onTap,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 10,
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:
                                                  expired
                                                      ? Colors.orange
                                                      : const Color(0xFF0EA5E9),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              order.itemName ?? 'Order',
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFF1A1A2E),
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          expired
                                              ? Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.orange
                                                      .withOpacity(0.12),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: const Text(
                                                  '• • •',
                                                  style: TextStyle(
                                                    color: Colors.orange,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w700,
                                                    letterSpacing: 2,
                                                  ),
                                                ),
                                              )
                                              : Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                    0xFF0EA5E9,
                                                  ).withOpacity(0.10),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  _timeLabel(order.orderId),
                                                  style: const TextStyle(
                                                    color: Color(0xFF0EA5E9),
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w700,
                                                    fontFeatures: [
                                                      FontFeature.tabularFigures(),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                          const SizedBox(width: 4),
                                          const Icon(
                                            LucideIcons.chevronRight,
                                            size: 14,
                                            color: Color(0xFFB0BEC5),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                              const SizedBox(height: 4),
                            ],
                          )
                          : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
