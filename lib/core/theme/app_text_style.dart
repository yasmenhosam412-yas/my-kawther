import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:elkawther/core/theme/app_colors.dart';

class AppTextStyles {
  static const _font = 'NotoSansArabic';

  static TextStyle get noto14w400 => GoogleFonts.notoSansArabic(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.black87,
  );

  static TextStyle get noto24w500 => GoogleFonts.notoSansArabic(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: AppColors.loginBlack,
  );
  static TextStyle get noto16w400 => GoogleFonts.notoSansArabic(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Colors.black.withOpacity(0.4),
  );

  static TextStyle ibmPlexSans16w500 = GoogleFonts.ibmPlexSansArabic(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.black.withOpacity(0.8),
  );

  static TextStyle headlineLarge = const TextStyle(
    fontFamily: _font,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: Colors.black,
  );
}
