import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PharmacyLogo extends StatelessWidget {
  const PharmacyLogo({super.key, this.size, this.fit = BoxFit.contain});

  final double? size;
  final BoxFit fit;

  static const String assetPath = 'assets/images/pharmacy_logo.svg';

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetPath,
      width: size,
      height: size,
      fit: fit,
    );
  }
}
