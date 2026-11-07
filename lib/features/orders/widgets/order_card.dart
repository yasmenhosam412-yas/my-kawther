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

    final status = _statusStyle(context, order.status);
    final total =
        '${numberFormat.format(double.tryParse(order.totalPrice) ?? 0)} ${S.of(context).currency}';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: status.color.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              Routes.orderDetails,
              arguments: order.orderId,
            );
          },
          child: Column(
              children: [
                Container(height: 5, color: status.color),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: status.color.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(status.icon, color: status.color, size: 20),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${S.of(context).orderNumber} #${order.orderId}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.noto16w400.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.darkColor,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  dateLabel,
                                  style: AppTextStyles.noto14w400.copyWith(
                                    color: AppColors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: status.color.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              status.label,
                              style: AppTextStyles.noto14w400.copyWith(
                                color: status.color,
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.light,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.shopping_bag_outlined,
                              size: 16,
                              color: AppColors.primaryColor.withOpacity(0.9),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${S.of(context).quantity}: ${order.itemsCount ?? '0'}',
                              style: AppTextStyles.noto14w400.copyWith(
                                color: AppColors.darkColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              total,
                              style: AppTextStyles.noto14w400.copyWith(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Directionality.of(context).name == 'rtl'
                                  ? Icons.chevron_left_rounded
                                  : Icons.chevron_right_rounded,
                              size: 18,
                              color: AppColors.primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
          ),
        ),
      ),
    );
  }
}

class _OrderStatusStyle {
  const _OrderStatusStyle(this.icon, this.label, this.color);

  final IconData icon;
  final String label;
  final Color color;
}

_OrderStatusStyle _statusStyle(BuildContext context, String status) {
  return switch (status) {
    'pending' => _OrderStatusStyle(
      Icons.schedule_rounded,
      S.of(context).pending,
      const Color(0xFFD97706),
    ),
    'confirmed' => _OrderStatusStyle(
      Icons.verified_outlined,
      S.of(context).active,
      AppColors.primaryColor,
    ),
    'completed' => _OrderStatusStyle(
      Icons.verified_rounded,
      S.of(context).delivered,
      const Color(0xFF059669),
    ),
    'canceled' => _OrderStatusStyle(
      Icons.cancel_rounded,
      S.of(context).cancelled,
      const Color(0xFFDC2626),
    ),
    'on_delivery' => _OrderStatusStyle(
      Icons.local_shipping_rounded,
      S.of(context).onDelivery,
      AppColors.teal,
    ),
    _ => _OrderStatusStyle(Icons.info_outline, status, AppColors.grey),
  };
}
