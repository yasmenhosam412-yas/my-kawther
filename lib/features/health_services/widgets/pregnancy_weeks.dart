import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';

class PregnancyWeeksList extends StatefulWidget {
  final int currentWeek;

  const PregnancyWeeksList({super.key, required this.currentWeek});

  @override
  State<PregnancyWeeksList> createState() => _PregnancyWeeksListState();
}

class _PregnancyWeeksListState extends State<PregnancyWeeksList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentWeek();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCurrentWeek() {
    const itemWidth = 48.0;
    final offset = (widget.currentWeek - 1) * itemWidth;
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: 41,
        itemBuilder: (context, index) {
          final weekNumber = index + 1;
          final isCurrentWeek = weekNumber == widget.currentWeek;
          return Container(
            width: 40,
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: isCurrentWeek ? AppColors.primaryColor : AppColors.light,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$weekNumber',
              style: AppTextStyles.noto14w400.copyWith(
                color: isCurrentWeek ? Colors.white : AppColors.darkColor,
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
          );
        },
      ),
    );
  }
}
