import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

Future<bool> increaseQuantity(
  int index,
  List<Map<String, dynamic>> items,
) async {
  try {
    items[index]['quantity']++;
    return true;
  } catch (e) {
    return false;
  }
}

Future<bool> decreaseQuantity(
  int index,
  List<Map<String, dynamic>> items,
) async {
  try {
    if (items[index]['quantity'] > 1) {
      items[index]['quantity']--;
    }
    return true;
  } catch (e) {
    return false;
  }
}

Future<bool> deleteItem(int index, List<Map<String, dynamic>> items) async {
  try {
    items.removeAt(index);
    return true;
  } catch (e) {
    return false;
  }
}

String getInitial(String name) {
  if (name.isNotEmpty) {
    return name.trim()[0];
  } else {
    return '?';
  }
}

String formatTime24(TimeOfDay time) {
  final now = DateTime.now();
  final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
  return DateFormat('HH:mm:ss').format(dt);
}
