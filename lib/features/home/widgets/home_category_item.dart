import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/features/home/widgets/home_catalog_image.dart';
import 'package:flutter/material.dart';

class HomeCategoryItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final VoidCallback? onTap;

  const HomeCategoryItem({
    super.key,
    required this.imageUrl,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 86,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: HomeCatalogImage(
                width: double.infinity,
                height: double.infinity,
                assetPath: imageUrl,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTextStyles.noto14w400.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.darkColor,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
