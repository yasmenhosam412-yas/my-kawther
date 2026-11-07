import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/features/profile/cubit/profile_cubit.dart';
import 'package:elkawther/features/profile/models/user_model.dart';
import 'package:elkawther/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/utils/functions.dart';
import 'package:elkawther/core/routes/routes.dart';

class ProfileHeaderSection extends StatelessWidget {
  const ProfileHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileCubitState>(
      builder: (context, state) {
        final UserModel? user = state is ProfileUserLoadedState
            ? state.user
            : context.read<ProfileCubit>().userData;
        final isLoading =
            state is ProfileUserLoadingState ||
            state is ProfileCubitInitialState;
        final name = isLoading ? 'Account name' : (user?.name ?? '');
        final email = isLoading ? 'name@email.com' : (user?.email ?? '');
        final phone = isLoading ? '01000000000' : (user?.phone ?? '');

        return Column(
          children: [
            Container(
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 36),
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
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(32),
                ),
              ),
              child: Stack(
                children: [
                  const Positioned(
                    right: -36,
                    top: -28,
                    child: _HeaderBlob(size: 140),
                  ),
                  const Positioned(
                    left: -24,
                    bottom: -10,
                    child: _HeaderBlob(size: 96),
                  ),
                  Skeletonizer(
                    enabled: isLoading,
                    child: Column(
                      children: [
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            S.of(context).profile,
                            style: AppTextStyles.noto16w400.copyWith(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.22),
                          ),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.white,
                            child: Text(
                              getInitial(name),
                              style: AppTextStyles.noto16w400.copyWith(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w800,
                                fontSize: 28,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          isLoading
                              ? name
                              : '${S.of(context).hello}! $name',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.noto16w400.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        if (isLoading || email.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            email,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.noto14w400.copyWith(
                              color: Colors.white.withOpacity(0.82),
                              fontSize: 13,
                            ),
                          ),
                        ],
                        if (isLoading || phone.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.16),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              phone,
                              style: AppTextStyles.noto14w400.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -22),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE6EEF5)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.10),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          child: _QuickAction(
                            icon: Assets.iconsOrders2,
                            label: S.of(context).orders,
                            color: AppColors.primaryColor,
                            onTap: () => Navigator.pushNamed(
                              context,
                              Routes.myOrders,
                              arguments: false,
                            ),
                          ),
                        ),
                        const VerticalDivider(
                          width: 1,
                          thickness: 1,
                          color: Color(0xFFE8EEF3),
                        ),
                        Expanded(
                          child: _QuickAction(
                            icon: Assets.iconsMyPoints2,
                            label: S.of(context).my_points,
                            color: AppColors.teal,
                            onTap: () => Navigator.pushNamed(
                              context,
                              Routes.profilePoints,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (state is ProfileUserErrorState)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    state.message.localizedMessage(context),
                    style: AppTextStyles.noto14w400.copyWith(
                      color: Colors.red.shade700,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _HeaderBlob extends StatelessWidget {
  const _HeaderBlob({required this.size});

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

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  icon,
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.noto14w400.copyWith(
                    color: AppColors.darkColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
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
