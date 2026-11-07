import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/features/profile/widgets/profile_scaffold.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';

class SuccessRefundView extends StatelessWidget {
  const SuccessRefundView({super.key});

  void _home(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _home(context);
      },
      child: ProfileScaffold(
        title: S.of(context).returns,
        showBack: false,
        bottom: ProfilePrimaryButton(
          title: S.of(context).back_to_home,
          onPressed: () => _home(context),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    color: const Color(0xFF059669).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Color(0xFF059669),
                    size: 40,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  S.of(context).request_submitted_successfully,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.noto16w400.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: AppColors.darkColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  S.of(context).we_will_reply_asap,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.noto14w400.copyWith(color: AppColors.grey),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      Routes.returns,
                      (route) => false,
                    );
                  },
                  child: Text(isAr ? 'عرض المرتجعات' : 'View returns'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
