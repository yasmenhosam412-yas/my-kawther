import 'package:elkawther/core/toasts/toasts.dart';
import 'package:elkawther/core/services/local_notifications.dart';
import 'package:elkawther/features/my_dose/data/dose_local_store.dart';
import 'package:flutter/material.dart';
import 'package:text_search/text_search.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/features/my_dose/models/medication_model.dart';
import 'package:elkawther/features/my_dose/models/time_model.dart';
import 'package:elkawther/features/health_services/screens/vaccines/noti/noti_methods.dart';
import 'package:elkawther/features/my_dose/widgets/empty_dose.dart';
import 'package:elkawther/features/my_dose/widgets/medication_item.dart';
import 'package:elkawther/features/my_dose/widgets/my_dose_search_bar.dart';
import 'package:elkawther/features/my_dose/widgets/week_day_selector.dart';
import 'package:elkawther/features/my_dose/widgets/success_dose_dialog.dart';

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
  final _store = DoseLocalStore.instance;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    selectedDayIndex = _dayIndexMap[DateTime.now().weekday] ?? 3;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  String _getWeekdayByIndex(int index) {
    const weekdays = [
      'saturday',
      'sunday',
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
    ];
    return weekdays[index];
  }

  Future<void> _handleMarkAsTaken(
    MedicationModel medication,
    TimeModel timeModel,
  ) async {
    final todayIndex = _dayIndexMap[DateTime.now().weekday];

    if (selectedDayIndex != todayIndex) {
      if (mounted) {
        ToastMessage().displayMessageToast(
          S.of(context).onlyUpdateToday,
          AppColors.primaryColor,
        );
      }
      return;
    }

    final confirmed = await SuccessDoseDialog.show(
      context,
      medicineName: medication.name,
      timeLabel: timeModel.time.length >= 5
          ? timeModel.time.substring(0, 5)
          : timeModel.time,
    );

    if (confirmed != true) return;
    _store.markTaken(medicationId: medication.id, timeId: timeModel.id);
  }

  List<MedicationItem> _itemsFor(String query) {
    final dayName = _getWeekdayByIndex(selectedDayIndex);
    final medications = _store.forDay(dayName);
    final items = medications
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
              _store.removeFromDay(medication.id, dayName);
              final allIds = await getNotificationIds(medication.name);
              for (final time in medication.times) {
                final notifId = safeNotificationId(
                  time.id + time.time.hashCode + dayName.hashCode,
                );
                if (allIds.contains(notifId)) {
                  await flutterLocalNotificationsPlugin.cancel(notifId);
                  await removeNotificationId(medication.name, notifId);
                }
              }
            },
            onDeleteAll: () async {
              _store.deleteAll(medication.id);
              await cancelNotificationsForMedicine(medication.name);
            },
            onMarkAsTaken: (timeModel) =>
                _handleMarkAsTaken(medication, timeModel),
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
            child: ListenableBuilder(
              listenable: _store,
              builder: (context, _) {
                final items = _itemsFor(searchController.text);
                if (items.isEmpty) return const EmptyDose();
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
                  itemCount: items.length,
                  itemBuilder: (context, index) => items[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
