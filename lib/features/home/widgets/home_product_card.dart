import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/features/home/data/home_demo_data.dart';
import 'package:elkawther/features/home/data/home_favorites_store.dart';
import 'package:elkawther/features/home/screens/home_navigation.dart';
import 'package:elkawther/features/home/widgets/home_catalog_image.dart';
import 'package:elkawther/features/home/widgets/home_commerce_buttons.dart';
import 'package:elkawther/features/cart/cubit/cart_cubit.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/core/widgets/guest_user_dialog.dart';
import 'package:elkawther/features/auth/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class HomeProductCard extends StatefulWidget {
  static const double cardAspectRatio = 0.62;

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
              AspectRatio(
                aspectRatio: 1.35,
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
                          child: HomeCatalogImage(
                            assetPath: product.imageUrl,
                            fit: BoxFit.cover,
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
                      child: HomeFavoriteButton(
                        isFavorite: isFav,
                        onPressed: () {
                          HomeFavoritesStore.instance.toggle(product);
                          setState(() {});
                        },
                      ),
                    ),
                    PositionedDirectional(
                      bottom: -16,
                      end: 10,
                      child: HomeCartAddButton(
                        onPressed: () {
                          final authState = context.read<AuthCubit>().state;
                          if (authState is! AuthLoadedLogin &&
                              authState is! AuthLoadedRegister) {
                            showGuestLoginDialog(context);
                            return;
                          }
                          final sizeId = product.productSizeId;
                          if (sizeId == null || sizeId <= 0) {
                            HomeNavigation.openProduct(context, product);
                            return;
                          }
                          context
                              .read<CartCubit>()
                              .addItem(product.id, 1, sizeId)
                              .then((result) {
                                if (!context.mounted) return;
                                result.fold(
                                  (error) => ScaffoldMessenger.of(
                                    context,
                                  ).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        error.localizedMessage(context),
                                      ),
                                    ),
                                  ),
                                  (_) => ScaffoldMessenger.of(
                                    context,
                                  ).showSnackBar(
                                    SnackBar(
                                      content: Text(S.of(context).addedToCart),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  ),
                                );
                              });
                        },
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
                    if (product.reviews > 0) ...[
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap:
                            () => HomeNavigation.openRatings(context, product),
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
                    ],
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
        height: 158 / HomeProductCard.cardAspectRatio,
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
  const HomeChipsRow({super.key, required this.items, required this.products});

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
              child: HomeCatalogImage(
                assetPath: imageUrl,
                fit: BoxFit.cover,
                width: 72,
                height: 72,
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
