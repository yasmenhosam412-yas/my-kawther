import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';

class SuccessDoseDialog {
  const SuccessDoseDialog._();

  static Future<bool> show(
    BuildContext context, {
    String? medicineName,
    String? timeLabel,
  }) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isAr = Localizations.localeOf(context).languageCode == 'ar';
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.lightDarker,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.teal.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      size: 38,
                      color: AppColors.teal,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isAr ? 'تأكيد أخذ الجرعة' : 'Confirm this dose',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.noto16w400.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.darkColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    [
                      if (medicineName != null && medicineName.isNotEmpty)
                        medicineName,
                      if (timeLabel != null && timeLabel.isNotEmpty) timeLabel,
                    ].join('  •  '),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.noto14w400.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.grey,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isAr
                        ? 'سيتم تعليم هذه الجرعة كمأخوذة لليوم'
                        : 'This dose will be marked as taken for today',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.noto14w400.copyWith(
                      fontSize: 13,
                      color: AppColors.grey,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context, false),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: AppColors.lightDarker,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              isAr ? 'لاحقاً' : 'Later',
                              style: AppTextStyles.noto14w400.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.darkColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.teal,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              S.of(context).the_dose_has_been_taken,
                              textAlign: TextAlign.center,
                              style: AppTextStyles.noto14w400.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                              ),
                            ),
                          ),
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
    );
    return result == true;
  }
}
