import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';

import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/core/theme/app_padding.dart';
import 'package:elkawther/core/utils/helpers.dart';

class OrderInfoHeader extends StatelessWidget {
  final String orderNumber;
  final String date;
  final String shipmentNumber;
  final OrderState orderState;
  final String orderMeaning;

  const OrderInfoHeader({
    super.key,
    required this.orderNumber,
    required this.date,
    required this.shipmentNumber,
    required this.orderState,
    required this.orderMeaning,
  });

  @override
  Widget build(BuildContext context) {
    final statusWidget = switch (orderState) {
      OrderState.active => _buildStatus(
        context,
        Icons.schedule_outlined,
        S.of(context).pending,
        const Color(0xffFFAB07),
      ),
      OrderState.delivered => _buildStatus(
        context,
        Icons.done,
        S.of(context).accepted,
        Colors.green,
      ),
      OrderState.canceled => _buildStatus(
        context,
        Icons.cancel_outlined,
        S.of(context).rejected,
        Colors.red,
      ),
      OrderState.onDelivery => _buildStatus(
        context,
        Icons.delivery_dining,
        S.of(context).onDelivery,
        Colors.green,
      ),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${S.of(context).orderNumber}: $orderNumber",
              style: AppTextStyles.noto16w400.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                const Icon(Icons.calendar_month, size: 16, color: Colors.grey),
                const SizedBox(width: 7),
                Text(
                  date,
                  style: AppTextStyles.noto16w400.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppPadding.small),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "${S.of(context).status}: $orderMeaning",
                style: AppTextStyles.noto16w400.copyWith(
                  color: Colors.black87,
                  fontSize: 14,
                ),
              ),
            ),
            statusWidget,
          ],
        ),
      ],
    );
  }

  Widget _buildStatus(
    BuildContext context,
    IconData icon,
    String text,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 5),
        Text(text, style: AppTextStyles.noto16w400.copyWith(color: color)),
      ],
    );
  }
}
