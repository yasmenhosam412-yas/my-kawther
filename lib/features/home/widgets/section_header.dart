import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onPressed;
  final bool? showFire;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onPressed,
    this.showFire = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.noto24w500.copyWith(
                      fontSize: 17,
                      color: AppColors.darkColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (showFire == true) ...[
                  const SizedBox(width: 4),
                  SvgPicture.asset(Assets.fire),
                ],
              ],
            ),
          ),
          if (onPressed != null && actionText != null)
            TextButton(
              onPressed: onPressed,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                actionText!,
                style: AppTextStyles.noto14w400.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
