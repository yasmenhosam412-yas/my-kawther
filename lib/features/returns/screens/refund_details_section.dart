import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:elkawther/core/theme/app_padding.dart';
import 'package:elkawther/generated/l10n.dart';

class RefundDetailsSection extends StatelessWidget {
  final String address;
  final String paymentMethod;
  final String? deliveryFee;
  final String totalPrice;
  final String points;
  final String gift;
  final String notes;
  final String reson;

  const RefundDetailsSection({
    super.key,
    required this.address,
    required this.paymentMethod,
    this.deliveryFee,
    required this.totalPrice,
    required this.points,
    required this.gift,
    required this.notes,
    required this.reson,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(AppPadding.small),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).orderDetails,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppPadding.small),

          _buildDetailRow(
            context,
            icon: Icons.location_on,
            label: S.of(context).addressOfTake,
            value: address,
          ),

          _buildDetailRow(
            context,
            icon: Icons.payment,
            label: S.of(context).paymentMethod,
            value:
                (paymentMethod == "cash")
                    ? S.of(context).cash
                    : S.of(context).zainCach,
          ),

          _buildDetailRow(
            context,
            icon: Icons.attach_money,
            label: S.of(context).totalPrice,
            value:
                "${double.tryParse(totalPrice)!.toStringAsFixed(0)} ${S.of(context).currency}",
          ),

          // _buildDetailRow(
          //   context,
          //   icon: Icons.star,
          //   label: S.of(context).pointsEarned,
          //   value: points,
          // // ),
          // if (gift.isNotEmpty)
          //   _buildDetailRow(
          //     context,
          //     icon: Icons.discount,
          //     label: S.of(context).gift,
          //     value: gift,
          //   ),
          _buildDetailRow(
            context,
            icon: Icons.notes,
            label: S.of(context).return_reason,
            value: reson,
          ),

          if (notes.isNotEmpty) ...[
            _buildDetailRow(
              context,
              icon: Icons.notes,
              label: S.of(context).note,
              value: notes,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppPadding.small),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: "$label : ", style: AppTextStyles.ibmPlexSans16w500),
            TextSpan(
              text: value,
              style: AppTextStyles.ibmPlexSans16w500.copyWith(
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
