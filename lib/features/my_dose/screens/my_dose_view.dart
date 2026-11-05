import 'package:elkawther/core/services/local_notifications.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/widgets/app_snack_bar.dart';
import 'package:elkawther/features/health_services/screens/vaccines/noti/noti_methods.dart';
import 'package:elkawther/features/my_dose/cubit/my_dose_cubit.dart';
import 'package:elkawther/features/my_dose/cubit/my_dose_state.dart';
import 'package:elkawther/features/my_dose/models/daily_medication_model.dart';
import 'package:elkawther/features/my_dose/models/medication_model.dart';
import 'package:elkawther/features/my_dose/models/time_model.dart';
import 'package:elkawther/features/my_dose/widgets/empty_dose.dart';
import 'package:elkawther/features/my_dose/widgets/medication_item.dart';
import 'package:elkawther/features/my_dose/widgets/my_dose_search_bar.dart';
import 'package:elkawther/features/my_dose/widgets/success_dose_dialog.dart';
import 'package:elkawther/features/my_dose/widgets/week_day_selector.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:text_search/text_search.dart';

const _weekdays = [
  'saturday',
  'sunday',
  'monday',
  'tuesday',
  'wednesday',
  'thursday',
  'friday',
];

const _dayIndexMap = {
  DateTime.saturday: 0,
  DateTime.sunday: 1,
  DateTime.monday: 2,
  DateTime.tuesday: 3,
  DateTime.wednesday: 4,
  DateTime.thursday: 5,
  DateTime.friday: 6,
};

class MyDoseView extends StatefulWidget {
  const MyDoseView({super.key});

  @override
  State<MyDoseView> createState() => _MyDoseViewState();
}

class _MyDoseViewState extends State<MyDoseView>
    with AutomaticKeepAliveClientMixin {
  int selectedDayIndex = 3;
  final TextEditingController searchController = TextEditingController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    selectedDayIndex = _dayIndexMap[DateTime.now().weekday] ?? 3;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<MedicationCubit>().fetchAllMedications();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  String get _selectedDay => _weekdays[selectedDayIndex];

  Future<void> _handleMarkAsTaken(
    MedicationModel medication,
    TimeModel timeModel,
  ) async {
    if (selectedDayIndex != _dayIndexMap[DateTime.now().weekday]) {
      AppSnackBar.warning(S.of(context).onlyUpdateToday);
      return;
    }

    final confirmed = await SuccessDoseDialog.show(
      context,
      medicineName: medication.name,
      timeLabel:
          timeModel.time.length >= 5
              ? timeModel.time.substring(0, 5)
              : timeModel.time,
    );
    if (!mounted || confirmed != true) return;

    final time =
        timeModel.time.length == 5 ? '${timeModel.time}:00' : timeModel.time;
    final success = await context.read<MedicationCubit>().updateMedicationLog(
      medicationId: medication.id,
      time: time,
      status: 'taken',
      shownDate:
          '${DateTime.now().year.toString().padLeft(4, '0')}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}',
    );
    if (!mounted || !success) return;

    AppSnackBar.success(S.of(context).the_dose_has_been_taken);
  }

  List<MedicationItem> _itemsFor(
    List<DailyMedicationModel> dailyMeds,
    String query,
  ) {
    final day = dailyMeds.where(
      (item) => item.day.toLowerCase() == _selectedDay,
    );
    final medications =
        day.isEmpty ? <MedicationModel>[] : day.first.medications;
    final items =
        medications
            .map(
              (medication) => MedicationItem(
                medication: medication,
                times: medication.times,
                name: medication.name,
                details: medication.notes ?? '',
                quantity: medication.quantityPerTime.toString(),
                image: medication.imagePath ?? '',
                selectedDayIndex: selectedDayIndex,
                onDeleteForToday: () async {
                  final removed = await context
                      .read<MedicationCubit>()
                      .removeMedicationFromDay(medication.id, _selectedDay);
                  if (!removed) return;
                  final allIds = await getNotificationIds(medication.name);
                  for (final time in medication.times) {
                    final id = safeNotificationId(
                      time.id + time.time.hashCode + _selectedDay.hashCode,
                    );
                    if (allIds.contains(id)) {
                      await flutterLocalNotificationsPlugin.cancel(id);
                      await removeNotificationId(medication.name, id);
                    }
                  }
                },
                onDeleteAll: () async {
                  final deleted = await context
                      .read<MedicationCubit>()
                      .deleteMedication(medication.id);
                  if (deleted) {
                    await cancelNotificationsForMedicine(medication.name);
                  }
                },
                onMarkAsTaken: (time) => _handleMarkAsTaken(medication, time),
              ),
            )
            .toList();

    final trimmed = query.trim();
    if (trimmed.isEmpty) return items;
    final search = TextSearch(
      items
          .map(
            (item) => TextSearchItem(item, [
              TextSearchItemTerm(item.name),
              TextSearchItemTerm(item.details),
            ]),
          )
          .toList(),
    );
    return search.search(trimmed).map((result) => result.object).toList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: const Color(0xFFF5FAFD),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).myDose,
                  style: AppTextStyles.noto16w400.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isAr
                      ? 'تتبع أدويتك اليومية بسهولة'
                      : 'Track your daily medications easily',
                  style: AppTextStyles.noto14w400.copyWith(
                    color: AppColors.grey,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 16),
                MyDoseSearchBar(
                  controller: searchController,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 14),
                WeekDaySelector(
                  selectedIndex: selectedDayIndex,
                  onSelect: (index) {
                    setState(() => selectedDayIndex = index);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<MedicationCubit, MedicationState>(
              builder: (context, state) {
                final cubit = context.read<MedicationCubit>();
                if (state is MedicationLoading && cubit.dailyMeds.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is MedicationError && cubit.dailyMeds.isEmpty) {
                  return _LoadError(
                    message: state.msg.localizedMessage(context),
                    onRetry: cubit.fetchAllMedications,
                  );
                }

                final items = _itemsFor(cubit.dailyMeds, searchController.text);
                if (items.isEmpty) return const EmptyDose();
                return Stack(
                  children: [
                    ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
                      itemCount: items.length,
                      itemBuilder: (context, index) => items[index],
                    ),
                    if (state is MedicationLoading)
                      const Align(
                        alignment: Alignment.topCenter,
                        child: LinearProgressIndicator(minHeight: 2),
                      ),
                    if (state is MedicationError)
                      Align(
                        alignment: Alignment.topCenter,
                        child: Material(
                          color: Colors.red.shade50,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              state.msg.localizedMessage(context),
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off_rounded, size: 44, color: Colors.grey),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: onRetry, child: Text(S.of(context).retry)),
        ],
      ),
    ),
  );
}
