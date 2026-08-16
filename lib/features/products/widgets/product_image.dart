import 'package:cached_network_image/cached_network_image.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/widgets/pharmacy_placeholder.dart';
import 'package:flutter/material.dart';

class CustomProductImagesSliver extends StatelessWidget {
  final int selectedImageIndex;
  final List<String> productImages;
  final String mainImage;
  final ValueChanged<int> onImageSelected;

  const CustomProductImagesSliver({
    super.key,
    required this.selectedImageIndex,
    required this.productImages,
    required this.onImageSelected,
    required this.mainImage,
  });

  @override
  Widget build(BuildContext context) {
    final allImages = [
      if (mainImage.isNotEmpty) mainImage,
      ...productImages.where((image) => image.isNotEmpty && image != mainImage),
    ];

    if (allImages.isEmpty) {
      return const SliverToBoxAdapter(
        child: SizedBox(
          height: 280,
          child: ColoredBox(
            color: AppColors.light,
            child: Center(child: PharmacyPlaceholder(size: 96)),
          ),
        ),
      );
    }

    final imageToDisplay =
        selectedImageIndex < allImages.length
            ? allImages[selectedImageIndex]
            : allImages.first;

    return SliverToBoxAdapter(
      child: Column(
        children: [
          SizedBox(
            height: 300,
            width: double.infinity,
            child: CachedNetworkImage(
              imageUrl: imageToDisplay,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
              placeholder: (context, url) => const PharmacyImageLoading(),
              errorWidget: (context, url, error) => const ColoredBox(
                color: AppColors.light,
                child: Center(child: PharmacyPlaceholder(size: 96)),
              ),
            ),
          ),
          if (allImages.length > 1)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: SizedBox(
                height: 68,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: allImages.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final isSelected = index == selectedImageIndex;
                    return GestureDetector(
                      onTap: () => onImageSelected(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 68,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primaryColor
                                : Colors.white,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryColor.withOpacity(0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: allImages[index],
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                const PharmacyImageLoading(),
                            errorWidget: (context, url, error) =>
                                const PharmacyPlaceholder(size: 28),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
