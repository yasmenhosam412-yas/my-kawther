import 'package:flutter/material.dart';
import 'package:elkawther/features/products/models/brand_products_model.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/generated/l10n.dart';

class ProductInfo extends StatefulWidget {
  final String name;
  final String price;
  final double rating;
  final String reviewsCount;
  final VoidCallback onReviewsTap;
  final List<ProductSize> sizes;
  final ProductSize? selectedSize;
  final ValueChanged<ProductSize> onSizeSelected;

  const ProductInfo({
    super.key,
    required this.name,
    required this.price,
    required this.rating,
    required this.reviewsCount,
    required this.onReviewsTap,
    required this.sizes,
    required this.onSizeSelected,
    this.selectedSize,
  });

  @override
  State<ProductInfo> createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  late List<ProductSize> volumes;
  late ProductSize selectedVolume;
  double? sleetcedPrisce;

  @override
  void initState() {
    super.initState();
    volumes = widget.sizes;
    sleetcedPrisce = double.tryParse(widget.sizes[0].price ?? "0") ?? 0.0;
    // Use parent-provided selectedSize or fallback to first
    selectedVolume = widget.selectedSize ?? volumes.first;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name + Rating
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.name,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              children: [
                Text(
                  '${widget.rating}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const SizedBox(width: 2),
                const Icon(Icons.star, color: Colors.amber, size: 15),
                const SizedBox(width: 2),
                GestureDetector(
                  onTap: widget.onReviewsTap,
                  child: Text(
                    '(${widget.reviewsCount})',
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Sizes List
        Align(
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children:
                volumes.map((vol) {
                  final isSelected = vol == selectedVolume;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedVolume = vol;
                        sleetcedPrisce =
                            double.tryParse(vol.price ?? "0") ?? 0.0;
                      });
                      widget.onSizeSelected(vol);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isSelected ? AppColors.primaryColor : Colors.white,
                        border: Border.all(color: Colors.grey[500]!),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        vol.size ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? Colors.white : Colors.grey[500],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
        ),

        const SizedBox(height: 12),

        // Price
        Text(
          "$sleetcedPrisce ${S.of(context).currency}",
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
