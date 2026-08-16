import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_padding.dart';
import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/core/utils/validators.dart';
import 'package:elkawther/features/health_services/models/vaccines.dart';
import 'package:elkawther/core/widgets/custom_text_form_field.dart';
import 'package:elkawther/core/widgets/text_field_with_custom_label.dart';
import 'package:elkawther/features/health_services/widgets/health_service_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker_theme.dart';
import 'package:flutter_holo_date_picker/widget/date_picker_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:elkawther/features/health_services/screens/vaccines/noti/noti_methods.dart';

class VaccineScedule extends StatefulWidget {
  final List<FullVaccinesModel> upcomingVaccines;

  const VaccineScedule({super.key, required this.upcomingVaccines});

  @override
  State<VaccineScedule> createState() => _VaccineSceduleState();
}

class _VaccineSceduleState extends State<VaccineScedule> {
  final TextEditingController babyNameController = TextEditingController();
  final TextEditingController babyBirthController = TextEditingController();
  late DateTime _selectedDate;
  String? selectedGender;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _requestPermissionsOnStart();
  }

  Future<void> _requestPermissionsOnStart() async {
    if (await Permission.notification.isDenied ||
        await Permission.notification.isPermanentlyDenied) {
      await Permission.notification.request();
    }

    final isExactAlarmGranted = await isExactAlarmAllowed();
    if (!isExactAlarmGranted) {
      await requestExactAlarmPermissionIfNeeded();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return HealthServiceScaffold(
      title: S.of(context).vaccineSchedule,
      subtitle: isAr ? 'تذكير بمواعيد التطعيم' : 'Vaccine reminder setup',
      bottom: HealthPrimaryButton(
        title: S.of(context).add,
        onPressed: () async {
          if (babyNameController.text.trim().isEmpty ||
              selectedGender == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(S.of(context).requiredFeilds)),
            );
            return;
          }

          if (!context.mounted) return;
          Navigator.pushNamed(context, Routes.home);

          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).notificationsScheduled)),
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
                  validator: (value) => Validators.validateName(context, value),
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
                      onChanged: (value) =>
                          setState(() => selectedGender = value),
                    ),
                  ),
                ),
                const SizedBox(height: AppPadding.medium),
                TextFieldCustomLabel(label: S.of(context).dob),
                CustomTextFormField(
                  controller: babyBirthController,
                  hintText: S.of(context).datePeriods,
                  readOnly: true,
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
                        btnOkOnPress: () {
                          setState(() {
                            babyBirthController.text =
                                "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}";
                          });
                        },
                        body: DatePickerWidget(
                          looping: false,
                          firstDate: DateTime.now().subtract(
                            const Duration(days: 1000),
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

  int generateNotificationId(DateTime baseDate, int index) {
    return int.parse(
      '${baseDate.year}${baseDate.month.toString().padLeft(2, '0')}${baseDate.day.toString().padLeft(2, '0')}$index',
    );
  }
}
