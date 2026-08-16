import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';

class HealthResultSheet {
  const HealthResultSheet._();

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    double heightFactor = 0.78,
    bool expand = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final maxHeight =
            MediaQuery.sizeOf(context).height * heightFactor;
        final sheet = Container(
          width: double.infinity,
          height: expand ? maxHeight : null,
          constraints: expand ? null : BoxConstraints(maxHeight: maxHeight),
          decoration: const BoxDecoration(
            color: Color(0xFFF5FAFD),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: child,
        );
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: sheet,
        );
      },
    );
  }
}

class HealthSheetHandle extends StatelessWidget {
  const HealthSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 8),
      child: Center(
        child: Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.lightDarker,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}

class HealthStatusChip extends StatelessWidget {
  const HealthStatusChip({
    super.key,
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTextStyles.noto14w400.copyWith(
          color: color,
          fontWeight: FontWeight.w800,
          fontSize: 13,
        ),
      ),
    );
  }
}

class HealthMetricHero extends StatelessWidget {
  const HealthMetricHero({
    super.key,
    required this.color,
    required this.icon,
    required this.title,
    required this.status,
    required this.child,
  });

  final Color color;
  final IconData icon;
  final String title;
  final String status;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.10),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.noto14w400.copyWith(
              color: AppColors.grey,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          child,
          if (status.isNotEmpty) ...[
            const SizedBox(height: 10),
            HealthStatusChip(label: status, color: color),
          ],
        ],
      ),
    );
  }
}

class HealthHistoryCard extends StatelessWidget {
  const HealthHistoryCard({
    super.key,
    required this.child,
    this.color = AppColors.primaryColor,
  });

  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.08)),
      ),
      child: child,
    );
  }
}

class HealthConditionChip extends StatelessWidget {
  const HealthConditionChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.light,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: AppTextStyles.noto14w400.copyWith(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}

Color healthEvalColor(String evaluation) {
  final value = evaluation.toLowerCase();
  if (value.contains('طبيعي') || value.contains('normal')) {
    return AppColors.teal;
  }
  if (value.contains('منخفض') ||
      value.contains('نقص') ||
      value.contains('low') ||
      value.contains('under')) {
    return const Color(0xFF3B82F6);
  }
  if (value.contains('مقدمات') ||
      value.contains('قليلا') ||
      value.contains('زيادة')) {
    return const Color(0xFFF59E0B);
  }
  if (value.contains('مرتفع') ||
      value.contains('سمنة') ||
      value.contains('high') ||
      value.contains('obes')) {
    return const Color(0xFFEF4444);
  }
  return AppColors.primaryColor;
}
