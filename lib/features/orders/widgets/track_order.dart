import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/features/orders/models/track_order.dart';
import 'package:elkawther/features/orders/widgets/order_state_stepper.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TrackOrderBottomSheet extends StatelessWidget {
  const TrackOrderBottomSheet({super.key, required this.track});

  final TrackOrder track;

  @override
  Widget build(BuildContext context) {
    // Determine if order is shipped based on status
    final isShipped = track.status == 'on_delivery' ||
        track.status == 'compiled' ||
        track.status == 'completed' ||
        track.status == 'canceled';
    final dateLabel = _formatDate(context, track.lastUpdate);

    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        color: Colors.white,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.greyBorder,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    S.of(context).order_status,
                    style: AppTextStyles.noto16w400.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.darkColor,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded, color: AppColors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            OrderStateStepper(
              isShipped: isShipped,
              orderDate: dateLabel,
              shippingDate: isShipped ? dateLabel : null,
              status: track.status,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(BuildContext context, String raw) {
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) return raw;
    return DateFormat(
      'd MMM, HH:mm',
      Localizations.localeOf(context).toString(),
    ).format(parsed);
  }
}