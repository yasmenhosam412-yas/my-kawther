import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:elkawther/features/health_services/data/health_local_calc.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_padding.dart';
import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/core/utils/validators.dart';
import 'package:elkawther/core/widgets/custom_text_form_field.dart';
import 'package:elkawther/core/widgets/text_field_with_custom_label.dart';
import 'package:elkawther/features/health_services/widgets/health_service_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker_theme.dart';
import 'package:flutter_holo_date_picker/widget/date_picker_widget.dart';

class VaccineCalc extends StatefulWidget {
  const VaccineCalc({super.key});

  @override
  State<VaccineCalc> createState() => _VaccineCalcState();
}

class _VaccineCalcState extends State<VaccineCalc> {
  final TextEditingController babyNameController = TextEditingController();
  final TextEditingController babyBirthController = TextEditingController();
  late DateTime _selectedDate;
  String? selectedGender;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return HealthServiceScaffold(
      title: S.of(context).addChild,
      subtitle: isAr ? 'أضف طفلاً لجدول التطعيمات' : 'Add a child to the schedule',
      bottom: HealthPrimaryButton(
        title: S.of(context).add,
        onPressed: () {
          if (babyNameController.text.isEmpty ||
              selectedGender == null ||
              babyBirthController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(S.of(context).requiredFeilds)),
            );
            return;
          }

          final child = HealthLocalCalc.child(
            name: babyNameController.text,
            gender: selectedGender!,
            birthDate: _selectedDate,
          );
          HealthLocalStore.instance.addChild(child);
          Navigator.pushReplacementNamed(
            context,
            Routes.vaccinesTest,
            arguments: {'child': child},
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
                TextFieldCustomLabel(label: S.of(context).babyName),
                CustomTextFormField(
                  controller: babyNameController,
                  hintText: S.of(context).babyNameEnter,
                  keyboardType: TextInputType.name,
                  validator: (value) => Validators.validateEmail(context, value),
                ),
                const SizedBox(height: AppPadding.medium),
                TextFieldCustomLabel(label: S.of(context).gender),
                HealthDropdownBox(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selectedGender,
                      hint: Text(S.of(context).enterGender),
                      items: [
                        DropdownMenuItem(
                          value: 'ذكر',
                          child: Text(S.of(context).male),
                        ),
                        DropdownMenuItem(
                          value: 'أنثى',
                          child: Text(S.of(context).female),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: AppPadding.medium),
                TextFieldCustomLabel(label: S.of(context).dob),
                CustomTextFormField(
                  controller: babyBirthController,
                  hintText: S.of(context).datePeriods,
                  readOnly: true,
                  keyboardType: TextInputType.datetime,
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.calendar_month,
                      color: AppColors.primaryColor,
                    ),
                    onPressed: () {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.noHeader,
                        animType: AnimType.rightSlide,
                        btnCancelText: S.of(context).cancel,
                        btnCancelOnPress: () {},
                        btnOkText: S.of(context).confirm,
                        btnOkOnPress: () => setState(() {
                          babyBirthController.text =
                              "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}";
                        }),
                        body: DatePickerWidget(
                          looping: false,
                          firstDate: DateTime.now().subtract(
                            const Duration(days: 2500),
                          ),
                          lastDate: DateTime.now(),
                          initialDate: _selectedDate,
                          dateFormat: "dd-MM-yyyy",
                          onChange: (newDate, _) => _selectedDate = newDate,
                          pickerTheme: const DateTimePickerTheme(
                            itemTextStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                            dividerColor: AppColors.primaryColor,
                          ),
                        ),
                      ).show();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
