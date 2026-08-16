import 'dart:io';

import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/features/checkout/data/checkout_local_store.dart';
import 'package:elkawther/features/checkout/widgets/address.dart';
import 'package:elkawther/features/checkout/widgets/payment_option_zain.dart';
import 'package:elkawther/features/home/data/home_cart_store.dart';
import 'package:elkawther/features/home/data/home_demo_data.dart';
import 'package:elkawther/features/orders/data/orders_local_store.dart';
import 'package:elkawther/features/profile/widgets/profile_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

import 'package:elkawther/core/toasts/toasts.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_padding.dart';
import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/features/profile/models/profile_models.dart';
import 'package:elkawther/features/addresses/widgets/build_address_bottom_sheet.dart';
import 'package:elkawther/core/widgets/pharmacy_placeholder.dart';

class CheckOutView extends StatefulWidget {
  const CheckOutView({super.key});

  @override
  State<CheckOutView> createState() => _CheckOutViewState();
}

class _CheckOutViewState extends State<CheckOutView> {
  final _store = CheckoutLocalStore.instance;
  final _cart = HomeCartStore.instance;
  final notesController = TextEditingController();
  final promoCodeController = TextEditingController();
  final numberController = TextEditingController(text: CheckoutLocalStore.zainNumber);
  final creditController = TextEditingController(text: CheckoutLocalStore.qiCard);
  late final TextEditingController phoneController;
  File? image;
  String transferMethod = 'cash';
  bool promoApplied = false;

  @override
  void initState() {
    super.initState();
    phoneController = TextEditingController(text: '01012345678');
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

  List<HomeCartLine> get _lines {
    if (_cart.lines.isNotEmpty) return _cart.lines;
    return HomeDemoData.bestSelling
        .take(2)
        .map((product) => HomeCartLine(product: product))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final items = _lines;
    final address = _store.current;
    final format = NumberFormat('#,##0');
    final subtotal = items.fold<double>(0, (sum, line) => sum + line.lineTotal);
    final delivery = _store.deliveryFeeFor(address);
    final discount = promoApplied ? subtotal * CheckoutLocalStore.promoPercent : 0.0;
    final total = subtotal - discount + delivery;

    return ProfileScaffold(
      title: S.of(context).checkout,
      subtitle: isAr ? 'راجع العنوان والدفع قبل التأكيد' : 'Review address and payment',
      bottom: ProfilePrimaryButton(
        title: S.of(context).confirmOrder,
        onPressed: () => _confirm(address),
      ),
      body: ListView(
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
                    onAddressSelected: (_) => setState(() {}),
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
          AddressWidget(
            addressName: address.address ?? '',
            addressDetails: address.city ?? '',
            location: address.landmark ?? '',
            isPharm: address.isPharmacy ?? false,
            apartment: address.apartment ?? '',
            type: address.type ?? 'home',
            phoneNumber: phoneController.text,
            phoneController: phoneController,
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
            onPaymentSelected: (method) => setState(() => transferMethod = method),
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
                _priceRow(S.of(context).subtotal, format.format(subtotal)),
                const SizedBox(height: 8),
                _priceRow(S.of(context).deliveryFee, format.format(delivery)),
                const SizedBox(height: 8),
                _priceRow(S.of(context).discount, format.format(discount)),
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
                borderSide: const BorderSide(color: AppColors.primaryColor),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
          const SizedBox(height: AppPadding.medium),
        ],
      ),
    );
  }

  Widget _itemCard(HomeCartLine line) {
    final product = line.product;
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
            child: CachedNetworkImage(
              imageUrl: product.imageUrl,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => const PharmacyPlaceholder(size: 32),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name(context),
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
              readOnly: promoApplied,
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
                if (promoApplied) {
                  setState(() {
                    promoApplied = false;
                    promoCodeController.clear();
                  });
                  return;
                }
                if (code == CheckoutLocalStore.promoCode) {
                  setState(() => promoApplied = true);
                  ToastMessage().displayMessageToast(
                    S.of(context).approved,
                    AppColors.teal,
                  );
                } else {
                  ToastMessage().displayMessageToast(
                    S.of(context).promoCodeExpired,
                    Colors.red,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    promoApplied ? const Color(0xFFEF4444) : AppColors.primaryColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                promoApplied ? S.of(context).remove : S.of(context).confirm,
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

  void _confirm(AddressModel address) {
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

    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final lines = _lines;
    final subtotal = lines.fold<double>(0, (sum, line) => sum + line.lineTotal);
    final delivery = _store.deliveryFeeFor(address);
    final discount = promoApplied ? subtotal * CheckoutLocalStore.promoPercent : 0.0;
    final total = subtotal - discount + delivery;
    final gift = isAr
        ? 'هدية مع طلبك: فيتامين C'
        : 'Gift with your order: Vitamin C';
    OrdersLocalStore.instance.addFromCheckout(
      items: [
        for (final line in lines)
          for (var i = 0; i < line.quantity; i++) line.product,
      ],
      address: address,
      paymentMethod: transferMethod,
      total: total.toStringAsFixed(0),
      deliveryFee: delivery.toStringAsFixed(0),
      gift: gift,
    );
    _cart.clear();
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.checkoutSuccess,
      (route) => false,
      arguments: {
        'points': 80,
        'gift': Localizations.localeOf(context).languageCode == 'ar'
            ? 'هدية مع طلبك: فيتامين C'
            : 'Gift with your order: Vitamin C',
      },
    );
  }
}
