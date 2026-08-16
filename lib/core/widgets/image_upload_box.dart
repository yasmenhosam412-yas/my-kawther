import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

class ImageUploadBox extends StatelessWidget {
  final VoidCallback onTap;
  final double? width;
  final double? height;
  final String label;
  final File? image;

  const ImageUploadBox({
    super.key,
    required this.onTap,
    this.width,
    this.height,
    required this.label,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DottedBorder(
        color: Colors.grey,
        strokeWidth: 1,
        dashPattern: const [10, 6],
        borderType: BorderType.RRect,
        radius: const Radius.circular(8),
        child: Container(
          width: width ?? double.infinity,
          height: height ?? 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[100],
          ),
          child:
              image != null
                  ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      image!,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                  : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.upload, size: 30, color: Colors.grey),
                      const SizedBox(height: 6),
                      Text(
                        label,
                        textAlign: TextAlign.center,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }
}
