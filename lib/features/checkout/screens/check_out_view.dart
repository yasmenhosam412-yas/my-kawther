import 'dart:io';

import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/theme/app_padding.dart';
import 'package:elkawther/core/toasts/toasts.dart';
import 'package:elkawther/features/checkout/data/checkout_local_store.dart';
import 'package:elkawther/features/checkout/widgets/address.dart';
import 'package:elkawther/features/checkout/widgets/payment_option_zain.dart';
import 'package:elkawther/features/addresses/cubit/addresses_cubit.dart';
import 'package:elkawther/features/addresses/widgets/build_address_bottom_sheet.dart';
import 'package:elkawther/features/cart/cubit/cart_cubit.dart';
import 'package:elkawther/features/cart/models/cart_model.dart';
import 'package:elkawther/features/home/widgets/home_catalog_image.dart';
import 'package:elkawther/features/profile/models/profile_models.dart';
import 'package:elkawther/features/profile/widgets/profile_scaffold.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CheckOutView extends StatefulWidget {
  const CheckOutView({super.key});

  @override
  State<CheckOutView> createState() => _CheckOutViewState();
}

class _CheckOutViewState extends State<CheckOutView> {
  final _store = CheckoutLocalStore.instance;
  final notesController = TextEditingController();
  final promoCodeController = TextEditingController();
  final numberController = TextEditingController(
    text: CheckoutLocalStore.zainNumber,
  );
  final creditController = TextEditingController(
    text: CheckoutLocalStore.qiCard,
  );
  late final TextEditingController phoneController;
  AddressModel? _selectedAddress;
  File? image;
  String transferMethod = 'cash';

