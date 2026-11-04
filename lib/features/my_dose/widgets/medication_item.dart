import 'dart:io';
import 'dart:ui' as ui;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/features/my_dose/models/medication_model.dart';
import 'package:elkawther/features/my_dose/models/time_model.dart';
import 'package:elkawther/features/my_dose/widgets/delete_dose_dialog.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MedicationItem extends StatefulWidget {
  final List<TimeModel> times;
  final String name;
  final String details;
  final String quantity;
  final MedicationModel medication;
  final VoidCallback onDeleteForToday;
  final VoidCallback onDeleteAll;
  final String image;
  final int selectedDayIndex;
  final Function(TimeModel) onMarkAsTaken;

  const MedicationItem({
    super.key,
    required this.times,
    required this.name,
    required this.details,
    required this.quantity,
    required this.medication,
    required this.onDeleteForToday,
    required this.onDeleteAll,
    required this.image,
    required this.selectedDayIndex,
    required this.onMarkAsTaken,
  });

  @override
  State<MedicationItem> createState() => _MedicationItemState();
}

class _MedicationItemState extends State<MedicationItem> {
  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder:
          (_) => DeleteDoseDialog(
            onDeleteForToday: () {
              Navigator.of(context).pop();
              widget.onDeleteForToday();
            },
            onDeleteAll: () {
              Navigator.of(context).pop();
              widget.onDeleteAll();
            },
          ),
    );
  }

  String formatTime(String timeString) {
    try {
      final now = DateTime.now();
      final parts = timeString.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      final second = parts.length > 2 ? int.parse(parts[2]) : 0;
      final dateTime = DateTime(
        now.year,
        now.month,
        now.day,
        hour,
        minute,
        second,
      );
      return DateFormat('h:mm a').format(dateTime);
    } catch (e) {
      return timeString;
    }
  }

  bool get _allTaken => widget.times.every((time) => time.status == 'taken');

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Dismissible(
      key: Key(widget.medication.id.toString()),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        _showDeleteDialog();
        return false;
      },
      background: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment:
            Directionality.of(context) == ui.TextDirection.rtl
                ? Alignment.centerLeft
                : Alignment.centerRight,
        decoration: BoxDecoration(
          color: const Color(0xFFE44A4A),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                _allTaken
                    ? AppColors.teal.withOpacity(0.28)
                    : AppColors.lightDarker,
          ),
          boxShadow: [
            BoxShadow(
              color: (_allTaken ? AppColors.teal : AppColors.primaryColor)
                  .withOpacity(0.08),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              Navigator.pushNamed(
                context,
                Routes.addDose,
                arguments: {
                  'times': widget.times,
                  'name': widget.name,
                  'details': widget.details,
                  'quantity': widget.quantity,
                  'medication': widget.medication,
                  'image': widget.image,
                  'isEdit': true,
                  'Id': widget.medication.id.toInt(),
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildImage(),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.noto14w400.copyWith(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 15,
                                      color: AppColors.darkColor,
                                    ),
                                  ),
                                ),
                                if (_allTaken)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.teal.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      isAr ? 'تم' : 'Taken',
                                      style: AppTextStyles.noto14w400.copyWith(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.teal,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            if (widget.details.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                widget.details,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.noto14w400.copyWith(
                                  color: AppColors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                            const SizedBox(height: 4),
                            Text(
                              '${S.of(context).quantityPerTime} ${widget.quantity}',
                              style: AppTextStyles.noto14w400.copyWith(
                                color: AppColors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...widget.times.map((timeModel) {
                    final taken = timeModel.status == 'taken';
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Material(
                        color:
                            taken
                                ? AppColors.teal.withOpacity(0.08)
                                : const Color(0xFFF5FAFD),
                        borderRadius: BorderRadius.circular(14),
                        child: InkWell(
                          onTap:
                              taken
                                  ? null
                                  : () => widget.onMarkAsTaken(timeModel),
                          borderRadius: BorderRadius.circular(14),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color:
                                        taken ? AppColors.teal : Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color:
                                          taken
                                              ? AppColors.teal
                                              : AppColors.primaryColor,
                                      width: 1.6,
                                    ),
                                  ),
                                  child: Icon(
                                    taken
                                        ? Icons.check_rounded
                                        : Icons.schedule_rounded,
                                    size: 16,
                                    color:
                                        taken
                                            ? Colors.white
                                            : AppColors.primaryColor,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    formatTime(timeModel.time),
                                    style: AppTextStyles.noto14w400.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color:
                                          taken
                                              ? AppColors.teal
                                              : AppColors.darkColor,
                                    ),
                                  ),
                                ),
                                Text(
                                  taken
                                      ? (isAr ? 'تم أخذ الجرعة' : 'Dose taken')
                                      : (isAr ? 'تأكيد الأخذ' : 'Mark taken'),
                                  style: AppTextStyles.noto14w400.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color:
                                        taken
                                            ? AppColors.teal
                                            : AppColors.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (widget.image.isEmpty) {
      return _imagePlaceholder();
    }
    final imageUri = Uri.tryParse(widget.image);
    final Widget image;
    if (widget.image.startsWith('assets/')) {
      image = Image.asset(
        widget.image,
        width: 64,
        height: 64,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _imagePlaceholder(),
      );
    } else if (imageUri?.scheme == 'http' || imageUri?.scheme == 'https') {
      image = CachedNetworkImage(
        imageUrl: widget.image,
        width: 64,
        height: 64,
        fit: BoxFit.cover,
        placeholder: (_, __) => _imagePlaceholder(),
        errorWidget: (_, __, ___) => _imagePlaceholder(),
      );
    } else {
      image = Image.file(
        File(widget.image),
        width: 64,
        height: 64,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _imagePlaceholder(),
      );
    }
    return ClipRRect(borderRadius: BorderRadius.circular(16), child: image);
  }

  Widget _imagePlaceholder() => Container(
    width: 64,
    height: 64,
    color: AppColors.light,
    child: const Icon(Icons.medication_rounded, color: AppColors.primaryColor),
  );
}
