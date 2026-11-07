import 'package:flutter/material.dart';

import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/core/widgets/custom_elevated_button.dart';

class LoginFirstView extends StatelessWidget {
  const LoginFirstView({super.key, this.expand = true});

  final bool expand;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: AppColors.light,
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(
                Icons.lock_outline_rounded,
                color: AppColors.primaryColor,
                size: 36,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              S.of(context).loginRequired,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              S.of(context).pleaseLoginToAccessContent,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: AppColors.grey),
            ),
            const SizedBox(height: 20),
            CustomElevatedButton(
              onPressed: () => Navigator.pushNamed(context, Routes.login),
              title: S.of(context).login,
              backgroundColor: AppColors.primaryColor,
            ),
          ],
        ),
      );
    if (!expand) return content;
    return Center(child: content);
  }
}

Future<void> showGuestLoginDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder:
        (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.lock_outline,
                  color: AppColors.primaryColor,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  S.of(context).loginRequired,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                CustomElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, Routes.login);
                  },
                  title: S.of(context).login,
                  backgroundColor: AppColors.primaryColor,
                ),
              ],
            ),
          ),
        ),
  );
}
