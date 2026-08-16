import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/core/toasts/toasts.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/features/health_services/data/health_local_calc.dart';
import 'package:elkawther/features/health_services/widgets/health_service_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/features/health_services/models/vaccines.dart';
import 'package:elkawther/features/health_services/screens/vaccines/noti/noti_methods.dart';

class VaccineResult extends StatefulWidget {
  final Child child;

  const VaccineResult({super.key, required this.child});

  @override
  State<VaccineResult> createState() => _VaccineResultState();
}

class _VaccineResultState extends State<VaccineResult> {
  late Child _child;

  @override
  void initState() {
    super.initState();
    _child = HealthLocalStore.instance.childById(widget.child.id) ?? widget.child;
    requestPermissionsOnStart();
  }

  void _complete(int vaccineId) {
    if (_child.vaccines.any((v) => v.id == vaccineId && v.isCompleted)) return;
    setState(() {
      _child = HealthLocalStore.instance.completeVaccine(
        childId: _child.id,
        vaccineId: vaccineId,
        fallback: _child,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentChild = _child;

        final completed =
            currentChild.vaccines.where((v) => v.isCompleted).toList();
        final upcoming =
            currentChild.vaccines.where((v) {
              final date = DateTime.tryParse(v.scheduledDate);
              if (date == null) return false;
              return !v.isCompleted && date.isAfter(DateTime.now());
            }).toList();
        final missed =
            currentChild.vaccines.where((v) {
              final date = DateTime.tryParse(v.scheduledDate);
              if (date == null) return false;
              return !v.isCompleted && date.isBefore(DateTime.now());
            }).toList();

        return HealthServiceScaffold(
          title: S.of(context).vaccineSchedule,
          subtitle: currentChild.childName,
          bottom: HealthPrimaryButton(
            title: S.of(context).reminder,
            onPressed: () async {
              final allowed = await isExactAlarmAllowed();
              if (allowed) {
                for (var v in missed) {
                  final vaccineDate = DateTime.tryParse(v.scheduledDate);
                  if (vaccineDate == null) continue;

                  final scheduledDateTime = DateTime(
                    vaccineDate.year,
                    vaccineDate.month,
                    vaccineDate.day,
                    12,
                    35,
                  );

                  if (!context.mounted) return;
                  await scheduleNotificationBasedOnLocation(
                    title: S.of(context).vaccineReminderTitle,
                    body: '${widget.child.childName} - ${v.vaccineName}',
                    dateTime: scheduledDateTime,
                    channelId: 'vaccine_reminder',
                    channelName: 'Vaccine Reminders',
                    channelDescription: 'Notifications for upcoming vaccines',
                    id: v.id,
                  );
                }

                if (!context.mounted) return;
                ToastMessage().displayMessageToast(
                  S.of(context).doneSchedule,
                  Colors.green,
                );

                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    Routes.home,
                    (route) => false,
                  );
                }
              } else {
                requestExactAlarmPermissionIfNeeded();
              }
            },
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            children: [
              if (upcoming.isNotEmpty) ...[
                Text(
                  S.of(context).comingVac,
                  style: AppTextStyles.noto16w400.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkColor,
                  ),
                ),
                const SizedBox(height: 10),
                ...upcoming.map(
                  (v) => VaccineCard(
                    vaccine: v,
                    onToggle: () => _complete(v.id),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              if (missed.isNotEmpty) ...[
                Text(
                  S.of(context).missedVac,
                  style: AppTextStyles.noto16w400.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkColor,
                  ),
                ),
                const SizedBox(height: 10),
                ...missed.map(
                  (v) => VaccineCard(
                    vaccine: v,
                    onToggle: () => _complete(v.id),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              if (completed.isNotEmpty) ...[
                Text(
                  S.of(context).completedVac,
                  style: AppTextStyles.noto16w400.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkColor,
                  ),
                ),
                const SizedBox(height: 10),
                ...completed.map(
                  (v) => VaccineCard(
                    vaccine: v,
                    onToggle: () => _complete(v.id),
                  ),
                ),
              ],
            ],
          ),
        );
  }
}

enum VaccineStatus { upcoming, completed, missed }

class VaccineCard extends StatelessWidget {
  final Vaccine vaccine;
  final VoidCallback onToggle;

  const VaccineCard({super.key, required this.vaccine, required this.onToggle});

  String _formatDate(String input) {
    try {
      final date = DateTime.parse(input);
      return DateFormat.yMMMMd('ar').format(date);
    } catch (_) {
      return input;
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = _formatDate(vaccine.scheduledDate);

    final status =
        vaccine.isCompleted
            ? VaccineStatus.completed
            : DateTime.tryParse(
                  vaccine.scheduledDate,
                )?.isAfter(DateTime.now()) ??
                false
            ? VaccineStatus.upcoming
            : VaccineStatus.missed;

    Color bgColor;
    switch (status) {
      case VaccineStatus.upcoming:
        bgColor = AppColors.primaryColor;
        break;
      case VaccineStatus.completed:
        bgColor = Colors.green;
        break;
      case VaccineStatus.missed:
        bgColor = Colors.red;
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: bgColor.withOpacity(0.12),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            InkWell(
              onTap: vaccine.isCompleted ? null : onToggle,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 92,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  formattedDate,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.noto14w400.copyWith(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vaccine.vaccineName,
                    style: AppTextStyles.noto16w400.copyWith(
                      fontWeight: FontWeight.w800,
                      color: status == VaccineStatus.missed
                          ? Colors.red
                          : AppColors.darkColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    vaccine.description,
                    style: AppTextStyles.noto14w400.copyWith(
                      fontSize: 12,
                      color: status == VaccineStatus.missed
                          ? Colors.red
                          : AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
