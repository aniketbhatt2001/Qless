import 'package:flutter/material.dart';
import 'package:canteen_mangement/features/home/presentation/views/search_meals_view.dart';

/// Persistent search bar header delegate.
///
/// Creates pinned search bar that remains visible while scrolling.
/// Tapping opens full search view for meal searching.
class HomeSearchBarDelegate extends SliverPersistentHeaderDelegate {
  HomeSearchBarDelegate();

  @override
  double get minExtent => 72;

  @override
  double get maxExtent => 72;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
      child: GestureDetector(
        onTap: () => Navigator.of(
          context,
          rootNavigator: true,
        ).push(
          MaterialPageRoute(
            builder: (context) => const SearchMealsView(),
          ),
        ),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Row(
            children: [
              SizedBox(width: 14),
              Icon(Icons.search_rounded, color: Color(0xFF0EA5E9), size: 20),
              SizedBox(width: 10),
              Text(
                "Search meals...",
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant HomeSearchBarDelegate oldDelegate) {
    return false;
  }
}

/// Animated section divider with "Popular Meals" label.
///
/// Displays section header with animated food emoji.
class PopularMealsDivider extends StatefulWidget {
  const PopularMealsDivider({super.key});

  @override
  State<PopularMealsDivider> createState() => _PopularMealsDividerState();
}

class _PopularMealsDividerState extends State<PopularMealsDivider>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    // Subtle animation adds life to static section header
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Row(
        children: [
          // Left-aligned label with animated emoji
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Popular Meals',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                  color: Color(0xFF0EA5E9),
                ),
              ),
              const SizedBox(width: 4),
              Image.asset('assets/food.gif', width: 22, height: 22),
            ],
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}
