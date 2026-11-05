import 'package:elkawther/core/widgets/app_snack_bar.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/features/health_services/cubit/health_service_cubit.dart';
import 'package:elkawther/features/health_services/widgets/weight_bottom_sheet.dart';
import 'package:elkawther/core/widgets/custom_text_form_field.dart';
import 'package:elkawther/core/widgets/text_field_with_custom_label.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import 'package:elkawther/core/theme/app_padding.dart';
import 'package:elkawther/core/utils/validators.dart';
import 'package:elkawther/features/health_services/widgets/health_service_scaffold.dart';

class WeightCalc extends StatelessWidget {
  WeightCalc({super.key});

  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return HealthServiceScaffold(
      title: S.of(context).body_weight,
      subtitle: isAr ? 'حساب مؤشر كتلة الجسم' : 'BMI calculator',
      bottom: HealthPrimaryButton(
        title: S.of(context).calc,
        onPressed: () async {
          final weightText = weightController.text.trim();
          final heightText = heightController.text.trim();

          if (heightText.isEmpty) {
            AppSnackBar.warning(S.of(context).enterHeight);
            return;
          }

          if (heightController.text.length > 3 ||
              weightController.text.length > 3) {
            AppSnackBar.warning(S.of(context).pleaseEnterValidNumber);
            return;
          }

          if (weightText.isEmpty) {
            AppSnackBar.warning(S.of(context).enterWeight);
            return;
          }

          String normalizeInput(String input) {
            if (input.endsWith('.')) return '${input}0';
            return input;
          }

          try {
            final desiredWeight = double.parse(normalizeInput(weightText));
            final desiredHeight = double.parse(normalizeInput(heightText));

            final cubit = context.read<HealthServiceCubit>();
            await cubit.fetchBodyWeightData(
              weight: desiredWeight,
              height: desiredHeight,
              unit: 'metric',
              context: context,
            );

            if (!context.mounted) return;

            final state = cubit.state;
            if (state is HealthServicesLoaded) {
              weightResultBottomSheet(context, state.weightBody);
            } else if (state is HealthServicesError) {
              AppSnackBar.error(state.message.message);
            }
          } catch (e) {
            AppSnackBar.error(S.of(context).pleaseEnterValidNumber);
          }
        },
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          HealthFormCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFieldCustomLabel(label: S.of(context).height),
                          CustomTextFormField(
                            controller: heightController,
                            hintText: S.of(context).enterHeight,
                            keyboardType: TextInputType.number,
                            validator: (value) =>
                                Validators.validateEmail(context, value),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppPadding.medium),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFieldCustomLabel(label: S.of(context).unit),
                          HealthDropdownBox(
                            child: Text(S.of(context).cm),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppPadding.medium),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFieldCustomLabel(label: S.of(context).weight),
                          CustomTextFormField(
                            controller: weightController,
                            hintText: S.of(context).enterWeight,
                            keyboardType: TextInputType.number,
                            validator: (value) =>
                                Validators.validateEmail(context, value),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppPadding.medium),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFieldCustomLabel(label: S.of(context).unit),
                          HealthDropdownBox(
                            child: Text(S.of(context).kgm),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
