import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';

import 'package:elkawther/core/theme/app_padding.dart';

class TextFieldCustomLabel extends StatelessWidget {
  const TextFieldCustomLabel({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          child: Text(
            label,
            style: AppTextStyles.noto16w400.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.darkColor,
            ),
          ),
        ),
        const SizedBox(height: AppPadding.small),
      ],
    );
  }
}
