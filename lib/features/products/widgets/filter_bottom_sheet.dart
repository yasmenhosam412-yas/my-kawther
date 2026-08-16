import 'package:flutter/material.dart';

import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_padding.dart';

class FilterBottomSheet extends StatefulWidget {
  final Set<String> selectedFilters;
  final void Function(String filter, bool isSelected) onFilterChanged;

  const FilterBottomSheet({
    super.key,
    required this.selectedFilters,
    required this.onFilterChanged,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late List<String> filters;

  void _toggleFilter(String filter) {
    final isCurrentlySelected = widget.selectedFilters.contains(filter);
    widget.onFilterChanged(filter, !isCurrentlySelected);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    filters = [
      S.of(context).price_high_to_low,
      S.of(context).price_low_to_high,
      S.of(context).best_selling,
      S.of(context).top_rated,
      S.of(context).newest,
    ];
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // important for minimal height
        children: [
          Padding(
            padding: const EdgeInsets.all(AppPadding.medium),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.of(context).arrangement,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          const Divider(thickness: 1, height: 1),
          ListView.separated(
            shrinkWrap: true,
            // allows ListView to take minimal height
            physics: const NeverScrollableScrollPhysics(),
            // prevents scrolling
            padding: const EdgeInsets.all(AppPadding.medium),
            itemCount: filters.length,
            separatorBuilder:
                (context, index) => const SizedBox(height: AppPadding.medium),
            itemBuilder: (context, index) {
              final filter = filters[index];
              final isSelected = widget.selectedFilters.contains(filter);
              return GestureDetector(
                onTap: () => _toggleFilter(filter),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            isSelected
                                ? AppColors.primaryColor
                                : Colors.grey.shade300,
                      ),
                      child:
                          isSelected
                              ? const Icon(
                                Icons.check,
                                size: 14,
                                color: Colors.white,
                              )
                              : null,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      filter,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: AppPadding.medium),
        ],
      ),
    );
  }
}
