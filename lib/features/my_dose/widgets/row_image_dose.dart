import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';

class RowImage extends StatelessWidget {
  final File? selectedImage;
  final String imageUrl;
  final bool removeImageFlag;
  final VoidCallback onPickImage;
  final VoidCallback onRemoveImage;

  const RowImage({
    super.key,
    required this.selectedImage,
    required this.imageUrl,
    required this.onPickImage,
    required this.onRemoveImage,
    this.removeImageFlag = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage =
        selectedImage != null || (imageUrl.isNotEmpty && !removeImageFlag);

    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: _buildImage(),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            height: 48,
            child: OutlinedButton.icon(
              onPressed: hasImage ? onRemoveImage : onPickImage,
              icon: Icon(
                hasImage ? Icons.delete_outline_rounded : Icons.photo_outlined,
                size: 18,
                color: hasImage ? const Color(0xFFE44A4A) : AppColors.primaryColor,
              ),
              label: Text(
                hasImage ? S.of(context).deletePhoto : S.of(context).addPhoto,
                style: AppTextStyles.noto14w400.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: hasImage
                      ? const Color(0xFFE44A4A)
                      : AppColors.primaryColor,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: hasImage
                      ? const Color(0xFFE44A4A).withOpacity(0.35)
                      : AppColors.lightDarker,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImage() {
    if (selectedImage != null) {
      return Image.file(
        selectedImage!,
        width: 64,
        height: 64,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }
    if (imageUrl.isNotEmpty && !removeImageFlag) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        width: 64,
        height: 64,
        fit: BoxFit.cover,
        placeholder: (_, __) => _placeholder(),
        errorWidget: (_, __, ___) => _placeholder(),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() => Container(
    width: 64,
    height: 64,
    color: AppColors.light,
    child: const Icon(
      Icons.medication_rounded,
      color: AppColors.primaryColor,
    ),
  );
}
