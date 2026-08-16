import 'package:elkawther/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:elkawther/features/notifications/cubit/notification_cubit.dart';
import 'package:elkawther/core/theme/app_padding.dart';

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
    return GestureDetector(
      onTap: () {
        context.read<NotificationCubit>().markAsRead(id);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: AppPadding.medium),
        padding: const EdgeInsets.all(AppPadding.medium),
        decoration: BoxDecoration(
          color: isRead ? Colors.grey[200] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isRead ? Colors.grey[300]! : Colors.blue.shade100,
            width: isRead ? 0.5 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.white,
              child: SvgPicture.asset(
                Assets.noti,
                width: 30,
                height: 30,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: AppPadding.medium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    timeAgo(DateTime.parse(createdAt)),
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: AppPadding.small),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String timeAgo(DateTime pastDateTime) {
    final now = DateTime.now();
    final difference = now.difference(pastDateTime);

    if (difference.inMinutes < 60) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else if (difference.inHours < 24) {
      return 'منذ ${difference.inHours} ساعة';
    } else {
      return 'منذ ${difference.inDays} يوم';
    }
  }
}
