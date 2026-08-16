import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/features/profile/widgets/profile_scaffold.dart';
import 'package:flutter/material.dart';

import 'package:elkawther/generated/l10n.dart';

class ConfirmLogoutBottomSheet extends StatelessWidget {
  const ConfirmLogoutBottomSheet({
    super.key,
    required this.label,
    required this.onConfirm,
    required this.onCancel,
    this.confirmColor,
  });

  final String label;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final Color? confirmColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF5FAFD),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: SafeArea(
        top: false,
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
            const SizedBox(height: 18),
            Text(
              label,
              style: AppTextStyles.noto16w400.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.darkColor,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            ProfilePrimaryButton(
              title: S.of(context).yes,
              color: confirmColor ?? const Color(0xFFEF4444),
              onPressed: onConfirm,
            ),
            const SizedBox(height: 8),
            ProfilePrimaryButton(
              title: S.of(context).no,
              color: AppColors.grey,
              onPressed: onCancel,
            ),
          ],
        ),
      ),
    );
  }
}
