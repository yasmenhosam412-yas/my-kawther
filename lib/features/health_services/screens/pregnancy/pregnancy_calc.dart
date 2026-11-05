import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:elkawther/core/widgets/app_snack_bar.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/core/widgets/custom_text_form_field.dart';
import 'package:elkawther/core/widgets/text_field_with_custom_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_holo_date_picker/date_picker_theme.dart';
import 'package:flutter_holo_date_picker/widget/date_picker_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:elkawther/features/health_services/cubit/health_service_cubit.dart';
import 'package:elkawther/features/health_services/data/health_local_calc.dart';
import 'package:elkawther/features/health_services/models/pregnancy_calc_model.dart';
import 'package:elkawther/features/health_services/widgets/health_service_scaffold.dart';

class PregnancyCalc extends StatefulWidget {
  const PregnancyCalc({super.key});

  @override
  State<PregnancyCalc> createState() => _PregnancyCalcState();
}

class _PregnancyCalcState extends State<PregnancyCalc> {
  final TextEditingController controller = TextEditingController();
  DateTime? selectedDate;
  DateTime? _tempPickedDate;
  bool _checkingSaved = true;

  @override
  void initState() {
    super.initState();
    _tempPickedDate = DateTime.now();
    _openSavedResult();
  }

  Future<void> _openSavedResult() async {
    final saved = await SavedPregnancy.read();
    if (!mounted) return;
    if (saved != null) {
      Navigator.pushReplacementNamed(
        context,
        Routes.pregnancyTest,
        arguments: saved,
      );
      return;
    }
    setState(() => _checkingSaved = false);
  }

  void _showDatePicker(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.rightSlide,
      btnCancelText: S.of(context).cancel,
      btnCancelOnPress: () {},
      btnOkText: S.of(context).confirm,
      btnOkOnPress: () {
        if (_tempPickedDate != null) {
          setState(() {
            selectedDate = _tempPickedDate;
            controller.text = DateFormat(
              'yyyy-MM-dd',
              'en',
            ).format(_tempPickedDate!);
          });
        }
      },
      body: Column(
        children: [
          DatePickerWidget(
            looping: false,
            lastDate: DateTime.now(),
            firstDate: DateTime.now().subtract(const Duration(days: 500)),
            initialDate: _tempPickedDate!,
            dateFormat: "dd-MM-yyyy",
            onChange: (DateTime newDate, _) {
              _tempPickedDate = newDate;
            },
            pickerTheme: const DateTimePickerTheme(
              itemTextStyle: TextStyle(color: Colors.black, fontSize: 20),
              dividerColor: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    if (_checkingSaved) {
      return HealthServiceScaffold(
        title: S.of(context).pregnancy_calculator,
        subtitle: isAr ? 'متابعة الحمل والأسبوع' : 'Pregnancy week tracker',
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return HealthServiceScaffold(
      title: S.of(context).pregnancy_calculator,
      subtitle: isAr ? 'متابعة الحمل والأسبوع' : 'Pregnancy week tracker',
      bottom: HealthPrimaryButton(
        title: S.of(context).calc,
        onPressed: () async {
          if (selectedDate == null) {
            AppSnackBar.warning(S.of(context).selectDate);
            return;
          }
          final lastPeriodDate =
              DateFormat('yyyy-MM-dd', 'en').format(selectedDate!);
          final cubit = context.read<HealthServiceCubit>();
          await cubit.fetchPregnancyCalcData(
            lastPeriodDate: lastPeriodDate,
            context: context,
          );
          if (!context.mounted) return;
          final state = cubit.state;
          if (state is HealthServicesPreganacyLoaded) {
            await SavedPregnancy.save(
              lastPeriodDate,
              state.pregnancyCalc.result,
            );
            if (!context.mounted) return;
            Navigator.pushReplacementNamed(
              context,
              Routes.pregnancyTest,
              arguments: state.pregnancyCalc.result,
            );
          } else if (state is HealthServicesError) {
            AppSnackBar.error(state.message.message);
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
                  controller: controller,
                  hintText: S.of(context).datePeriods,
                  readOnly: true,
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.calendar_month,
                      color: AppColors.primaryColor,
                    ),
                    onPressed: () => _showDatePicker(context),
                  ),
                  validator: (_) => null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SavedPregnancy {
  static const _dateKey = 'saved_pregnancy_last_period';
  static const _resultKey = 'saved_pregnancy_result';

  static Future<void> save(
    String lastPeriodDate,
    PregnancyResultModel result,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_dateKey, lastPeriodDate);
    await prefs.setString(_resultKey, jsonEncode(result.toJson()));
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_dateKey);
    await prefs.remove(_resultKey);
  }

  static Future<PregnancyResultModel?> read() async {
    final prefs = await SharedPreferences.getInstance();
    final date = HealthLocalCalc.parseDate(prefs.getString(_dateKey) ?? '');
    if (date == null) return null;

    final fresh = HealthLocalCalc.pregnancy(date).result;
    final raw = prefs.getString(_resultKey);
    if (raw == null) return fresh;

    try {
      final saved = PregnancyResultModel.fromJson(
        Map<String, dynamic>.from(jsonDecode(raw) as Map),
      );
      if (saved.currentWeek != fresh.currentWeek) return fresh;
      return PregnancyResultModel(
        lastPeriodDate: _text(saved.lastPeriodDate, fresh.lastPeriodDate),
        dueDate: _text(saved.dueDate, fresh.dueDate),
        currentWeek: fresh.currentWeek,
        currentDay: fresh.currentDay,
        monthInfo: _text(saved.monthInfo, fresh.monthInfo),
        babySize: _text(saved.babySize, fresh.babySize),
        babyWeight: _text(saved.babyWeight, fresh.babyWeight),
        babyLength: _text(saved.babyLength, fresh.babyLength),
        imageStage: saved.imageStage == 0 ? fresh.imageStage : saved.imageStage,
      );
    } catch (_) {
      return fresh;
    }
  }

  static String _text(String value, String fallback) {
    final text = value.trim();
    return text.isEmpty ? fallback : text;
  }
}
