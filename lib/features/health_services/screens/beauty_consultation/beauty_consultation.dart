import 'package:flutter/material.dart';
import 'package:elkawther/core/widgets/app_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/features/health_services/widgets/health_service_scaffold.dart';

class BeautyConsultation extends StatelessWidget {
  const BeautyConsultation({super.key});

  Future<void> _openWhatsApp(BuildContext context) async {
    final url = Uri.parse('https://wa.me/201098765432');
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (context.mounted) {
        AppSnackBar.error('لا يمكن فتح الرابط. حاول مرة أخرى لاحقاً.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return HealthServiceScaffold(
      title: S.of(context).beautyConsultation,
      subtitle: isAr ? 'استشارة تجميل سريعة' : 'Quick beauty consultation',
      bottom: HealthPrimaryButton(
        title: isAr ? 'تواصل عبر واتساب' : 'Chat on WhatsApp',
        color: const Color(0xFF16A34A),
        onPressed: () => _openWhatsApp(context),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          HealthFormCard(
            child: Column(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDB2777).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Icon(
                    Icons.spa_outlined,
                    color: Color(0xFFDB2777),
                    size: 36,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  S.of(context).beautyConsultation,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.noto16w400.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isAr
                      ? 'احصلي على استشارة تجميل من فريق الكوثر عبر واتساب.'
                      : 'Get a beauty consult from the Elkawther team on WhatsApp.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.noto14w400.copyWith(
                    color: AppColors.grey,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
