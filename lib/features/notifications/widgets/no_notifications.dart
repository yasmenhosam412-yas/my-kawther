import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elkawther/generated/assets.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/core/theme/app_padding.dart';

class NoNotifications extends StatelessWidget {
  const NoNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.medium),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(Assets.notiEmpty),
            const SizedBox(height: AppPadding.large),
            Text(
              S.of(context).no_notifications,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                //color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppPadding.small),
            Text(
              S.of(context).no_notifications_message,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppPadding.medium),
          ],
        ),
      ),
    );
  }
}
