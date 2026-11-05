import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';

/// The single shared product-card design used across the whole app
/// (home, category, brand, search, favorites, related lists...).
///
/// Every product card delegates its visual rendering here so the look is
/// always identical; callers keep their own product data / tap / cart logic.
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.image,
    required this.title,
    required this.priceText,
    this.originalPriceText,
    this.discountBadge,
    this.favoriteButton,
    this.actionButton,
    this.ratingRow,
    this.onTap,
  });

  /// Full-bleed image widget (already handles asset/network + placeholders).
  final Widget image;

  final String title;
  final String priceText;
  final String? originalPriceText;

  /// Small teal pill shown at the leading-top of the image area.
  final String? discountBadge;

  /// Favorite button shown at the top-end of the image area.
  final Widget? favoriteButton;

  /// Add-to-cart button rendered at the trailing side of the price row.
  final Widget? actionButton;

  /// Optional rating row placed under the title (stays in content column).
  final Widget? ratingRow;

  final VoidCallback? onTap;

  static const double cardAspectRatio = 0.62;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.lightDarker.withOpacity(0.7)),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkColor.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.white,
          child: InkWell(
            onTap: onTap,
            splashColor: AppColors.primaryColor.withOpacity(0.05),
            highlightColor: AppColors.primaryColor.withOpacity(0.03),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 6,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.light,
                              AppColors.light.withOpacity(0.45),
                              const Color(0xFFF9FCFE),
                            ],
                          ),
                        ),
                      ),
                      Positioned.fill(child: image),
                      if (discountBadge != null)
                        PositionedDirectional(
                          top: 10,
                          start: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.teal,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.teal.withOpacity(0.22),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Text(
                              discountBadge!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.noto14w400.copyWith(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      if (favoriteButton != null)
                        PositionedDirectional(top: 8, end: 8, child: favoriteButton!),
                    ],
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 11),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.noto14w400.copyWith(
                            color: AppColors.darkColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            height: 1.3,
                          ),
                        ),
                        if (ratingRow != null) ...[
                          const SizedBox(height: 6),
                          ratingRow!,
                        ],
                        const Spacer(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    priceText,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.noto16w400.copyWith(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14,
                                    ),
                                  ),
                                  if (originalPriceText != null)
                                    Text(
                                      originalPriceText!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.noto14w400.copyWith(
                                        color: AppColors.gray,
                                        fontSize: 10,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            if (actionButton != null) ...[
                              const SizedBox(width: 6),
                              actionButton!,
                            ],
                          ],
                        ),
                      ],
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

  /// Shared rating row; used by all product cards.
  static Widget ratingChip({
    required double rating,
    required int reviews,
    Color starColor = const Color(0xFFFFB800),
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFAEC),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, color: starColor, size: 14),
          const SizedBox(width: 3),
          Text(
            rating.toStringAsFixed(1),
            style: AppTextStyles.noto14w400.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.darkColor,
            ),
          ),
          if (reviews > 0) ...[
            const SizedBox(width: 2),
            Text(
              '($reviews)',
              style: AppTextStyles.noto14w400.copyWith(
                fontSize: 10,
                color: AppColors.grey,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
