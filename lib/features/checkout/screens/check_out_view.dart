import 'dart:io';

import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/theme/app_padding.dart';
import 'package:elkawther/core/widgets/app_snack_bar.dart';
import 'package:elkawther/features/checkout/models/checkout_payment_method.dart';
import 'package:elkawther/features/checkout/widgets/address.dart';
import 'package:elkawther/features/checkout/widgets/payment_option_zain.dart';
import 'package:elkawther/features/addresses/cubit/addresses_cubit.dart';
import 'package:elkawther/features/addresses/widgets/build_address_bottom_sheet.dart';
import 'package:elkawther/features/cart/cubit/cart_cubit.dart';
import 'package:elkawther/features/cart/models/cart_model.dart';
import 'package:elkawther/features/home/widgets/home_catalog_image.dart';
import 'package:elkawther/features/profile/cubit/profile_cubit.dart';
import 'package:elkawther/features/profile/models/profile_models.dart';
import 'package:elkawther/features/profile/services/loyalty_service.dart';
import 'package:elkawther/features/profile/widgets/profile_scaffold.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

class CheckOutView extends StatefulWidget {
  const CheckOutView({super.key});

  @override
  State<CheckOutView> createState() => _CheckOutViewState();
}

class _CheckOutViewState extends State<CheckOutView> {
  final notesController = TextEditingController();
  final promoCodeController = TextEditingController();
  final pointsController = TextEditingController();
  late final TextEditingController phoneController;
  AddressModel? _selectedAddress;
  File? image;
  String transferMethod = '';
  List<CheckoutPaymentMethod> _paymentMethods = const [];
  bool _paymentsLoading = true;
  LoyaltyAccount? _loyalty;

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
      final profile = context.read<ProfileCubit>();
      if (profile.deliveryPrices == null) {
        profile.getDeliveryPricesAndCities();
      }
      _loadLoyalty();
      _loadPaymentMethods();
    });
  }

  Future<void> _loadPaymentMethods() async {
    try {
      final methods = await fetchCheckoutPaymentMethods();
      if (!mounted) return;
      setState(() {
        _paymentMethods = methods;
        _paymentsLoading = false;
        if (methods.isNotEmpty &&
            !methods.any((method) => method.code == transferMethod)) {
          transferMethod = methods.first.code;
        }
      });
    } catch (_) {
      if (mounted) setState(() => _paymentsLoading = false);
    }
  }

  Future<void> _loadLoyalty() async {
    try {
      final account = await GetIt.I<LoyaltyService>().account();
      if (!mounted) return;
      setState(() => _loyalty = account);
    } catch (_) {}
  }

  @override
  void dispose() {
    notesController.dispose();
    promoCodeController.dispose();
    pointsController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartCubit = context.watch<CartCubit>();
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final items = cartCubit.cart;
    final addressCubit = context.watch<AddressCubit>();
    final profileCubit = context.watch<ProfileCubit>();
    final availableAddresses = addressCubit.addresses ?? const <AddressModel>[];
    final address =
        _selectedAddress ??
        addressCubit.getDefaultAddress() ??
        (availableAddresses.isNotEmpty ? availableAddresses.first : null);
    final format = NumberFormat('#,##0');
    final subtotal = cartCubit.subtotal;
    final delivery = address == null
        ? 0.0
        : profileCubit.getDeliveryPriceForAddress(address) ?? 0;
    final discount = cartCubit.discount;
    final total = subtotal - discount + delivery;

    return BlocListener<CartCubit, CartState>(
      listener: (context, state) {
        if (state is CartError) {
          AppSnackBar.error(state.message);
        } else if (state is CartLoaded && state.errorMessage != null) {
          AppSnackBar.error(state.errorMessage!.localizedMessage(context));
        } else if (state is CouponApplied) {
          final message = state.coupon?.message;
          AppSnackBar.success(
            message == null || message.trim().isEmpty
                ? S.of(context).approved
                : message,
          );
          promoCodeController.clear();
        } else if (state is CouponRejected) {
          AppSnackBar.warning(state.message);
        } else if (state is OrderConfirmed) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.checkoutSuccess,
            (route) => false,
            arguments: state.data,
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
                  : () => _confirm(address, total: total, delivery: delivery),
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
                        Expanded(
                          child: _sectionHeader(
                            1,
                            address?.isPickupFromPharmacy == true
                                ? S.of(context).takeFromPharamcy
                                : S.of(context).delivery_address,
                          ),
                        ),
                        const SizedBox(width: 8),
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
                        isPharm: address.isPickupFromPharmacy,
                        apartment: address.apartment ?? '',
                        type: address.type ?? 'home',
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
                    _sectionHeader(2, S.of(context).paymentTool),
                    const SizedBox(height: 10),
                    PaymentMethodWidget(
                      methods: _paymentMethods,
                      loading: _paymentsLoading,
                      onImagePicked: (picked) => setState(() => image = picked),
                      onPaymentSelected:
                          (method) => setState(() => transferMethod = method),
                    ),
                    const SizedBox(height: 16),
                    _sectionHeader(3, S.of(context).order_list),
                    const SizedBox(height: 10),
                    ...items.map(_itemCard),
                    const SizedBox(height: 8),
                    _promoField(),
                    if (_loyalty?.redeemEnabled != false) ...[
                      const SizedBox(height: 12),
                      TextField(
                        controller: pointsController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: isAr
                              ? 'نقاط الولاء المستخدمة'
                              : 'Loyalty points to redeem',
                          helperText: _pointsHelper(isAr),
                          helperMaxLines: 3,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ],
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

  Widget _sectionHeader(int step, String title) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '$step',
            style: AppTextStyles.noto14w400.copyWith(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.noto16w400.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.darkColor,
            ),
          ),
        ),
      ],
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
                Row(
                  children: [
                    Text(
                      '${S.of(context).quantity}: ${line.quantity}',
                      style: AppTextStyles.noto14w400.copyWith(
                        color: AppColors.grey,
                        fontSize: 12,
                      ),
                    ),
                    if (line.discountPercentage > 0) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.teal.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '-${line.discountPercentage}%',
                          style: AppTextStyles.noto14w400.copyWith(
                            color: AppColors.teal,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ],
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

  void _confirm(
    AddressModel? address, {
    required double total,
    required double delivery,
  }) {
    if (context.read<CartCubit>().cart.isEmpty) return;
    CheckoutPaymentMethod? payment;
    for (final method in _paymentMethods) {
      if (method.code == transferMethod) {
        payment = method;
        break;
      }
    }
    final requiresReceipt = payment?.requiresReceipt == true;
    if (transferMethod.isEmpty) {
      AppSnackBar.warning(S.of(context).paymentTool);
      return;
    }
    if (requiresReceipt && image == null) {
      AppSnackBar.warning(S.of(context).upload_image_here_please);
      return;
    }
    if (phoneController.text.trim().isEmpty) {
      AppSnackBar.warning(S.of(context).pleaseEnterPhoneNumber);
      return;
    }

    final checkoutAddressId = address?.checkoutAddressId;
    if (checkoutAddressId == null) {
      AppSnackBar.error(S.of(context).delivery_address);
      return;
    }

    final redeemPoints = _redeemPoints(isArabic: _isArabic);
    if (redeemPoints == -1) return;
    context.read<CartCubit>().confirmOrder(
      context,
      checkoutAddressId,
      transferMethod,
      context.read<CartCubit>().coupon?.code ?? '',
      notesController.text.trim(),
      image: image,
      expectedTotal: delivery == 0 && redeemPoints == null ? total : null,
      redeemPoints: redeemPoints,
    );
  }

  bool get _isArabic =>
      Localizations.localeOf(context).languageCode == 'ar';

  String? _pointsHelper(bool isAr) {
    final loyalty = _loyalty;
    if (loyalty == null) return null;
    final parts = <String>[
      if (loyalty.balance > 0)
        isAr
            ? 'المتاح ${loyalty.balance} نقطة'
            : '${loyalty.balance} points available',
      if (loyalty.minRedeemPoints > 0)
        isAr
            ? 'الحد الأدنى ${loyalty.minRedeemPoints}'
            : 'Minimum ${loyalty.minRedeemPoints}',
      if (loyalty.rules.trim().isNotEmpty) loyalty.rules.trim(),
    ];
    if (parts.isEmpty) return null;
    return parts.join(' · ');
  }

  int? _redeemPoints({required bool isArabic}) {
    final raw = pointsController.text.trim();
    if (raw.isEmpty || _loyalty?.redeemEnabled == false) return null;
    final points = int.tryParse(raw);
    if (points == null || points <= 0) {
      AppSnackBar.warning(
        isArabic ? 'أدخل عدد نقاط صحيح' : 'Enter a valid points amount',
      );
      return -1;
    }
    final loyalty = _loyalty;
    if (loyalty != null && loyalty.balance > 0 && points > loyalty.balance) {
      AppSnackBar.error(
        isArabic
            ? 'النقاط الصالحة غير كافية: المطلوب $points والمتاح ${loyalty.balance}.'
            : 'Not enough points: $points required, ${loyalty.balance} available.',
      );
      return -1;
    }
    if (loyalty != null &&
        loyalty.minRedeemPoints > 0 &&
        points < loyalty.minRedeemPoints) {
      AppSnackBar.error(
        isArabic
            ? 'الحد الأدنى لاستبدال النقاط هو ${loyalty.minRedeemPoints}.'
            : 'The minimum points to redeem is ${loyalty.minRedeemPoints}.',
      );
      return -1;
    }
    if (loyalty != null &&
        loyalty.maxRedeemPoints > 0 &&
        points > loyalty.maxRedeemPoints) {
      AppSnackBar.error(
        isArabic
            ? 'الحد الأقصى لاستبدال النقاط هو ${loyalty.maxRedeemPoints}.'
            : 'The maximum points to redeem is ${loyalty.maxRedeemPoints}.',
      );
      return -1;
    }
    return points;
  }
}
