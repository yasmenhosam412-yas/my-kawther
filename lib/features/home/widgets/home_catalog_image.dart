import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/widgets/pharmacy_placeholder.dart';
import 'package:flutter/material.dart';

class HomeCatalogImage extends StatelessWidget {
  const HomeCatalogImage({
    super.key,
    required this.assetPath,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.fallback,
  });

  final String assetPath;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    final uri = Uri.tryParse(assetPath);
    final isNetworkImage =
        uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
    final image = isNetworkImage
        ? Image.network(
            assetPath,
            fit: fit,
            width: width,
            height: height,
            errorBuilder: _buildFallback,
          )
        : Image.asset(
            assetPath,
            fit: fit,
            width: width,
            height: height,
            errorBuilder: _buildFallback,
          );
    return image;
  }

  Widget _buildFallback(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) =>
      fallback ??
      const ColoredBox(
        color: AppColors.light,
        child: Center(child: PharmacyPlaceholder(size: 48)),
      );
}
