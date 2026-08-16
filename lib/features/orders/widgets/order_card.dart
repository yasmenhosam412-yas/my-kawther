import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/features/orders/models/orders_model.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,##0');
    final date = DateTime.tryParse(order.date);
    final dateLabel = date == null
        ? order.date
        : DateFormat(
            'd MMM yyyy',
            Localizations.localeOf(context).toString(),
          ).format(date);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${S.of(context).orderNumber} : ${order.orderId}',
                  style: AppTextStyles.noto16w400.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.calendar_month_outlined,
                size: 16,
                color: AppColors.grey.withOpacity(0.9),
              ),
              const SizedBox(width: 6),
              Text(
                dateLabel,
                style: AppTextStyles.noto14w400.copyWith(
                  color: AppColors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                '${S.of(context).quantity}: ${order.itemsCount}',
                style: AppTextStyles.noto14w400.copyWith(
                  color: AppColors.darkColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                '${S.of(context).totalPrice}: ${numberFormat.format(double.tryParse(order.totalPrice) ?? 0)} ${S.of(context).currency}',
                style: AppTextStyles.noto14w400.copyWith(
                  color: AppColors.darkColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    Routes.orderDetails,
                    arguments: order.orderId,
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryColor,
                  side: const BorderSide(color: AppColors.primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                child: Text(
                  S.of(context).details,
                  style: AppTextStyles.noto14w400.copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Spacer(),
              _StatusChip(status: order.status),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final (icon, label, color) = switch (status) {
      'pending' => (Icons.hourglass_top_rounded, S.of(context).pending, Colors.orange),
      'confirmed' => (
        Icons.schedule_outlined,
        S.of(context).active,
        Colors.amber.shade800,
      ),
      'completed' => (Icons.done_rounded, S.of(context).delivered, AppColors.teal),
      'canceled' => (
        Icons.cancel_outlined,
        S.of(context).cancelled,
        const Color(0xFFE44A4A),
      ),
      'on_delivery' => (
        Icons.delivery_dining_rounded,
        S.of(context).onDelivery,
        AppColors.teal,
      ),
      _ => (Icons.info_outline, status, AppColors.grey),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.noto14w400.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
