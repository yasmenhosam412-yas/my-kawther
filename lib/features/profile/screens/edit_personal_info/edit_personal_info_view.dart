import 'package:flutter/material.dart';

import 'package:elkawther/generated/assets.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/features/profile/widgets/profile_list_tile.dart';
import 'package:elkawther/features/profile/widgets/profile_scaffold.dart';

class EditPersonalInfo extends StatelessWidget {
  const EditPersonalInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return ProfileScaffold(
      title: S.of(context).editProfile,
      subtitle: isAr ? 'عدّل بيانات حسابك' : 'Update your account details',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          ProfileListTile(
            icon: Assets.iconsEmail2,
            title: S.of(context).email,
            onTap: () => Navigator.pushNamed(context, Routes.editEmail),
          ),
          ProfileListTile(
            icon: Assets.iconsPhone2,
            title: S.of(context).phone_number,
            onTap: () => Navigator.pushNamed(context, Routes.editPhone),
          ),
          ProfileListTile(
            icon: Assets.iconsPassword2,
            title: S.of(context).password,
            onTap: () => Navigator.pushNamed(context, Routes.editPassword),
          ),
        ],
      ),
    );
  }
}
