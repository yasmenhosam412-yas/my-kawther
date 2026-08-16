import 'package:elkawther/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastMessage {
  void displayMessageToast(String text, Color? background) {
    Fluttertoast.showToast(
      msg: text,
      textColor: Colors.white,
      backgroundColor: background ?? AppColors.primaryColor,
    );
  }
}
