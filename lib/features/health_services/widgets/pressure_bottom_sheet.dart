import 'package:easy_localization/easy_localization.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/features/health_services/models/measures.dart';
import 'package:elkawther/features/health_services/widgets/health_result_sheet.dart';
import 'package:elkawther/features/health_services/widgets/health_service_scaffold.dart';
import 'package:elkawther/features/health_services/widgets/pressure_widget.dart';
import 'package:flutter/material.dart';
import 'package:elkawther/core/theme/app_text_style.dart';

void pressureBottomSheet(
  BuildContext context,
  BloodMeasureModel bloodData,
  List<BloodPressureDataFetched> allResults,
) {
  final color = healthEvalColor(bloodData.data.evaluation);
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
                    icon: Icons.favorite_rounded,
                    title: S.of(context).latestBloodPressureMeasurement,
                    status: bloodData.data.evaluation,
                    child: PressureWidget(
                      max: '${bloodData.data.systolic}',
                      min: '${bloodData.data.diastolic}',
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
                    } catch (_) {}
                    return HealthHistoryCard(
                      color: color,
                      child: Row(
                        children: [
                          PressureWidget(
                            max: '${item.systolic}',
                            min: '${item.diastolic}',
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
                                label: _pressureCondition(item.conditionType),
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

String _pressureCondition(String key) {
  switch (key) {
    case 'morning':
    case 'صباحي':
      return 'صباحي';
    case 'evening':
    case 'مسائي':
      return 'مسائي';
    default:
      return key;
  }
}
