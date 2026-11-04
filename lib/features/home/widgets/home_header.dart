import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/widgets/pharmacy_logo.dart';
import 'package:elkawther/features/cart/cubit/cart_cubit.dart';
import 'package:elkawther/features/home/screens/home_navigation.dart';
import 'package:elkawther/features/auth/cubit/auth_cubit.dart';
import 'package:elkawther/features/profile/cubit/profile_cubit.dart';
import 'package:elkawther/generated/assets.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
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
            final userName =
                authState is AuthVisitor
                    ? S.of(context).guest
                    : profileState is ProfileUserLoadedState
                    ? profileState.user.name
                    : S.of(context).guest;

            return Row(
              children: [
                const PharmacyLogo(size: 52),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${S.of(context).welcome} 👋',
                        style: AppTextStyles.noto14w400.copyWith(
                          color: AppColors.gray,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        userName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.noto24w500.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                          color: AppColors.darkColor,
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
                const SizedBox(width: 8),
                _HeaderIconButton(
                  asset: Assets.iconsNotificationIcon,
                  count: 3,
                  onTap: () => HomeNavigation.openNotifications(context),
                ),
                const SizedBox(width: 8),
                _HeaderIconButton(
                  asset: Assets.iconsWhatsappIcon,
                  onTap: () async {
                    final uri = Uri.parse('https://wa.me/');
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                ),
              ],
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
      elevation: 0,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Ink(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.10),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              SvgPicture.asset(asset, width: 18, height: 18),
              if (count > 0)
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    width: 16,
                    height: 16,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      count > 9 ? '9+' : '$count',
                      style: AppTextStyles.noto14w400.copyWith(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
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
