import 'package:cached_network_image/cached_network_image.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/widgets/custom_elevated_button.dart';
import 'package:elkawther/core/widgets/pharmacy_placeholder.dart';
import 'package:elkawther/features/home/data/home_cart_store.dart';
import 'package:elkawther/features/home/data/home_demo_data.dart';
import 'package:elkawther/features/home/data/home_favorites_store.dart';
import 'package:elkawther/features/home/screens/home_navigation.dart';
import 'package:elkawther/features/home/widgets/home_sub_scaffold.dart';
import 'package:elkawther/generated/assets.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class HomeProductDetailsView extends StatefulWidget {
  const HomeProductDetailsView({super.key, required this.product});

  final HomeDemoProduct product;

  @override
  State<HomeProductDetailsView> createState() => _HomeProductDetailsViewState();
}

class _HomeProductDetailsViewState extends State<HomeProductDetailsView> {
  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final numberFormat = NumberFormat('#,##0');
    final isFav = HomeFavoritesStore.instance.contains(product.id);

    return HomeSubScaffold(
      title: product.name(context),
      actions: [
        IconButton(
          onPressed: () {
            HomeFavoritesStore.instance.toggle(product);
            setState(() {});
          },
          icon: SvgPicture.asset(
            isFav ? Assets.iconsFav2 : Assets.iconsFav,
            width: 20,
            height: 20,
          ),
        ),
      ],
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: CustomElevatedButton(
            title: S.of(context).addToCart,
            backgroundColor: AppColors.primaryColor,
            onPressed: () {
              HomeCartStore.instance.add(product);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(S.of(context).addedToCart),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 280,
            width: double.infinity,
            child: CachedNetworkImage(
              imageUrl: product.imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => const PharmacyImageLoading(),
              errorWidget: (context, url, error) => const ColoredBox(
                color: AppColors.light,
                child: Center(child: PharmacyPlaceholder(size: 96)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (product.hasDiscount)
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.teal,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${S.of(context).discount} ${product.discountLabel ?? ''}',
                      style: AppTextStyles.noto14w400.copyWith(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                Text(
                  product.name(context),
                  style: AppTextStyles.noto24w500.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkColor,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => HomeNavigation.openRatings(context, product),
                  child: Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: Color(0xFFFFC107),
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${product.rating}',
                      style: AppTextStyles.noto14w400.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkColor,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '(${product.reviews})',
                      style: AppTextStyles.noto14w400.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                    const SizedBox(width: 6),
                   const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 18,
                      color: AppColors.primaryColor,
                    ),
                  ],
                ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      '${numberFormat.format(product.price)} ${S.of(context).currency}',
                      style: AppTextStyles.noto24w500.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 22,
                      ),
                    ),
                    if (product.originalPrice != null) ...[
                      const SizedBox(width: 10),
                      Text(
                        '${numberFormat.format(product.originalPrice)} ${S.of(context).currency}',
                        style: AppTextStyles.noto16w400.copyWith(
                          color: AppColors.gray,
                          fontSize: 14,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  S.of(context).description,
                  style: AppTextStyles.noto16w400.copyWith(
                    color: AppColors.darkColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  product.subtitle(context),
                  style: AppTextStyles.noto14w400.copyWith(
                    color: AppColors.grey,
                    height: 1.5,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  S.of(context).bestSellingProducts,
                  style: AppTextStyles.noto16w400.copyWith(
                    color: AppColors.darkColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 220,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: HomeDemoData.allProducts
                        .where((item) => item.id != product.id)
                        .take(6)
                        .length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final related = HomeDemoData.allProducts
                          .where((item) => item.id != product.id)
                          .take(6)
                          .toList()[index];
                      return GestureDetector(
                        onTap: () => HomeNavigation.openProduct(
                          context,
                          related,
                        ),
                        child: SizedBox(
                          width: 140,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: CachedNetworkImage(
                                  imageUrl: related.imageUrl,
                                  height: 120,
                                  width: 140,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      const PharmacyImageLoading(),
                                  errorWidget: (context, url, error) =>
                                      const PharmacyPlaceholder(size: 48),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                related.name(context),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.noto14w400.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.darkColor,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${numberFormat.format(related.price)} ${S.of(context).currency}',
                                style: AppTextStyles.noto14w400.copyWith(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
