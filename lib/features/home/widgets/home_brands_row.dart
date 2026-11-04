import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/features/home/data/home_demo_data.dart';
import 'package:elkawther/features/home/screens/home_navigation.dart';
import 'package:elkawther/features/home/widgets/home_catalog_image.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';

class HomeBrandsRow extends StatelessWidget {
  const HomeBrandsRow({super.key, this.brands = HomeDemoData.catalogBrands});

  final List<HomeDemoBrand> brands;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 174,
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
    final category = brand.category(context).trim();
    final borderRadius = BorderRadius.circular(compact ? 22 : 20);
    final card = Material(
      color: Colors.white,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: borderRadius,
            border: Border.all(color: AppColors.lightDarker.withOpacity(0.8)),
            boxShadow: [
              BoxShadow(
                color: (compact ? brand.color : AppColors.darkColor)
                    .withOpacity(compact ? 0.08 : 0.06),
                blurRadius: compact ? 16 : 14,
                offset: Offset(0, compact ? 6 : 5),
              ),
            ],
          ),
          child:
              compact
                  ? Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: borderRadius,
                        child: HomeCatalogImage(
                          assetPath: brand.logoUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: borderRadius,
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0x11000000),
                              Color(0x22000000),
                              Color(0xCC000000),
                            ],
                            stops: [0, 0.42, 1],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Icon(
                                  Icons.verified_rounded,
                                  color: Colors.white,
                                  size: 19,
                                ),
                                Icon(
                                  Localizations.localeOf(
                                            context,
                                          ).languageCode ==
                                          'ar'
                                      ? Icons.arrow_back_rounded
                                      : Icons.arrow_forward_rounded,
                                  color: Colors.white,
                                  size: 17,
                                ),
                              ],
                            ),
                            const Spacer(),
                            Text(
                              brand.name(context),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: AppTextStyles.noto14w400.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                height: 1.15,
                                color: Colors.white,
                                shadows: const [
                                  Shadow(color: Colors.black54, blurRadius: 8),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                  : Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        _brandLogo(116),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _brandTag(context),
                              const SizedBox(height: 12),
                              Text(
                                brand.name(context),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.noto16w400.copyWith(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.darkColor,
                                ),
                              ),
                              if (category.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  category,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.noto14w400.copyWith(
                                    fontSize: 12,
                                    color: AppColors.grey,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Localizations.localeOf(context).languageCode == 'ar'
                              ? Icons.arrow_back_rounded
                              : Icons.arrow_forward_rounded,
                          color: brand.color,
                          size: 22,
                        ),
                      ],
                    ),
                  ),
        ),
      ),
    );

    if (!compact) return card;
    return SizedBox(width: 154, child: card);
  }

  Widget _brandTag(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: brand.color.withOpacity(0.09),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          S.of(context).brands,
          style: AppTextStyles.noto14w400.copyWith(
            color: brand.color,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _brandLogo(double size) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: brand.color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: brand.color.withOpacity(0.08)),
      ),
      child: HomeCatalogImage(
        assetPath: brand.logoUrl,
        fit: BoxFit.contain,
        width: size,
        height: size,
      ),
    );
  }
}
