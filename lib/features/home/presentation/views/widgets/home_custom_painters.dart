import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Custom painters for promotional banner decorative elements.
///
/// Provides various visual effects for promo banners:
/// - Diagonal slashes for dynamic feel
/// - Stripes for texture
/// - Ice crystals for beverage theme
/// - Arc dots for modern aesthetic

/// Diagonal slash pattern painter for dessert category.
class DiagonalSlashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Draws diagonal lines to create dynamic visual interest
    void drawLine(
      double xTopFrac,
      double xBotFrac,
      double opacity,
      double width,
    ) {
      final paint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFD4860A).withValues(alpha: 0.0),
            const Color(0xFFD4860A).withValues(alpha: opacity),
            const Color(0xFFD4860A).withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
        ..strokeWidth = width
        ..style = PaintingStyle.stroke;
      
      canvas.drawLine(
        Offset(size.width * xTopFrac, 0),
        Offset(size.width * xBotFrac, size.height),
        paint,
      );
    }

    drawLine(0.40, 0.30, 0.18, 1.2);
    drawLine(0.44, 0.34, 0.09, 1.0);
  }

  @override
  bool shouldRepaint(_) => false;
}

/// Stripe pattern painter for snack category.
class StripePainter extends CustomPainter {
  final Color color;
  
  const StripePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.10)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    
    // Creates diagonal stripe pattern for texture
    for (int i = 0; i < 6; i++) {
      final x = size.width * (0.34 + i * 0.028);
      canvas.drawLine(
        Offset(x, 0),
        Offset(x - size.height * 0.3, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

/// Ice crystal pattern painter for drink category.
class IcePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00CFFF).withValues(alpha: 0.10)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Draws hexagonal crystal pattern to represent ice/cold drinks
    final cx = size.width * 0.38;
    final cy = size.height * 0.25;
    const r = 22.0;
    
    for (int i = 0; i < 6; i++) {
      final angle = math.pi / 3 * i;
      final x = cx + r * math.cos(angle);
      final y = cy + r * math.sin(angle);
      canvas.drawLine(Offset(cx, cy), Offset(x, y), paint);
    }
    
    canvas.drawCircle(
      Offset(cx, cy),
      r,
      paint..color = const Color(0xFF00CFFF).withValues(alpha: 0.06),
    );
  }

  @override
  bool shouldRepaint(_) => false;
}

/// Arc dot pattern painter for beverage category.
class ArcDotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFBB66FF).withValues(alpha: 0.18)
      ..style = PaintingStyle.fill;

    // Creates arc of dots for modern, elegant aesthetic
    const cx = 30.0;
    final cy = size.height * 0.5;
    
    for (int i = 0; i < 5; i++) {
      final angle = -math.pi / 4 + (math.pi / 2) / 4 * i;
      const r = 55.0;
      final x = cx + r * math.cos(angle);
      final y = cy + r * math.sin(angle);
      canvas.drawCircle(Offset(x, y), 2.5 - i * 0.3, paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

/// Dashed divider for separating menu items.
class DashedDivider extends StatelessWidget {
  final double height;
  final Color color;

  const DashedDivider({
    super.key,
    this.height = 1,
    this.color = const Color(0xFFCBD5E1),
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const dashWidth = 4.0;
        const dashSpace = 4.0;
        final dashCount =
            (constraints.maxWidth / (dashWidth + dashSpace)).floor();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: height,
              child: DecoratedBox(decoration: BoxDecoration(color: color)),
            );
          }),
        );
      },
    );
  }
}
