import 'package:flutter/material.dart';

double getHeight(BuildContext context) => MediaQuery.of(context).size.height;
double getWidth(BuildContext context) => MediaQuery.of(context).size.width;

bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 400;
bool isTab(BuildContext context) =>
    MediaQuery.of(context).size.width < 1000 &&
    MediaQuery.of(context).size.width >= 400;
bool isDesktop(BuildContext context) =>
    MediaQuery.of(context).size.width >= 1000;

double getResponsiveFontSize(BuildContext context, {required double fontSize}) {
  double scaleFactor = getScaleFactor(context);
  double responsiveFontSize = fontSize * scaleFactor;

  double lowerLimit = fontSize * .8;
  double upperLimit = fontSize * 1;
  return responsiveFontSize.clamp(lowerLimit, upperLimit);
}

double getScaleFactor(BuildContext context) {
  double width = MediaQuery.sizeOf(context).width;
  if (width > 600 && width < 1000) {
    return width / 700;
  } else {
    return width / 1000;
  }
} //fontSize: getResponsiveFontSize(context,fontSize: 30)
