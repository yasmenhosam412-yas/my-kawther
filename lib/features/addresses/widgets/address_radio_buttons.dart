import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';

class AddressRadioButtons extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String? initialValue;

  const AddressRadioButtons({
    super.key,
    required this.onChanged,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    final selected = initialValue ?? 'home';
    return Row(
      children: [
        Expanded(
          child: _TypeChip(
            label: S.of(context).homeAddress,
            selected: selected == 'home',
            onTap: () => onChanged('home'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _TypeChip(
            label: S.of(context).workAddress,
            selected: selected == 'work',
            onTap: () => onChanged('work'),
          ),
        ),
      ],
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          height: 44,
          decoration: BoxDecoration(
            color: selected ? AppColors.primaryColor : const Color(0xFFF5FAFD),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected
                  ? AppColors.primaryColor
                  : AppColors.primaryColor.withOpacity(0.12),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTextStyles.noto14w400.copyWith(
                color: selected ? Colors.white : AppColors.darkColor,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
