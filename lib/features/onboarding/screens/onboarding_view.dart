import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/widgets/app_snack_bar.dart';
import 'package:elkawther/features/onboarding/models/onboarding_model.dart';
import 'package:elkawther/features/onboarding/widgets/onboarding_icons.dart';
import 'package:elkawther/features/onboarding/widgets/onboarding_item.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _controller = PageController();
  int currentIndex = 0;
  DateTime? lastPressed;

  List<OnboardingModel> _pages(BuildContext context) => [
    OnboardingModel(
      svg: OnboardingIcons.health,
      title: S.of(context).onb1Title,
      subtitle: S.of(context).onb1Subtitle,
      accent: AppColors.teal,
    ),
    OnboardingModel(
      svg: OnboardingIcons.smart,
      title: S.of(context).onb2Title,
      subtitle: S.of(context).onb2Subtitle,
      accent: AppColors.primaryColor,
    ),
    OnboardingModel(
      svg: OnboardingIcons.products,
      title: S.of(context).onb3Title,
      subtitle: S.of(context).onb3Subtitle,
      accent: AppColors.teal,
    ),
  ];

  void _onNext(int lastIndex) {
    if (currentIndex < lastIndex) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeOutCubic,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _goBack() {
    _controller.previousPage(
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeOutCubic,
    );
  }

  void _finishOnboarding() {
    if (context.mounted) {
      Navigator.pushNamed(context, Routes.chooseUserType);
    }
  }

  Future<void> _handlePop() async {
    if (currentIndex > 0) {
      _goBack();
      return;
    }

    final now = DateTime.now();
    if (lastPressed == null ||
        now.difference(lastPressed!) > const Duration(seconds: 2)) {
      lastPressed = now;
      AppSnackBar.info(S.of(context).pressAgainToExit);
      return;
    }
    SystemNavigator.pop();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = _pages(context);
    final isLast = currentIndex == pages.length - 1;
    final accent = pages[currentIndex].accent;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _handlePop();
      },
      child: Scaffold(
        body: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                accent.withOpacity(0.10),
                Colors.white,
                Colors.white,
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                  child: Row(
                    children: [
                      if (currentIndex > 0)
                        _TopChipButton(
                          onTap: _goBack,
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            color: AppColors.darkColor,
                          ),
                        )
                      else
                        const SizedBox(width: 44, height: 44),
                      const Spacer(),
                      if (!isLast)
                        _TopChipButton(
                          onTap: _finishOnboarding,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          child: Text(
                            S.of(context).skip,
                            style: AppTextStyles.ibmPlexSans16w500.copyWith(
                              fontSize: 14,
                              color: AppColors.grey,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: pages.length,
                    onPageChanged: (index) {
                      setState(() => currentIndex = index);
                    },
                    itemBuilder:
                        (_, index) => OnboardingItem(model: pages[index]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
                  child: Column(
                    children: [
                      _buildIndicator(pages.length, accent),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () => _onNext(pages.length - 1),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accent,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shadowColor: accent.withOpacity(0.35),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                isLast
                                    ? S.of(context).startNow
                                    : S.of(context).next,
                                style: AppTextStyles.ibmPlexSans16w500.copyWith(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                isLast
                                    ? Icons.check_rounded
                                    : Icons.arrow_forward_rounded,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator(int length, Color accent) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (index) {
        final selected = currentIndex == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: selected ? 28 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: selected ? accent : AppColors.greyCarsoul,
            borderRadius: BorderRadius.circular(99),
          ),
        );
      }),
    );
  }
}

class _TopChipButton extends StatelessWidget {
  const _TopChipButton({
    required this.onTap,
    required this.child,
    this.padding,
  });

  final VoidCallback onTap;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: padding == null ? 44 : null,
          height: 44,
          padding: padding,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
