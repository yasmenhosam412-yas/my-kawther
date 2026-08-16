import 'dart:io';
import 'package:elkawther/features/addresses/cubit/addresses_cubit.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:elkawther/features/orders/models/order_details_model.dart';
import 'package:elkawther/features/returns/widgets/payment_filter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:elkawther/features/orders/cubit/orders_cubit.dart';
import 'package:elkawther/features/profile/cubit/profile_cubit.dart';
import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/generated/assets.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_padding.dart';
import 'package:elkawther/features/profile/models/profile_models.dart';
import 'package:elkawther/features/addresses/widgets/address_custom_container.dart';
import 'package:elkawther/features/orders/widgets/order_product_item.dart';
import 'package:elkawther/core/widgets/custom_elevated_button.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class RefundProductSecondView extends StatefulWidget {
  final OrderDetailsModel orderDetails;
  final List<File> imageFiles;
  final String selectedReason;
  final String note;

  const RefundProductSecondView({
    super.key,
    required this.orderDetails,
    this.imageFiles = const [],
    required this.selectedReason,
    required this.note,
  });

  @override
  State<RefundProductSecondView> createState() =>
      _RefundProductSecondViewState();
}

class _RefundProductSecondViewState extends State<RefundProductSecondView> {
  late final List<OrderProduct> products;
  late final List<File> imageFiles;
  AddressModel? selectedAddress;
  final int _selectedIndex = 0;
  bool _isLoading = false;
  String refundMethod = "cash";

