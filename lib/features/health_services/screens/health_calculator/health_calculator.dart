import 'package:easy_localization/easy_localization.dart';
import 'package:elkawther/core/widgets/app_snack_bar.dart';
import 'package:elkawther/features/health_services/cubit/health_service_cubit.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:elkawther/core/widgets/custom_text_form_field.dart';
import 'package:elkawther/core/widgets/text_field_with_custom_label.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_holo_date_picker/date_picker_theme.dart';
import 'package:flutter_holo_date_picker/widget/date_picker_widget.dart';

import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_padding.dart';
import 'package:elkawther/core/utils/validators.dart';
import 'package:elkawther/features/health_services/data/health_local_calc.dart';
import 'package:elkawther/features/health_services/models/monthly_period_calc_model.dart';
import 'package:elkawther/features/health_services/widgets/health_service_scaffold.dart';
import 'dart:convert';

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
  bool _checkingSaved = true;

  @override
  void initState() {
    super.initState();
    _openSavedResult();
  }

  Future<void> _openSavedResult() async {
    final saved = await SavedPeriod.read();
    if (!mounted) return;
    if (saved != null) {
      Navigator.pushReplacementNamed(
        context,
        Routes.healthTest,
        arguments: saved,
      );
      return;
    }
    setState(() => _checkingSaved = false);
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    if (_checkingSaved) {
      return HealthServiceScaffold(
        title: S.of(context).ovulation_calculator,
        subtitle: isAr ? 'حاسبة الدورة والخصوبة' : 'Cycle and fertility tracker',
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return HealthServiceScaffold(
      title: S.of(context).ovulation_calculator,
      subtitle: isAr ? 'حاسبة الدورة والخصوبة' : 'Cycle and fertility tracker',
      bottom: HealthPrimaryButton(
        title: S.of(context).calc,
        onPressed: () async {
          try {
            final start = DateTime.parse(lastPeriodDate.text.trim());
            final cycleLengthInt = int.parse(cycleLengthController.text.trim());
            final periodLengthInt = int.parse(
              periodLengthController.text.trim(),
            );
            final startText = DateFormat('yyyy-MM-dd', 'en').format(start);
            final cubit = context.read<HealthServiceCubit>();
            await cubit.fetchPeriodData(
              startDayOfCycle: startText,
              cycleLength: cycleLengthInt,
              periodLength: periodLengthInt,
              context: context,
            );
            if (!context.mounted) return;
            final state = cubit.state;
            if (state is HealthServicesPeriodLoaded) {
              await SavedPeriod.save(
                start: startText,
                cycleLength: cycleLengthInt,
                periodLength: periodLengthInt,
              );
              if (!context.mounted) return;
              Navigator.pushReplacementNamed(
                context,
                Routes.healthTest,
                arguments: state.monthlyPeriodCalc,
              );
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
                  validator:
                      (value) => Validators.validateNumber(context, value),
                ),
                const SizedBox(height: AppPadding.medium),
                TextFieldCustomLabel(label: S.of(context).periodLength),
                CustomTextFormField(
                  controller: periodLengthController,
                  hintText: S.of(context).fill,
                  keyboardType: TextInputType.number,
                  validator:
                      (value) => Validators.validateNumber(context, value),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SavedPeriod {
  static const _key = 'saved_period_inputs';

  static Future<void> save({
    required String start,
    required int cycleLength,
    required int periodLength,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode({
        'start': start,
        'cycle': cycleLength,
        'period': periodLength,
      }),
    );
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  static Future<MonthlyPeriodCalc?> read() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    if (saved == null) return null;
    try {
      final json = jsonDecode(saved);
      if (json is! Map) return null;
      final start = HealthLocalCalc.parseDate(json['start']?.toString() ?? '');
      final cycle = int.tryParse('${json['cycle']}');
      final period = int.tryParse('${json['period']}');
      if (start == null || cycle == null || period == null || cycle <= 0) {
        return null;
      }
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      var cycleStart = DateTime(start.year, start.month, start.day);
      if (!today.isBefore(cycleStart)) {
        final cyclesPassed = today.difference(cycleStart).inDays ~/ cycle;
        cycleStart = cycleStart.add(Duration(days: cyclesPassed * cycle));
      }
      return HealthLocalCalc.period(
        startDay: cycleStart,
        cycleLength: cycle,
        periodLength: period,
      );
    } catch (_) {
      return null;
    }
  }
}
