import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:elkawther/generated/l10n.dart';

class OrderDetailsSection extends StatelessWidget {
  final String address;
  final String paymentMethod;
  final String? deliveryFee;
  final String totalPrice;
  final String points;
  final String gift;

  const OrderDetailsSection({
    super.key,
    required this.address,
    required this.paymentMethod,
    this.deliveryFee,
    required this.totalPrice,
    required this.points,
    required this.gift,
  });

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,##0');
    final paymentLabel = paymentMethod == 'cash'
        ? S.of(context).cash
        : paymentMethod == 'qicard'
            ? S.of(context).qiCard
            : S.of(context).zainCach;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).orderDetails,
          style: AppTextStyles.noto16w400.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.darkColor,
          ),
        ),
        const SizedBox(height: 10),
        _buildDetailRow(
          label: S.of(context).shippingAddress,
          value: address,
        ),
        _buildDetailRow(
          label: S.of(context).paymentMethod,
          value: paymentLabel,
        ),
        if (deliveryFee != null)
          _buildDetailRow(
            label: S.of(context).deliveryFee,
            value:
                '${(double.tryParse(deliveryFee ?? '') ?? 0).toStringAsFixed(0)} ${S.of(context).currency}',
          ),
        _buildDetailRow(
          label: S.of(context).totalPrice,
          value:
              '${numberFormat.format(double.tryParse(totalPrice) ?? 0)} ${S.of(context).currency}',
        ),
        _buildDetailRow(
          label: S.of(context).pointsEarned,
          value: points,
        ),
        if (gift.isNotEmpty)
          _buildDetailRow(
            label: S.of(context).gift,
            value: gift,
          ),
      ],
    );
  }

  Widget _buildDetailRow({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$label : ',
              style: AppTextStyles.noto14w400.copyWith(
                color: AppColors.grey,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextSpan(
              text: value,
              style: AppTextStyles.noto14w400.copyWith(
                color: AppColors.darkColor,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
