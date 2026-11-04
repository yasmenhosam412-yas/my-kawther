import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/features/profile/widgets/confirm_logout_bottom_sheet.dart';
import 'package:elkawther/features/profile/cubit/profile_cubit.dart';
import 'package:elkawther/features/auth/cubit/auth_cubit.dart';
import 'package:elkawther/features/profile/widgets/profile_header_section.dart';
import 'package:elkawther/features/profile/widgets/profile_list_tile.dart';
import 'package:elkawther/features/profile/widgets/radio_button_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elkawther/core/providers/locale_provider.dart';
import 'package:elkawther/core/toasts/toasts.dart';
import 'package:elkawther/generated/assets.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/core/routes/routes.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<ProfileCubit>().getUserData();
    });
  }

  Future<void> _open(String route, {Object? arguments}) async {
    await Navigator.pushNamed(context, route, arguments: arguments);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: const Color(0xFFF5FAFD),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primaryColor.withOpacity(0.16),
                  AppColors.light,
                  const Color(0xFFF5FAFD),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).profile,
                  style: AppTextStyles.noto16w400.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isAr
                      ? 'حسابك وإعدادات التطبيق'
                      : 'Your account and app settings',
                  style: AppTextStyles.noto14w400.copyWith(
                    color: AppColors.grey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
              children: [
                const ProfileHeaderSection(),
                const SizedBox(height: 20),
                Text(
                  S.of(context).my_account,
                  style: AppTextStyles.noto16w400.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkColor,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 10),
                ProfileListTile(
                  icon: Assets.iconsProfile2,
                  title: S.of(context).edit_profile,
                  onTap: () => _open(Routes.editPersonalInfo),
                ),
                ProfileListTile(
                  icon: Assets.iconsMap2,
                  title: S.of(context).my_addresses,
                  onTap: () => _open(Routes.addresses),
                ),
                ProfileListTile(
                  icon: Assets.iconsFavourite2,
                  title: S.of(context).favourite,
                  onTap: () => _open(Routes.favourite),
                ),
                const SizedBox(height: 8),
                Text(
                  S.of(context).specializations,
                  style: AppTextStyles.noto16w400.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkColor,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 10),
                ProfileListTile(
                  icon: Assets.iconsLang2,
                  title: S.of(context).language,
                  trailing: Text(
                    Localizations.localeOf(context).languageCode == 'ar'
                        ? S.of(context).arabic
                        : S.of(context).english,
                    style: AppTextStyles.noto14w400.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  onTap: () {
                    final currentLocaleCode =
                        Localizations.localeOf(context).languageCode;
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder:
                          (_) => RadioButtonsBottomSheet(
                            valuesList: [
                              S.of(context).arabic,
                              S.of(context).english,
                            ],
                            selectedValue:
                                currentLocaleCode == 'ar'
                                    ? S.of(context).arabic
                                    : S.of(context).english,
                            label: S.of(context).language,
                            onChanged: (value) async {
                              final newLocale =
                                  value == S.of(context).arabic
                                      ? const Locale('ar')
                                      : const Locale('en');
                              await context.read<LocaleProvider>().setLocale(
                                newLocale.languageCode,
                              );
                              if (!context.mounted) return;
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                Routes.home,
                                (route) => false,
                              );
                            },
                          ),
                    );
                  },
                ),
                ProfileListTile(
                  icon: Assets.iconsContact2,
                  title: S.of(context).contactUs,
                  onTap: () => _open(Routes.contactUs),
                ),
                ProfileListTile(
                  icon: Assets.iconsTerms2,
                  title: S.of(context).terms_and_conditions,
                  onTap:
                      () => Navigator.pushNamed(
                        context,
                        Routes.termsAndConditions,
                      ),
                ),
                ProfileListTile(
                  icon: Assets.iconsPolicy2,
                  title: S.of(context).privacy_policy,
                  onTap:
                      () =>
                          Navigator.pushNamed(context, Routes.privacyAndPolicy),
                ),
                const SizedBox(height: 8),
                ProfileListTile(
                  icon: Assets.iconsLogout,
                  title: S.of(context).logout,
                  iconColor: const Color(0xFFEF4444),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder:
                          (_) => ConfirmLogoutBottomSheet(
                            label: S.of(context).exit_app,
                            onConfirm: () async {
                              await context.read<AuthCubit>().logout();
                              if (!context.mounted) return;
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                Routes.chooseUserType,
                                (route) => false,
                              );
                            },
                            onCancel: () => Navigator.pop(context),
                          ),
                    );
                  },
                ),
                ProfileListTile(
                  icon: Assets.iconsDelete,
                  title: S.of(context).delete_account,
                  iconColor: const Color(0xFFEF4444),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder:
                          (_) => ConfirmLogoutBottomSheet(
                            label: S.of(context).delete_account,
                            confirmColor: const Color(0xFFEF4444),
                            onConfirm: () async {
                              await context.read<AuthCubit>().logout();
                              if (!context.mounted) return;
                              ToastMessage().displayMessageToast(
                                isAr
                                    ? 'تم حذف الحساب محلياً'
                                    : 'Account deleted locally',
                                AppColors.teal,
                              );
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                Routes.login,
                                (route) => false,
                              );
                            },
                            onCancel: () => Navigator.pop(context),
                          ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
