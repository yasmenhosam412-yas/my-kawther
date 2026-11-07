import 'package:elkawther/features/profile/widgets/legal_section.dart';
import 'package:elkawther/features/profile/widgets/profile_scaffold.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return ProfileScaffold(
      title: S.of(context).terms_and_conditions,
      subtitle: isAr ? 'شروط استخدام التطبيق' : 'App terms of use',
      body: RemoteLegalBody(select: (settings) => settings.termsConditions),
    );
  }
}
