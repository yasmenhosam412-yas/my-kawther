import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';

class HealthPeriod extends StatelessWidget {
  const HealthPeriod({
    super.key,
    required this.healthDate,
    required this.title,
    this.color = AppColors.primaryColor,
    this.icon = Icons.calendar_month_rounded,
  });

  final String healthDate;
  final String title;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withOpacity(0.14),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 16, color: color),
            ),
            const SizedBox(height: 10),
            Text(
              healthDate,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.noto14w400.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.darkColor,
                fontSize: 13,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.noto14w400.copyWith(
                fontSize: 11,
                color: AppColors.grey,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
