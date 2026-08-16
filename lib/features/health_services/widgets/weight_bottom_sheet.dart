import 'package:flutter/material.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/features/health_services/models/weight_body.dart';
import 'package:elkawther/features/health_services/widgets/health_result_sheet.dart';
import 'package:elkawther/features/health_services/widgets/health_service_scaffold.dart';

void weightResultBottomSheet(BuildContext context, WeightBody result) {
  Color bmiColor(double bmi) {
    if (bmi < 18.5) return const Color(0xFF3B82F6);
    if (bmi < 25) return AppColors.teal;
    if (bmi < 30) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }

  final bmi = result.bmi;
  final color = bmi != null ? bmiColor(bmi) : AppColors.primaryColor;
  final isAr = Localizations.localeOf(context).languageCode == 'ar';

  HealthResultSheet.show(
    context: context,
    heightFactor: 0.62,
    expand: false,
    child: SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const HealthSheetHandle(),
            HealthMetricHero(
              color: color,
              icon: Icons.monitor_weight_outlined,
              title: S.of(context).bodyIndexScore,
              status: result.status ?? '',
              child: Text(
                bmi?.toStringAsFixed(1) ?? '--',
                style: AppTextStyles.noto16w400.copyWith(
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  color: AppColors.darkColor,
                  height: 1,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: const SizedBox(
                height: 10,
                child: Row(
                  children: [
                    Expanded(child: ColoredBox(color: Color(0xFF3B82F6))),
                    Expanded(child: ColoredBox(color: AppColors.teal)),
                    Expanded(child: ColoredBox(color: Color(0xFFF59E0B))),
                    Expanded(child: ColoredBox(color: Color(0xFFEF4444))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  '18.5',
                  style: AppTextStyles.noto14w400.copyWith(
                    color: AppColors.grey,
                    fontSize: 11,
                  ),
                ),
                Text(
                  '25',
                  style: AppTextStyles.noto14w400.copyWith(
                    color: AppColors.grey,
                    fontSize: 11,
                  ),
                ),
                Text(
                  '30',
                  style: AppTextStyles.noto14w400.copyWith(
                    color: AppColors.grey,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            if ((result.description ?? '').isNotEmpty)
              Text(
                result.description!,
                textAlign: TextAlign.center,
                style: AppTextStyles.noto14w400.copyWith(
                  color: AppColors.grey,
                  height: 1.4,
                ),
              ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                isAr
                    ? 'نطاق وزنك الصحي: ${result.idealRange ?? '--'}'
                    : 'Healthy range: ${result.idealRange ?? '--'}',
                textAlign: TextAlign.center,
                style: AppTextStyles.noto14w400.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.darkColor,
                ),
              ),
            ),
            const SizedBox(height: 16),
            HealthPrimaryButton(
              title: S.of(context).confirm,
              color: color,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    ),
  );
}
