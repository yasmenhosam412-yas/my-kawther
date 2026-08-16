import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/widgets/pharmacy_logo.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';

class EmptyDose extends StatelessWidget {
  const EmptyDose({super.key});

  void _openAdd(BuildContext context) {
    Navigator.pushNamed(
      context,
      Routes.addDose,
      arguments: {"isEdit": false},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const PharmacyLogo(size: 88),
            const SizedBox(height: 20),
            Text(
              S.of(context).noMedicationHasBeenAddedYet,
              textAlign: TextAlign.center,
              style: AppTextStyles.noto16w400.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.darkColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              S.of(context).pleaseAddMedications,
              textAlign: TextAlign.center,
              style: AppTextStyles.noto14w400.copyWith(
                color: AppColors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => _openAdd(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  S.of(context).addMedication,
                  style: AppTextStyles.noto14w400.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
