import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/features/notifications/cubit/notification_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class NotificationItem extends StatelessWidget {
  final int id;
  final String description;
  final String createdAt;
  final bool isRead;

  const NotificationItem({
    super.key,
    required this.id,
    required this.description,
    required this.createdAt,
    this.isRead = false,
  });

  @override
  Widget build(BuildContext context) {
    final parsed = DateTime.tryParse(createdAt)?.toLocal();
    final accent = isRead ? AppColors.grey : AppColors.primaryColor;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: isRead ? Colors.white : const Color(0xFFF3FAFE),
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => context.read<NotificationCubit>().markAsRead(id),
          child: Ink(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isRead
                    ? const Color(0xFFE6EEF5)
                    : AppColors.primaryColor.withOpacity(0.18),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: isRead ? const Color(0xFFF4F7FA) : Colors.white,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(_iconFor(description), size: 20, color: accent),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        description,
                        style: AppTextStyles.noto14w400.copyWith(
                          fontWeight: isRead ? FontWeight.w500 : FontWeight.w700,
                          color: isRead
                              ? AppColors.grey
                              : AppColors.darkColor,
                          height: 1.35,
                        ),
                      ),
                      if (parsed != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          _timeAgo(context, parsed),
                          style: AppTextStyles.noto14w400.copyWith(
                            fontSize: 11,
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (!isRead) ...[
                  const SizedBox(width: 8),
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(top: 6),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _iconFor(String body) {
    final text = body.toLowerCase();
    if (text.contains('خصم') ||
        text.contains('عرض') ||
        text.contains('offer') ||
        text.contains('discount')) {
      return Icons.local_offer_rounded;
    }
    if (text.contains('طلب') ||
        text.contains('توصيل') ||
        text.contains('order') ||
        text.contains('deliver')) {
      return Icons.local_shipping_rounded;
    }
    if (text.contains('جرع') ||
        text.contains('دواء') ||
        text.contains('dose') ||
        text.contains('medicine')) {
      return Icons.medication_rounded;
    }
    return Icons.notifications_none_rounded;
  }

  String _timeAgo(BuildContext context, DateTime past) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final difference = DateTime.now().difference(past);
    if (difference.isNegative || difference.inMinutes < 1) {
      return isAr ? 'الآن' : 'Just now';
    }
    if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return isAr ? 'منذ $minutes د' : '${minutes}m ago';
    }
    if (difference.inHours < 24) {
      final hours = difference.inHours;
      return isAr ? 'منذ $hours س' : '${hours}h ago';
    }
    if (difference.inDays < 7) {
      final days = difference.inDays;
      return isAr ? 'منذ $days ي' : '${days}d ago';
    }
    return DateFormat.MMMd(isAr ? 'ar' : 'en').format(past);
  }
}
