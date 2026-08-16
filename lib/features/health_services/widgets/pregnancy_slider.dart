import 'package:easy_localization/easy_localization.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/features/health_services/models/monthly_period_calc_model.dart';

class FertilityProgressBar extends StatefulWidget {
  final int cycleLength;
  final DateTime startDayOfCycle;
  final List<DayInfo> days;

  const FertilityProgressBar({
    super.key,
    required this.cycleLength,
    required this.startDayOfCycle,
    required this.days,
  });

  @override
  State<FertilityProgressBar> createState() => _FertilityProgressBarState();
}

class _FertilityProgressBarState extends State<FertilityProgressBar> {
  late int selectedDayIndex;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    selectedDayIndex = widget.days.indexWhere((day) {
      final dayDate = DateTime.parse(day.date);
      return dayDate.year == today.year &&
          dayDate.month == today.month &&
          dayDate.day == today.day;
    });
    if (selectedDayIndex == -1) selectedDayIndex = 0;
  }

  Color _getColorByPhaseAndChance(String phase, String chance) {
    final value = int.tryParse(chance.replaceAll('%', '')) ?? 0;
    switch (phase) {
      case 'حيض':
        return Colors.redAccent;
      case 'تبويض':
        return value >= 30 ? Colors.green.shade800 : Colors.green.shade600;
      case 'خصوبة عالية':
        return value >= 25 ? Colors.green.shade500 : Colors.green.shade300;
      case 'خصوبة منخفضة':
        return Colors.orangeAccent;
      case 'خصوبة متوسطة':
        return Colors.deepOrange;
      case 'غير خصبة':
      case 'ما بعد التبويض':
        return Colors.grey.shade400;
      default:
        return Colors.amberAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
          decoration: BoxDecoration(
            color: _getColorByPhaseAndChance(
              widget.days[selectedDayIndex].phase,
              widget.days[selectedDayIndex].pregnancyChance,
            ).withOpacity(0.10),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Text(
                "${DateFormat('d MMMM', 'ar').format(DateTime.parse(widget.days[selectedDayIndex].date))} - ${S.of(context).pregnancyChance}: ${widget.days[selectedDayIndex].pregnancyChance}",
                textAlign: TextAlign.center,
                style: AppTextStyles.noto16w400.copyWith(
                  fontWeight: FontWeight.w800,
                  color: _getColorByPhaseAndChance(
                    widget.days[selectedDayIndex].phase,
                    widget.days[selectedDayIndex].pregnancyChance,
                  ),
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "${S.of(context).level}: ${widget.days[selectedDayIndex].phase}",
                style: AppTextStyles.noto14w400.copyWith(
                  fontSize: 13,
                  color: AppColors.grey,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        Stack(
          children: [
            Row(
              children:
                  widget.days.map((day) {
                    return Expanded(
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          gradient: LinearGradient(
                            colors: [
                              _getColorByPhaseAndChance(
                                day.phase,
                                day.pregnancyChance,
                              ).withOpacity(0.7),
                              _getColorByPhaseAndChance(
                                day.phase,
                                day.pregnancyChance,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ],
        ),

        const SizedBox(height: 16),

        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.transparent,
            inactiveTrackColor: Colors.transparent,
            trackHeight: 0,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
            thumbColor: _getColorByPhaseAndChance(
              widget.days[selectedDayIndex].phase,
              widget.days[selectedDayIndex].pregnancyChance,
            ),
          ),
          child: Slider(
            value: selectedDayIndex.toDouble(),
            min: 0,
            max: (widget.days.length - 1).toDouble(),
            divisions: widget.days.length - 1,
            onChanged: (value) {
              setState(() {
                selectedDayIndex = value.round();
              });
            },
          ),
        ),

        const SizedBox(height: 8),

        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            DateFormat(
              'd MMMM',
              'ar',
            ).format(DateTime.parse(widget.days[selectedDayIndex].date)),
            style: AppTextStyles.noto16w400,
          ),
        ),
      ],
    );
  }
}
