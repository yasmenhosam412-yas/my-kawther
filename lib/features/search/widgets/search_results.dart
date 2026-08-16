import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/generated/assets.dart';
import 'package:elkawther/core/theme/app_padding.dart';

class SearchResults extends StatelessWidget {
  final List<String> items;
  final void Function(String)? onItemTap;

  const SearchResults({super.key, required this.items, this.onItemTap});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppPadding.medium),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () => onItemTap?.call(item),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    SvgPicture.asset(
                      Assets.iconsSearchIcon,
                      width: 18,
                      height: 18,
                      color: AppColors.darkColor,
                    ),
                    const SizedBox(width: 8),

                    Expanded(
                      child: Text(
                        item,
                        style: Theme.of(context).textTheme.titleMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.trending_up_outlined,
                size: 16,
                color: AppColors.darkColor,
              ),
            ],
          ),
        );
      },
      separatorBuilder:
          (context, index) => const SizedBox(height: AppPadding.medium),
    );
  }
}
