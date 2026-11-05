import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/widgets/app_snack_bar.dart';
import 'package:elkawther/features/orders/cubit/orders_cubit.dart';
import 'package:elkawther/features/orders/models/all_returns.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/core/theme/app_padding.dart';
import 'package:elkawther/core/routes/routes.dart';

enum ReturnStatus { accepted, rejected, pending, canceled }

class ReturnCard extends StatelessWidget {
  final int orderNumber;
  final int orderId;
  final String totalPrice;
  final String date;
  final ReturnStatus status;
  final AllReturns returnItem;

  const ReturnCard({
    super.key,
    required this.orderNumber,
    required this.orderId,
    required this.totalPrice,
    required this.date,
    required this.status,
    required this.returnItem,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color backgroundColor;
    Color textColor;
    String statusText;

    switch (status) {
      case ReturnStatus.pending:
        backgroundColor = const Color(0xffFFAB07);
        textColor = Colors.white;
        statusText = S.of(context).active;
        break;
      case ReturnStatus.accepted:
        backgroundColor = const Color(0xffd9ffcc);
        textColor = const Color(0xff02ff2b);
        statusText = S.of(context).accepted;
        break;
      case ReturnStatus.rejected:
        backgroundColor = const Color(0xffdb3224);
        textColor = Colors.white;
        statusText = S.of(context).refused;
        break;
      case ReturnStatus.canceled:
        backgroundColor = const Color(0xffdb3224);
        textColor = Colors.white;
        statusText = S.of(context).refused;
        break;
    }

    return Card(
      elevation: 4,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Number and Date Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${S.of(context).order_number} : $orderNumber",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_month,
                      size: 18,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: AppPadding.small),
                    Text(
                      date,
                      style: AppTextStyles.ibmPlexSans16w500.copyWith(
                        color: AppColors.darkColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: AppPadding.medium),

            // Order ID
            FittedBox(
              child: Row(
                children: [
                  Text(
                    "${S.of(context).order_id}: ",
                    style: AppTextStyles.ibmPlexSans16w500.copyWith(
                      color: AppColors.darkColor,
                    ),
                  ),
                  Text(
                    "$orderId",
                    style: AppTextStyles.ibmPlexSans16w500.copyWith(
                      color: AppColors.darkColor,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppPadding.medium),

            // Quantity & Total Price Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Row(
                //   children: [
                //     Text(
                //       "${S.of(context).quantity}: ",
                //       style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black87),
                //     ),
                //     Text(
                //       "$quantity",
                //       style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                //     ),
                //   ],
                // ),
                Row(
                  children: [
                    Text(
                      "${S.of(context).total_price} ",
                      style: AppTextStyles.ibmPlexSans16w500.copyWith(
                        color: AppColors.darkColor,
                      ),
                    ),
                    Text(
                      totalPrice,
                      style: AppTextStyles.ibmPlexSans16w500.copyWith(
                        color: AppColors.darkColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: AppPadding.medium),

            // Buttons Row
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (status == ReturnStatus.pending)
                    TextButton(
                      onPressed: () async {
                        try {
                          final message = await context
                              .read<OrdersCubit>()
                              .cancelReturn(returnItem.id);
                          if (!context.mounted || message.isEmpty) return;
                          AppSnackBar.success(message);
                        } catch (error) {
                          if (context.mounted) {
                            AppSnackBar.error(error.toString());
                          }
                        }
                      },
                      child: Text(S.of(context).cancel),
                    ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: const BorderSide(color: Colors.black),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        Routes.returnProductDetails,
                        arguments: orderNumber,
                      );
                    },
                    child: Text(
                      S.of(context).details,
                      style: AppTextStyles.ibmPlexSans16w500.copyWith(
                        color: AppColors.darkColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: backgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        statusText,
                        style: AppTextStyles.ibmPlexSans16w500.copyWith(
                          color: textColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
