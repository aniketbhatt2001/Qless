import 'package:flutter/material.dart';

/// Promotional banner widget for category showcases.
///
/// Displays visually rich promotional content with:
/// - Background image
/// - Gradient overlays
/// - Category chip
/// - Headline text
/// - Call-to-action button
/// - Optional decorative painter
///
/// Used in carousel to promote different food categories.
class PromoBanner extends StatelessWidget {
  final Color bgColor;
  final Color shadowColor;
  final Color accentColor;
  final Color headlineColor;
  final Color ctaTextColor;
  final String imageUrl;
  final String chipLabel;
  final String headLine1;
  final String headLine2;
  final String tagline;
  final String ctaLabel;
  final CustomPainter? painter;
  final VoidCallback? onTap;

  const PromoBanner({
    super.key,
    required this.bgColor,
    required this.shadowColor,
    required this.accentColor,
    required this.headlineColor,
    required this.imageUrl,
    required this.chipLabel,
    required this.headLine1,
    required this.headLine2,
    required this.tagline,
    required this.ctaLabel,
    this.ctaTextColor = Colors.white,
    this.painter,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 190,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: shadowColor.withValues(alpha: 0.12),
                blurRadius: 14,
                spreadRadius: -2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background color layer
                Container(color: bgColor),

                // Food image positioned on right
                Positioned(
                  right: -10,
                  top: 0,
                  bottom: 0,
                  width: 235,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    alignment: Alignment.centerLeft,
                    loadingBuilder: (_, child, progress) =>
                        progress == null ? child : const SizedBox.shrink(),
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),

                // Subtle grain overlay for texture
                Opacity(
                  opacity: 0.07,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.topRight,
                        radius: 1.8,
                        colors: [accentColor, Colors.transparent],
                      ),
                    ),
                  ),
                ),

                // Left fade gradient to ensure text readability
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        bgColor,
                        bgColor.withValues(alpha: 0.94),
                        bgColor.withValues(alpha: 0.56),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.38, 0.62, 0.83],
                    ),
                  ),
                ),

                // Accent glow orb for visual interest
                Positioned(
                  left: -50,
                  bottom: -50,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          accentColor.withValues(alpha: 0.20),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                // Optional decorative painter (stripes, ice, etc.)
                if (painter != null) CustomPaint(painter: painter),

                // Content layer
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 0, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 18),

                      // Category chip with line accent
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(width: 16, height: 1.5, color: accentColor),
                          const SizedBox(width: 7),
                          Text(
                            chipLabel,
                            style: TextStyle(
                              color: accentColor,
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2.2,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Flexible text area prevents overflow
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900,
                                  fontStyle: FontStyle.italic,
                                  height: 1.05,
                                  letterSpacing: -0.5,
                                ),
                                children: [
                                  TextSpan(
                                    text: '$headLine1\n',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  TextSpan(
                                    text: headLine2,
                                    style: TextStyle(color: headlineColor),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              tagline,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.50),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Call-to-action button
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              accentColor.withValues(alpha: 0.85),
                              accentColor,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              ctaLabel,
                              style: TextStyle(
                                color: ctaTextColor,
                                fontWeight: FontWeight.w800,
                                fontSize: 12.5,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 14,
                              color: ctaTextColor,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),
                    ],
                  ),
                ),

                // Top gloss line for polish
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.0),
                          Colors.white.withValues(alpha: 0.14),
                          Colors.white.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
