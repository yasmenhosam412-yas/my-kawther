import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/features/home/widgets/home_sub_scaffold.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';

class HomeNotificationsView extends StatelessWidget {
  const HomeNotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final items = [
      (
        Icons.local_offer_rounded,
        isAr ? 'خصم 30% على الفيتامينات' : '30% off vitamins',
        isAr ? 'العرض ساري حتى نهاية الأسبوع' : 'Offer valid until the weekend',
      ),
      (
        Icons.local_shipping_rounded,
        isAr ? 'طلبك في الطريق' : 'Your order is on the way',
        isAr ? 'سيصل خلال ساعات قليلة' : 'It will arrive in a few hours',
      ),
      (
        Icons.medication_rounded,
        isAr ? 'منتجات جديدة وصلت' : 'New products arrived',
        isAr ? 'تصفح أحدث الإضافات في الصيدلية' : 'Browse the latest pharmacy arrivals',
      ),
    ];

    return HomeSubScaffold(
      title: S.of(context).notifications,
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = items[index];
          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.light,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(item.$1, color: AppColors.primaryColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.$2,
                        style: AppTextStyles.noto14w400.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.$3,
                        style: AppTextStyles.noto14w400.copyWith(
                          color: AppColors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
