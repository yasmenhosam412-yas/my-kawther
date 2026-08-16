import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/utils/responsive.dart';
import 'package:elkawther/features/health_services/models/pregnancy_calc_model.dart';
import 'package:elkawther/features/health_services/widgets/health_service_scaffold.dart';
import 'package:elkawther/features/health_services/widgets/pregnancy_weeks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PregnancyResult extends StatelessWidget {
  final PregnancyResultModel result;

  const PregnancyResult({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return HealthServiceScaffold(
      title: S.of(context).pregnancyAndChildbirthCalculator,
      subtitle: '${result.currentWeek} ${S.of(context).week}',
      bottom: result.currentWeek >= 40
          ? HealthPrimaryButton(
              title: S.of(context).newPregnaancy,
              onPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  Routes.pregnancyServices,
                );
              },
            )
          : null,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          HealthFormCard(
            child: Column(
              children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                S.of(context).firstDayOfLastMenstrualCycle,
                                style: Theme.of(context).textTheme.titleSmall!
                                    .copyWith(color: AppColors.primaryColor),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                result.lastPeriodDate,
                                style: Theme.of(context).textTheme.titleSmall!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          child: VerticalDivider(
                            thickness: 1,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                S.of(context).expectedDOBirth,
                                style: Theme.of(context).textTheme.titleSmall!
                                    .copyWith(color: AppColors.primaryColor),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                result.dueDate,
                                style: Theme.of(context).textTheme.titleSmall!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24, child: Divider()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: 115.w,
                          height: 115.h,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            border: Border.all(
                              width: 4,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                " ${result.currentWeek} ${S.of(context).week}",
                                style: Theme.of(
                                  context,
                                ).textTheme.titleSmall!.copyWith(
                                  color: AppColors.primaryColor,
                                  fontSize: getResponsiveFontSize(
                                    context,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              SizedBox(height: 24.h, child: const Divider()),
                              Text(
                                result.monthInfo,
                                textAlign: TextAlign.center,
                                style: Theme.of(
                                  context,
                                ).textTheme.titleSmall!.copyWith(
                                  color: AppColors.primaryColor,
                                  fontSize: getResponsiveFontSize(
                                    context,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        _babyShape(context, result.babySize),
                      ],
                    ),
                    Text(
                      S.of(context).fetalDimensions,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16, child: Divider()),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                S.of(context).height,
                                style: Theme.of(
                                  context,
                                ).textTheme.titleSmall!.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                result.babyLength,
                                style: Theme.of(
                                  context,
                                ).textTheme.titleSmall!.copyWith(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32, child: VerticalDivider()),
                        Expanded(
                          flex: 1,

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                S.of(context).weight,
                                style: Theme.of(
                                  context,
                                ).textTheme.titleSmall!.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                result.babyWeight,
                                style: Theme.of(
                                  context,
                                ).textTheme.titleSmall!.copyWith(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32, child: VerticalDivider()),
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                S.of(context).volume,
                                style: Theme.of(
                                  context,
                                ).textTheme.titleSmall!.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                result.babySize,
                                style: Theme.of(
                                  context,
                                ).textTheme.titleSmall!.copyWith(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              HealthFormCard(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Image.asset(
                              "assets/images/pregnancy_stage1.png",
                              width: 100,
                              height: 120,
                            ),
                            Container(
                              height: 28,
                              width: 80,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: result.imageStage == 1
                                    ? AppColors.primaryColor
                                    : AppColors.light,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                S.of(context).firstThird,
                                style: AppTextStyles.noto14w400.copyWith(
                                  color: result.imageStage == 1
                                      ? Colors.white
                                      : AppColors.darkColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Image.asset(
                              "assets/images/pregnancy_stage2.png",
                              width: 100,
                              height: 120,
                            ),
                            Container(
                              height: 28,
                              width: 80,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: result.imageStage == 2
                                    ? AppColors.primaryColor
                                    : AppColors.light,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                S.of(context).secondThird,
                                style: AppTextStyles.noto14w400.copyWith(
                                  color: result.imageStage == 2
                                      ? Colors.white
                                      : AppColors.darkColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Image.asset(
                              "assets/images/pregnancy_stage3.png",
                              width: 100,
                              height: 120,
                            ),
                            Container(
                              height: 28,
                              width: 80,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: result.imageStage == 3
                                    ? AppColors.primaryColor
                                    : AppColors.light,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                S.of(context).thirdThird,
                                style: AppTextStyles.noto14w400.copyWith(
                                  color: result.imageStage == 3
                                      ? Colors.white
                                      : AppColors.darkColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: _buildStageMonths(
                        context,
                        result.imageStage,
                        result.monthInfo,
                      ),
                    ),

                    const SizedBox(height: 12),
                    Text(
                      S.of(context).weeks,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    PregnancyWeeksList(currentWeek: result.currentWeek),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ],
          ),
    );
  }

  List<Widget> _buildStageMonths(
    BuildContext context,
    int stage,
    String monthInfo,
  ) {
    List<String> months;

    String lastChar = monthInfo.trim().split(' ').last;
    int monthNumber = int.tryParse(lastChar) ?? 0;

    if (stage == 1) {
      months = ["الشهر الأول", "الشهر الثاني", "الشهر الثالث"];
    } else if (stage == 2) {
      months = ["الشهر الرابع", "الشهر الخامس", "الشهر السادس"];
    } else {
      months = ["الشهر السابع", "الشهر الثامن", "الشهر التاسع"];
    }

    return months.map((month) {
      int indexInStage = months.indexOf(month);
      int stageStartMonth = (stage - 1) * 3 + 1;
      int currentMonthNumber = stageStartMonth + indexInStage;

      bool isActive = currentMonthNumber == monthNumber;

      return Expanded(
        flex: 1,
        child: Container(
          height: 40,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryColor : AppColors.light,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            month,
            style: AppTextStyles.noto14w400.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 11,
              color: isActive ? Colors.white : AppColors.darkColor,
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _babyShape(BuildContext context, String shape) {
    switch (shape) {
      case "بحجم موزة":
        return Image.asset('assets/icons/banana.png', height: 120, width: 120);
      case "بحجم كوسة":
        return Image.asset('assets/icons/kousa.png', height: 120, width: 120);
      case "بحجم باذنجانة كبيرة":
        return Image.asset('assets/icons/baz.png', height: 120, width: 120);
      case "بحجم برقوق":
        return Image.asset('assets/icons/barkouk.png', height: 120, width: 120);
      case "بحجم بذرة سمسم":
        return Image.asset('assets/icons/smsm.png', height: 120, width: 120);
      case "بحجم بطيخة":
        return Image.asset(
          'assets/images/baby_size.png',
          height: 120,
          width: 120,
        );
      case "غير متاح":
        return Image.asset(
          'assets/icons/notExist.png',
          height: 100,
          width: 100,
        );
      default:
        return Image.asset(
          'assets/icons/notExist.png',
          height: 100,
          width: 100,
        );
    }
  }
}
