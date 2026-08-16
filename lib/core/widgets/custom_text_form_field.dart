import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final String hintText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final bool? readOnly;
  final bool isPassword;
  final TextStyle? hintStyle;
  final bool? makeTextCenter;

  const CustomTextFormField({
    super.key,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.readOnly = false,
    this.isPassword = false,
    this.hintStyle,
    this.makeTextCenter,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late FocusNode _focusNode;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {});
    });

    if (!widget.isPassword) {
      _obscureText = false;
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isFocused = _focusNode.hasFocus;

    return TextFormField(
      focusNode: _focusNode,
      maxLines: widget.isPassword ? 1 : widget.maxLines,
      controller: widget.controller,
      readOnly: widget.readOnly ?? false,
      obscureText: _obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: widget.hintText,
        hintStyle:
            widget.hintStyle ??
            AppTextStyles.noto14w400.copyWith(
              color: Colors.black.withOpacity(0.3),
            ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: isFocused ? AppColors.primaryColor : AppColors.greyBorder,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.red.shade800, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.red.shade800, width: 1.5),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        prefixIcon: widget.prefixIcon,
        suffixIcon:
            widget.isPassword
                ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
                : widget.suffixIcon,
      ),
      keyboardType:
          widget.isPassword
              ? TextInputType.visiblePassword
              : widget.keyboardType,
      validator: widget.validator,
      textAlign:
          (widget.makeTextCenter == true) ? TextAlign.center : TextAlign.start,

      onFieldSubmitted: (value) {
        FocusScope.of(context).unfocus();
      },
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
      onTapUpOutside: (event) {
        FocusScope.of(context).unfocus();
      },
    );
  }
}
