import 'package:canteen_mangement/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:canteen_mangement/core/constants/app_routes.dart';
import 'package:canteen_mangement/core/theme/custom%20theme_tokens.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

class OrderSuccessAnimation extends StatefulWidget {
  const OrderSuccessAnimation({super.key});

  @override
  State<OrderSuccessAnimation> createState() => _OrderSuccessAnimationState();
}

class _OrderSuccessAnimationState extends State<OrderSuccessAnimation>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _rippleController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _textOffsetAnimation;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _scaleAnimation = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    );

    _opacityAnimation = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
    );

    _textOffsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOutBack),
      ),
    );

    _mainController.forward();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background ripples
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _rippleController,
              builder: (context, child) {
                return CustomPaint(
                  painter: RipplePainter(
                    animationValue: _rippleController.value,
                    color: primary.withAlpha((255 * 0.1).toInt()),
                  ),
                );
              },
            ),
          ),

          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated Icon
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: Colors.green.shade500,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withAlpha((255 * 0.3).toInt()),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        LucideIcons.check,
                        color: Colors.white,
                        size: 80,
                      ),
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Success Text
                  FadeTransition(
                    opacity: _opacityAnimation,
                    child: SlideTransition(
                      position: _textOffsetAnimation,
                      child: Column(
                        children: [
                          Text(
                            'Order Successful!',
                            style: theme.textTheme.displaySmall?.copyWith(
                              color: theme.colorScheme.onSurface,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Text(
                              'Your delicious meal is being prepared and will be ready shortly.',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: context.tokens.mutedText,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 64),

                  // Action Button
                  FadeTransition(
                    opacity: _opacityAnimation,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 48),
                      child: ElevatedButton(
                        onPressed: () {
                          Get.find<DashboardController>().changeIndex(3);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              context.tokens.rLg,
                            ),
                          ),
                          elevation: 8,
                          shadowColor: primary.withAlpha((255 * 0.4).toInt()),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Track Order'),
                            SizedBox(width: 8),
                            Icon(LucideIcons.arrowRight, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RipplePainter extends CustomPainter {
  final double animationValue;
  final Color color;

  RipplePainter({required this.animationValue, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width * 0.8;

    for (int i = 3; i >= 1; i--) {
      final progress = (animationValue + (i / 3)) % 1.0;
      final radius = maxRadius * progress;
      final opacity = 1.0 - progress;

      final paint =
          Paint()
            ..color = color.withAlpha((255 * opacity).toInt())
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.0;

      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(RipplePainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}
