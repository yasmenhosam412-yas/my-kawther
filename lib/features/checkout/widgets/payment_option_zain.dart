import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/core/widgets/image_upload_box.dart';
import 'package:elkawther/features/checkout/data/checkout_local_store.dart';
import 'package:elkawther/features/profile/widgets/profile_scaffold.dart';

class PaymentMethodWidget extends StatefulWidget {
  final Function(File)? onImagePicked;
  final Function(String)? onPaymentSelected;
  final TextEditingController? numberController;
  final TextEditingController? creditController;

  const PaymentMethodWidget({
    super.key,
    this.onImagePicked,
    this.onPaymentSelected,
    this.numberController,
    this.creditController,
  });

  @override
  State<PaymentMethodWidget> createState() => PaymentMethodWidgetState();
}

class PaymentMethodWidgetState extends State<PaymentMethodWidget> {
  late String _selectedPayment;
  late TextEditingController number;
  late TextEditingController credit;
  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    number = widget.numberController ??
        TextEditingController(text: CheckoutLocalStore.zainNumber);
    credit = widget.creditController ??
        TextEditingController(text: CheckoutLocalStore.qiCard);
    _selectedPayment = 'cash';
  }

  @override
  void dispose() {
    if (widget.numberController == null) number.dispose();
    if (widget.creditController == null) credit.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        final file = File(pickedFile.path);
        setState(() => _pickedImage = file);
        widget.onImagePicked?.call(file);
      }
    } catch (_) {}
  }

  void _select(String value) {
    setState(() => _selectedPayment = value);
    widget.onPaymentSelected?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final selected = _selectedPayment;
    return ProfileFormCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...[
            (S.of(context).cash, 'cash', Icons.payments_rounded),
            (
              S.of(context).zainCach,
              'zaincash',
              Icons.account_balance_wallet_rounded,
            ),
            (S.of(context).qiCard, 'qicard', Icons.credit_card_rounded),
          ].map(
            (entry) => _paymentOption(
              value: entry.$2,
              label: entry.$1,
              icon: entry.$3,
              selected: selected == entry.$2,
              onTap: () => _select(entry.$2),
            ),
          ),
          if (selected == 'zaincash') ...[
            const SizedBox(height: 14),
            Text(
              '${S.of(context).zainCach}: ${number.text}',
              style: AppTextStyles.noto14w400.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.darkColor,
              ),
            ),
            const SizedBox(height: 10),
            ImageUploadBox(
              label: S.of(context).upload_image_here,
              image: _pickedImage,
              onTap: _pickImage,
              height: 140,
            ),
          ] else if (selected == 'qicard') ...[
            const SizedBox(height: 14),
            Text(
              '${S.of(context).credit_card}: ${credit.text}',
              style: AppTextStyles.noto14w400.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.darkColor,
              ),
            ),
            const SizedBox(height: 10),
            ImageUploadBox(
              label: S.of(context).upload_image_here,
              image: _pickedImage,
              onTap: _pickImage,
              height: 140,
            ),
          ],
        ],
      ),
    );
  }

  Widget _paymentOption({
    required String value,
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            color: selected ? AppColors.light : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? AppColors.primaryColor : AppColors.lightDarker,
              width: selected ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.08),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color:
                      selected
                          ? AppColors.primaryColor.withOpacity(0.12)
                          : AppColors.grey2,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: selected ? AppColors.primaryColor : AppColors.grey,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.noto14w400.copyWith(
                    color: selected ? AppColors.darkColor : AppColors.grey,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ),
              if (selected)
                const Icon(
                  Icons.check_circle_rounded,
                  size: 22,
                  color: AppColors.primaryColor,
                )
              else
                const SizedBox(width: 22),
            ],
          ),
        ),
      ),
    );
  }
}
