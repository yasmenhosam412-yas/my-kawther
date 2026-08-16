import 'dart:io';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/toasts/toasts.dart';
import 'package:elkawther/features/my_dose/data/dose_local_store.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/features/my_dose/models/medication_model.dart';
import 'package:elkawther/features/my_dose/models/time_model.dart';
import 'package:elkawther/features/health_services/screens/vaccines/noti/noti_methods.dart';
import 'package:elkawther/core/widgets/custom_text_form_field.dart';
import 'package:elkawther/features/my_dose/widgets/row_image_dose.dart';
import 'package:elkawther/core/widgets/show_error.dart';
import 'package:elkawther/core/widgets/text_field_with_custom_label.dart';

class AddDoseView extends StatefulWidget {
  final List<TimeModel>? times;
  final String? name;
  final String? details;
  final String? quantity;
  final MedicationModel? medication;
  final String? image;
  final bool isEdit;
  final int? medicineId;

  const AddDoseView({
    super.key,
    this.times,
    this.name,
    this.details,
    this.quantity,
    this.medication,
    this.image,
    required this.isEdit,
    this.medicineId,
  });

  @override
  State<AddDoseView> createState() => _AddDoseViewState();
}

class _AddDoseViewState extends State<AddDoseView> {
  late TextEditingController _nameController;
  late TextEditingController _notesController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int doseQuantity = 1;
  int? selectedReminderIndex;
  final List<TimeOfDay> selectedTimes = [];
  final List<String> selectedWeekDays = [];

