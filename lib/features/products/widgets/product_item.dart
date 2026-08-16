import 'package:bounce/bounce.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/toasts/toasts.dart';
import 'package:elkawther/core/widgets/guest_user_dialog.dart';
import 'package:elkawther/core/widgets/pharmacy_placeholder.dart';
import 'package:elkawther/features/auth/cubit/auth_cubit.dart';
import 'package:elkawther/features/cart/cubit/cart_cubit.dart';
import 'package:elkawther/features/categories/models/category_products_model.dart';
import 'package:elkawther/features/favorites/models/favourite_model.dart';
import 'package:elkawther/generated/assets.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class ProductItem extends StatelessWidget {
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final double cardWidth = constraints.maxWidth;

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
          child: Container(
            width: cardWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: AppColors.light,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(18),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(18),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: image,
                            fit: BoxFit.contain,
                            placeholder:
                                (context, url) => const PharmacyImageLoading(),
                            errorWidget:
                                (context, url, error) => const Center(
                                  child: PharmacyPlaceholder(size: 72),
                                ),
                          ),
                        ),
                      ),
                      if (showDiscount)
                        PositionedDirectional(
                          top: 10,
                          start: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.teal,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${S.of(context).discount} $discount',
                              style: AppTextStyles.noto14w400.copyWith(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      PositionedDirectional(
                        top: 8,
                        end: 8,
                        child: _buildFavouriteButton(context),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.noto14w400.copyWith(
                            color: AppColors.darkColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Color(0xFFFFC107),
                              size: 14,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${rating ?? 0}',
                              style: AppTextStyles.noto14w400.copyWith(
                                fontSize: 11,
                                color: AppColors.darkColor,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '(${reviews ?? 0})',
                              style: AppTextStyles.noto14w400.copyWith(
                                fontSize: 11,
                                color: AppColors.grey,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${numberFormat.format(price)} ${S.of(context).currency}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.noto16w400.copyWith(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                  if (hasDiscount)
                                    Text(
                                      '${numberFormat.format(sizesIds?.first.originalPrice ?? sizesIdsFav!.first.originalPrice!)} ${S.of(context).currency}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.noto16w400.copyWith(
                                        color: AppColors.gray,
                                        fontSize: 11,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            _AddToCartButton(
                              productId: productId,
                              sizesIds: sizesIds,
                              sizesIdsFav: sizesIdsFav,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFavouriteButton(BuildContext context) {
    return BlocSelector<AuthCubit, AuthState, bool>(
      selector: (state) => state.status == AuthStatus.authenticated,
      builder: (context, isLoggedIn) {
        return Material(
          color: Colors.white,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap:
                isLoggedIn
                    ? onFavClick
                    : () => showGuestLoginDialog(context),
            child: Padding(
              padding: const EdgeInsets.all(7),
              child:
                  isLoggedIn && isFav
                      ? SvgPicture.asset(Assets.iconsFav2, width: 16, height: 16)
                      : SvgPicture.asset(Assets.iconsFav, width: 16, height: 16),
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
      selector: (state) => state.status == AuthStatus.authenticated,
      builder: (context, isLoggedIn) {
        return Material(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () async {
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
                (l) => ToastMessage().displayMessageToast(
                  l.localizedMessage(context),
                  AppColors.primaryColor,
                ),
                (r) => ToastMessage().displayMessageToast(
                  S.of(context).addedToCart,
                  AppColors.primaryColor,
                ),
              );
            },
            child: const SizedBox(
              width: 32,
              height: 32,
              child: Icon(Icons.add_rounded, color: Colors.white, size: 18),
            ),
          ),
        );
      },
    );
  }
}
