import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/core/widgets/image_upload_box.dart';
import 'package:elkawther/features/checkout/models/checkout_payment_method.dart';
import 'package:elkawther/features/profile/widgets/profile_scaffold.dart';

class PaymentMethodWidget extends StatefulWidget {
  final Function(File)? onImagePicked;
  final Function(String)? onPaymentSelected;
  final List<CheckoutPaymentMethod> methods;
  final bool loading;

  const PaymentMethodWidget({
    super.key,
    this.onImagePicked,
    this.onPaymentSelected,
    this.methods = const [],
    this.loading = false,
  });

  @override
  State<PaymentMethodWidget> createState() => PaymentMethodWidgetState();
}

class PaymentMethodWidgetState extends State<PaymentMethodWidget> {
  String _selectedPayment = '';
  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    _syncSelection(widget.methods);
  }

  @override
  void didUpdateWidget(PaymentMethodWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.methods != widget.methods) {
      _syncSelection(widget.methods);
    }
  }

  void _syncSelection(List<CheckoutPaymentMethod> methods) {
    if (methods.isEmpty) return;
    final exists = methods.any((method) => method.code == _selectedPayment);
    if (exists) return;
    final code = methods.first.code;
    _selectedPayment = code;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onPaymentSelected?.call(code);
    });
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
    CheckoutPaymentMethod? selected;
    for (final method in widget.methods) {
      if (method.code == _selectedPayment) {
        selected = method;
        break;
      }
    }
    return ProfileFormCard(
      child: widget.loading
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              ),
            )
          : widget.methods.isEmpty
          ? Text(
              Localizations.localeOf(context).languageCode == 'ar'
                  ? 'لا توجد طرق دفع متاحة'
                  : 'No payment methods available',
              style: AppTextStyles.noto14w400.copyWith(color: AppColors.grey),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...widget.methods.map(
                  (method) => _paymentOption(
                    value: method.code,
                    label: method.name,
                    icon: method.icon,
                    selected: selected?.code == method.code,
                    onTap: () => _select(method.code),
                  ),
                ),
                if (selected != null && selected.requiresReceipt) ...[
                  const SizedBox(height: 14),
                  if (selected.accountName != null)
                    Text(
                      selected.accountName!,
                      style: AppTextStyles.noto14w400.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.darkColor,
                      ),
                    ),
                  if (selected.accountNumber != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      selected.accountNumber!,
                      style: AppTextStyles.noto14w400.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                  if (selected.instructions != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      selected.instructions!,
                      style: AppTextStyles.noto14w400.copyWith(
                        color: AppColors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
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
