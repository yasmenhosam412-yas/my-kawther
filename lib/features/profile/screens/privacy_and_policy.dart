import 'package:elkawther/features/profile/widgets/legal_section.dart';
import 'package:elkawther/features/profile/widgets/profile_scaffold.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return ProfileScaffold(
      title: S.of(context).privacyPolicy,
      subtitle: isAr ? 'كيف نتعامل مع بياناتك' : 'How we handle your data',
      body: RemoteLegalBody(select: (settings) => settings.privacyPolicy),
    );
  }
}
