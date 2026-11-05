import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/widgets/pharmacy_placeholder.dart';
import 'package:elkawther/features/home/widgets/home_product_card.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';

/// Shown whenever a home product section has no products to display.
/// Keeps the same height as [HomeProductsRow] so the section layout
/// doesn't jump when products arrive or disappear.
class EmptyProductsPlaceholder extends StatelessWidget {
  const EmptyProductsPlaceholder({super.key});

  static const double _rowHeight = 158 / HomeProductCard.cardAspectRatio;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        width: double.infinity,
        height: _rowHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.light.withOpacity(0.45),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.borderColor.withOpacity(0.5)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const PharmacyPlaceholder(size: 52),
            const SizedBox(height: 10),
            Text(
              S.of(context).no_products_found,
              style: AppTextStyles.noto16w400.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
