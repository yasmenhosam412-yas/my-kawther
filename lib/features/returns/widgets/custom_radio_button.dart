import 'package:flutter/material.dart';

class CustomRadioButtons extends StatefulWidget {
  const CustomRadioButtons({
    super.key,
    required this.valuesList,
    this.onChanged,
  });

  final List<String> valuesList;
  final ValueChanged<String>? onChanged;

  @override
  State<CustomRadioButtons> createState() => _CustomRadioButtonsState();
}

class _CustomRadioButtonsState extends State<CustomRadioButtons> {
  String _selectedValue = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        widget.valuesList.length,
        (index) => ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Radio<String>(
            value: widget.valuesList[index],
            groupValue: _selectedValue,
            onChanged: (value) {
              setState(() {
                _selectedValue = value!;
              });
              if (widget.onChanged != null) {
                widget.onChanged!(value!);
              }
            },
          ),
          title: Text(
            widget.valuesList[index],
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ),
    );
  }
}
