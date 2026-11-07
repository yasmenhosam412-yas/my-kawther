import 'package:elkawther/features/checkout/widgets/payment_method_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/features/profile/data/app_settings.dart';
import 'package:elkawther/core/theme/app_padding.dart';
import 'package:elkawther/core/widgets/image_upload_box.dart';

class PaymentMethodsWidget extends StatefulWidget {
  const PaymentMethodsWidget({super.key});

  @override
  State<PaymentMethodsWidget> createState() => _PaymentMethodsWidgetState();
}

class _PaymentMethodsWidgetState extends State<PaymentMethodsWidget> {
  String selectedMethod = "";

  @override
  Widget build(BuildContext context) {
    final zain = context.watch<AppSettings>().zaincash;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).payment_methods,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.grey,
          ),
        ),
        const SizedBox(height: AppPadding.medium),
        Row(
          children: [
            PaymentMethodButton(
              title: S.of(context).cashOn,
              isSelected: selectedMethod == S.of(context).cashOn,
              onTap: () {
                setState(() {
                  selectedMethod = S.of(context).cashOn;
                });
              },
            ),
            PaymentMethodButton(
              title: S.of(context).zainCach,
              isSelected: selectedMethod == S.of(context).zainCach,
              onTap: () {
                setState(() {
                  selectedMethod = S.of(context).zainCach;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: AppPadding.medium),
        if (selectedMethod == S.of(context).cashOn)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).paymentOptions,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.grey,
                ),
              ),
              const SizedBox(height: AppPadding.medium),
              Container(
                width:
                    double
                        .infinity, // This makes the container take full screen width
                padding: const EdgeInsets.all(AppPadding.small),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[400]!),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  S.of(context).cashOn,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(),
                ),
              ),
            ],
          ),
        if (selectedMethod == S.of(context).zainCach)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).paymentOptions,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.grey,
                ),
              ),
              const SizedBox(height: AppPadding.medium),

              if (zain != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppPadding.small),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[400]!),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${S.of(context).zainCach}: $zain',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(),
                ),
              ),
              const SizedBox(height: AppPadding.medium),
              SizedBox(
                width: double.infinity,
                child: ImageUploadBox(
                  onTap: () {},
                  label: S.of(context).upload_the_conversion_image,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
