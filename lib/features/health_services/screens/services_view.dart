import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/features/health_services/widgets/health_creative_icons.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:elkawther/generated/l10n.dart';

class ServicesView extends StatelessWidget {
  const ServicesView({super.key});

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final services = [
      _ServiceItem(
        title: S.of(context).ovulation_calculator,
        subtitle: isAr ? 'حاسبة الدورة والخصوبة' : 'Cycle and fertility tracker',
        kind: HealthServiceKind.ovulation,
        color: const Color(0xFFEC4899),
        route: Routes.healthServices,
      ),
      _ServiceItem(
        title: S.of(context).pregnancy_calculator,
        subtitle: isAr ? 'متابعة الحمل والأسبوع' : 'Pregnancy week tracker',
        kind: HealthServiceKind.pregnancy,
        color: const Color(0xFF7C3AED),
        route: Routes.pregnancyServices,
      ),
      _ServiceItem(
        title: S.of(context).blood_pressure,
        subtitle: isAr ? 'قياس وتقييم الضغط' : 'Measure and evaluate BP',
        kind: HealthServiceKind.bloodPressure,
        color: const Color(0xFFEF4444),
        route: Routes.bloodPressure,
      ),
      _ServiceItem(
        title: S.of(context).blood_sugar,
        subtitle: isAr ? 'متابعة السكر' : 'Blood sugar follow-up',
        kind: HealthServiceKind.bloodSugar,
        color: const Color(0xFFF59E0B),
        route: Routes.bloodSugar,
      ),
      _ServiceItem(
        title: S.of(context).body_weight,
        subtitle: isAr ? 'حساب مؤشر كتلة الجسم' : 'BMI calculator',
        kind: HealthServiceKind.bodyWeight,
        color: const Color(0xFF0B76B9),
        route: Routes.bodyWeight,
      ),
      _ServiceItem(
        title: S.of(context).vaccination_schedule,
        subtitle: isAr ? 'جدول تطعيمات الأطفال' : 'Kids vaccine schedule',
        kind: HealthServiceKind.vaccination,
        color: const Color(0xFF06A786),
        route: Routes.allChildren,
      ),
      _ServiceItem(
        title: S.of(context).ask_pharmacist,
        subtitle: isAr ? 'تواصل عبر واتساب' : 'Chat on WhatsApp',
        kind: HealthServiceKind.pharmacist,
        color: const Color(0xFF16A34A),
        whatsapp: '201012345678',
      ),
      _ServiceItem(
        title: S.of(context).beauty_consultation,
        subtitle: isAr ? 'استشارة تجميل' : 'Beauty consultation',
        kind: HealthServiceKind.beauty,
        color: const Color(0xFFDB2777),
        whatsapp: '201098765432',
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5FAFD),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).services,
                  style: AppTextStyles.noto16w400.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isAr
                      ? 'حاسبات صحية واستشارات سريعة'
                      : 'Health calculators and quick consults',
                  style: AppTextStyles.noto14w400.copyWith(
                    color: AppColors.grey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
              itemCount: services.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.92,
              ),
              itemBuilder: (context, index) {
                return _ServiceCard(item: services[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceItem {
  const _ServiceItem({
    required this.title,
    required this.subtitle,
    required this.kind,
    required this.color,
    this.route,
    this.whatsapp,
  });

  final String title;
  final String subtitle;
  final HealthServiceKind kind;
  final Color color;
  final String? route;
  final String? whatsapp;
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.item});

  final _ServiceItem item;

  Future<void> _open(BuildContext context) async {
    if (item.whatsapp != null) {
      final url = Uri.parse('https://wa.me/${item.whatsapp}');
      await launchUrl(url, mode: LaunchMode.externalApplication);
      return;
    }
    if (item.route != null) {
      Navigator.pushNamed(context, item.route!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: () => _open(context),
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: item.color.withOpacity(0.12)),
            boxShadow: [
              BoxShadow(
                color: item.color.withOpacity(0.10),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 16, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HealthCreativeIcon(kind: item.kind, color: item.color),
                const Spacer(),
                Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.noto14w400.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkColor,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.noto14w400.copyWith(
                    fontSize: 11,
                    color: AppColors.grey,
                    height: 1.3,
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
