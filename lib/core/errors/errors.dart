import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import 'package:elkawther/generated/l10n.dart';

class Errors extends Equatable {
  final String message;
  final int? statusCode;

  const Errors({required this.message, this.statusCode});

  factory Errors.fromJson(Map<String, dynamic> json) {
    String rawMessage =
        json["message"]?.toString() ??
        json["error"]?.toString() ??
        "Unexpected error";

    int? code =
        json["statusCode"] is int
            ? json["statusCode"]
            : json["status"] is int
            ? json["status"]
            : null;

    if (json.containsKey("original")) {
      final original = json["original"];
      if (original is Map<String, dynamic>) {
        rawMessage = original["message"]?.toString() ?? rawMessage;
      }
    }

    if (json.containsKey("errors")) {
      final errors = json["errors"];
      if (errors is Map<String, dynamic>) {
        List<String> messages = [];

        if (errors.containsKey('cycle_length')) {
          final value = errors['cycle_length'];
          if (value is List && value.isNotEmpty) {
            messages.add(value.first.toString());
          } else if (value is String) {
            messages.add(value);
          }
        }
        if (errors.containsKey('period_length')) {
          final value = errors['period_length'];
          if (value is List && value.isNotEmpty) {
            messages.add(value.first.toString());
          } else if (value is String) {
            messages.add(value);
          }
        }

        errors.forEach((key, value) {
          if (key == 'cycle_length') return;
          if (key == 'period_length') return;
          if (value is List) {
            for (var e in value) {
              if (e != null) messages.add(e.toString());
            }
          } else if (value != null) {
            messages.add(value.toString());
          }
        });

        if (messages.isNotEmpty) {
          rawMessage = messages.join("\n");
        }
      }
    }

    return Errors(message: rawMessage, statusCode: code);
  }

  factory Errors.fromDioError(DioError e) {
    final data = e.response?.data;
    if (data is Map) {
      final error = Errors.fromJson(Map<String, dynamic>.from(data));
      return Errors(
        message: error.message,
        statusCode: error.statusCode ?? e.response?.statusCode,
      );
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return const Errors(message: "connectionTimeout");
      case DioExceptionType.sendTimeout:
        return const Errors(message: "sendTimeout");
      case DioExceptionType.receiveTimeout:
        return const Errors(message: "receiveTimeout");
      case DioExceptionType.cancel:
        return const Errors(message: "requestCancelled");
      case DioExceptionType.connectionError:
        return const Errors(message: "noInternet");
      case DioExceptionType.badResponse:
        if (e.response?.data != null &&
            e.response!.data is Map<String, dynamic>) {
          final error = Errors.fromJson(e.response!.data);
          return Errors(
            message: error.message,
            statusCode: error.statusCode ?? e.response?.statusCode,
          );
        }
        return Errors(
          message: "badResponse",
          statusCode: e.response?.statusCode,
        );
      case DioExceptionType.unknown:
      default:
        return const Errors(message: "unexpectedNetworkError");
    }
  }

  String localizedMessage(BuildContext context) {
    final normalized = message.trim().toLowerCase();

    switch (normalized) {
      case "unauthorized":
        return S.of(context).wrong_email_pass;
      case "connectiontimeout":
        return S.of(context).connectionTimeout;
      case "sendtimeout":
        return S.of(context).sendTimeout;
      case "receivetimeout":
        return S.of(context).receiveTimeout;
      case "badresponse":
        return S.of(context).badResponse;
      case "requestcancelled":
        return S.of(context).requestCancelled;
      case "nointernet":
        return S.of(context).noInternet;
      case "unexpectednetworkerror":
        return S.of(context).unexpectedNetworkError;
      case "email not found.":
        return S.of(context).emailNotFound;
      case "the selected product size is invalid.":
        return S.of(context).sizeNoAvaibleNow;
      case "product not found.":
        return S.of(context).productNotAvailable;
      case "the cycle length field must not be greater than 35.":
        return S.of(context).cycleLengthMax;
      case "the cycle length field must be at least 21.":
        return S.of(context).cycleLengthMin;
      case "the period length field must not be greater than 10.":
        return S.of(context).periodLengthMax;
      case "the period length field must be at least 3.":
        return S.of(context).periodMin;
      case "the cycle length field must not be greater than 35. (and 1 more error)":
        return S.of(context).cycleAndPeriodError;
    }

    if (message.contains("كود الخصم غير صالح")) {
      return S.of(context).cuponExpired;
    }

    String localized = message;
    localized = localized.replaceAll(
      RegExp(r"^The\s", caseSensitive: false),
      "",
    );
    localized = localized.replaceAllMapped(
      RegExp(r"\bemail\b", caseSensitive: false),
      (_) => S.of(context).email,
    );
    localized = localized.replaceAllMapped(
      RegExp(r"\bphone\b", caseSensitive: false),
      (_) => S.of(context).phoneNumber,
    );
    localized = localized.replaceAll("number", "");
    localized = localized.replaceAll("The", "");
    localized = localized.replaceAll(
      "has already been taken",
      S.of(context).alreadyExist,
    );
    localized = localized.replaceAll("by another user.", "");

    return localized.trim();
  }

  @override
  List<Object?> get props => [message, statusCode];

  @override
  String toString() => "Errors(statusCode: $statusCode, message: $message)";
}
