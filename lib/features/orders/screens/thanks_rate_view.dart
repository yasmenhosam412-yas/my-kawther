import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/features/profile/widgets/profile_scaffold.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';

class ThanksRateView extends StatelessWidget {
  const ThanksRateView({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileScaffold(
      showBack: false,
      title: S.of(context).thank_you_for_your_rating,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
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
                Icons.star_rounded,
                size: 46,
                color: AppColors.teal,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              S.of(context).thank_you_for_your_rating,
              textAlign: TextAlign.center,
              style: AppTextStyles.noto16w400.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 22,
                color: AppColors.darkColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              S.of(context).your_opinion_matters,
              textAlign: TextAlign.center,
              style: AppTextStyles.noto14w400.copyWith(color: AppColors.grey),
            ),
            const Spacer(),
            ProfilePrimaryButton(
              title: S.of(context).back_to_home,
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.home,
                  (route) => false,
                );
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
