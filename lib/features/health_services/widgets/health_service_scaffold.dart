import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/features/health_services/cubit/health_service_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HealthServiceScaffold extends StatelessWidget {
  const HealthServiceScaffold({
    super.key,
    required this.title,
    required this.body,
    this.subtitle,
    this.bottom,
    this.showBack = true,
  });

  final String title;
  final String? subtitle;
  final Widget body;
  final Widget? bottom;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FAFD),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(showBack ? 8 : 20, 8, 20, 18),
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
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  if (showBack)
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: AppColors.darkColor,
                      ),
                    ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.noto16w400.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.darkColor,
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            subtitle!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.noto14w400.copyWith(
                              fontSize: 12,
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: body),
          if (bottom != null)
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: bottom!,
              ),
            ),
        ],
      ),
    );
  }
}

class HealthPrimaryButton extends StatelessWidget {
  const HealthPrimaryButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.color,
    this.lockWhileLoading = true,
  });

  final String title;
  final VoidCallback onPressed;
  final Color? color;
  final bool lockWhileLoading;

  @override
  Widget build(BuildContext context) {
    if (!lockWhileLoading) {
      return _button(isLoading: false);
    }

    HealthServiceCubit? cubit;
    try {
      cubit = BlocProvider.of<HealthServiceCubit>(context, listen: false);
    } catch (_) {
      cubit = null;
    }

    if (cubit == null) {
      return _button(isLoading: false);
    }

    return BlocBuilder<HealthServiceCubit, HealthServcieState>(
      bloc: cubit,
      buildWhen: (previous, current) =>
          _isBusyState(previous) != _isBusyState(current),
      builder: (context, state) => _button(isLoading: _isBusyState(state)),
    );
  }

  bool _isBusyState(HealthServcieState state) =>
      state is HealthServicesLoading ||
      state is HealthServicesVaccineFullLoading ||
      state is HealthServicesUpdatingVaccineStatus ||
      state is ChildDeletedLoading;

  Widget _button({required bool isLoading}) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppColors.primaryColor,
          foregroundColor: Colors.white,
          disabledBackgroundColor:
              (color ?? AppColors.primaryColor).withOpacity(0.55),
          disabledForegroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                title,
                style: AppTextStyles.noto14w400.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
      ),
    );
  }
}

class HealthDropdownBox extends StatelessWidget {
  const HealthDropdownBox({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFF5FAFD),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.12)),
      ),
      child: child,
    );
  }
}

class HealthFormCard extends StatelessWidget {
  const HealthFormCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}
