import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/features/home/data/home_demo_data.dart';
import 'package:elkawther/generated/assets.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum HomeProductSort { none, priceHigh, priceLow, bestSelling }

extension HomeProductSortX on HomeProductSort {
  String label(BuildContext context) {
    final l10n = S.of(context);
    switch (this) {
      case HomeProductSort.none:
        return l10n.all_products;
      case HomeProductSort.priceHigh:
        return l10n.price_high_to_low;
      case HomeProductSort.priceLow:
        return l10n.price_low_to_high;
      case HomeProductSort.bestSelling:
        return l10n.best_selling;
    }
  }
}

List<HomeDemoProduct> sortedHomeProducts(
  List<HomeDemoProduct> products,
  HomeProductSort sort,
) {
  final list = List<HomeDemoProduct>.from(products);
  switch (sort) {
    case HomeProductSort.none:
      break;
    case HomeProductSort.priceHigh:
      list.sort((a, b) => b.price.compareTo(a.price));
    case HomeProductSort.priceLow:
      list.sort((a, b) => a.price.compareTo(b.price));
    case HomeProductSort.bestSelling:
      list.sort((a, b) {
        final byRating = b.rating.compareTo(a.rating);
        if (byRating != 0) return byRating;
        return b.reviews.compareTo(a.reviews);
      });
  }
  return list;
}

List<HomeDemoProduct> bestSellingHomeProducts(
  List<HomeDemoProduct> products, {
  int limit = 6,
}) {
  final sorted = sortedHomeProducts(products, HomeProductSort.bestSelling);
  if (sorted.length <= limit) return sorted;
  return sorted.take(limit).toList();
}

Future<void> showHomeSortSheet({
  required BuildContext context,
  required HomeProductSort selected,
  required ValueChanged<HomeProductSort> onSelected,
}) {
  const options = [
    HomeProductSort.priceHigh,
    HomeProductSort.priceLow,
    HomeProductSort.bestSelling,
  ];

  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 12, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.lightDarker,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        S.of(context).arrangement,
                        style: AppTextStyles.noto16w400.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.darkColor,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close_rounded,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...options.map((option) {
                  final isSelected = option == selected;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Material(
                      color: isSelected ? AppColors.light : const Color(0xFFF5FAFD),
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        onTap: () {
                          onSelected(
                            isSelected ? HomeProductSort.none : option,
                          );
                          Navigator.pop(context);
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                option == HomeProductSort.bestSelling
                                    ? Icons.local_fire_department_rounded
                                    : Icons.payments_outlined,
                                size: 20,
                                color: isSelected
                                    ? AppColors.teal
                                    : AppColors.primaryColor,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  option.label(context),
                                  style: AppTextStyles.noto14w400.copyWith(
                                    fontSize: 14,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: AppColors.darkColor,
                                  ),
                                ),
                              ),
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected
                                      ? AppColors.teal
                                      : Colors.white,
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.teal
                                        : AppColors.lightDarker,
                                  ),
                                ),
                                child: isSelected
                                    ? const Icon(
                                        Icons.check_rounded,
                                        size: 14,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class HomeFilterButton extends StatelessWidget {
  const HomeFilterButton({
    super.key,
    required this.sort,
    required this.onSelected,
    this.size = 48,
  });

  final HomeProductSort sort;
  final ValueChanged<HomeProductSort> onSelected;
  final double size;

  @override
  Widget build(BuildContext context) {
    final active = sort != HomeProductSort.none;
    return Material(
      color: active ? AppColors.teal : AppColors.light,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: () => showHomeSortSheet(
          context: context,
          selected: sort,
          onSelected: onSelected,
        ),
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          width: size,
          height: size,
          child: Center(
            child: SvgPicture.asset(
              Assets.iconsFilterIcon,
              height: 22,
              width: 22,
              colorFilter: ColorFilter.mode(
                active ? Colors.white : AppColors.primaryColor,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomeSortChip extends StatelessWidget {
  const HomeSortChip({
    super.key,
    required this.sort,
    required this.onClear,
  });

  final HomeProductSort sort;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    if (sort == HomeProductSort.none) return const SizedBox.shrink();
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: InputChip(
        backgroundColor: AppColors.light,
        label: Text(
          sort.label(context),
          style: AppTextStyles.noto14w400.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.darkColor,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.lightDarker),
        ),
        deleteIcon: const Icon(Icons.close, size: 16),
        onDeleted: onClear,
      ),
    );
  }
}
