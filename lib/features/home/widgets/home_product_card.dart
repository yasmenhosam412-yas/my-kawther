import 'package:cached_network_image/cached_network_image.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/widgets/pharmacy_placeholder.dart';
import 'package:elkawther/features/home/data/home_cart_store.dart';
import 'package:elkawther/features/home/data/home_demo_data.dart';
import 'package:elkawther/features/home/data/home_favorites_store.dart';
import 'package:elkawther/features/home/screens/home_navigation.dart';
import 'package:elkawther/generated/assets.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class HomeProductCard extends StatefulWidget {
  const HomeProductCard({super.key, required this.product});

  final HomeDemoProduct product;

  @override
  State<HomeProductCard> createState() => _HomeProductCardState();
}

class _HomeProductCardState extends State<HomeProductCard> {
  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final numberFormat = NumberFormat('#,##0');
    final currency = S.of(context).currency;
    final isFav = HomeFavoritesStore.instance.contains(product.id);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => HomeNavigation.openProduct(context, product),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.10),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                        child: ColoredBox(
                          color: AppColors.light,
                          child: CachedNetworkImage(
                            imageUrl: product.imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                const PharmacyImageLoading(),
                            errorWidget: (context, url, error) => const Center(
                              child: PharmacyPlaceholder(size: 64),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (product.hasDiscount)
                      PositionedDirectional(
                        top: 10,
                        start: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.teal,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            product.discountLabel ?? S.of(context).discount,
                            style: AppTextStyles.noto14w400.copyWith(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    PositionedDirectional(
                      top: 8,
                      end: 8,
                      child: Material(
                        color: Colors.white,
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () {
                            HomeFavoritesStore.instance.toggle(product);
                            setState(() {});
                          },
                          child: SizedBox(
                            width: 32,
                            height: 32,
                            child: Center(
                              child: SvgPicture.asset(
                                isFav ? Assets.iconsFav2 : Assets.iconsFav,
                                width: 15,
                                height: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    PositionedDirectional(
                      bottom: -16,
                      end: 10,
                      child: Material(
                        color: AppColors.primaryColor,
                        shape: const CircleBorder(),
                        elevation: 4,
                        shadowColor: AppColors.primaryColor.withOpacity(0.4),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () {
                            HomeCartStore.instance.add(product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(S.of(context).addedToCart),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          child: const SizedBox(
                            width: 36,
                            height: 36,
                            child: Icon(
                              Icons.add_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 20, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name(context),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.noto14w400.copyWith(
                        color: AppColors.darkColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: () => HomeNavigation.openRatings(context, product),
                      child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8E8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Color(0xFFFFC107),
                            size: 13,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${product.rating}',
                            style: AppTextStyles.noto14w400.copyWith(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.darkColor,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '(${product.reviews})',
                            style: AppTextStyles.noto14w400.copyWith(
                              fontSize: 10,
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${numberFormat.format(product.price)} $currency',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.noto16w400.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                    if (product.originalPrice != null)
                      Text(
                        '${numberFormat.format(product.originalPrice)} $currency',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.noto14w400.copyWith(
                          color: AppColors.gray,
                          fontSize: 11,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeProductsRow extends StatelessWidget {
  const HomeProductsRow({super.key, required this.products});

  final List<HomeDemoProduct> products;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: SizedBox(
        height: 262,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.zero,
          itemCount: products.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            return SizedBox(
              width: 158,
              child: HomeProductCard(product: products[index]),
            );
          },
        ),
      ),
    );
  }
}

class HomeChipsRow extends StatelessWidget {
  const HomeChipsRow({
    super.key,
    required this.items,
    required this.products,
  });

  final List<HomeDemoChip> items;
  final List<HomeDemoProduct> products;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 118,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final item = items[index];
          return HomeCategoryItemStatic(
            title: item.name(context),
            imageUrl: item.imageUrl,
            onTap: () {
              if (item.id != null) {
                HomeNavigation.openCategories(
                  context,
                  selectedCategoryId: item.id,
                );
                return;
              }
              HomeNavigation.openList(
                context,
                title: item.name(context),
                products: products,
              );
            },
          );
        },
      ),
    );
  }
}

class HomeCategoryItemStatic extends StatelessWidget {
  const HomeCategoryItemStatic({
    super.key,
    required this.title,
    required this.imageUrl,
    this.onTap,
  });

  final String title;
  final String imageUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
      width: 86,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              width: 72,
              height: 72,
              placeholder: (context, url) => const PharmacyImageLoading(),
              errorWidget: (context, url, error) =>
                  const PharmacyPlaceholder(size: 40),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.noto14w400.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.darkColor,
              height: 1.2,
            ),
          ),
        ],
      ),
      ),
    );
  }
}
