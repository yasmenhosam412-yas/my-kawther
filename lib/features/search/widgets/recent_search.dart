import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';

import 'package:elkawther/generated/l10n.dart';

class SearchRecent extends StatelessWidget {
  final List<String> items;
  final VoidCallback? onClearAll;
  final Function(String index)? onRemoveItem;
  final Function(String item)? onTapItem;

  const SearchRecent({
    super.key,
    required this.items,
    this.onClearAll,
    this.onRemoveItem,
    this.onTapItem,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                S.of(context).searchHistory,
                style: AppTextStyles.noto14w400.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.grey,
                  fontSize: 13,
                ),
              ),
            ),
            if (items.isNotEmpty)
              TextButton(
                onPressed: onClearAll,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  S.of(context).clearAll,
                  style: AppTextStyles.noto14w400.copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        if (items.isEmpty)
          Text(
            S.of(context).no_resent,
            style: AppTextStyles.noto14w400.copyWith(color: AppColors.grey),
          )
        else
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final term = items[index];
              return Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  onTap: () => onTapItem?.call(term),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE6EEF5)),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.history_rounded,
                          size: 18,
                          color: AppColors.primaryColor,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            term,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.noto14w400.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.darkColor,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => onRemoveItem?.call(term),
                          visualDensity: VisualDensity.compact,
                          icon: const Icon(
                            Icons.close_rounded,
                            size: 18,
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
