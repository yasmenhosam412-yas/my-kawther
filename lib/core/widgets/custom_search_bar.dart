import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elkawther/generated/assets.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_padding.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    super.key,
    required this.searchHint,
    this.controller,
    this.onChanged,
  });

  final String searchHint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.small),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyCarsoul, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      height: 45.h,
      child: Row(
        children: [
          SvgPicture.asset(Assets.iconsSearchIcon, height: 22, width: 22),
          const SizedBox(width: AppPadding.small),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              onSubmitted: onChanged,
              decoration: InputDecoration(
                hintText: searchHint,
                border: InputBorder.none,
                hintStyle: AppTextStyles.noto14w400.copyWith(
                  color: Colors.black.withOpacity(0.4),
                ),
                isCollapsed: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
              style: AppTextStyles.noto14w400.copyWith(color: Colors.black),
              enabled: controller != null,
            ),
          ),
        ],
      ),
    );
  }
}
