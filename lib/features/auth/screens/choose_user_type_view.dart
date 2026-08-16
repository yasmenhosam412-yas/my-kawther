import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/widgets/pharmacy_logo.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';

class ChooseUserTypeView extends StatelessWidget {
  const ChooseUserTypeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryColor.withOpacity(0.10),
              Colors.white,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
            child: Column(
              children: [
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    child: InkWell(
                      onTap: () => Navigator.maybePop(context),
                      borderRadius: BorderRadius.circular(14),
                      child: const SizedBox(
                        width: 44,
                        height: 44,
                        child: Icon(
                          Icons.arrow_back_rounded,
                          color: AppColors.darkColor,
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(flex: 2),
                Container(
                  width: 168,
                  height: 168,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.16),
                        blurRadius: 32,
                        offset: const Offset(0, 14),
                      ),
                    ],
                  ),
                  child: const PharmacyLogo(),
                ),
                const SizedBox(height: 28),
                Text(
                  S.of(context).welcome,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.headlineLarge.copyWith(
                    color: AppColors.primaryColor,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  S.of(context).yourPharmacyInYourPocket,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.noto16w400.copyWith(
                    color: AppColors.grey,
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
                const Spacer(flex: 3),
                _UserTypeCard(
                  title: S.of(context).loginUser,
                  icon: Icons.person_rounded,
                  filled: true,
                  onTap: () => Navigator.pushNamed(context, Routes.login),
                ),
                const SizedBox(height: 14),
                _UserTypeCard(
                  title: S.of(context).continueAsVisitor,
                  icon: Icons.storefront_rounded,
                  filled: false,
                  onTap: () => Navigator.pushNamed(context, Routes.home),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UserTypeCard extends StatelessWidget {
  const _UserTypeCard({
    required this.title,
    required this.icon,
    required this.filled,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final background = filled ? AppColors.primaryColor : Colors.white;
    final foreground = filled ? Colors.white : AppColors.primaryColor;

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: filled
                ? null
                : Border.all(color: AppColors.primaryColor, width: 1.4),
            boxShadow: filled
                ? [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.28),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: filled
                      ? Colors.white.withOpacity(0.16)
                      : AppColors.light,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: foreground),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.ibmPlexSans16w500.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: foreground,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_rounded,
                color: foreground,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
