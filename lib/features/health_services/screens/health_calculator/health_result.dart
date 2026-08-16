import 'package:easy_localization/easy_localization.dart';
import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/features/health_services/models/monthly_period_calc_model.dart';
import 'package:elkawther/features/health_services/widgets/health_period.dart';
import 'package:flutter/material.dart';

import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_padding.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
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
    final last = widget.monthlyPeriodCalc.data.period.startDayOfCycle;
    final cycleLength = widget.monthlyPeriodCalc.data.period.cycleLength;

    DateTime nextPeriodDate = last.add(Duration(days: cycleLength));
    final now = DateTime.now();

    int daysUntilNextPeriod = nextPeriodDate.difference(now).inDays;

    if (daysUntilNextPeriod < 0) {
      final cyclesPassed = ((now.difference(last).inDays) / cycleLength).ceil();
      nextPeriodDate = last.add(Duration(days: cyclesPassed * cycleLength));
      daysUntilNextPeriod = nextPeriodDate.difference(now).inDays;
    }

    final formatteNextDatePeriod = DateFormat(
      'd MMMM',
      "ar",
    ).format(nextPeriodDate);
    final formatteOvulDate = DateFormat(
      'd MMMM',
      "ar",
    ).format(DateTime.parse(widget.monthlyPeriodCalc.data.ovulationDate));
    final formatteFertileStart = DateFormat(
      'd MMMM',
      "ar",
    ).format(DateTime.parse(widget.monthlyPeriodCalc.data.fertileStart));

    return HealthServiceScaffold(
      title: "$daysUntilNextPeriod ${S.of(context).remainDays}",
      subtitle: "$formatteNextDatePeriod - ${S.of(context).nextMenstruation}",
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          HealthPrimaryButton(
            title: S.of(context).menstruation,
            onPressed: () {
              Navigator.pushReplacementNamed(
                context,
                Routes.fertilityCalendar,
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
                  "${S.of(context).day} - ${S.of(context).periodDays} ${widget.monthlyPeriodCalc.data.period.cycleLength}",
                  style: AppTextStyles.noto16w400.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkColor,
                  ),
                ),
                const SizedBox(height: 16),
                FertilityProgressBar(
                  cycleLength: widget.monthlyPeriodCalc.data.period.cycleLength,
                  startDayOfCycle:
                      widget.monthlyPeriodCalc.data.period.startDayOfCycle,
                  days: widget.monthlyPeriodCalc.data.days
                      .map(
                        (e) => DayInfo(
                          date: e.date,
                          phase: e.phase,
                          pregnancyChance: e.pregnancyChance,
                        ),
                      )
                      .toList(),
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
