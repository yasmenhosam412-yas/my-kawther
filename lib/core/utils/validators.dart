import 'package:flutter/material.dart';

import 'package:elkawther/generated/l10n.dart';

class Validators {
  static String? validateName(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return S.of(context).feildRequired;
    }
    return null;
  }

  static String? validatePhone(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return S.of(context).pleaseEnterValidPhoneNumber;
    }

    final cleaned = value.replaceAll(RegExp(r'\s+'), '');

    if (!RegExp(r'^\d+$').hasMatch(cleaned)) {
      return S.of(context).pleaseEnterValidPhoneNumber;
    }

    return null;
  }

  static String? validateNumber(BuildContext context, String? value) {
    return value == null || value.isEmpty
        ? S.of(context).pleaseEnterValidNumber
        : null;
  }

  static String? validateText(BuildContext context, String? value) {
    return value == null || value.isEmpty
        ? S.of(context).pleaseEnterValidText
        : null;
  }

  static String? validateEmail(BuildContext context, String? value) {
    const pattern = r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,64}$";
    final regex = RegExp(pattern);

    if (value == null || value.trim().isEmpty) {
      return S.of(context).pleaseEnter;
    } else if (!regex.hasMatch(value.trim())) {
      return S.of(context).pleaseEnterValidEmail;
    }
    return null;
  }

  static String? validatePassword(BuildContext context, String? value) {
    String errorMessage = '';
    if (value == null || value.isEmpty) {
      return S.of(context).pleaseEnter;
    }
    if (value.length < 8) {
      errorMessage += S.of(context).passwordShouldBeAtLeast8Characters;
    }
    return errorMessage.isEmpty ? null : errorMessage;
  }

  static String? validatePin(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return S.of(context).pleaseEnterPin;
    }

    return null;
  }

  static String? validatePasswordConfirm(
    BuildContext context,
    String? value,
    String? originalPassword,
  ) {
    if (value == null || value.isEmpty) {
      return S.of(context).pleaseEnter;
    }

    if (originalPassword != null && value != originalPassword) {
      return S.of(context).passwordsDoNotMatch;
    }

    return null;
  }
}
