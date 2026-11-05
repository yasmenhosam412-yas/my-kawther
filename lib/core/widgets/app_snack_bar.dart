import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';

enum AppSnackBarType { success, error, warning, info }

/// One consistent toast/snackbar design for the whole app.
///
/// Usage:
///   AppSnackBar.success(S.of(context).added);
///   AppSnackBar.error(errorMessage);
///   AppSnackBar.info('...');
///   AppSnackBar.warning('...');
///
/// Works from anywhere (no context needed) because it uses the global
/// [messengerKey] registered on MaterialApp in main.dart.
class AppSnackBar {
  AppSnackBar._();

  /// Registered as `scaffoldMessengerKey` on MaterialApp.
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>(
        debugLabel: 'app-snackbar-messenger',
      );

  static void success(String message) =>
      show(message, type: AppSnackBarType.success);
  static void error(String message) =>
      show(message, type: AppSnackBarType.error);
  static void warning(String message) =>
      show(message, type: AppSnackBarType.warning);
  static void info(String message) => show(message, type: AppSnackBarType.info);

  static void show(
    String message, {
    AppSnackBarType type = AppSnackBarType.info,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final messenger = messengerKey.currentState;
    if (message.trim().isEmpty || messenger == null) {
      debugPrint('AppSnackBar skipped: $message');
      return;
    }
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        _build(message, type, duration, actionLabel, onAction),
      );
  }

  static SnackBar _build(
    String message,
    AppSnackBarType type,
    Duration duration,
    String? actionLabel,
    VoidCallback? onAction,
  ) {
    final style = _styleFor(type);
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      backgroundColor: Colors.transparent,
      duration: duration,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      content: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFF1E2430),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          left: false,
          right: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: style.color.withOpacity(0.18),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(style.icon, size: 19, color: style.color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: AppTextStyles.noto14w400.copyWith(
                      color: Colors.white,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                    ),
                  ),
                ),
                if (actionLabel != null && onAction != null) ...[
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: onAction,
                    style: TextButton.styleFrom(
                      foregroundColor: style.color,
                      minimumSize: const Size(40, 36),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                    child: Text(
                      actionLabel,
                      style: AppTextStyles.noto14w400.copyWith(
                        color: style.color,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  static _AppSnackBarStyle _styleFor(AppSnackBarType type) {
    switch (type) {
      case AppSnackBarType.success:
        return const _AppSnackBarStyle(Icons.check_circle_rounded, Color(0xFF2FD8A0));
      case AppSnackBarType.error:
        return const _AppSnackBarStyle(Icons.error_rounded, Color(0xFFFF6B6B));
      case AppSnackBarType.warning:
        return const _AppSnackBarStyle(
          Icons.warning_amber_rounded,
          Color(0xFFFFC24A),
        );
      case AppSnackBarType.info:
        return const _AppSnackBarStyle(Icons.info_rounded, Color(0xFF5BBDF7));
    }
  }
}

class _AppSnackBarStyle {
  const _AppSnackBarStyle(this.icon, this.color);

  final IconData icon;
  final Color color;
}
