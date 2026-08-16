import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:elkawther/generated/assets.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/core/theme/app_padding.dart';

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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.medium),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.of(context).searchHistory,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              if (items.isNotEmpty)
                InkWell(
                  onTap: onClearAll,
                  borderRadius: BorderRadius.circular(6),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      S.of(context).clearAll,
                      style: AppTextStyles.noto14w400.copyWith(
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppPadding.medium),

        if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.medium),
            child: Center(
              child: Text(
                S.of(context).no_resent,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          )
        else
          ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.medium),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => onTapItem?.call(items[index]),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Text(
                          items[index],
                          style: Theme.of(context).textTheme.titleMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: SvgPicture.asset(
                      Assets.iconsClear,
                      width: 16,
                      height: 16,
                    ),
                    onPressed: () => onRemoveItem?.call(items[index]),
                    splashRadius: 20,
                  ),
                ],
              );
            },
            separatorBuilder:
                (_, __) => const SizedBox(height: AppPadding.small),
          ),
      ],
    );
  }
}
