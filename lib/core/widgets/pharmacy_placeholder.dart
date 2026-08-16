import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

class PharmacyImageLoading extends StatelessWidget {
  const PharmacyImageLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFD6F0FA),
      highlightColor: Colors.white,
      period: const Duration(milliseconds: 1100),
      child: const SizedBox.expand(
        child: ColoredBox(
          color: Color(0xFFECF8FF),
          child: Center(
            child: SizedBox(
              width: 36,
              height: 36,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Color(0xFF0B76B9),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.local_pharmacy_rounded,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PharmacyPlaceholder extends StatelessWidget {
  const PharmacyPlaceholder({super.key, this.size = 72});

  final double size;

  static const String _svg = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 200 200" fill="none">
  <rect width="200" height="200" rx="28" fill="#ECF8FF"/>
  <rect x="74" y="38" width="52" height="22" rx="8" fill="#0B76B9"/>
  <rect x="68" y="56" width="64" height="18" rx="6" fill="#06A786"/>
  <rect x="62" y="72" width="76" height="92" rx="16" fill="#0B76B9"/>
  <rect x="78" y="88" width="44" height="10" rx="5" fill="#ECF8FF" fill-opacity="0.45"/>
  <rect x="78" y="106" width="30" height="10" rx="5" fill="#ECF8FF" fill-opacity="0.3"/>
  <circle cx="148" cy="148" r="28" fill="#06A786"/>
  <rect x="136" y="144" width="24" height="8" rx="4" fill="#FFFFFF"/>
  <rect x="144" y="136" width="8" height="24" rx="4" fill="#FFFFFF"/>
</svg>
''';

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(_svg, width: size, height: size, fit: BoxFit.contain);
  }
}

class PharmacyPromoArt extends StatelessWidget {
  const PharmacyPromoArt({super.key, this.size = 120});

  final double size;

  static const String _svg = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 280 160" fill="none">
  <rect width="280" height="160" rx="24" fill="#0B76B9"/>
  <circle cx="232" cy="28" r="40" fill="#0E84C8"/>
  <circle cx="24" cy="140" r="28" fill="#06A786" fill-opacity="0.35"/>
  <rect x="36" y="42" width="44" height="86" rx="12" fill="#FFFFFF"/>
  <rect x="44" y="28" width="28" height="18" rx="6" fill="#06A786"/>
  <rect x="92" y="54" width="44" height="74" rx="12" fill="#D6F0FA"/>
  <rect x="100" y="40" width="28" height="18" rx="6" fill="#0B76B9"/>
  <rect x="148" y="36" width="44" height="92" rx="12" fill="#FFFFFF"/>
  <rect x="156" y="22" width="28" height="18" rx="6" fill="#06A786"/>
  <circle cx="228" cy="96" r="26" fill="#FFFFFF"/>
  <rect x="216" y="92" width="24" height="8" rx="4" fill="#0B76B9"/>
  <rect x="224" y="84" width="8" height="24" rx="4" fill="#0B76B9"/>
</svg>
''';

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(_svg, width: size, height: size, fit: BoxFit.cover);
  }
}
