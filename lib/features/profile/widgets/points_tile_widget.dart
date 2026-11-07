import 'package:easy_localization/easy_localization.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';

import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/features/profile/models/points_response.dart';

class PointTileWidget extends StatelessWidget {
  final OrderPoints point;

  const PointTileWidget({super.key, required this.point});

  @override
  Widget build(BuildContext context) {
    final date = point.redeemedAt ?? point.expiredAt ?? point.expiresAt ?? point.createdAt;
    final dateLabel = point.redeemedAt != null
        ? S.of(context).redeemedAt
        : point.expiredAt != null
        ? S.of(context).expired_at
        : point.expiresAt != null
        ? S.of(context).expiresIn
        : '';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE6EEF5)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.teal.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.stars_rounded,
              color: AppColors.teal,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  point.orderName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.noto14w400.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dateLabel.isEmpty
                      ? DateFormat('dd/MM/yyyy').format(date)
                      : '$dateLabel ${DateFormat('dd/MM/yyyy').format(date)}',
                  style: AppTextStyles.noto14w400.copyWith(
                    color: AppColors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.teal.withOpacity(0.10),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${point.pointsEarned}',
              style: AppTextStyles.noto14w400.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.teal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
