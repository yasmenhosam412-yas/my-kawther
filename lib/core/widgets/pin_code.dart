import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_padding.dart';
import 'package:elkawther/core/utils/validators.dart';

class PinCode extends StatelessWidget {
  const PinCode({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      controller: controller,
      length: 4,
      validator: (value) => Validators.validatePin(context, value),
      obscureText: false,
      animationType: AnimationType.fade,
      animationDuration: const Duration(milliseconds: 300),
      errorTextDirection: TextDirection.rtl,
      mainAxisAlignment: MainAxisAlignment.center,
      separatorBuilder:
          (context, index) => const SizedBox(width: AppPadding.medium),
      enableActiveFill: true,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(16),
        fieldHeight: 60,
        fieldWidth: 56,
        activeColor: AppColors.primaryColor,
        selectedColor: AppColors.primaryColor,
        inactiveColor: AppColors.greyCarsoul,
        activeFillColor: Colors.white,
        selectedFillColor: AppColors.light,
        inactiveFillColor: Colors.white,
      ),
    );
  }
}
