import 'package:cached_network_image/cached_network_image.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/widgets/pharmacy_placeholder.dart';
import 'package:elkawther/features/categories/models/categories_model.dart';
import 'package:flutter/material.dart';

class SubcategoryChips extends StatelessWidget {
  final List<Subcategory> subcategories;
  final int? selected;
  final ValueChanged<int?> onSelected;
  final String allLabel;

  const SubcategoryChips({
    super.key,
    required this.subcategories,
    required this.selected,
    required this.onSelected,
    required this.allLabel,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: subcategories.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _Chip(
              label: allLabel,
              selected: selected == null,
              onTap: () => onSelected(null),
            );
          }

          final sub = subcategories[index - 1];
          return _Chip(
            label: sub.name,
            imageUrl: sub.imageUrl,
            selected: sub.id == selected,
            onTap: () => onSelected(sub.id),
          );
        },
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.imageUrl,
  });

  final String label;
  final String? imageUrl;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.teal : AppColors.light,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(6, 5, 12, 5),
          child: Row(
            children: [
              if (imageUrl != null && imageUrl!.isNotEmpty) ...[
                ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: imageUrl!,
                    width: 24,
                    height: 24,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const PharmacyImageLoading(),
                    errorWidget: (context, url, error) =>
                        const PharmacyPlaceholder(size: 16),
                  ),
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: AppTextStyles.noto14w400.copyWith(
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? Colors.white : AppColors.darkColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
