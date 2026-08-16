import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/widgets/pharmacy_placeholder.dart';
import 'package:elkawther/features/home/data/home_demo_data.dart';
import 'package:elkawther/features/home/screens/home_navigation.dart';
import 'package:flutter/material.dart';

class HomeBanner extends StatefulWidget {
  const HomeBanner({super.key});

  @override
  State<HomeBanner> createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {
  int _current = 0;
  late final CarouselSliderController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CarouselSliderController();
  }

  @override
  Widget build(BuildContext context) {
    const banners = HomeDemoData.banners;

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: banners.length,
          carouselController: _controller,
          options: CarouselOptions(
            aspectRatio: 2.25,
            autoPlay: true,
            viewportFraction: 1,
            onPageChanged: (index, reason) => setState(() => _current = index),
          ),
          itemBuilder: (context, index, realIndex) {
            final banner = banners[index];
            return GestureDetector(
              onTap: () => HomeNavigation.openList(
                context,
                title: banner.title(context),
                products: HomeDemoData.productsForBanner(index),
              ),
              child: _PharmacyBannerCard(
                title: banner.title(context),
                imageUrl: banner.imageUrl,
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: banners.asMap().entries.map((entry) {
            final isActive = _current == entry.key;
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: isActive ? 18 : 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(99),
                  color: isActive
                      ? AppColors.primaryColor
                      : AppColors.greyCarsoul,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _PharmacyBannerCard extends StatelessWidget {
  const _PharmacyBannerCard({
    required this.title,
    required this.imageUrl,
  });

  final String title;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: AppColors.primaryColor,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            placeholder: (context, url) => const PharmacyImageLoading(),
            errorWidget: (context, url, error) => const ColoredBox(
              color: Color(0xff0B76B9),
              child: PharmacyPromoArt(size: 280),
            ),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: AlignmentDirectional.centerStart,
                end: AlignmentDirectional.centerEnd,
                colors: [
                  Color(0xCC0B76B9),
                  Color(0x6606A786),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                title,
                style: AppTextStyles.headlineLarge.copyWith(
                  color: Colors.white,
                  fontSize: 18,
                  height: 1.3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
