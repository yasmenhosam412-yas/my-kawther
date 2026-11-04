import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/features/onboarding/models/onboarding_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingItem extends StatelessWidget {
  final OnboardingModel model;

  const OnboardingItem({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return LayoutBuilder(
      builder: (context, constraints) {
        final imageSize = (size.width * 0.78).clamp(
          0.0,
          constraints.maxHeight * 0.6,
        );

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Container(
                width: imageSize,
                height: imageSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: model.accent.withOpacity(0.18),
                      blurRadius: 36,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: SvgPicture.string(model.svg, fit: BoxFit.contain),
                ),
              ),
              const Spacer(flex: 2),
              Text(
                model.title ?? '',
                textAlign: TextAlign.center,
                style: AppTextStyles.headlineLarge.copyWith(
                  color: model.accent,
                  fontSize: 26,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                model.subtitle ?? '',
                textAlign: TextAlign.center,
                style: AppTextStyles.noto16w400.copyWith(
                  color: const Color(0xFF6B7280),
                  fontSize: 15,
                  height: 1.6,
                ),
              ),
              const Spacer(),
            ],
          ),
        );
      },
    );
  }
}
