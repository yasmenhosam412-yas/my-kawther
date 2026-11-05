import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/features/health_services/data/health_local_calc.dart';
import 'package:elkawther/features/health_services/models/monthly_period_calc_model.dart';
import 'package:elkawther/features/health_services/widgets/health_period.dart';
import 'package:flutter/material.dart';

import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_padding.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/features/health_services/screens/health_calculator/health_calculator.dart';
import 'package:elkawther/features/health_services/widgets/health_service_scaffold.dart';
import 'package:elkawther/features/health_services/widgets/pregnancy_slider.dart';

class HealthTestResult extends StatefulWidget {
  final MonthlyPeriodCalc monthlyPeriodCalc;

  const HealthTestResult({super.key, required this.monthlyPeriodCalc});

  @override
  State<HealthTestResult> createState() => _HealthTestResultState();
}

class _HealthTestResultState extends State<HealthTestResult> {
  @override
  Widget build(BuildContext context) {
    final data = widget.monthlyPeriodCalc.data;
    final last = data.period.startDayOfCycle;
    final cycleLength =
        data.period.cycleLength <= 0 ? 28 : data.period.cycleLength;
    final languageCode = Localizations.localeOf(context).languageCode;

    var nextPeriodDate = last.add(Duration(days: cycleLength));
    final now = DateTime.now();
    var daysUntilNextPeriod = nextPeriodDate.difference(now).inDays;

    if (daysUntilNextPeriod < 0) {
      final elapsed = now.difference(last).inDays;
      final cyclesPassed =
          (elapsed / cycleLength).ceil().clamp(1, 1000).toInt();
      nextPeriodDate = last.add(Duration(days: cyclesPassed * cycleLength));
      daysUntilNextPeriod = nextPeriodDate.difference(now).inDays;
    }
    if (daysUntilNextPeriod < 0) daysUntilNextPeriod = 0;

    final ovulation =
        HealthLocalCalc.parseDate(data.ovulationDate) ??
        last.add(Duration(days: cycleLength - 14));
    final fertileStart =
        HealthLocalCalc.parseDate(data.fertileStart) ??
        ovulation.subtract(const Duration(days: 5));
    final days =
        data.days.isNotEmpty
            ? data.days
            : HealthLocalCalc.period(
              startDay: last,
              cycleLength: cycleLength,
              periodLength: data.period.periodLength,
            ).data.days;

    final formatteNextDatePeriod = HealthLocalCalc.formatDayMonth(
      nextPeriodDate,
      languageCode: languageCode,
    );
    final formatteOvulDate = HealthLocalCalc.formatDayMonth(
      ovulation,
      languageCode: languageCode,
    );
    final formatteFertileStart = HealthLocalCalc.formatDayMonth(
      fertileStart,
      languageCode: languageCode,
    );

    return HealthServiceScaffold(
      title: "$daysUntilNextPeriod ${S.of(context).remainDays}",
      subtitle: "$formatteNextDatePeriod - ${S.of(context).nextMenstruation}",
      bottom: HealthPrimaryButton(
        title: S.of(context).enternewDate,
        onPressed: () async {
          await SavedPeriod.clear();
          if (!context.mounted) return;
          Navigator.pushReplacementNamed(context, Routes.healthServices);
        },
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          HealthPrimaryButton(
            title: S.of(context).menstruation,
            onPressed: () {
              Navigator.pushReplacementNamed(
                context,
                Routes.fertilityCalendar,
                arguments: widget.monthlyPeriodCalc,
              );
            },
          ),
          const SizedBox(height: 16),
          HealthFormCard(
            child: Column(
              children: [
                Text(
                  S.of(context).cyclePhase,
                  style: AppTextStyles.noto16w400.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkColor,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    HealthPeriod(
                      healthDate: formatteFertileStart,
                      title: S.of(context).nextFertility,
                      color: AppColors.teal,
                      icon: Icons.spa_rounded,
                    ),
                    const SizedBox(width: 8),
                    HealthPeriod(
                      healthDate: formatteOvulDate,
                      title: S.of(context).ovulation,
                      color: const Color(0xFFEC4899),
                      icon: Icons.brightness_1_rounded,
                    ),
                    const SizedBox(width: 8),
                    HealthPeriod(
                      healthDate: formatteNextDatePeriod,
                      title: S.of(context).nextMenstruation,
                      color: const Color(0xFFEF4444),
                      icon: Icons.water_drop_rounded,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          HealthFormCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "${S.of(context).day} - ${S.of(context).periodDays} $cycleLength",
                  style: AppTextStyles.noto16w400.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkColor,
                  ),
                ),
                const SizedBox(height: 16),
                FertilityProgressBar(
                  cycleLength: cycleLength,
                  startDayOfCycle: last,
                  days: days,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppPadding.medium),
        ],
      ),
    );
  }
}
