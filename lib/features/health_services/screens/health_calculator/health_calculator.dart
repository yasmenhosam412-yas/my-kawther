import 'package:easy_localization/easy_localization.dart';
import 'package:elkawther/features/health_services/data/health_local_calc.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/core/widgets/custom_text_form_field.dart';
import 'package:elkawther/core/widgets/text_field_with_custom_label.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_holo_date_picker/date_picker_theme.dart';
import 'package:flutter_holo_date_picker/widget/date_picker_widget.dart';

import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_padding.dart';
import 'package:elkawther/core/utils/validators.dart';
import 'package:elkawther/features/health_services/widgets/health_service_scaffold.dart';

class HealthCalculator extends StatefulWidget {
  const HealthCalculator({super.key});

  @override
  State<HealthCalculator> createState() => _HealthCalculatorState();
}

class _HealthCalculatorState extends State<HealthCalculator> {
  final TextEditingController lastPeriodDate = TextEditingController();

  final TextEditingController cycleLengthController = TextEditingController();

  final TextEditingController periodLengthController = TextEditingController();

  DateTime? _tempPickedDate;

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return HealthServiceScaffold(
      title: S.of(context).ovulation_calculator,
      subtitle: isAr ? 'حاسبة الدورة والخصوبة' : 'Cycle and fertility tracker',
      bottom: HealthPrimaryButton(
        title: S.of(context).calc,
        onPressed: () {
          try {
            final start = DateTime.parse(lastPeriodDate.text.trim());
            final cycleLengthInt = int.parse(
              cycleLengthController.text.trim(),
            );
            final periodLengthInt = int.parse(
              periodLengthController.text.trim(),
            );
            final result = HealthLocalCalc.period(
              startDay: start,
              cycleLength: cycleLengthInt,
              periodLength: periodLengthInt,
            );
            HealthLocalStore.instance.monthResponse =
                HealthLocalCalc.monthResponse(result);
            Navigator.pushReplacementNamed(
              context,
              Routes.healthTest,
              arguments: result,
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(S.of(context).pleaseEnterValidNumber),
              ),
            );
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
                TextFieldCustomLabel(label: S.of(context).dayOfLastMenstrual),
                CustomTextFormField(
                  controller: lastPeriodDate,
                  hintText: S.of(context).datePeriods,
                  readOnly: true,
                  keyboardType: TextInputType.datetime,
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.calendar_month,
                      color: AppColors.primaryColor,
                    ),
                    onPressed: () {
                      _tempPickedDate = DateTime.now();
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.noHeader,
                        animType: AnimType.rightSlide,
                        btnCancelText: S.of(context).cancel,
                        btnCancelOnPress: () {},
                        btnOkText: S.of(context).confirm,
                        btnOkOnPress: () {
                          if (_tempPickedDate != null) {
                            Future.delayed(Duration.zero, () {
                              setState(() {
                                lastPeriodDate.text = DateFormat(
                                  'yyyy-MM-dd',
                                  'en',
                                ).format(_tempPickedDate!);
                              });
                            });
                          }
                        },
                        body: Column(
                          children: [
                            DatePickerWidget(
                              looping: false,
                              lastDate: DateTime.now(),
                              firstDate: DateTime.now().subtract(
                                const Duration(days: 365),
                              ),
                              initialDate: _tempPickedDate!,
                              dateFormat: "dd-MM-yyyy",
                              onChange: (DateTime newDate, _) {
                                _tempPickedDate = newDate;
                              },
                              pickerTheme: const DateTimePickerTheme(
                                itemTextStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                                dividerColor: AppColors.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ).show();
                    },
                  ),
                  validator: (value) => Validators.validateText(context, value),
                ),
                const SizedBox(height: AppPadding.medium),
                TextFieldCustomLabel(label: S.of(context).DurationCycles),
                CustomTextFormField(
                  controller: cycleLengthController,
                  hintText: S.of(context).fill,
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      Validators.validateNumber(context, value),
                ),
                const SizedBox(height: AppPadding.medium),
                TextFieldCustomLabel(label: S.of(context).periodLength),
                CustomTextFormField(
                  controller: periodLengthController,
                  hintText: S.of(context).fill,
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      Validators.validateNumber(context, value),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
