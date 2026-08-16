import 'package:flutter/material.dart';

import 'package:elkawther/generated/assets.dart';
import 'package:elkawther/core/theme/app_padding.dart';

class AutoDisappearingDialog extends StatefulWidget {
  const AutoDisappearingDialog({super.key, required this.title});
  final String title;

  @override
  State<AutoDisappearingDialog> createState() => _AutoDisappearingDialogState();
}

class _AutoDisappearingDialogState extends State<AutoDisappearingDialog> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(AppPadding.small),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppPadding.large),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Image.asset(
                    Assets.imagesSuccess,
                    width: 100,
                    height: 100,
                  ),
                ),
                const SizedBox(height: AppPadding.medium),
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppPadding.medium),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
