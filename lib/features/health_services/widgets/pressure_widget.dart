import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class PressureWidget extends StatelessWidget {
  final String max;
  final String min;
  const PressureWidget({super.key, required this.max, required this.min});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Reading(value: max, label: 'SYS', color: const Color(0xFFEF4444)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            '/',
            style: AppTextStyles.noto16w400.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.grey,
            ),
          ),
        ),
        _Reading(value: min, label: 'DIA', color: AppColors.primaryColor),
      ],
    );
  }
}

class _Reading extends StatelessWidget {
  const _Reading({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: AppTextStyles.noto16w400.copyWith(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: AppColors.darkColor,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.noto14w400.copyWith(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}
