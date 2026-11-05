import 'package:elkawther/core/widgets/app_snack_bar.dart';
import 'package:flutter/material.dart';

/// Legacy toast entry point kept for compatibility.
///
/// It now renders through the unified [AppSnackBar] design so the whole
/// app has one consistent toast/snackbar UI. The [background] color is
/// used to infer the semantic type of the message (success / error / info).
class ToastMessage {
  void displayMessageToast(String text, Color? background) {
    AppSnackBar.show(text, type: _typeFor(background));
  }

  AppSnackBarType _typeFor(Color? c) {
    if (c == null) {
      return AppSnackBarType.info;
    }
    final r = c.red;
    final g = c.green;
    final b = c.blue;
    // Teal / green tones -> success
    if (g >= 140 && g > r + 30) {
      return AppSnackBarType.success;
    }
    // Red tones -> error
    if (r >= 150 && r > g + 40 && r > b + 30) {
      return AppSnackBarType.error;
    }
    // Grey / dark tones -> warning
    if (r.abs() < 80 && g.abs() < 80 && b.abs() < 80) {
      return AppSnackBarType.warning;
    }
    return AppSnackBarType.info;
  }
}