  @override
  void initState() {
    super.initState();
    products = widget.orderDetails.products;
    imageFiles = widget.imageFiles;

    final cubit = context.read<AddressCubit>();
    if (cubit.addresses == null || cubit.addresses!.isEmpty) {
      cubit.getAllAddresses(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileCubit = context.watch<AddressCubit>();
    final defaultAddress = profileCubit.getDefaultAddress();
    final addressToShow = selectedAddress ?? defaultAddress;

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).return_product),
        centerTitle: true,
      ),
      body: BlocListener<OrdersCubit, OrdersState>(
        listener: (context, state) async {
          if (state is OrdersLoading) {
            setState(() => _isLoading = true);
          } else {
            setState(() => _isLoading = false);
          }

          if (state is OrdersRefunded) {
            Navigator.pushReplacementNamed(context, Routes.successRefund);
          } else if (state is OrdersError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(S.of(context).unexpectedError)),
            );
          }
        },
        child: AbsorbPointer(
          absorbing: _isLoading,
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(AppPadding.small),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          S.of(context).delivery_address,
                          style: AppTextStyles.ibmPlexSans16w500.copyWith(
                            color: Colors.black,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            showDisplayAddressesBottomSheet(
                              context,
                              onAddressSelected: (address) {
                                setState(() {
                                  selectedAddress = address;
                                });
                              },
                            );
                          },
                          child: Text(
                            S.of(context).change,
                            style: AppTextStyles.ibmPlexSans16w500.copyWith(
                              color: Colors.black.withOpacity(0.6),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppPadding.medium),
                    if (addressToShow != null)
                      AddressCustomContainer(
                        selected: true,
                        addControlButtons: false,
                        isToRefund: true,
                        addressModel: addressToShow,
                      )
                    else if (profileCubit.state is ProfileCubitLoadingState)
                      Skeletonizer(
                        containersColor: Colors.grey.shade100,
                        child: AddressCustomContainer(
                          selected: true,
                          addControlButtons: false,
                          isToRefund: true,
                          addressModel: AddressModel(isDefault: false),
                        ),
                      )
                    else
                      Text(
                        S.of(context).noAddressesFound,
                        style: const TextStyle(color: AppColors.primaryColor),
                      ),

                    const SizedBox(height: AppPadding.medium),

                    PaymentFilterChips(
                      labels: [S.of(context).cash, S.of(context).zainCach],
                      initialIndex: _selectedIndex,
                      selectedMethod: (String val) {
                        setState(() {
                          refundMethod = val;
                        });
                      },
                    ),

                    const SizedBox(height: AppPadding.medium),

                    Text(
                      S.of(context).product_details,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppPadding.medium),
                    if (products.isNotEmpty)
                      Column(
                        children: List.generate(products.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: OrderProductItem(product: products[index]),
                          );
                        }),
                      )
                    else
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(Assets.unfound, width: 70, height: 70),
                            const SizedBox(height: AppPadding.medium),
                            Text(
                              S.of(context).no_products_found,
                              style: AppTextStyles.ibmPlexSans16w500.copyWith(
                                fontSize: 22,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const Divider(),
                    const SizedBox(height: AppPadding.medium),

                    Text(
                      S.of(context).return_reason,
                      style: AppTextStyles.ibmPlexSans16w500.copyWith(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: AppPadding.small),
                    Text(
                      widget.selectedReason,
                      style: AppTextStyles.ibmPlexSans16w500.copyWith(
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: AppPadding.medium),

                    if (widget.note.isNotEmpty) ...[
                      Text(
                        S.of(context).comment,
                        style: AppTextStyles.ibmPlexSans16w500.copyWith(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: AppPadding.small),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          widget.note,
                          style: AppTextStyles.ibmPlexSans16w500.copyWith(
                            color: Colors.black.withOpacity(0.6),
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: AppPadding.medium),

                    Text(
                      S.of(context).pictures,
                      style: AppTextStyles.ibmPlexSans16w500.copyWith(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: AppPadding.small2),
                    Container(
                      height: 200,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppPadding.small),
                        border: Border.all(color: AppColors.darkColor),
                      ),
                      child:
                          imageFiles.isNotEmpty
                              ? ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: imageFiles.length,
                                separatorBuilder:
                                    (_, __) => const SizedBox(width: 8),
                                itemBuilder:
                                    (context, index) => ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.file(
                                        imageFiles[index],
                                        width: 120,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                              )
                              : Center(
                                child: Text(
                                  S.of(context).no_images,
                                  style: AppTextStyles.ibmPlexSans16w500
                                      .copyWith(color: AppColors.grey),
                                ),
                              ),
                    ),

                    const SizedBox(height: AppPadding.medium),

                    Container(
                      padding: const EdgeInsets.all(AppPadding.medium),
                      decoration: BoxDecoration(
                        color: const Color(0xffD4D4D4).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(AppPadding.small),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            S.of(context).refund_amount,
                            style: AppTextStyles.ibmPlexSans16w500.copyWith(
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            '${getTotal(widget.orderDetails)} ${S.of(context).currency}',
                            style: AppTextStyles.ibmPlexSans16w500.copyWith(
                              color: AppColors.darkColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppPadding.medium),
                    CustomElevatedButton(
                      onPressed:
                          _isLoading
                              ? null
                              : () {
                                final address =
                                    (selectedAddress ?? defaultAddress)
                                        ?.address ??
                                    '';
                                if (address.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        S.of(context).noAddressesFound,
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                context.read<OrdersCubit>().requestRefund(
                                  orderId: widget.orderDetails.orderId,
                                  reason: widget.selectedReason,
                                  note: widget.note,
                                  refundAmount: widget.orderDetails.totalPrice,
                                  refundMethod: refundMethod,
                                  address: address,
                                  images: widget.imageFiles,
                                );
                              },
                      title:
                          _isLoading
                              ? S.of(context).loading
                              : S.of(context).submit_request,
                      backgroundColor:
                          _isLoading
                              ? CupertinoColors.extraLightBackgroundGray
                              : AppColors.primaryColor,
                    ),
                  ],
                ),
              ),

              if (_isLoading)
                Container(
                  color: Colors.black.withOpacity(0.2),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void showDisplayAddressesBottomSheet(
    BuildContext context, {
    required Function(AddressModel selectedAddress) onAddressSelected,
  }) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return BlocBuilder<ProfileCubit, ProfileCubitState>(
          builder: (context, state) {
            final addresses = context.read<AddressCubit>().addresses ?? [];

            if (state is ProfileCubitLoadingState) {
              return const Padding(
                padding: EdgeInsets.all(AppPadding.large),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (addresses.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(AppPadding.large),
                child: Center(
                  child: Text(
                    S.of(context).noAddressesFound,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppPadding.medium,
                horizontal: AppPadding.medium,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    S.of(context).please_select_address,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppPadding.medium),
                  ...addresses.map((address) {
                    return Card(
                      color: Colors.grey.shade100,
                      elevation: 0,
                      child: ListTile(
                        title: Text(
                          address.address ?? 'No address',
                          style: AppTextStyles.noto16w400.copyWith(
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          address.city ?? '',
                          style: AppTextStyles.noto16w400.copyWith(
                            color: Colors.black,
                          ),
                        ),
                        trailing:
                            address.isDefault
                                ? Text(
                                  S.of(context).defultAddress,
                                  style: AppTextStyles.noto16w400.copyWith(
                                    fontSize: 12,
                                    color: AppColors.darkColor,
                                  ),
                                )
                                : null,
                        onTap: () {
                          Navigator.pop(context);
                          onAddressSelected(address);
                        },
                      ),
                    );
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String getTotal(OrderDetailsModel orderDetails) {
    double orderTotal = double.parse(orderDetails.totalPrice);
    double deliveryFee = double.parse(orderDetails.deliveryFee);
    return (orderTotal - deliveryFee).toStringAsFixed(0);
  }
}
