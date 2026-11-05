import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';

/// Branded error state shown when the dashboard fails to load
/// (network problems, server errors, ...). Also supports
/// pull-to-refresh via the parent RefreshIndicator.
class HomeErrorView extends StatelessWidget {
  const HomeErrorView({
    super.key,
    required this.message,
    this.onRetry,
  });

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 36, 16, 28),
      child: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 380),
          curve: Curves.easeOutCubic,
          builder: (context, t, child) {
            return Opacity(
              opacity: t,
              child: Transform.translate(
                offset: Offset(0, (1 - t) * 24),
                child: Transform.scale(scale: 0.95 + 0.05 * t, child: child),
              ),
            );
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: AppColors.borderColor.withOpacity(0.4)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x160B426A),
                  blurRadius: 36,
                  offset: Offset(0, 20),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 86,
                  height: 86,
                  decoration: BoxDecoration(
                    color: AppColors.light,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.16),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.cloud_off_rounded,
                    size: 40,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  S.of(context).homeErrorTitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.headlineLarge.copyWith(
                    fontSize: 19,
                    color: AppColors.darkColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.noto14w400.copyWith(
                    fontSize: 13.5,
                    height: 1.6,
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  S.of(context).homeErrorSubtitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.noto14w400.copyWith(
                    fontSize: 12.5,
                    height: 1.6,
                    color: AppColors.grey.withOpacity(0.85),
                  ),
                ),
                if (onRetry != null) ...[
                  const SizedBox(height: 22),
                  _RetryButton(onTap: onRetry!),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RetryButton extends StatelessWidget {
  const _RetryButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryColor, AppColors.teal],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: 170,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.refresh_rounded, size: 20, color: Colors.white),
                const SizedBox(width: 7),
                Text(
                  S.of(context).retry,
                  style: AppTextStyles.noto14w400.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
