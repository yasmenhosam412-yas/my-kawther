import 'dart:io';

import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/widgets/app_snack_bar.dart';
import 'package:elkawther/core/widgets/image_upload_box.dart';
import 'package:elkawther/features/orders/models/order_details_model.dart';
import 'package:elkawther/features/orders/widgets/uploaded_image_item.dart';
import 'package:elkawther/features/profile/widgets/custom_radio_buttons.dart';
import 'package:elkawther/features/profile/widgets/profile_scaffold.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ReturnProduct extends StatefulWidget {
  const ReturnProduct({super.key, required this.order});

  final OrderDetailsModel order;

  @override
  State<ReturnProduct> createState() => _ReturnProductState();
}

class _ReturnProductState extends State<ReturnProduct> {
  final _noteController = TextEditingController();
  final List<File> _images = [];
  String _reason = '';

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickMultiImage();
    if (picked.isEmpty) return;
    setState(() => _images.addAll(picked.map((file) => File(file.path))));
  }

  void _next() {
    if (_reason.isEmpty) {
      AppSnackBar.warning(S.of(context).please_select_reason);
      return;
    }
    Navigator.pushNamed(
      context,
      Routes.returnProductSecondStep,
      arguments: {
        'details': widget.order,
        'images': _images,
        'reason': _reason,
        'notes': _noteController.text.trim(),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final reasons = [
      S.of(context).product_borken,
      S.of(context).product_not_as_described,
      S.of(context).unsatisfied_with_quality,
      S.of(context).product_not_suitable,
      S.of(context).received_wrong_product,
      S.of(context).change_of_mind,
    ];

    return ProfileScaffold(
      title: S.of(context).return_product,
      subtitle: '#${widget.order.orderId}',
      bottom: ProfilePrimaryButton(title: S.of(context).next, onPressed: _next),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          ProfileFormCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${S.of(context).refund_amount}: ${widget.order.totalPrice}',
                  style: AppTextStyles.noto16w400.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${widget.order.products.length} ${isAr ? 'منتجات' : 'items'}',
                  style: AppTextStyles.noto14w400.copyWith(color: AppColors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            S.of(context).return_reason,
            style: AppTextStyles.noto16w400.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.darkColor,
            ),
          ),
          const SizedBox(height: 10),
          CustomRadioButtons(
            valuesList: reasons,
            selectedValue: _reason,
            onChanged: (value) => setState(() => _reason = value),
          ),
          const SizedBox(height: 8),
          Text(
            S.of(context).note,
            style: AppTextStyles.noto16w400.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.darkColor,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _noteController,
            minLines: 4,
            maxLines: 6,
            decoration: InputDecoration(
              hintText: S.of(context).write_your_comment_here,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            S.of(context).pictures,
            style: AppTextStyles.noto16w400.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.darkColor,
            ),
          ),
          const SizedBox(height: 10),
          if (_images.isEmpty)
            ImageUploadBox(
              onTap: _pickImage,
              height: 120,
              label: S.of(context).upload_photos_here,
            )
          else
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ..._images.map(
                  (image) => SizedBox(
                    width: 96,
                    height: 96,
                    child: UploadedImageItem(
                      file: image,
                      onRemove: () => setState(() => _images.remove(image)),
                    ),
                  ),
                ),
                SizedBox(
                  width: 96,
                  height: 96,
                  child: ImageUploadBox(
                    onTap: _pickImage,
                    width: 96,
                    height: 96,
                    label: S.of(context).upload,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
