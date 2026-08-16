import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';

class WeekDaySelector extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onSelect;

  const WeekDaySelector({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  State<WeekDaySelector> createState() => _WeekDaySelectorState();
}

class _WeekDaySelectorState extends State<WeekDaySelector> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelected();
    });
  }

  @override
  void didUpdateWidget(covariant WeekDaySelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _scrollToSelected();
    }
  }

  void _scrollToSelected() {
    if (!_scrollController.hasClients) return;

    const itemWidth = 86.0;
    double position = (widget.selectedIndex * itemWidth) - itemWidth;
    if (position < 0) position = 0;
    if (position > _scrollController.position.maxScrollExtent) {
      position = _scrollController.position.maxScrollExtent;
    }

    _scrollController.animateTo(
      position,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final days = [
      S.of(context).saturday,
      S.of(context).sunday,
      S.of(context).monday,
      S.of(context).tuesday,
      S.of(context).wednesday,
      S.of(context).thursday,
      S.of(context).friday,
    ];

    return SizedBox(
      height: 40,
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = index == widget.selectedIndex;
          return Material(
            color: isSelected ? AppColors.teal : Colors.white,
            borderRadius: BorderRadius.circular(22),
            child: InkWell(
              onTap: () => widget.onSelect(index),
              borderRadius: BorderRadius.circular(22),
              child: Container(
                width: 78,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isSelected ? AppColors.teal : AppColors.lightDarker,
                  ),
                ),
                child: Text(
                  days[index],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.noto14w400.copyWith(
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 12,
                    color: isSelected ? Colors.white : AppColors.darkColor,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
