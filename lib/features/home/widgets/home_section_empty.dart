import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/widgets/pharmacy_logo.dart';
import 'package:elkawther/core/widgets/pharmacy_placeholder.dart';
import 'package:flutter/material.dart';

/// Compact empty state for a home horizontal section (keeps section height stable).
class HomeSectionEmpty extends StatelessWidget {
  const HomeSectionEmpty({
    super.key,
    required this.message,
    this.height = 140,
    this.iconSize = 48,
    this.padding = const EdgeInsets.only(top: 12),
  });

  final String message;
  final double height;
  final double iconSize;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Container(
        width: double.infinity,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.light.withOpacity(0.45),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.borderColor.withOpacity(0.5)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PharmacyPlaceholder(size: iconSize),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: AppTextStyles.noto16w400.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Full-page / browse empty state used by list and grid screens.
class HomePageEmpty extends StatelessWidget {
  const HomePageEmpty({
    super.key,
    required this.message,
    this.logoSize = 72,
  });

  final String message;
  final double logoSize;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PharmacyLogo(size: logoSize),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.noto14w400.copyWith(
                color: AppColors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
