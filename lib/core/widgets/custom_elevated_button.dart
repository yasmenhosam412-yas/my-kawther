import 'package:bounce/bounce.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:elkawther/core/theme/app_colors.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.buttonOnly = false,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.height,
    this.fontSize,
  });

  final void Function()? onPressed;
  final String title;
  final bool buttonOnly;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double? height;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    final button = Bounce(
      duration: const Duration(milliseconds: 150),
      onTap: onPressed,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(backgroundColor),
          elevation: WidgetStateProperty.all(0),
          side: WidgetStateProperty.all(
            borderColor != null
                ? BorderSide(color: borderColor!)
                : BorderSide.none,
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        child: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.ibmPlexSans16w500.copyWith(
            fontSize: fontSize ?? 20,
            color: textColor ?? Colors.white,
          ),
        ),
      ),
    );

    return buttonOnly
        ? button
        : SizedBox(width: double.infinity, height: height ?? 50, child: button);
  }
}

class CustomElevatedButtonWithIcon extends StatelessWidget {
  const CustomElevatedButtonWithIcon({
    super.key,
    required this.onPressed,
    required this.title,
    this.buttonOnly = false,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.height,
    this.fontSize,
    this.icon,
  });

  final void Function()? onPressed;
  final String title;
  final bool buttonOnly;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double? height;
  final double? fontSize;
  final String? icon;

  @override
  Widget build(BuildContext context) {
    final button = Bounce(
      duration: const Duration(milliseconds: 150),
      onTap: onPressed,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.white),

          elevation: WidgetStateProperty.all(0),
          side: WidgetStateProperty.all(
            const BorderSide(color: AppColors.primaryColor),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        label: Text(
          "   $title   ",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.ibmPlexSans16w500.copyWith(
            fontSize: 20,
            color: AppColors.primaryColor,
          ),
        ),
        icon: SvgPicture.asset(icon!),
      ),
    );

    return buttonOnly
        ? button
        : SizedBox(width: double.infinity, height: height ?? 50, child: button);
  }
}
