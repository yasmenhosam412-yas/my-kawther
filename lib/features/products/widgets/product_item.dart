import 'package:bounce/bounce.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/widgets/app_snack_bar.dart';
import 'package:elkawther/core/widgets/guest_user_dialog.dart';
import 'package:elkawther/core/widgets/pharmacy_placeholder.dart';
import 'package:elkawther/core/widgets/product_card.dart';
import 'package:elkawther/features/auth/cubit/auth_cubit.dart';
import 'package:elkawther/features/cart/cubit/cart_cubit.dart';
import 'package:elkawther/features/categories/models/category_products_model.dart';
import 'package:elkawther/features/favorites/models/favourite_model.dart';
import 'package:elkawther/features/home/widgets/home_commerce_buttons.dart';
import 'package:elkawther/features/profile/cubit/reviews_cubit.dart';
import 'package:elkawther/features/products/widgets/rating_bottom_sheet.dart';
import 'package:elkawther/generated/assets.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

class ProductItem extends StatelessWidget {
  static const double cardAspectRatio = 0.62;

  final int productId;
  final String image;
  final String? title;
  final String? subtitle;
  final double price;
  final double? rating;
  final int? reviews;
  final bool hasDiscount;
  final String? discount;
  final List<AvailableSize>? sizesIds;
  final List<AvailableSizeFav>? sizesIdsFav;
  final VoidCallback onFavClick;
  final bool isFav;

  const ProductItem({
    super.key,
    required this.productId,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.price,
    this.rating,
    this.reviews,
    this.hasDiscount = false,
    this.discount,
    this.sizesIds,
    this.sizesIdsFav,
    required this.onFavClick,
    required this.isFav,
  });

  @override
  Widget build(BuildContext context) {
    final bool showDiscount = discount?.isNotEmpty == true && hasDiscount;
    final numberFormat = NumberFormat('#,##0');
    final double? originalPrice =
        sizesIds != null && sizesIds!.isNotEmpty
            ? sizesIds!.first.originalPrice
            : sizesIdsFav != null && sizesIdsFav!.isNotEmpty
            ? sizesIdsFav!.first.originalPrice
            : null;

    return Bounce(
      onTap:
          () => Navigator.pushNamed(
            context,
            Routes.productDetails,
            arguments: {
              "id": productId,
              "click": onFavClick,
              "isFav": isFav,
              "isView": false,
            },
          ),
      child: ProductCard(
        image: Padding(
          padding: const EdgeInsets.all(14),
          child: CachedNetworkImage(
            imageUrl: image,
            fit: BoxFit.cover,
            placeholder: (context, url) => const PharmacyImageLoading(),
            errorWidget:
                (context, url, error) =>
                    const Center(child: PharmacyPlaceholder(size: 72)),
          ),
        ),
        title: title ?? '',
        priceText: '${numberFormat.format(price)} ${S.of(context).currency}',
        originalPriceText:
            originalPrice != null && originalPrice > price
                ? '${numberFormat.format(originalPrice)} ${S.of(context).currency}'
                : null,
        discountBadge:
            showDiscount ? '${S.of(context).discount} $discount' : null,
        favoriteButton: _buildFavouriteButton(context),
        actionButton: _AddToCartButton(
          productId: productId,
          sizesIds: sizesIds,
          sizesIdsFav: sizesIdsFav,
        ),
        ratingRow: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap:
              () => showModalBottomSheet<void>(
                context: context,
                isScrollControlled: false,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                builder:
                    (_) => BlocProvider(
                      create: (_) => GetIt.I<ReviewCubit>(),
                      child: AllReviewsBottomSheet(productId: productId),
                    ),
              ),
          child: Row(
            children: [
              const Icon(
                Icons.star_rounded,
                color: Color(0xFFFFB800),
                size: 16,
              ),
              const SizedBox(width: 3),
              Text(
                (rating ?? 0).toStringAsFixed(1),
                style: AppTextStyles.noto14w400.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkColor,
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '(${reviews ?? 0})',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.noto14w400.copyWith(
                    fontSize: 10,
                    color: AppColors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: null,
      ),
    );
  }

  Widget _buildFavouriteButton(BuildContext context) {
    return BlocSelector<AuthCubit, AuthState, bool>(
      selector:
          (state) => state is AuthLoadedLogin || state is AuthLoadedRegister,
      builder: (context, isLoggedIn) {
        return Material(
          color: Colors.white,
          shape: const CircleBorder(),
          elevation: 3,
          shadowColor: AppColors.darkColor.withOpacity(0.12),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap:
                isLoggedIn ? onFavClick : () => showGuestLoginDialog(context),
            child: SizedBox(
              width: 36,
              height: 36,
              child: Center(
                child:
                    isLoggedIn && isFav
                        ? SvgPicture.asset(
                          Assets.iconsFav2,
                          width: 17,
                          height: 17,
                        )
                        : SvgPicture.asset(
                          Assets.iconsFav,
                          width: 17,
                          height: 17,
                        ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AddToCartButton extends StatelessWidget {
  const _AddToCartButton({
    required this.productId,
    this.sizesIds,
    this.sizesIdsFav,
  });

  final int productId;
  final List<AvailableSize>? sizesIds;
  final List<AvailableSizeFav>? sizesIdsFav;

  int _getSelectedSizeId() {
    if (sizesIds != null && sizesIds!.isNotEmpty) {
      final available = sizesIds!.firstWhere(
        (e) => e.stock != null && e.stock! > 0,
        orElse: () => sizesIds!.first,
      );
      return available.id ?? 0;
    } else if (sizesIdsFav != null && sizesIdsFav!.isNotEmpty) {
      final available = sizesIdsFav!.firstWhere(
        (e) => e.stock != null && e.stock! > 0,
        orElse: () => sizesIdsFav!.first,
      );
      return available.id ?? 0;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AuthCubit, AuthState, bool>(
      selector:
          (state) => state is AuthLoadedLogin || state is AuthLoadedRegister,
      builder: (context, isLoggedIn) {
        return HomeCartAddButton(
          onPressed: () async {
            if (!isLoggedIn) {
              showGuestLoginDialog(context);
              return;
            }
            final cartItem = await context.read<CartCubit>().addItem(
              productId,
              1,
              _getSelectedSizeId(),
            );
            cartItem.fold(
              (l) => AppSnackBar.error(l.localizedMessage(context)),
              (r) => AppSnackBar.success(S.of(context).addedToCart),
            );
          },
        );
      },
    );
  }
}
