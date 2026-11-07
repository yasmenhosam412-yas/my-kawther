import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/widgets/pharmacy_logo.dart';
import 'package:elkawther/features/cart/cubit/cart_cubit.dart';
import 'package:elkawther/features/home/screens/home_navigation.dart';
import 'package:elkawther/features/auth/cubit/auth_cubit.dart';
import 'package:elkawther/features/profile/cubit/profile_cubit.dart';
import 'package:elkawther/features/profile/data/app_settings.dart';
import 'package:elkawther/generated/assets.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({super.key});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && context.read<AuthCubit>().state is AuthLoadedLogin) {
        context.read<ProfileCubit>().getUserData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        return BlocBuilder<ProfileCubit, ProfileCubitState>(
          builder: (context, profileState) {
            final isVisitor = authState is AuthVisitor;
            final isLoading =
                !isVisitor &&
                (authState is AuthInitial ||
                    authState is AuthLoading ||
                    profileState is ProfileCubitInitialState ||
                    profileState is ProfileUserLoadingState ||
                    profileState is ProfileCubitLoadingState);
            final userName = isVisitor
                ? S.of(context).guest
                : profileState is ProfileUserLoadedState
                ? profileState.user.name
                : context.read<ProfileCubit>().userData?.name ??
                      S.of(context).guest;

            return Container(
              padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF085A94),
                    AppColors.primaryColor,
                    Color(0xFF1A8FCF),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const PharmacyLogo(size: 36),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${S.of(context).welcome} 👋',
                          style: AppTextStyles.noto14w400.copyWith(
                            color: Colors.white.withOpacity(0.82),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Skeletonizer(
                          enabled: isLoading,
                          child: Text(
                            isLoading ? 'User name' : userName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.noto24w500.copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  BlocBuilder<CartCubit, CartState>(
                    builder: (context, cartState) {
                      final count = context.read<CartCubit>().cart.fold<int>(
                        0,
                        (sum, item) => sum + item.quantity,
                      );
                      return _HeaderIconButton(
                        asset: Assets.cart,
                        count: count,
                        onTap: () => HomeNavigation.openCart(context),
                      );
                    },
                  ),
                  const SizedBox(width: 6),
                  _HeaderIconButton(
                    asset: Assets.iconsNotificationIcon,
                    count: 3,
                    onTap: () => HomeNavigation.openNotifications(context),
                  ),
                  const SizedBox(width: 6),
                  _HeaderIconButton(
                    asset: Assets.iconsWhatsappIcon,
                    onTap: () async {
                      final url = context.read<AppSettings>().whatsAppUrl;
                      if (url == null) return;
                      final uri = Uri.parse(url);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.asset,
    required this.onTap,
    this.count = 0,
  });

  final String asset;
  final VoidCallback onTap;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Ink(
          width: 38,
          height: 38,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              SvgPicture.asset(asset, width: 18, height: 18),
              if (count > 0)
                PositionedDirectional(
                  top: -2,
                  end: -2,
                  child: Container(
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.4),
                    ),
                    child: Text(
                      count > 9 ? '9+' : '$count',
                      style: AppTextStyles.noto14w400.copyWith(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                        height: 1,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
