import 'package:cached_network_image/cached_network_image.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/widgets/pharmacy_placeholder.dart';
import 'package:elkawther/features/home/data/home_demo_data.dart';
import 'package:elkawther/features/home/widgets/home_catalog_image.dart';
import 'package:elkawther/features/orders/models/order_details_model.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';

class OrderProductItem extends StatelessWidget {
  final OrderProduct product;

  const OrderProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final demo =
        HomeDemoData.allProducts
            .where((item) => item.id == product.productId)
            .firstOrNull;
    final name = demo?.name(context) ?? product.name;
    final imagePath = product.image ?? demo?.imageUrl;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: ColoredBox(
            color: AppColors.light,
            child:
                imagePath == null || imagePath.isEmpty
                    ? const PharmacyPlaceholder(size: 48)
                    : imagePath.startsWith('assets/')
                    ? HomeCatalogImage(
                      assetPath: imagePath,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                    )
                    : CachedNetworkImage(
                      imageUrl: imagePath,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                      placeholder:
                          (context, url) => const PharmacyImageLoading(),
                      errorWidget:
                          (context, url, error) =>
                              const PharmacyPlaceholder(size: 48),
                    ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: AppTextStyles.noto16w400.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.darkColor,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${S.of(context).quantity}: ${product.quantity}',
                style: AppTextStyles.noto14w400.copyWith(color: AppColors.grey),
              ),
              Text(
                '${S.of(context).totalPrice}: ${(double.tryParse(product.totalPrice) ?? 0).toStringAsFixed(0)} ${S.of(context).currency}',
                style: AppTextStyles.noto14w400.copyWith(
                  color: AppColors.darkColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
