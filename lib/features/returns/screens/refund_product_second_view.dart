import 'dart:io';

import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/widgets/app_snack_bar.dart';
import 'package:elkawther/features/addresses/cubit/addresses_cubit.dart';
import 'package:elkawther/features/addresses/widgets/build_address_bottom_sheet.dart';
import 'package:elkawther/features/checkout/models/checkout_payment_method.dart';
import 'package:elkawther/features/orders/cubit/orders_cubit.dart';
import 'package:elkawther/features/orders/models/order_details_model.dart';
import 'package:elkawther/features/profile/models/profile_models.dart';
import 'package:elkawther/features/profile/widgets/profile_scaffold.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RefundProductSecondView extends StatefulWidget {
  const RefundProductSecondView({
    super.key,
    required this.orderDetails,
    required this.selectedReason,
    required this.note,
    this.imageFiles = const [],
  });

  final OrderDetailsModel orderDetails;
  final List<File> imageFiles;
  final String selectedReason;
  final String note;

  @override
  State<RefundProductSecondView> createState() => _RefundProductSecondViewState();
}

class _RefundProductSecondViewState extends State<RefundProductSecondView> {
  AddressModel? _selectedAddress;
  List<CheckoutPaymentMethod> _methods = const [];
  String _refundMethod = 'cash';
  bool _loadingMethods = true;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final addresses = context.read<AddressCubit>();
      if (addresses.addresses == null) {
        await addresses.getAllAddresses(context);
      }
      await _loadMethods();
    });
  }

  Future<void> _loadMethods() async {
    try {
      final methods = await fetchCheckoutPaymentMethods();
      if (!mounted) return;
      setState(() {
        _methods = methods;
        _loadingMethods = false;
        if (methods.isNotEmpty &&
            !methods.any((method) => method.code == _refundMethod)) {
          _refundMethod = methods.first.code;
        }
      });
    } catch (_) {
      if (mounted) setState(() => _loadingMethods = false);
    }
  }

  Future<void> _submit(AddressModel? address) async {
    final line = address?.address?.trim() ?? '';
    if (line.isEmpty) {
      AppSnackBar.error(S.of(context).noAddressesFound);
      return;
    }
    setState(() => _sending = true);
    try {
      await context.read<OrdersCubit>().requestRefund(
        orderId: widget.orderDetails.orderId,
        reason: widget.selectedReason,
        note: widget.note,
        refundAmount: widget.orderDetails.totalPrice,
        refundMethod: _refundMethod,
        address: line,
        images: widget.imageFiles,
      );
      if (!mounted) return;
      final state = context.read<OrdersCubit>().state;
      if (state is OrdersRefunded) {
        Navigator.pushReplacementNamed(context, Routes.successRefund);
      } else if (state is OrdersError) {
        AppSnackBar.error(state.error.localizedMessage(context));
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final addresses = context.watch<AddressCubit>();
    final address = _selectedAddress ?? addresses.getDefaultAddress();

    return ProfileScaffold(
      title: S.of(context).return_product,
      subtitle: isAr ? 'العنوان وطريقة الاسترداد' : 'Address and refund method',
      bottom: ProfilePrimaryButton(
        title: S.of(context).submit_request,
        isLoading: _sending,
        onPressed: _sending ? null : () => _submit(address),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          ProfileFormCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        S.of(context).delivery_address,
                        style: AppTextStyles.noto16w400.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColors.darkColor,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        showDisplayAddressesBottomSheet(
                          context,
                          selectedAddress: address,
                          onAddressSelected: (value) {
                            setState(() => _selectedAddress = value);
                          },
                        );
                      },
                      child: Text(S.of(context).change),
                    ),
                  ],
                ),
                Text(
                  address?.address?.trim().isNotEmpty == true
                      ? address!.address!
                      : S.of(context).noAddressesFound,
                  style: AppTextStyles.noto14w400.copyWith(color: AppColors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isAr ? 'طريقة الاسترداد' : 'Refund method',
            style: AppTextStyles.noto16w400.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.darkColor,
            ),
          ),
          const SizedBox(height: 10),
          if (_loadingMethods)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              ),
            )
          else
            ...(_methods.isEmpty
                    ? [
                      CheckoutPaymentMethod(
                        code: 'cash',
                        type: 'cash',
                        name: S.of(context).cash,
                        requiresReceipt: false,
                      ),
                    ]
                    : _methods)
                .map(
                  (method) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => setState(() => _refundMethod = method.code),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              Icon(method.icon, color: AppColors.primaryColor),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  method.name,
                                  style: AppTextStyles.noto14w400.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.darkColor,
                                  ),
                                ),
                              ),
                              Icon(
                                _refundMethod == method.code
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_off,
                                color: AppColors.primaryColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
          const SizedBox(height: 6),
          ProfileFormCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _line(S.of(context).return_reason, widget.selectedReason),
                if (widget.note.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  _line(S.of(context).note, widget.note),
                ],
                const SizedBox(height: 10),
                _line(S.of(context).refund_amount, widget.orderDetails.totalPrice),
                if (widget.imageFiles.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 84,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.imageFiles.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (context, index) => ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          widget.imageFiles[index],
                          width: 84,
                          height: 84,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _line(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.noto14w400.copyWith(color: AppColors.grey),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: AppTextStyles.noto14w400.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.darkColor,
            ),
          ),
        ),
      ],
    );
  }
}
