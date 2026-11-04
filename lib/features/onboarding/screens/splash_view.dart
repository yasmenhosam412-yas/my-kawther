import 'dart:math' as math;

import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/widgets/pharmacy_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../auth/cubit/auth_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _pulseAnimation = Tween<double>(begin: 0.96, end: 1.02).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
    _controller.repeat(reverse: true);
    _completeStartup();
  }

  Future<void> _completeStartup() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final hasSession = await context.read<AuthCubit>().restoreSession();
    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      hasSession ? Routes.home : Routes.onboarding,
      (route) => false,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFEAF7FD), Colors.white, Color(0xFFF2FBF9)],
          ),
        ),
        child: Stack(
          children: [
            const Positioned(
              top: -90,
              right: -70,
              child: _BackgroundOrb(size: 250, color: Color(0x220B76B9)),
            ),
            const Positioned(
              bottom: -100,
              left: -85,
              child: _BackgroundOrb(size: 260, color: Color(0x1F06A786)),
            ),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final logoSize = math.min(
                    200.0,
                    math.min(
                      constraints.maxWidth * 0.52,
                      constraints.maxHeight * 0.34,
                    ),
                  );

                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                        minWidth: constraints.maxWidth,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 24,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AnimatedBuilder(
                                  animation: _pulseAnimation,
                                  builder:
                                      (context, child) => Transform.scale(
                                        scale: _pulseAnimation.value,
                                        child: child,
                                      ),
                                  child: Container(
                                    width: logoSize + 44,
                                    height: logoSize + 44,
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(48),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.8),
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primaryColor
                                              .withOpacity(0.14),
                                          blurRadius: 40,
                                          offset: const Offset(0, 18),
                                        ),
                                      ],
                                    ),
                                    child: PharmacyLogo(size: logoSize),
                                  ),
                                ),
                                const SizedBox(height: 34),
                                Text(
                                  isArabic
                                      ? 'صيدلية الكوثر'
                                      : 'El Kawther Pharmacy',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.headlineLarge.copyWith(
                                    color: AppColors.darkColor,
                                    fontSize: 26,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  isArabic
                                      ? 'رعايتك الصحية، بكل عناية'
                                      : 'Your health, cared for every day',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.noto16w400.copyWith(
                                    color: AppColors.grey,
                                    fontSize: 15,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 48),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 112,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(99),
                                    child: const LinearProgressIndicator(
                                      minHeight: 4,
                                      backgroundColor: Color(0xFFDCEEF5),
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  isArabic
                                      ? 'لحظات ونكون معك'
                                      : 'Getting things ready',
                                  style: AppTextStyles.noto14w400.copyWith(
                                    color: AppColors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BackgroundOrb extends StatelessWidget {
  const _BackgroundOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
