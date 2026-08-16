import 'package:elkawther/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

import 'package:elkawther/generated/assets.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/core/theme/app_padding.dart';
import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/core/widgets/custom_elevated_button.dart';

class CheckOutDialog extends StatelessWidget {
  const CheckOutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppPadding.small),
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppPadding.large),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Image.asset(
                    Assets.imagesSuccess,
                    width: 200,
                    height: 200,
                  ),
                ),
                const SizedBox(height: AppPadding.medium),
                FittedBox(
                  child: Text(
                    S.of(context).order_success,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: AppPadding.medium),
                CustomElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, Routes.home);
                  },
                  backgroundColor: AppColors.primaryColor,
                  title: S.of(context).back_to_home,
                ),
                const SizedBox(height: AppPadding.medium),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(S.of(context).continue_shopping),
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
