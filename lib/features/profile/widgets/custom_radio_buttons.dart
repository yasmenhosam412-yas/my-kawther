import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';

class CustomRadioButtons extends StatefulWidget {
  const CustomRadioButtons({
    super.key,
    required this.valuesList,
    required this.onChanged,
    this.selectedValue,
  });

  final List<String> valuesList;
  final ValueChanged<String> onChanged;
  final String? selectedValue;

  @override
  State<CustomRadioButtons> createState() => _CustomRadioButtonsState();
}

class _CustomRadioButtonsState extends State<CustomRadioButtons> {
  late String _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.selectedValue ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.valuesList.map((value) {
        final selected = value == _selectedValue;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                setState(() => _selectedValue = value);
                widget.onChanged(value);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: selected
                        ? AppColors.primaryColor
                        : AppColors.primaryColor.withOpacity(0.08),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      selected
                          ? Icons.radio_button_checked_rounded
                          : Icons.radio_button_off_rounded,
                      color: selected ? AppColors.primaryColor : AppColors.grey,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      value,
                      style: AppTextStyles.noto14w400.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
