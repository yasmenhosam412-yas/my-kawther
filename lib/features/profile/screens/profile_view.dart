import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/widgets/guest_user_dialog.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/features/profile/widgets/confirm_logout_bottom_sheet.dart';
import 'package:elkawther/features/profile/cubit/profile_cubit.dart';
import 'package:elkawther/features/auth/cubit/auth_cubit.dart';
import 'package:elkawther/features/profile/widgets/profile_header_section.dart';
import 'package:elkawther/features/profile/widgets/radio_button_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:elkawther/core/providers/locale_provider.dart';
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
      if (!mounted) return;
      if (context.read<AuthCubit>().state is AuthVisitor) return;
      context.read<ProfileCubit>().getUserData();
    });
  }

  Future<void> _open(String route, {Object? arguments}) async {
    await Navigator.pushNamed(context, route, arguments: arguments);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final isVisitor = context.watch<AuthCubit>().state is AuthVisitor;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FB),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 120),
        children: [
          if (isVisitor) ...[
            _ProfileBanner(
              title: S.of(context).profile,
              subtitle:
                  isAr
                      ? 'حسابك وإعدادات التطبيق'
                      : 'Your account and app settings',
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(22)),
                clipBehavior: Clip.antiAlias,
                child: LoginFirstView(expand: false),
              ),
            ),
          ] else
            const ProfileHeaderSection(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isVisitor) ...[
                  _SectionLabel(S.of(context).my_account, top: 2),
                  _ProfileGroup(
                    items: [
                      _ProfileAction(
                        icon: Assets.iconsProfile2,
                        title: S.of(context).edit_profile,
                        onTap: () => _open(Routes.editPersonalInfo),
                      ),
                      _ProfileAction(
                        icon: Assets.iconsMap2,
                        title: S.of(context).my_addresses,
                        onTap: () => _open(Routes.addresses),
                      ),
                      _ProfileAction(
                        icon: Assets.iconsFavourite2,
                        title: S.of(context).favourite,
                        onTap: () => _open(Routes.favourite),
                      ),
                      _ProfileAction(
                        icon: Assets.iconsOrders2,
                        title: S.of(context).returns,
                        onTap: () => _open(Routes.returns),
                      ),
                    ],
                  ),
                ],
                _SectionLabel(
                  S.of(context).specializations,
                  top: isVisitor ? 18 : 22,
                ),
                _ProfileGroup(
                  items: [
                    _ProfileAction(
                      icon: Assets.iconsLang2,
                      title: S.of(context).language,
                      trailing: _LanguagePill(
                        label:
                            isAr ? S.of(context).arabic : S.of(context).english,
                      ),
                      onTap: () => _openLanguageSheet(context),
                    ),
                    _ProfileAction(
                      icon: Assets.iconsContact2,
                      title: S.of(context).contactUs,
                      onTap: () => _open(Routes.contactUs),
                    ),
                    _ProfileAction(
                      icon: Assets.iconsTerms2,
                      title: S.of(context).terms_and_conditions,
                      onTap:
                          () => Navigator.pushNamed(
                            context,
                            Routes.termsAndConditions,
                          ),
                    ),
                    _ProfileAction(
                      icon: Assets.iconsPolicy2,
                      title: S.of(context).privacy_policy,
                      onTap:
                          () => Navigator.pushNamed(
                            context,
                            Routes.privacyAndPolicy,
                          ),
                    ),
                  ],
                ),
                if (!isVisitor) ...[
                  _SectionLabel(
                    isAr ? 'إجراءات الحساب' : 'Account actions',
                    top: 22,
                  ),
                  _ProfileGroup(
                    items: [
                      _ProfileAction(
                        icon: Assets.iconsLogout,
                        title: S.of(context).logout,
                        danger: true,
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
                      // _ProfileAction(
                      //   icon: Assets.iconsDelete,
                      //   title: S.of(context).delete_account,
                      //   danger: true,
                      //   onTap: () {
                      //     showModalBottomSheet(
                      //       context: context,
                      //       backgroundColor: Colors.transparent,
                      //       builder: (_) => ConfirmLogoutBottomSheet(
                      //         label: S.of(context).delete_account,
                      //         confirmColor: const Color(0xFFEF4444),
                      //         onConfirm: () async {
                      //           try {
                      //             await context.read<AuthCubit>().deleteAccount();
                      //             if (!context.mounted) return;
                      //             context.read<ProfileCubit>().clearUser();
                      //             AppSnackBar.success(
                      //               isAr ? 'تم حذف الحساب' : 'Account deleted',
                      //             );
                      //             Navigator.pushNamedAndRemoveUntil(
                      //               context,
                      //               Routes.login,
                      //               (route) => false,
                      //             );
                      //           } catch (error) {
                      //             if (!context.mounted) return;
                      //             final message = error is DioException
                      //                 ? Errors.fromDioError(
                      //                     error,
                      //                   ).localizedMessage(context)
                      //                 : S.of(context).unexpectedNetworkError;
                      //             AppSnackBar.error(message);
                      //           }
                      //         },
                      //         onCancel: () => Navigator.pop(context),
                      //       ),
                      //     );
                      //   },
                      // ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openLanguageSheet(BuildContext context) {
    final currentLocaleCode = Localizations.localeOf(context).languageCode;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (_) => RadioButtonsBottomSheet(
            valuesList: [S.of(context).arabic, S.of(context).english],
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
  }
}

class _ProfileBanner extends StatelessWidget {
  const _ProfileBanner({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF085A94),
            AppColors.primaryColor,
            Color(0xFF1A8FCF),
          ],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Stack(
        children: [
          const Positioned(right: -36, top: -28, child: _BannerBlob(size: 120)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.noto16w400.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTextStyles.noto14w400.copyWith(
                  color: Colors.white.withOpacity(0.82),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BannerBlob extends StatelessWidget {
  const _BannerBlob({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.08),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label, {required this.top});

  final String label;
  final double top;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(6, top, 6, 8),
      child: Text(
        label,
        style: AppTextStyles.noto14w400.copyWith(
          fontWeight: FontWeight.w800,
          color: AppColors.grey,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _LanguagePill extends StatelessWidget {
  const _LanguagePill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTextStyles.noto14w400.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }
}

class _ProfileAction {
  const _ProfileAction({
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailing,
    this.danger = false,
  });

  final String icon;
  final String title;
  final VoidCallback onTap;
  final Widget? trailing;
  final bool danger;
}

class _ProfileGroup extends StatelessWidget {
  const _ProfileGroup({required this.items});

  final List<_ProfileAction> items;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            _ProfileRow(action: items[i]),
            if (i != items.length - 1)
              const Divider(
                height: 1,
                thickness: 1,
                indent: 66,
                endIndent: 16,
                color: Color(0xFFF0F4F8),
              ),
          ],
        ],
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({required this.action});

  final _ProfileAction action;

  @override
  Widget build(BuildContext context) {
    final tint =
        action.danger ? const Color(0xFFEF4444) : AppColors.primaryColor;

    return InkWell(
      onTap: action.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: tint.withOpacity(0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SvgPicture.asset(
                action.icon,
                width: 22,
                height: 22,
                colorFilter: ColorFilter.mode(tint, BlendMode.srcIn),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                action.title,
                style: AppTextStyles.noto14w400.copyWith(
                  fontWeight: FontWeight.w700,
                  color: action.danger ? tint : AppColors.darkColor,
                  fontSize: 14,
                ),
              ),
            ),
            if (action.trailing != null) ...[
              action.trailing!,
              const SizedBox(width: 6),
            ],
            if (!action.danger)
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: AppColors.grey.withOpacity(0.7),
                textDirection: Directionality.of(context),
              ),
          ],
        ),
      ),
    );
  }
}
