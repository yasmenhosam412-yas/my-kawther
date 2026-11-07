import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/widgets/app_snack_bar.dart';
import 'package:elkawther/features/orders/cubit/orders_cubit.dart';
import 'package:elkawther/features/orders/models/all_returns.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:elkawther/core/routes/routes.dart';

class ReturnCard extends StatelessWidget {
  const ReturnCard({super.key, required this.item});

  final AllReturns item;

  @override
  Widget build(BuildContext context) {
    final style = _statusStyle(context, item.status);
    final pending = item.status.toLowerCase() == 'pending';
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: style.color.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 5, color: style.color),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${S.of(context).order_id} #${item.orderId}',
                          style: AppTextStyles.noto16w400.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.darkColor,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: style.color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          style.label,
                          style: AppTextStyles.noto14w400.copyWith(
                            color: style.color,
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.reason,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.noto14w400.copyWith(
                      color: AppColors.darkColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${S.of(context).refund_amount}: ${item.refundAmount}',
                    style: AppTextStyles.noto14w400.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  if ((item.refundMethod ?? '').isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      item.refundMethod!,
                      style: AppTextStyles.noto14w400.copyWith(
                        fontSize: 12,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if (pending)
                        TextButton(
                          onPressed: () => _cancel(context),
                          child: Text(S.of(context).cancel),
                        ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            Routes.returnProductDetails,
                            arguments: item.id,
                          );
                        },
                        child: Text(S.of(context).details),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _cancel(BuildContext context) async {
    try {
      final message = await context.read<OrdersCubit>().cancelReturn(item.id);
      if (!context.mounted || message.isEmpty) return;
      AppSnackBar.success(message);
    } catch (error) {
      if (context.mounted) AppSnackBar.error(error.toString());
    }
  }
}

class _StatusStyle {
  const _StatusStyle(this.label, this.color);

  final String label;
  final Color color;
}

_StatusStyle _statusStyle(BuildContext context, String status) {
  switch (status.toLowerCase()) {
    case 'accepted':
      return _StatusStyle(S.of(context).accepted, const Color(0xFF059669));
    case 'rejected':
    case 'refused':
      return _StatusStyle(S.of(context).refused, const Color(0xFFDC2626));
    case 'canceled':
    case 'cancelled':
      return _StatusStyle(S.of(context).canceled, const Color(0xFFDC2626));
    default:
      return _StatusStyle(S.of(context).active, const Color(0xFFD97706));
  }
}
