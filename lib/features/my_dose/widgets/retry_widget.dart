import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:elkawther/features/my_dose/cubit/my_dose_cubit.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/core/widgets/custom_elevated_button.dart';

class RetryWidget extends StatelessWidget {
  const RetryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: CustomElevatedButton(
        onPressed: () {
          context.read<MedicationCubit>().fetchAllMedications();
        },
        title: S.of(context).retry,
        backgroundColor: AppColors.primaryColor,
      ),
    );
  }
}
