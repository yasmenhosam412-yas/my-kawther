import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/core/widgets/custom_text_form_field.dart';
import 'package:elkawther/core/widgets/text_field_with_custom_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker_theme.dart';
import 'package:flutter_holo_date_picker/widget/date_picker_widget.dart';

import 'package:elkawther/features/health_services/data/health_local_calc.dart';
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

  @override
  void initState() {
    super.initState();
    _tempPickedDate = DateTime.now();
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
    return HealthServiceScaffold(
      title: S.of(context).pregnancy_calculator,
      subtitle: isAr ? 'متابعة الحمل والأسبوع' : 'Pregnancy week tracker',
      bottom: HealthPrimaryButton(
        title: S.of(context).calc,
        onPressed: () {
          if (selectedDate == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(S.of(context).selectDate)),
            );
            return;
          }
          final result = HealthLocalCalc.pregnancy(selectedDate!);
          Navigator.pushReplacementNamed(
            context,
            Routes.pregnancyTest,
            arguments: result.result,
          );
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
