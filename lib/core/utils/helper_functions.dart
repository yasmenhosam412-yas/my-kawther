import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:elkawther/generated/l10n.dart';

class HelperFunctions {
  static String getTime(DateTime dateTime, BuildContext context) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return S.of(context).justNow;
    } else if (difference.inMinutes < 60) {
      return "${S.of(context).before} ${difference.inMinutes} ${S.of(context).minutes}";
    } else if (difference.inHours < 24) {
      return "${S.of(context).before} ${difference.inHours} ${S.of(context).hours}";
    } else if (difference.inDays < 7) {
      return "${S.of(context).before} ${difference.inDays} ${S.of(context).days}";
    } else {
      return DateFormat.yMMMd(
        Localizations.localeOf(context).toString(),
      ).add_jm().format(dateTime);
    }
  }

  static String extractTime(String dateTime) {
    DateTime parsedDateTime = DateTime.parse(dateTime);
    return DateFormat('HH:mm').format(parsedDateTime);
  }

  static String extractDate(String dateTime) {
    DateTime parsedDateTime = DateTime.parse(dateTime);
    return DateFormat('dd/MM/yyyy').format(parsedDateTime);
  }

  static S _l10n(BuildContext context) => S.maybeOf(context) ?? S.current;

  static String handleDioError(DioException dioError, BuildContext context) {
    final s = _l10n(context);
    if (dioError.response != null) {
      if (dioError.response?.data['message'] != null) {
        return dioError.response!.data['message']!;
      } else {
        switch (dioError.response?.statusCode) {
          case 302:
            return dioError.response?.data['message'] ?? s.alreadyExist;
          case 400:
            return s.badRequest;
          case 401 || 403:
            return dioError.response?.data['message'] ?? s.badRequest;

          case 404:
            return s.thereAreNoItems;

          case 408 || 409 || 413:
            return dioError.response?.data['message'] ?? s.badRequest;
          case 422:
            return s.unProcessableEntity;
          case 500:
            return s.serverError;
          default:
            return s.unexpectedError;
        }
      }
    } else {
      return s.networkError;
    }
  }

  static getRandomColor() {
    final random = Random();
    return Color((random.nextInt(0xFFFFFF)) | 0xFF000000);
  }
}
