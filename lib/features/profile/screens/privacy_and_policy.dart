import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/features/profile/data/profile_local_store.dart';
import 'package:flutter/material.dart';

import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/features/profile/widgets/profile_scaffold.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return ProfileScaffold(
      title: S.of(context).privacyPolicy,
      subtitle: isAr ? 'كيف نتعامل مع بياناتك' : 'How we handle your data',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          ProfileFormCard(
            child: Text(
              ProfileLocalStore.instance.privacy(isAr),
              style: AppTextStyles.noto14w400.copyWith(
                color: AppColors.darkColor,
                height: 1.6,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
