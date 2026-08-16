import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/features/profile/widgets/profile_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/core/theme/app_padding.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/routes/routes.dart';

class CheckOutSuccessView extends StatelessWidget {
  final int points;
  final String? gift;

  const CheckOutSuccessView({super.key, required this.points, this.gift});

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.home,
          (route) => false,
        );
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5FAFD),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppPadding.large),
            child: Column(
              children: [
                const Spacer(),
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: AppColors.teal.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 46,
                    color: AppColors.teal,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  S.of(context).order_success_message,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.noto16w400.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                    color: AppColors.darkColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${S.of(context).pointsEarned} $points',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.noto14w400.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.teal,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  S.of(context).order_success_message2,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.noto14w400.copyWith(
                    color: AppColors.grey,
                  ),
                ),
                if (gift != null && gift!.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  ProfileFormCard(
                    child: Text(
                      gift!,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.noto14w400.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                ProfilePrimaryButton(
                  title: S.of(context).trackYourOrder,
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                      context,
                      Routes.myOrders,
                      arguments: true,
                    );
                  },
                ),
                const SizedBox(height: 10),
                ProfilePrimaryButton(
                  title: isAr ? S.of(context).continue_shopping : S.of(context).continue_shopping,
                  color: AppColors.grey,
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      Routes.home,
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
