import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';

import 'package:elkawther/features/profile/widgets/custom_radio_buttons.dart';

class RadioButtonsBottomSheet extends StatelessWidget {
  const RadioButtonsBottomSheet({
    super.key,
    required this.valuesList,
    required this.label,
    required this.onChanged,
    this.selectedValue,
  });

  final List<String> valuesList;
  final String label;
  final ValueChanged<String> onChanged;
  final String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF5FAFD),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.lightDarker,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: AppTextStyles.noto16w400.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.darkColor,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded, color: AppColors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              CustomRadioButtons(
                valuesList: valuesList,
                selectedValue: selectedValue,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
