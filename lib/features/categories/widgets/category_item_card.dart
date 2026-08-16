import 'package:bounce/bounce.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:elkawther/core/theme/app_padding.dart';
import 'package:elkawther/core/theme/app_colors.dart';

class CategoryItemCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final Color backgroundColor;
  final VoidCallback? onTap;

  const CategoryItemCard({
    super.key,
    required this.title,
    required this.imagePath,
    this.backgroundColor = AppColors.light,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Bounce(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.small,
          vertical: AppPadding.medium,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: AppColors.primaryColor, width: 1.2),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: AppPadding.small),
                child: CachedNetworkImage(
                  imageUrl: imagePath,
                  width: 70,
                  height: 70,
                  fit: BoxFit.contain,
                  placeholder:
                      (context, url) => const Center(
                        child: CircularProgressIndicator(strokeWidth: 1.5),
                      ),
                  errorWidget:
                      (context, url, error) => const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                        size: 40,
                      ),
                ),
              ),
            ),

            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.noto16w400.copyWith(color: Colors.black),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
