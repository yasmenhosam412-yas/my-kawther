import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/features/health_services/models/measures.dart';
import 'package:elkawther/features/health_services/widgets/health_result_sheet.dart';
import 'package:elkawther/features/health_services/widgets/health_service_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void sugarBottomSheet(
  BuildContext context,
  BloodSugarModel bloodSugar,
  List<BloodSugarDataFetched> allResults,
) {
  final value = bloodSugar.data.value;
  final evaluation = bloodSugar.data.evaluation;
  final color = healthEvalColor(evaluation);

  HealthResultSheet.show(
    context: context,
    child: SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Column(
          children: [
            const HealthSheetHandle(),
            Expanded(
              child: ListView(
                children: [
                  HealthMetricHero(
                    color: color,
                    icon: Icons.water_drop_rounded,
                    title: S.of(context).latestSugarMeasurement,
                    status: evaluation,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '$value',
                          style: AppTextStyles.noto16w400.copyWith(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            color: AppColors.darkColor,
                            height: 1,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            'mg/dL',
                            style: AppTextStyles.noto14w400.copyWith(
                              color: AppColors.grey,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      S.of(context).yourEntries,
                      style: AppTextStyles.noto16w400.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.darkColor,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...allResults.map((item) {
                    DateTime? measured;
                    try {
                      measured = DateTime.parse(item.measuredAt);
                    } catch (_) {
                      measured = DateTime.tryParse(
                        bloodSugar.data.measuredAt.toString(),
                      );
                    }
                    return HealthHistoryCard(
                      color: color,
                      child: Row(
                        children: [
                          Text(
                            '${item.value}',
                            style: AppTextStyles.noto16w400.copyWith(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: AppColors.darkColor,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'mg/dL',
                            style: AppTextStyles.noto14w400.copyWith(
                              color: AppColors.grey,
                              fontSize: 12,
                            ),
                          ),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (measured != null)
                                Text(
                                  DateFormat('hh:mm a').format(measured),
                                  style: AppTextStyles.noto14w400.copyWith(
                                    color: AppColors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              const SizedBox(height: 6),
                              HealthConditionChip(
                                label: _localizedCondition(
                                  item.conditionType,
                                  context,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
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

String _localizedCondition(String value, BuildContext context) {
  switch (value) {
    case 'fasting':
    case 'صائم':
      return S.of(context).fasting;
    case 'after_meal':
      return S.of(context).afterMeal;
    case 'before_breakfast':
      return S.of(context).beforeBreakFast;
    case 'random':
    case 'عشوائي':
      return S.of(context).random;
    default:
      return value;
  }
}
