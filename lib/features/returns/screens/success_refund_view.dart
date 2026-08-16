import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';

import 'package:elkawther/generated/assets.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/core/theme/app_padding.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/core/widgets/custom_elevated_button.dart';

class SuccessRefundView extends StatelessWidget {
  const SuccessRefundView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.home,
          (route) => false,
        );
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
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
                const SizedBox(height: AppPadding.small),
                Text(
                  textAlign: TextAlign.center,
                  S.of(context).request_submitted_successfully,
                  style: AppTextStyles.ibmPlexSans16w500.copyWith(
                    color: Colors.black,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: AppPadding.small),
                Text(
                  textAlign: TextAlign.center,
                  S.of(context).we_will_reply_asap,
                  style: AppTextStyles.ibmPlexSans16w500.copyWith(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: AppPadding.large),

                CustomElevatedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      Routes.home,
                      (route) => false,
                    ); // Go to home screen
                  },
                  backgroundColor: AppColors.primaryColor,
                  title: S.of(context).back_to_home,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