  File? selectedImage;
  String? _imageUrl;
  bool removeImageFlag = false;
  int? baseId;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name ?? '');
    _notesController = TextEditingController(text: widget.details ?? '');
    doseQuantity = int.tryParse(widget.quantity ?? '1') ?? 1;

    if (widget.times != null) {
      selectedTimes.addAll(
        widget.times!.map(
          (time) => TimeOfDay.fromDateTime(parseTimeString(time.time)),
        ),
      );
    }

    selectedReminderIndex = _mapRepeatTypeToIndex(
      widget.medication?.repeatType,
    );
    if (widget.medication?.days != null) {
      selectedWeekDays.addAll(widget.medication!.days);
    }

    _imageUrl = widget.image;

    requestPermissionsOnStart();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
        removeImageFlag = false;
      });
    }
  }

  void removeImage() {
    setState(() {
      selectedImage = null;
      _imageUrl = null;
      removeImageFlag = true;
    });
  }

  Future<void> addTime() async {
    FocusScope.of(context).unfocus();
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) setState(() => selectedTimes.add(time));
    if (!mounted) return;
    FocusScope.of(context).requestFocus(FocusNode());
  }

  void removeTime(TimeOfDay time) => setState(() => selectedTimes.remove(time));

  void toggleWeekDay(String day) {
    setState(() {
      if (selectedReminderIndex == 0) {
        selectedWeekDays
          ..clear()
          ..add(day);
      } else if (selectedReminderIndex == 2) {
        selectedWeekDays.contains(day)
            ? selectedWeekDays.remove(day)
            : selectedWeekDays.add(day);
      }
    });
  }

  int _mapRepeatTypeToIndex(String? repeatType) {
    switch (repeatType) {
      case 'once':
        return 0;
      case 'every_day':
        return 1;
      case 'specific_days':
        return 2;
      default:
        return 1;
    }
  }

  String _getRepeatTypeValue(int? index) {
    switch (index) {
      case 0:
        return 'once';
      case 1:
        return 'every_day';
      case 2:
        return 'specific_days';
      default:
        return 'once';
    }
  }

  String formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return TimeOfDay.fromDateTime(dt).format(context);
  }

  DateTime parseTimeString(String timeStr) {
    final parts = timeStr.split(':');
    final now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
      parts.length > 2 ? int.parse(parts[2]) : 0,
    );
  }

  bool _validateForm() {
    if (!_formKey.currentState!.validate()) return false;
    if (_nameController.text.trim().isEmpty) {
      showErrorDialog(S.of(context).errorEnterMedicineName, context);
      return false;
    }
    if (selectedTimes.isEmpty) {
      showErrorDialog(S.of(context).errorAddTime, context);
      return false;
    }
    if ((selectedReminderIndex == 0 || selectedReminderIndex == 2) &&
        selectedWeekDays.isEmpty) {
      showErrorDialog(
        selectedReminderIndex == 0
            ? S.of(context).errorSelectOnceDay
            : S.of(context).errorSelectSpecificDays,
        context,
      );
      return false;
    }
    return true;
  }

  Future<void> _saveMedication() async {
    if (!_validateForm()) return;

    final medicineName = _nameController.text.trim();
    final notes = _notesController.text.trim();
    final medName =
        medicineName.isNotEmpty ? medicineName : S.of(context).unnamedMedicine;
    final times = selectedTimes
        .map(
          (time) =>
              '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00',
        )
        .toList();
    final daysToSend = selectedReminderIndex == 1
        ? [
            'saturday',
            'sunday',
            'monday',
            'tuesday',
            'wednesday',
            'thursday',
            'friday',
          ]
        : List<String>.from(selectedWeekDays);
    final imagePath = selectedImage?.path ?? _imageUrl;

    MedicationModel? saved;
    if (widget.isEdit && widget.medicineId != null) {
      saved = DoseLocalStore.instance.update(
        id: widget.medicineId!,
        name: medName,
        notes: notes,
        imagePath: imagePath,
        quantityPerTime: doseQuantity,
        repeatType: _getRepeatTypeValue(selectedReminderIndex),
        days: daysToSend,
        times: times,
      );
      await cancelNotificationsForMedicine(medicineName);
    } else {
      saved = DoseLocalStore.instance.add(
        name: medName,
        notes: notes,
        imagePath: imagePath,
        quantityPerTime: doseQuantity,
        repeatType: _getRepeatTypeValue(selectedReminderIndex),
        days: daysToSend,
        times: times,
      );
    }

    if (!mounted || saved == null) return;
    final l10n = S.of(context);
    for (final timeModel in saved.times) {
      final parts = timeModel.time.split(':');
      final time = TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
      for (final day in daysToSend) {
        final notificationId = safeNotificationId(
          timeModel.id + timeModel.time.hashCode + day.hashCode,
        );
        await scheduleNotificationBasedOnLocation(
          id: notificationId,
          title: "${l10n.timeToTakeYourMedicine} : $medicineName",
          body:
              "${l10n.take} $doseQuantity ${l10n.dose} , ${l10n.note}: $notes",
          dateTime: _nextInstanceOfWeekday(time, day),
          channelId: 'medication_channel',
          channelName: 'Medication Reminders',
          channelDescription: 'Reminders for your medications',
        );
        await saveNotificationId(medName, notificationId);
      }
    }

    if (!mounted) return;
    ToastMessage().displayMessageToast(
      widget.isEdit
          ? S.of(context).medicineEditedSuccessfully
          : S.of(context).aNewMedicineHasBeenSuccessfullyAdded,
      AppColors.teal,
    );
    if (mounted) Navigator.of(context).pop();
  }

  // Future<void> scheduleMedicationNotifications({
  //   required int baseId,
  //   required String medicineName,
  //   required int doseQuantity,
  //   required String notes,
  //   required List<TimeOfDay> times,
  //   required int repeatIndex,
  //   required List<String> weekdays,
  // }) async {
  //   if (times.isEmpty) return;
  //
  //   for (int i = 0; i < times.length; i++) {
  //     final time = times[i];
  //
  //     if (Platform.isAndroid) {
  //       bool allowed = await isExactAlarmAllowed();
  //       if (!allowed) {
  //         await requestExactAlarmPermissionIfNeeded();
  //         allowed = await isExactAlarmAllowed();
  //       }
  //       if (!allowed) {
  //         debugPrint("❌ Exact alarms not permitted, skipping notification.");
  //         continue;
  //       }
  //     }
  //
  //     if (repeatIndex == 0) {
  //       final day = weekdays.isNotEmpty ? weekdays.first : 'monday';
  //       final scheduleDate = _nextInstanceOfWeekday(time, day);
  //
  //       await scheduleNotificationBasedOnLocation(
  //         id: baseId,
  //         title: "${S.of(context).timeToTakeYourMedicine} : $medicineName",
  //         body:
  //             "${S.of(context).take} $doseQuantity ${S.of(context).dose} , ${S.of(context).note}: $notes",
  //         dateTime: scheduleDate,
  //         channelId: "medication_reminder",
  //         channelName: "Medication Reminders",
  //         channelDescription: "Reminders to take your medication",
  //       );
  //     } else if (repeatIndex == 1) {
  //       var now = DateTime.now();
  //       var scheduleDate = DateTime(
  //         now.year,
  //         now.month,
  //         now.day,
  //         time.hour,
  //         time.minute,
  //       );
  //       if (scheduleDate.isBefore(now)) {
  //         scheduleDate = scheduleDate.add(const Duration(days: 1));
  //       }
  //
  //       await scheduleNotificationBasedOnLocation(
  //         id: baseId,
  //         title: "${S.of(context).timeToTakeYourMedicine} : $medicineName",
  //         body:
  //             "${S.of(context).take} $doseQuantity ${S.of(context).dose} , ${S.of(context).note}: $notes",
  //         dateTime: scheduleDate,
  //         channelId: "medication_reminder",
  //         channelName: "Medication Reminders",
  //         channelDescription: "Reminders to take your medication",
  //       );
  //     } else if (repeatIndex == 2) {
  //       for (final day in weekdays) {
  //         final scheduleDate = _nextInstanceOfWeekday(time, day);
  //         final daySafeId = safeNotificationId(baseId + day.hashCode);
  //
  //         await scheduleNotificationBasedOnLocation(
  //           id: daySafeId,
  //           title: "${S.of(context).timeToTakeYourMedicine} : $medicineName",
  //           body:
  //               "${S.of(context).take} $doseQuantity ${S.of(context).dose} , ${S.of(context).note}: $notes",
  //           dateTime: scheduleDate,
  //           channelId: "medication_reminder",
  //           channelName: "Medication Reminders",
  //           channelDescription: "Reminders to take your medication",
  //         );
  //       }
  //     }
  //   }
  // }

  DateTime _nextInstanceOfWeekday(TimeOfDay time, String weekdayStr) {
    final now = DateTime.now();

    final weekdays = {
      'monday': DateTime.monday,
      'tuesday': DateTime.tuesday,
      'wednesday': DateTime.wednesday,
      'thursday': DateTime.thursday,
      'friday': DateTime.friday,
      'saturday': DateTime.saturday,
      'sunday': DateTime.sunday,
    };

    int targetWeekday = weekdays[weekdayStr.toLowerCase()]!;

    DateTime scheduled = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    int daysDifference = targetWeekday - now.weekday;

    if (daysDifference < 0) {
      daysDifference += 7;
    }

    if (daysDifference == 0 && scheduled.isBefore(now)) {
      daysDifference = 7;
    }

    scheduled = scheduled.add(Duration(days: daysDifference));

    return scheduled;
  }

  @override
  Widget build(BuildContext context) {
    final reminderOptions = [
      S.of(context).onceReminder,
      S.of(context).dailyReminder,
      S.of(context).specificDaysReminder,
    ];

    final weekDaysMap = {
      'saturday': S.of(context).saturday,
      'sunday': S.of(context).sunday,
      'monday': S.of(context).monday,
      'tuesday': S.of(context).tuesday,
      'wednesday': S.of(context).wednesday,
      'thursday': S.of(context).thursday,
      'friday': S.of(context).friday,
    };

    return Scaffold(
      backgroundColor: const Color(0xFFF5FAFD),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(8, 8, 20, 18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primaryColor.withOpacity(0.16),
                  AppColors.light,
                  const Color(0xFFF5FAFD),
                ],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18,
                      color: AppColors.darkColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.isEdit
                              ? S.of(context).editMedicne
                              : S.of(context).addNewMedicine,
                          style: AppTextStyles.noto16w400.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.darkColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          Localizations.localeOf(context).languageCode == 'ar'
                              ? 'أدخل تفاصيل الجرعة والوقت'
                              : 'Enter dose details and reminder time',
                          style: AppTextStyles.noto14w400.copyWith(
                            fontSize: 12,
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                children: [
                  _DoseCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFieldCustomLabel(label: S.of(context).name2),
                        CustomTextFormField(
                          controller: _nameController,
                          hintText: S.of(context).nameOfMedicine,
                          validator: (value) =>
                              (value == null || value.trim().isEmpty)
                              ? S.of(context).errorEnterMedicineName
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFieldCustomLabel(label: S.of(context).notes),
                        CustomTextFormField(
                          controller: _notesController,
                          hintText: S.of(context).AddNotes,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 16),
                        RowImage(
                          imageUrl: _imageUrl ?? '',
                          selectedImage: selectedImage,
                          onPickImage: pickImage,
                          onRemoveImage: removeImage,
                          removeImageFlag: removeImageFlag,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _DoseCard(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            S.of(context).quantityPerTime,
                            style: AppTextStyles.noto14w400.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.darkColor,
                            ),
                          ),
                        ),
                        _QtyButton(
                          icon: Icons.remove_rounded,
                          onTap: () {
                            if (doseQuantity > 1) {
                              setState(() => doseQuantity--);
                            }
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            '$doseQuantity',
                            style: AppTextStyles.noto16w400.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.darkColor,
                            ),
                          ),
                        ),
                        _QtyButton(
                          icon: Icons.add_rounded,
                          onTap: () => setState(() => doseQuantity++),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _DoseCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                S.of(context).medicationSchedules,
                                style: AppTextStyles.noto14w400.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.darkColor,
                                ),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: addTime,
                              icon: const Icon(
                                Icons.add_rounded,
                                size: 18,
                                color: AppColors.primaryColor,
                              ),
                              label: Text(
                                S.of(context).addNewTime,
                                style: AppTextStyles.noto14w400.copyWith(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (selectedTimes.isEmpty)
                          Text(
                            Localizations.localeOf(context).languageCode == 'ar'
                                ? 'أضف وقتاً واحداً على الأقل'
                                : 'Add at least one reminder time',
                            style: AppTextStyles.noto14w400.copyWith(
                              color: AppColors.grey,
                              fontSize: 12,
                            ),
                          )
                        else
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: selectedTimes
                                .map(
                                  (time) => InputChip(
                                    backgroundColor: AppColors.light,
                                    label: Text(
                                      formatTime(time),
                                      style: AppTextStyles.noto14w400.copyWith(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                    deleteIcon: const Icon(
                                      Icons.close_rounded,
                                      size: 16,
                                      color: AppColors.grey,
                                    ),
                                    onDeleted: () => removeTime(time),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      side: const BorderSide(
                                        color: AppColors.lightDarker,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _DoseCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).repeatAlert,
                          style: AppTextStyles.noto14w400.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.darkColor,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: List.generate(reminderOptions.length, (
                            index,
                          ) {
                            final selected = selectedReminderIndex == index;
                            return ChoiceChip(
                              label: Text(reminderOptions[index]),
                              selected: selected,
                              onSelected: (_) {
                                setState(() {
                                  selectedReminderIndex = index;
                                  if (index == 0) selectedWeekDays.clear();
                                  if (index == 1) selectedWeekDays.clear();
                                });
                              },
                              selectedColor: AppColors.teal,
                              backgroundColor: AppColors.light,
                              labelStyle: AppTextStyles.noto14w400.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: selected
                                    ? Colors.white
                                    : AppColors.darkColor,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color: selected
                                      ? AppColors.teal
                                      : AppColors.lightDarker,
                                ),
                              ),
                              showCheckmark: false,
                            );
                          }),
                        ),
                        if (selectedReminderIndex == 0 ||
                            selectedReminderIndex == 2) ...[
                          const SizedBox(height: 14),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: weekDaysMap.entries.map((entry) {
                              final selected = selectedWeekDays.contains(
                                entry.key,
                              );
                              return ChoiceChip(
                                label: Text(entry.value),
                                selected: selected,
                                onSelected: (_) => toggleWeekDay(entry.key),
                                selectedColor: AppColors.primaryColor,
                                backgroundColor: Colors.white,
                                labelStyle: AppTextStyles.noto14w400.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: selected
                                      ? Colors.white
                                      : AppColors.darkColor,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                    color: selected
                                        ? AppColors.primaryColor
                                        : AppColors.lightDarker,
                                  ),
                                ),
                                showCheckmark: false,
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _saveMedication,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    widget.isEdit ? S.of(context).edit : S.of(context).save,
                    style: AppTextStyles.noto14w400.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DoseCard extends StatelessWidget {
  const _DoseCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _QtyButton extends StatelessWidget {
  const _QtyButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.light,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(icon, size: 18, color: AppColors.primaryColor),
        ),
      ),
    );
  }
}