  @override
  void initState() {
    super.initState();
    phoneController = TextEditingController(text: '01012345678');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<CartCubit>().loadCart(context);
      if (context.read<AddressCubit>().addresses == null) {
        context.read<AddressCubit>().getAllAddresses(context);
      }
    });
  }

  @override
  void dispose() {
    notesController.dispose();
    promoCodeController.dispose();
    numberController.dispose();
    creditController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartCubit = context.watch<CartCubit>();
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final items = cartCubit.cart;
    final addressCubit = context.watch<AddressCubit>();
    final availableAddresses = addressCubit.addresses ?? const <AddressModel>[];
    final address =
        _selectedAddress ??
        addressCubit.getDefaultAddress() ??
        (availableAddresses.isNotEmpty ? availableAddresses.first : null);
    final format = NumberFormat('#,##0');
    final subtotal = cartCubit.subtotal;
    final delivery = address == null ? 0.0 : _store.deliveryFeeFor(address);
    final discount = cartCubit.discount;
    final total = subtotal - discount + delivery;

    return BlocListener<CartCubit, CartState>(
      listener: (context, state) {
        if (state is CartError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is CartLoaded && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!.localizedMessage(context)),
            ),
          );
        } else if (state is CouponApplied) {
          ToastMessage().displayMessageToast(
            S.of(context).approved,
            AppColors.teal,
          );
          promoCodeController.clear();
        } else if (state is OrderConfirmed) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.checkoutSuccess,
            (route) => false,
            arguments: {
              'points': state.data.pointsEarned,
              'gift': state.data.giftDescription,
            },
          );
        }
      },
      child: ProfileScaffold(
        title: S.of(context).checkout,
        subtitle:
            items.isEmpty
                ? S.of(context).cartEmptySubtitle
                : isAr
                ? 'راجع العنوان والدفع قبل التأكيد'
                : 'Review address and payment',
        bottom: ProfilePrimaryButton(
          title:
              items.isEmpty
                  ? S.of(context).startShopping
                  : S.of(context).confirmOrder,
          onPressed:
              items.isEmpty
                  ? () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    Routes.home,
                    (route) => false,
                  )
                  : context.read<CartCubit>().state is OrderConfirmLoading
                  ? null
                  : () => _confirm(address),
        ),
        body:
            items.isEmpty
                ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.shopping_bag_outlined,
                          size: 56,
                          color: AppColors.grey.withOpacity(0.7),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          S.of(context).cartEmpty,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.noto16w400.copyWith(
                            color: AppColors.darkColor,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          S.of(context).cartEmptySubtitle,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.noto14w400.copyWith(
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  children: [
                    Row(
                      children: [
                        Text(
                          S.of(context).delivery_address,
                          style: AppTextStyles.noto16w400.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.darkColor,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            showDisplayAddressesBottomSheet(
                              context,
                              selectedAddress: address,
                              onAddressSelected:
                                  (selected) => setState(
                                    () => _selectedAddress = selected,
                                  ),
                            );
                          },
                          child: Text(
                            S.of(context).change,
                            style: AppTextStyles.noto14w400.copyWith(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (address != null)
                      AddressWidget(
                        addressName: address.address ?? '',
                        addressDetails: address.city ?? '',
                        location: address.landmark ?? '',
                        isPharm: address.isPharmacy ?? false,
                        apartment: address.apartment ?? '',
                        type: address.type ?? 'home',
                        phoneNumber: phoneController.text,
                        phoneController: phoneController,
                      )
                    else
                      ProfileFormCard(
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_off_outlined,
                              color: AppColors.grey,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                S.of(context).noAddressesFound,
                                style: AppTextStyles.noto14w400.copyWith(
                                  color: AppColors.darkColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed:
                                  () => Navigator.pushNamed(
                                    context,
                                    Routes.addNewAddress,
                                  ),
                              child: Text(S.of(context).add),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 16),
                    Text(
                      S.of(context).paymentTool,
                      style: AppTextStyles.noto16w400.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.darkColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    PaymentMethodWidget(
                      numberController: numberController,
                      creditController: creditController,
                      onImagePicked: (picked) => setState(() => image = picked),
                      onPaymentSelected:
                          (method) => setState(() => transferMethod = method),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      S.of(context).order_list,
                      style: AppTextStyles.noto16w400.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.darkColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...items.map(_itemCard),
                    const SizedBox(height: 8),
                    _promoField(),
                    const SizedBox(height: 12),
                    ProfileFormCard(
                      child: Column(
                        children: [
                          _priceRow(
                            S.of(context).subtotal,
                            format.format(subtotal),
                          ),
                          const SizedBox(height: 8),
                          _priceRow(
                            S.of(context).deliveryFee,
                            format.format(delivery),
                          ),
                          const SizedBox(height: 8),
                          _priceRow(
                            S.of(context).discount,
                            format.format(discount),
                          ),
                          const Divider(height: 20),
                          _priceRow(
                            S.of(context).total,
                            format.format(total),
                            isTotal: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      S.of(context).do_you_have_a_comment,
                      style: AppTextStyles.noto14w400.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.darkColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: notesController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: AppColors.primaryColor.withOpacity(0.12),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: AppColors.primaryColor.withOpacity(0.12),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: AppColors.primaryColor,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),
                    const SizedBox(height: AppPadding.medium),
                  ],
                ),
      ),
    );
  }

  Widget _itemCard(CartModel line) {
    final format = NumberFormat('#,##0');
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: HomeCatalogImage(
              assetPath: line.mainImage,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.noto14w400.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${S.of(context).quantity}: ${line.quantity}',
                  style: AppTextStyles.noto14w400.copyWith(
                    color: AppColors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${format.format(line.lineTotal)} ${S.of(context).currency}',
            style: AppTextStyles.noto14w400.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _promoField() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 6, 6, 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: promoCodeController,
              readOnly: context.read<CartCubit>().isCouponApplied,
              decoration: InputDecoration(
                hintText: S.of(context).promoCode,
                border: InputBorder.none,
                hintStyle: AppTextStyles.noto14w400.copyWith(
                  color: AppColors.grey,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                final code = promoCodeController.text.trim().toUpperCase();
                final cartCubit = context.read<CartCubit>();
                if (cartCubit.isCouponApplied) {
                  cartCubit.removeCoupon();
                  promoCodeController.clear();
                  return;
                }
                if (code.isEmpty) {
                  return;
                }
                cartCubit.applyCoupon(context, code);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    context.read<CartCubit>().isCouponApplied
                        ? const Color(0xFFEF4444)
                        : AppColors.primaryColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                context.read<CartCubit>().isCouponApplied
                    ? S.of(context).remove
                    : S.of(context).confirm,
                style: AppTextStyles.noto14w400.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.noto14w400.copyWith(
            color: isTotal ? AppColors.darkColor : AppColors.grey,
            fontWeight: isTotal ? FontWeight.w800 : FontWeight.w500,
            fontSize: isTotal ? 16 : 14,
          ),
        ),
        Text(
          '$amount ${S.of(context).currency}',
          style: AppTextStyles.noto14w400.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: isTotal ? 16 : 14,
            color: isTotal ? AppColors.primaryColor : AppColors.darkColor,
          ),
        ),
      ],
    );
  }

  void _confirm(AddressModel? address) {
    if (context.read<CartCubit>().cart.isEmpty) return;
    if (transferMethod != 'cash' && image == null) {
      ToastMessage().displayMessageToast(
        S.of(context).upload_image_here_please,
        AppColors.redOpacity,
      );
      return;
    }
    if (phoneController.text.trim().isEmpty) {
      ToastMessage().displayMessageToast(
        S.of(context).pleaseEnterPhoneNumber,
        AppColors.primaryColor,
      );
      return;
    }

    if (address?.id == null) {
      ToastMessage().displayMessageToast(
        S.of(context).delivery_address,
        AppColors.redOpacity,
      );
      return;
    }

    context.read<CartCubit>().confirmOrder(
      context,
      address!.id!,
      transferMethod,
      context.read<CartCubit>().coupon?.code ?? '',
      notesController.text.trim(),
      image: image,
    );
  }
}
