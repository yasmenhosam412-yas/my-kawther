import 'package:flutter/material.dart';

class OnboardingModel {
  final String svg;
  final String? title;
  final String? subtitle;
  final Color accent;

  OnboardingModel({
    required this.svg,
    this.title,
    this.subtitle,
    this.accent = const Color(0xff0B76B9),
  });
}
