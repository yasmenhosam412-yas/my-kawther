import 'package:elkawther/core/theme/app_padding.dart';
import 'package:flutter/material.dart';

class OtpDialog extends StatefulWidget {
  const OtpDialog({super.key, required this.title});

  final String title;

  @override
  State<OtpDialog> createState() => _OtpDialogState();
}

class _OtpDialogState extends State<OtpDialog> {
  @override
  void initState() {
    super.initState();

    // Auto-close after 1 second
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
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
                    'assets/images/success.png',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
