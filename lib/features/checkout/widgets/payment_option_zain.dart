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
    return ProfileFormCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _chip(S.of(context).cash, 'cash'),
              _chip(S.of(context).zainCach, 'zaincash'),
              _chip(S.of(context).qiCard, 'qicard'),
            ],
          ),
          if (_selectedPayment == 'zaincash') ...[
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
          ] else if (_selectedPayment == 'qicard') ...[
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

  Widget _chip(String label, String value) {
    final selected = _selectedPayment == value;
    return ChoiceChip(
      label: Text(
        label,
        style: AppTextStyles.noto14w400.copyWith(
          color: selected ? Colors.white : AppColors.grey,
          fontWeight: FontWeight.w700,
        ),
      ),
      showCheckmark: false,
      selected: selected,
      selectedColor: AppColors.primaryColor,
      backgroundColor: const Color(0xFFF5FAFD),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (_) => _select(value),
    );
  }
}
