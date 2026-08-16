import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/features/health_services/data/health_local_calc.dart';
import 'package:flutter/material.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/features/health_services/models/month_response.dart';
import 'package:elkawther/features/health_services/widgets/health_service_scaffold.dart';

class FertilityCalendarScreen extends StatelessWidget {
  const FertilityCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return HealthServiceScaffold(
      title: S.of(context).fertility_calendar,
      subtitle: S.of(context).ovulation_calculator,
      bottom: HealthPrimaryButton(
        title: S.of(context).enternewDate,
        onPressed: () {
          Navigator.pushReplacementNamed(context, Routes.healthServices);
        },
      ),
      body: Builder(
        builder: (context) {
          final monthResponse = HealthLocalStore.instance.monthResponse;
          if (monthResponse == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: HealthPrimaryButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.healthServices);
                  },
                  title: S.of(context).start_period_calc,
                ),
              ),
            );
          }
          return _buildCalendarUI(monthResponse);
        },
      ),
    );
  }

  Widget _buildCalendarUI(MonthResponse monthResponse) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 8),
        ...monthResponse.months.entries.map((monthEntry) {
          final month = monthEntry.key;
          final List<DayInfo> days = monthEntry.value;

          return _MonthCard(month: month, days: days);
        }),
      ],
    );
  }
}

class _MonthCard extends StatefulWidget {
  final String month;
  final List<DayInfo> days;

  const _MonthCard({required this.month, required this.days});

  @override
  State<_MonthCard> createState() => _MonthCardState();
}

class _MonthCardState extends State<_MonthCard> {
  final ScrollController _scrollController = ScrollController();
  DayInfo? selectedDay;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final todayIndex = widget.days.indexWhere((element) => element.isToday);
      if (todayIndex != -1) {
        final offset = todayIndex * 60.0;
        _scrollController.animateTo(
          offset,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );

        setState(() {
          selectedDay = widget.days[todayIndex];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: HealthFormCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.month,
              style: AppTextStyles.noto24w500.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 95,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: widget.days.length,
                itemBuilder: (context, index) {
                  final day = widget.days[index];
                  final isSelected = selectedDay?.date == day.date;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedDay = null;
                        } else {
                          selectedDay = day;
                        }
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? AppColors.primaryColor.withOpacity(0.10)
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 55,
                            height: 55,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:
                                    day.isToday
                                        ? AppColors.primaryColor
                                        : (day.pregnancyChance == "30%" ||
                                            day.pregnancyChance == "25%")
                                        ? Colors.green
                                        : (day.pregnancyChance == "5%")
                                        ? Colors.amber
                                        : Colors.grey.shade400,
                                width:
                                    (day.pregnancyChance == "30%" ||
                                            day.pregnancyChance == "25%" ||
                                            day.pregnancyChance == "5%")
                                        ? 3
                                        : (day.isToday ? 2 : 1),
                              ),
                              color:
                                  isSelected
                                      ? AppColors.light
                                      : Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                if (isSelected)
                                  BoxShadow(
                                    color: AppColors.primaryColor.withOpacity(0.25),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              day.date.split("-").last,
                              style: AppTextStyles.noto24w500.copyWith(
                                color:
                                    (day.pregnancyChance == "30%" ||
                                            day.pregnancyChance == "25%")
                                        ? Colors.green
                                        : (day.pregnancyChance == "5%")
                                        ? Colors.amber
                                        : (day.isToday
                                            ? AppColors.primaryColor
                                            : Colors.black87),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            day.phase,
                            style: AppTextStyles.noto24w500.copyWith(
                              fontSize: 11,
                              color:
                                  day.phase == "حيض"
                                      ? Colors.red
                                      : Colors.black54,
                              fontWeight:
                                  day.phase == "حيض"
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 400),
              crossFadeState:
                  selectedDay == null
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
              firstChild: const SizedBox.shrink(),
              secondChild: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.light,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(
                      S.of(context).date2,
                      selectedDay?.date ?? "",
                    ),
                    const SizedBox(height: 8),
                    _buildDetailRow(
                      S.of(context).phase,
                      selectedDay?.phase ?? "",
                    ),
                    const SizedBox(height: 8),
                    _buildDetailRow(
                      S.of(context).pregnancy_chance,
                      selectedDay?.pregnancyChance ?? "",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.noto14w400.copyWith(
              fontSize: 13,
              color: AppColors.grey,
            ),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.noto14w400.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: AppColors.darkColor,
          ),
        ),
      ],
    );
  }
}
