import 'package:cached_network_image/cached_network_image.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/features/home/data/home_demo_data.dart';
import 'package:elkawther/features/home/screens/home_navigation.dart';
import 'package:flutter/material.dart';

class HomeBrandsRow extends StatelessWidget {
  const HomeBrandsRow({super.key, this.brands = HomeDemoData.catalogBrands});

  final List<HomeDemoBrand> brands;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 148,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: brands.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final brand = brands[index];
          return HomeBrandCard(
            brand: brand,
            onTap: () => HomeNavigation.openBrand(context, brand),
          );
        },
      ),
    );
  }
}

class HomeBrandCard extends StatelessWidget {
  const HomeBrandCard({
    super.key,
    required this.brand,
    required this.onTap,
    this.compact = true,
  });

  final HomeDemoBrand brand;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final card = Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.lightDarker),
            boxShadow: [
              BoxShadow(
                color: brand.color.withOpacity(0.10),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              compact ? 12 : 14,
              compact ? 14 : 16,
              compact ? 12 : 14,
              compact ? 12 : 14,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: ColoredBox(
                    color: brand.color.withOpacity(0.08),
                    child: SizedBox(
                      width: compact ? 58 : 72,
                      height: compact ? 58 : 72,
                      child: CachedNetworkImage(
                        imageUrl: brand.logoUrl,
                        fit: BoxFit.cover,
                        width: compact ? 58 : 72,
                        height: compact ? 58 : 72,
                        placeholder: (context, url) =>
                            _BrandMark(brand: brand),
                        errorWidget: (context, url, error) =>
                            _BrandMark(brand: brand),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  brand.name(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.noto14w400.copyWith(
                    fontSize: compact ? 12 : 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  brand.category(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.noto14w400.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (!compact) return card;
    return SizedBox(width: 118, child: card);
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark({required this.brand});

  final HomeDemoBrand brand;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        brand.initial,
        style: AppTextStyles.noto16w400.copyWith(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: brand.color,
        ),
      ),
    );
  }
}
