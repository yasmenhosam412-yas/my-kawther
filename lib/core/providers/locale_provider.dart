import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('ar');

  Locale get locale => _locale;

  LocaleProvider() {
    loadLocale();
  }

  Future<void> setLocale(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', languageCode);
    await prefs.setString('lang', languageCode);
    _locale = Locale(languageCode);
    log("Language set to: $languageCode");
    final dio = GetIt.I.get<Dio>();
    dio.options.headers["Accept-Language"] = languageCode;
    notifyListeners();
  }

  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode =
        prefs.getString('language_code') ?? prefs.getString('lang') ?? 'ar';
    if (!prefs.containsKey('language_code')) {
      await prefs.setString('language_code', languageCode);
      await prefs.setString('lang', languageCode);
    }
    _locale = Locale(languageCode);
    log("Loaded language: $languageCode");
    final dio = GetIt.I.get<Dio>();
    dio.options.headers["Accept-Language"] = languageCode;
    notifyListeners();
  }
}
