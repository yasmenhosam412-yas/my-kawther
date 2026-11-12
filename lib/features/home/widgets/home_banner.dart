import 'package:carousel_slider/carousel_slider.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/features/home/data/home_demo_data.dart';
import 'package:elkawther/features/home/screens/home_navigation.dart';
import 'package:elkawther/features/home/widgets/home_catalog_image.dart';
import 'package:elkawther/features/home/widgets/home_section_empty.dart';
import 'package:flutter/material.dart';

class HomeBanner extends StatefulWidget {
  const HomeBanner({super.key, this.banners});

  final List<HomeDemoBanner>? banners;

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
    final banners = widget.banners ?? HomeDemoData.banners;
    if (banners.isEmpty) {
      final isAr = Localizations.localeOf(context).languageCode == 'ar';
      return HomeSectionEmpty(
        message: isAr ? 'لا توجد بانرات حالياً' : 'No banners available',
        height: 180,
        iconSize: 56,
        padding: EdgeInsets.zero,
      );
    }

    final isSingle = banners.length == 1;

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: banners.length,
          carouselController: _controller,
          options: CarouselOptions(
            height: 180,
            autoPlay: !isSingle,
            enableInfiniteScroll: !isSingle,
            viewportFraction: 1,
            enlargeCenterPage: false,
            padEnds: false,
            onPageChanged: (index, reason) => setState(() => _current = index),
          ),
          itemBuilder: (context, index, realIndex) {
            final banner = banners[index];
            return GestureDetector(
              onTap:
                  banner.link?.trim().isNotEmpty == true
                      ? () => HomeNavigation.openBannerProducts(
                        context,
                        title: banner.title(context),
                        link: banner.link!,
                      )
                      : widget.banners == null
                      ? () => HomeNavigation.openList(
                        context,
                        title: banner.title(context),
                        products: HomeDemoData.productsForBanner(index),
                      )
                      : null,
              child: _PharmacyBannerCard(
                title: banner.title(context),
                description: banner.description,
                imageUrl: banner.imageUrl,
                pageLabel: isSingle ? null : '${index + 1} / ${banners.length}',
              ),
            );
          },
        ),
        if (!isSingle) ...[
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
                banners.asMap().entries.map((entry) {
                  final isActive = _current == entry.key;
                  return GestureDetector(
                    onTap: () => _controller.animateToPage(entry.key),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: SizedBox(
                        width: 28,
                        height: 24,
                        child: Center(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            width: isActive ? 20 : 7,
                            height: 7,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(99),
                              color:
                                  isActive
                                      ? AppColors.primaryColor
                                      : AppColors.greyCarsoul,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
        ],
      ],
    );
  }
}

class _PharmacyBannerCard extends StatelessWidget {
  const _PharmacyBannerCard({
    required this.title,
    required this.imageUrl,
    this.description,
    this.pageLabel,
  });

  final String title;
  final String imageUrl;
  final String? description;
  final String? pageLabel;

  @override
  Widget build(BuildContext context) {
    final title = this.title.trim();
    final description = this.description?.trim() ?? '';
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: AppColors.primaryColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          HomeCatalogImage(
            assetPath: imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.28),
                  Colors.transparent,
                  const Color(0xE60B426A),
                ],
                stops: const [0, 0.42, 1],
              ),
            ),
          ),
          if (pageLabel != null)
            PositionedDirectional(
              top: 14,
              end: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.32)),
                ),
                child: Text(
                  pageLabel!,
                  textDirection: TextDirection.ltr,
                  style: AppTextStyles.noto14w400.copyWith(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          if (title.isNotEmpty || description.isNotEmpty)
            PositionedDirectional(
              start: 18,
              end: 18,
              bottom: 18,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title.isNotEmpty)
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.headlineLarge.copyWith(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                        shadows: const [
                          Shadow(
                            color: Color(0x66000000),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  if (description.isNotEmpty) ...[
                    if (title.isNotEmpty) const SizedBox(height: 6),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.noto14w400.copyWith(
                        color: Colors.white.withOpacity(0.92),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                        shadows: const [
                          Shadow(
                            color: Color(0x66000000),
                            blurRadius: 6,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}
