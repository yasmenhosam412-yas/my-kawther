import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/widgets/app_snack_bar.dart';
import 'package:elkawther/core/widgets/product_card.dart';
import 'package:elkawther/features/favorites/cubit/favourite_cubit.dart';
import 'package:elkawther/features/home/data/home_demo_data.dart';
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
  static const double cardAspectRatio = ProductCard.cardAspectRatio;

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
    return BlocBuilder<FavouriteCubit, FavouriteState>(
      builder: (context, state) {
        final isFav = context.read<FavouriteCubit>().isProductFavourite(
          product.id,
        );
        return Material(
      color: Colors.transparent,
      child: ProductCard(
        image: HomeCatalogImage(
          assetPath: product.imageUrl,
          fit: BoxFit.contain,
        ),
        title: product.name(context),
        priceText: '${numberFormat.format(product.price)} $currency',
        originalPriceText:
            product.originalPrice == null
                ? null
                : '${numberFormat.format(product.originalPrice)} $currency',
        discountBadge: product.hasDiscount
            ? (product.discountLabel ?? S.of(context).discount)
            : null,
        favoriteButton: HomeFavoriteButton(
          isFavorite: isFav,
          onPressed: () {
            final authState = context.read<AuthCubit>().state;
            if (authState is! AuthLoadedLogin &&
                authState is! AuthLoadedRegister) {
              showGuestLoginDialog(context);
              return;
            }
            context.read<FavouriteCubit>().toggleFavourite(
              productId: product.id,
              context: context,
            );
          },
        ),
        actionButton: HomeCartAddButton(
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
                    (error) =>
                        AppSnackBar.error(error.localizedMessage(context)),
                    (_) => AppSnackBar.success(S.of(context).addedToCart),
                  );
                });
          },
        ),
        ratingRow: product.reviews > 0
            ? GestureDetector(
                onTap: () => HomeNavigation.openRatings(context, product),
                behavior: HitTestBehavior.opaque,
                child: ProductCard.ratingChip(
                  rating: (product.rating as num).toDouble(),
                  reviews: product.reviews,
                ),
              )
            : null,
        onTap: () => HomeNavigation.openProduct(context, product),
      ),
    );
      },
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
