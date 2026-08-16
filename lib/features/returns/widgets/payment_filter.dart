import 'package:elkawther/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_padding.dart';
import 'package:elkawther/generated/l10n.dart';

class PaymentFilterChips extends StatefulWidget {
  final List<String> labels;
  final Function(String val) selectedMethod;
  final int? initialIndex;

  const PaymentFilterChips({
    super.key,
    required this.labels,
    required this.selectedMethod,
    this.initialIndex,
  });

  @override
  State<PaymentFilterChips> createState() => PaymentFilterChipsState();
}

class PaymentFilterChipsState extends State<PaymentFilterChips> {
  final TextEditingController transferNumberController =
      TextEditingController();
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex ?? 0;

    transferNumberController.addListener(() {
      if (widget.labels[selectedIndex] == S.of(context).zainCach) {
        widget.selectedMethod(
          "${S.of(context).zainCach} ${transferNumberController.text}",
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppPadding.small,
          runSpacing: AppPadding.small,
          children: List.generate(widget.labels.length, (index) {
            final isSelected = index == selectedIndex;
            return FittedBox(
              child: FilterChip(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppPadding.small),
                ),
                label: Text(
                  widget.labels[index],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : Colors.grey[700],
                  ),
                ),
                selected: isSelected,
                selectedColor: AppColors.primaryColor,
                backgroundColor: Colors.grey[300],
                onSelected: (_) {
                  setState(() {
                    selectedIndex = index;
                  });

                  if (widget.labels[index] == S.of(context).zainCach) {
                    widget.selectedMethod(transferNumberController.text);
                  } else {
                    widget.selectedMethod(widget.labels[index]);
                  }
                },
              ),
            );
          }),
        ),
        const SizedBox(height: AppPadding.small),
        if (widget.labels[selectedIndex] == S.of(context).zainCach)
          CustomTextField(
            controller: transferNumberController,
            hintText: S.of(context).numberTransfer,
            board: TextInputType.number,
          ),
      ],
    );
  }

  @override
  void dispose() {
    transferNumberController.dispose();
    super.dispose();
  }
}
