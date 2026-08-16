import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:elkawther/generated/assets.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/core/widgets/custom_elevated_button.dart';

class DeleteDoseDialog extends StatelessWidget {
  final VoidCallback onDeleteForToday;
  final VoidCallback onDeleteAll;

  const DeleteDoseDialog({
    super.key,
    required this.onDeleteForToday,
    required this.onDeleteAll,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(Assets.iconsDelete, height: 60, width: 60),
            const SizedBox(height: 15),

            Text(
              S.of(context).confirmDelete,

              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),
            CustomElevatedButton(
              title: S.of(context).deleteOnlyForToday,
              onPressed: onDeleteForToday,
              backgroundColor: Colors.red[900],
              fontSize: 14,
            ),
            const SizedBox(height: 10),
            CustomElevatedButton(
              title: S.of(context).totalDeletion,
              onPressed: onDeleteAll,
              backgroundColor: Colors.red,
              fontSize: 14,
            ),
          ],
        ),
      ),
    );
  }
}
