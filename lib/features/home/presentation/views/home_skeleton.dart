import 'package:canteen_mangement/features/home/presentation/views/widgets/menu_item_card.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          const SliverToBoxAdapter(child: _HeaderSkeleton()),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          const SliverToBoxAdapter(child: _CategoriesSkeleton()),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          const SliverToBoxAdapter(child: _BannerSkeleton()),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: MenuItemCardSkeleton(),
                );
              }),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}

class SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const SkeletonBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
      ),
    );
  }
}

class _HeaderSkeleton extends StatelessWidget {
  const _HeaderSkeleton();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        // padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonBox(width: 120, height: 14),
            SizedBox(height: 8),
            SkeletonBox(width: 120, height: 14),
            SizedBox(height: 8),
            SkeletonBox(width: 120, height: 14),
            SizedBox(height: 8),
            SkeletonBox(width: 180, height: 24),
            SizedBox(height: 20),
            SkeletonBox(width: double.infinity, height: 50),
          ],
        ),
      ),
    );
  }
}

class _CategoriesSkeleton extends StatelessWidget {
  const _CategoriesSkeleton();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SkeletonBox(width: 82, height: 82),
            SkeletonBox(width: 82, height: 82),
            SkeletonBox(width: 82, height: 82),
            SkeletonBox(width: 82, height: 82),
          ],
        ),
      ),
    );
  }
}

class _BannerSkeleton extends StatelessWidget {
  const _BannerSkeleton();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SkeletonBox(
          width: double.infinity,
          height: 180,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
    );
  }
}
