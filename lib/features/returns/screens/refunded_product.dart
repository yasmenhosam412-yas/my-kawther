import 'dart:io';
import 'package:elkawther/core/toasts/toasts.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/features/orders/models/order_details_model.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_padding.dart';
import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/core/widgets/image_upload_box.dart';
import 'package:elkawther/features/orders/widgets/order_product_item.dart';
import 'package:elkawther/features/orders/widgets/uploaded_image_item.dart';
import 'package:elkawther/features/profile/widgets/custom_radio_buttons.dart';
import 'package:elkawther/core/widgets/custom_elevated_button.dart';

class ReturnProduct extends StatefulWidget {
  final OrderDetailsModel order;

  const ReturnProduct({super.key, required this.order});

  @override
  State<ReturnProduct> createState() => _ReturnProductState();
}

class _ReturnProductState extends State<ReturnProduct> {
  late TextEditingController _textEditingController;
  final List<File> _images = [];

  late final List<OrderProduct> products;
  String selectedReson = "";

  @override
  void initState() {
    _textEditingController = TextEditingController();
    products = widget.order.products;
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final List<XFile> picked = await picker.pickMultiImage();
    if (picked.isNotEmpty) {
      setState(() {
        _images.addAll(picked.map((e) => File(e.path)));
      });
    }
  }

  void _removeImage(File file) {
    setState(() {
      _images.remove(file);
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).return_product,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(AppPadding.medium),
            sliver: SliverList.list(
              children: [
                Text(
                  S.of(context).product_details,
                  style: AppTextStyles.ibmPlexSans16w500.copyWith(
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: AppPadding.medium),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${S.of(context).order_id}:",
                      style: AppTextStyles.ibmPlexSans16w500.copyWith(
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "${widget.order.orderId}",
                      style: AppTextStyles.ibmPlexSans16w500.copyWith(
                        color: AppColors.darkColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppPadding.medium),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.of(context).return_order_date,
                      style: AppTextStyles.ibmPlexSans16w500.copyWith(
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      widget.order.lastUpdate,
                      style: AppTextStyles.ibmPlexSans16w500.copyWith(
                        color: AppColors.darkColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppPadding.medium),
                const Divider(),

                //const SizedBox(height: AppPadding.medium),
                // Text(
                //   "${products.length} ${S.of(context).items}",
                //   style: Theme.of(context)
                //       .textTheme
                //       .bodyLarge
                //       ?.copyWith(fontWeight: FontWeight.bold),
                //
                // ),
              ],
            ),
          ),
          // عرض قائمة المنتجات باستخدام SliverList.separated
          SliverList.separated(
            itemBuilder:
                (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppPadding.medium,
                  ),
                  child: OrderProductItem(product: products[index]),
                ),
            itemCount: products.length,
            separatorBuilder:
                (context, index) => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppPadding.medium),
                  child: Divider(),
                ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(AppPadding.medium),
            sliver: SliverList.list(
              children: [
                const Divider(),
                const SizedBox(height: AppPadding.small),
                Text(
                  S.of(context).return_reason,
                  style: AppTextStyles.ibmPlexSans16w500.copyWith(
                    fontSize: 18,
                    color: AppColors.darkColor,
                  ),
                ),
                const SizedBox(height: AppPadding.medium),
                CustomRadioButtons(
                  valuesList: [
                    S.of(context).product_borken,
                    S.of(context).product_not_as_described,
                    S.of(context).unsatisfied_with_quality,
                    S.of(context).product_not_suitable,
                    S.of(context).received_wrong_product,
                    S.of(context).change_of_mind,
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedReson = value;
                    });
                  },
                ),
                const SizedBox(height: AppPadding.medium),
                SizedBox(
                  height: 150,
                  child: TextFormField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      hintText: S.of(context).write_your_comment_here,
                      hintStyle: AppTextStyles.ibmPlexSans16w500.copyWith(
                        color: Colors.grey,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    maxLines: 10,
                  ),
                ),
                const SizedBox(height: AppPadding.medium),
                _images.isEmpty
                    ? ImageUploadBox(
                      onTap: _pickImage,
                      width: width - 32,
                      height: 120,
                      label: S.of(context).upload_photos_here,
                    )
                    : Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        ..._images.map(
                          (img) => SizedBox(
                            width: 100,
                            height: 100,
                            child: UploadedImageItem(
                              file: img,
                              onRemove: () => _removeImage(img),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: ImageUploadBox(
                            onTap: _pickImage,
                            label: S.of(context).upload,
                            width: 100,
                            height: 100,
                          ),
                        ),
                      ],
                    ),
                const SizedBox(height: AppPadding.medium),
                CustomElevatedButton(
                  onPressed: () {
                    if (selectedReson.isEmpty &&
                        _textEditingController.text.isEmpty) {
                      ToastMessage().displayMessageToast(
                        S.of(context).please_select_reason,
                        AppColors.gray,
                      );
                      return;
                    }

                    Navigator.pushNamed(
                      context,
                      Routes.returnProductSecondStep,
                      arguments: {
                        "details": widget.order,
                        "images": _images,
                        "reason": selectedReson,
                        "notes": _textEditingController.text,
                      },
                    );
                  },
                  backgroundColor: AppColors.primaryColor,
                  title: S.of(context).next,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
