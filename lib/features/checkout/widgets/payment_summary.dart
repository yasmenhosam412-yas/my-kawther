import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elkawther/features/cart/cubit/cart_cubit.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/widgets/app_snack_bar.dart';
import 'package:elkawther/core/theme/app_padding.dart';
import 'package:elkawther/generated/l10n.dart';

class PaymentSummary extends StatefulWidget {
  const PaymentSummary({super.key});

  @override
  State<PaymentSummary> createState() => _PaymentSummaryState();
}

class _PaymentSummaryState extends State<PaymentSummary> {
  final TextEditingController code = TextEditingController();

  @override
  void dispose() {
    code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.medium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Promo Code Input Row
          Container(
            height: 50,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: TextField(
                      controller: code,
                      decoration: InputDecoration(
                        labelText: S.of(context).promoCode,
                        labelStyle: const TextStyle(color: AppColors.grey),
                        filled: true,
                        fillColor: Colors.grey[200],
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[200]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 0,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppPadding.small),
                SizedBox(
                  height: 40,
                  width: 80,
                  child: BlocConsumer<CartCubit, CartState>(
                    listener: (context, state) {
                      if (state is CartError) {
                        AppSnackBar.error(state.message);
                      } else if (state is CouponApplied) {
                        AppSnackBar.success(S.of(context).approved);
                        code.clear();
                      } else if (state is CouponRejected) {
                        AppSnackBar.warning(state.message);
                      }
                    },
                    builder: (context, state) {
                      final isLoading = state is CartLoading;

                      return ElevatedButton(
                        onPressed:
                            isLoading
                                ? null
                                : () {
                                  FocusScope.of(context).unfocus();
                                  if (code.text.isNotEmpty) {}
                                },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        child:
                            isLoading
                                ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                                : Text(
                                  S.of(context).apply,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppPadding.medium),

          // Payment Summary Details
          // BlocBuilder<CartCubit, CartState>(
          //   builder: (context, state) {
          //     if (state is CartLoaded) {
          //       // final subtotal = state.cartItems.fold<double>(
          //       //   0,
          //       //   (sum, item) => sum + (item.discountedPrice * item.quantity),
          //       // );
          //
          //       final discount = 0.0;
          //       final total = subtotal - discount;
          //
          //       return Column(
          //         children: [
          //           _buildSummaryRow(
          //             context,
          //             title: S.of(context).subtotal,
          //             value: subtotal.toStringAsFixed(2),
          //           ),
          //           const SizedBox(height: AppPadding.medium),
          //
          //           _buildSummaryRow(
          //             context,
          //             title: S.of(context).discount,
          //             value: "-${discount.toStringAsFixed(2)}",
          //           ),
          //           const SizedBox(height: AppPadding.medium),
          //
          //           Divider(color: Colors.grey[400]!, thickness: 0.5),
          //           const SizedBox(height: AppPadding.medium),
          //
          //           _buildSummaryRow(
          //             context,
          //             title: S.of(context).total,
          //             value: total.toStringAsFixed(2),
          //             isBold: true,
          //             isLarge: true,
          //           ),
          //         ],
          //       );
          //     }
          //
          //     return const SizedBox.shrink();
          //   },
          // ),
        ],
      ),
    );
  }
}
