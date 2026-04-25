import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:canteen_mangement/features/home/presentation/views/category_products_view.dart';
import 'package:canteen_mangement/features/home/presentation/views/widgets/home_custom_painters.dart';
import 'package:canteen_mangement/features/home/presentation/views/widgets/home_promo_banner.dart';

/// Promotional carousel widget displaying category banners.
///
/// Auto-scrolling carousel showcasing different food categories
/// with visually rich promotional banners. Each banner is tappable
/// and navigates to the respective category view.
class HomePromoCarousel extends StatelessWidget {
  const HomePromoCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: CarouselSlider(
          options: CarouselOptions(
            height: 200,
            viewportFraction: 0.82,
            enableInfiniteScroll: true,
            enlargeCenterPage: true,
            enlargeFactor: 0.08,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayAnimationDuration: const Duration(milliseconds: 500),
            autoPlayCurve: Curves.easeInOut,
            scrollPhysics: const BouncingScrollPhysics(),
          ),
          items: _buildPromoItems(context),
        ),
      ),
    );
  }

  /// Builds list of promotional banner items with navigation.
  List<Widget> _buildPromoItems(BuildContext context) {
    final promoData = [
      {
        'widget': PromoBanner(
          bgColor: const Color(0xFF0C0804),
          shadowColor: const Color(0xFF8B1A00),
          accentColor: const Color(0xFFE05C00),
          headlineColor: const Color(0xFFFFB347),
          imageUrl:
              "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800&q=95&fit=crop",
          chipLabel: "MAIN COURSE",
          headLine1: "Crafted",
          headLine2: "To Perfection",
          tagline: "Full meals that satisfy every craving",
          ctaLabel: "Explore Mains",
        ),
        'category': 'Main',
      },
      {
        'widget': PromoBanner(
          bgColor: const Color(0xFF0E0E06),
          shadowColor: const Color(0xFF7A6B00),
          accentColor: const Color(0xFFD4E200),
          headlineColor: const Color(0xFFE8F500),
          imageUrl:
              "https://images.unsplash.com/photo-1621939514649-280e2ee25f60?w=800&q=95&fit=crop",
          chipLabel: "SNACKS",
          headLine1: "Bite-Sized",
          headLine2: "Brilliance",
          tagline: "Quick bites packed with bold flavor",
          ctaLabel: "Grab a Snack",
          ctaTextColor: const Color(0xFF1A1A00),
          painter: const StripePainter(color: Color(0xFFD4E200)),
        ),
        'category': 'Snack',
      },
      {
        'widget': PromoBanner(
          bgColor: const Color(0xFF040E12),
          shadowColor: const Color(0xFF006080),
          accentColor: const Color(0xFF00CFFF),
          headlineColor: const Color(0xFF5DE8FF),
          imageUrl:
              "https://images.unsplash.com/photo-1544145945-f90425340c7e?w=800&q=95&fit=crop",
          chipLabel: "DRINKS",
          headLine1: "Icy Cold,",
          headLine2: "Pure Bliss",
          tagline: "Chilled drinks to cool your day",
          ctaLabel: "Browse Drinks",
          ctaTextColor: const Color(0xFF001A22),
          painter:  IcePainter(),
        ),
        'category': 'Drink',
      },
      {
        'widget': PromoBanner(
          bgColor: const Color(0xFF0A0510),
          shadowColor: const Color(0xFF3D0066),
          accentColor: const Color(0xFFBB66FF),
          headlineColor: const Color(0xFFCF8FFF),
          imageUrl:
              "https://images.unsplash.com/photo-1559181567-c3190ca9d177?w=800&q=95&fit=crop",
          chipLabel: "BEVERAGES",
          headLine1: "Sip the",
          headLine2: "Good Life",
          tagline: "Hot, cold & everything in between",
          ctaLabel: "See Beverages",
          painter:  ArcDotPainter(),
        ),
        'category': 'Beverage',
      },
      {
        'widget': PromoBanner(
          bgColor: const Color(0xFF0D0907),
          shadowColor: const Color(0xFF8B4500),
          accentColor: const Color(0xFFD4860A),
          headlineColor: const Color(0xFFFFD580),
          imageUrl:
              "https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=900&q=95&fit=crop",
          chipLabel: "DESSERTS",
          headLine1: "Sweet",
          headLine2: "Indulgence",
          tagline: "Cakes, pastries & sweet treats",
          ctaLabel: "Explore Desserts",
          ctaTextColor: const Color(0xFF1A0800),
          painter:  DiagonalSlashPainter(),
        ),
        'category': 'Dessert',
      },
    ];

    return promoData
        .map(
          (item) => GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => CategoryProductsView(
                  category: item['category'] as String,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(25)),
                child: item['widget'] as Widget,
              ),
            ),
          ),
        )
        .toList();
  }
}
