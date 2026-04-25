import 'package:flutter/material.dart';
import 'package:canteen_mangement/features/cart/presentation/controllers/cart_controller.dart';
import 'package:canteen_mangement/features/menu/domain/entities/menu_item_entity.dart';
import 'package:canteen_mangement/features/menu/presentation/views/widgets/menu_detail_cart_action.dart';
import 'package:canteen_mangement/core/theme/custom%20theme_tokens.dart';

/// Content section widget for menu detail view.
///
/// Displays:
/// - Item name
/// - Meta chips (time, popular, fresh)
/// - Cart action buttons
/// - Description with expand/collapse
class MenuDetailContent extends StatefulWidget {
  final MenuItemEntity item;
  final CartController cartController;

  const MenuDetailContent({
    super.key,
    required this.item,
    required this.cartController,
  });

  @override
  State<MenuDetailContent> createState() => _MenuDetailContentState();
}

class _MenuDetailContentState extends State<MenuDetailContent> {
  bool _descExpanded = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item name
          Text(
            widget.item.name,
            style: textTheme.displaySmall?.copyWith(
              fontSize: 30,
              height: 1.2,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 14),

          // Meta chips (time, popular, fresh)
          _buildMetaChips(context, cs),
          const SizedBox(height: 24),

          // Cart action (add to cart / quantity selector)
          MenuDetailCartAction(
            itemId: widget.item.id,
            cartController: widget.cartController,
          ),
          const SizedBox(height: 30),

          // About section
          _buildSectionDivider(context, 'ABOUT THIS DISH'),
          const SizedBox(height: 14),
          _buildDescription(context, cs, textTheme),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  /// Builds meta information chips (time, popular, fresh).
  Widget _buildMetaChips(BuildContext context, ColorScheme cs) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (widget.item.timeTaken != null)
          _buildChip(
            context,
            icon: Icons.schedule_rounded,
            label: '${widget.item.timeTaken} mins',
            bgColor: cs.primary.withValues(alpha: 0.10),
            textColor: cs.primary,
          ),
        _buildChip(
          context,
          icon: Icons.local_fire_department_rounded,
          label: 'Popular',
          bgColor: const Color(0xFFFFECEC),
          textColor: const Color(0xFFD45C5C),
        ),
        _buildChip(
          context,
          icon: Icons.eco_rounded,
          label: 'Fresh',
          bgColor: const Color(0xFFE8F5E9),
          textColor: const Color(0xFF4CAF50),
        ),
      ],
    );
  }

  /// Builds individual meta chip.
  Widget _buildChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color bgColor,
    required Color textColor,
  }) {
    final tokens = context.tokens;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(tokens.rFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 5),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
          ),
        ],
      ),
    );
  }

  /// Builds description with expand/collapse functionality.
  Widget _buildDescription(
    BuildContext context,
    ColorScheme cs,
    TextTheme textTheme,
  ) {
    final desc = widget.item.description ??
        'A lovingly crafted dish prepared fresh each day with hand-selected ingredients. Every bite tells a story of quality, care, and culinary passion.';
    final descStyle = textTheme.bodyMedium?.copyWith(height: 1.8);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          desc,
          style: descStyle,
          maxLines: _descExpanded ? null : 5,
          overflow: _descExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
        ),
        // Show expand/collapse toggle only if text overflows
        LayoutBuilder(
          builder: (context, constraints) {
            final tp = TextPainter(
              text: TextSpan(text: desc, style: descStyle),
              maxLines: 4,
              textDirection: TextDirection.ltr,
            )..layout(maxWidth: constraints.maxWidth);

            final overflows = tp.didExceedMaxLines;
            if (!overflows) return const SizedBox.shrink();

            return GestureDetector(
              onTap: () => setState(() => _descExpanded = !_descExpanded),
              child: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  _descExpanded ? 'Read less ▲' : 'Read more ▼',
                  style: textTheme.bodySmall?.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  /// Builds section divider with label.
  Widget _buildSectionDivider(BuildContext context, String label) {
    final tokens = context.tokens;

    return Row(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 2.0,
                color: tokens.mutedText,
              ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  tokens.borderLight,
                  tokens.borderLight.withValues(alpha: 0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
