import 'package:elkawther/features/favorites/cubit/favourite_cubit.dart';
import 'package:elkawther/features/orders/cubit/orders_cubit.dart';
import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/widgets/pharmacy_logo.dart';
import 'package:elkawther/features/categories/models/category_products_model.dart';
import 'package:elkawther/features/orders/services/orders_services.dart';
import 'package:elkawther/features/products/widgets/product_image.dart';
import 'package:elkawther/features/products/widgets/product_details_shimmer.dart';
import 'package:elkawther/features/products/widgets/related_product_list.dart';
import 'package:elkawther/core/widgets/custom_elevated_button.dart';
import 'package:elkawther/features/products/widgets/rating_bottom_sheet.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import 'package:elkawther/features/auth/cubit/auth_cubit.dart';
import 'package:elkawther/features/products/cubit/product_details_cubit.dart';
import 'package:elkawther/generated/assets.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/features/products/services/product_details_service.dart';
import 'package:elkawther/core/widgets/bottom_bar.dart';
import 'package:elkawther/core/widgets/guest_user_dialog.dart';

class ProductDetailsView extends StatefulWidget {
  final int productId;
  final VoidCallback? onFavClick;
  final bool isFav;
  final bool isView;

  const ProductDetailsView({
    super.key,
    required this.productId,
    this.onFavClick,
    required this.isFav,
    required this.isView,
  });

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  int selectedImageIndex = 0;
  AvailableSize? selectedSize;
  bool showFullDescription = false;
  late bool isFav;

  @override
  void initState() {
    super.initState();
    isFav = widget.isFav;
    context.read<FavouriteCubit>().fetchFavourites(context);
  }

  void _goBack() {
    if (!widget.isView) {
      Navigator.pop(context);
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.home,
        (route) => false,
      );
    }
  }

  Future<bool> _onWillPop() async {
    _goBack();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductDetailsCubit(GetIt.I<ProductDetailsService>())
        ..fetchProductDetails(widget.productId, context),
      child: BlocConsumer<ProductDetailsCubit, ProductDetailsState>(
        listener: (context, state) {
          if (state is ProductDetailsLoaded &&
              selectedSize == null &&
              state.product.availableSizes.isNotEmpty) {
            setState(() {
              selectedSize = state.product.availableSizes.first;
            });
          }
        },
        buildWhen: (prev, curr) =>
            curr is ProductDetailsInitial ||
            curr is ProductDetailsLoading ||
            curr is ProductDetailsLoaded ||
            curr is ProductDetailsError,
        builder: (context, state) {
          if (state is ProductDetailsError) {
            return WillPopScope(
              onWillPop: _onWillPop,
              child: Scaffold(
                backgroundColor: const Color(0xFFF5FAFD),
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  leading: IconButton(
                    onPressed: _goBack,
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18,
                      color: AppColors.darkColor,
                    ),
                  ),
                ),
                body: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const PharmacyLogo(size: 88),
                        const SizedBox(height: 20),
                        Text(
                          state.message.localizedMessage(context),
                          textAlign: TextAlign.center,
                          style: AppTextStyles.noto14w400.copyWith(
                            fontSize: 16,
                            color: AppColors.darkColor,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 180,
                          child: CustomElevatedButton(
                            onPressed: () {
                              context
                                  .read<ProductDetailsCubit>()
                                  .fetchProductDetails(
                                    widget.productId,
                                    context,
                                  );
                            },
                            title: S.of(context).retry,
                            backgroundColor: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }

          if (state is ProductDetailsLoaded) {
            final product = state.product;
            final images = product.images;
            final imageUrl = product.imageUrl;
            final numberFormat = NumberFormat('#,##0');
            final currentSize = selectedSize ??
                (product.availableSizes.isNotEmpty
                    ? product.availableSizes.first
                    : null);
            final price = numberFormat.format(currentSize?.price ?? 0);
            final originalPrice = currentSize?.originalPrice;
            final hasDiscount = originalPrice != null &&
                originalPrice > (currentSize?.price ?? 0);
            final stock = currentSize?.stock ?? 0;

            return WillPopScope(
              onWillPop: _onWillPop,
              child: Scaffold(
                backgroundColor: const Color(0xFFF5FAFD),
                body: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      backgroundColor: Colors.white,
                      pinned: true,
                      elevation: 0,
                      surfaceTintColor: Colors.transparent,
                      centerTitle: true,
                      leading: Padding(
                        padding: const EdgeInsets.all(8),
                        child: _circleButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 16,
                            color: AppColors.darkColor,
                          ),
                          onTap: _goBack,
                        ),
                      ),
                      title: Text(
                        S.of(context).product_details,
                        style: AppTextStyles.noto16w400.copyWith(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkColor,
                        ),
                      ),
                      actions: [
                        _buildFavouriteButton(context, product.id),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(end: 12),
                          child: _circleButton(
                            icon: SvgPicture.asset(
                              Assets.shareIcon,
                              width: 18,
                              height: 18,
                            ),
                            onTap: () {
                              final url =
                                  'https://alkawthar.store/product/${widget.productId}';
                              final sharePrice =
                                  product.availableSizes.isNotEmpty
                                      ? product.availableSizes.first.price
                                      : '';
                              Share.share(
                                '🛍️ ${S.of(context).shareProduct}: *${product.name}*\n'
                                '💰 ${S.of(context).priceLabel}: $sharePrice\n'
                                '👉 ${S.of(context).viewHere}: $url',
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    CustomProductImagesSliver(
                      selectedImageIndex: selectedImageIndex,
                      productImages: images,
                      mainImage: imageUrl,
                      onImageSelected: (index) =>
                          setState(() => selectedImageIndex = index),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: AppTextStyles.noto24w500.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: AppColors.darkColor,
                              ),
                            ),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: false,
                                  backgroundColor: Colors.white,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(24),
                                    ),
                                  ),
                                  builder: (_) => BlocProvider(
                                    create: (_) =>
                                        OrdersCubit(OrdersServices()),
                                    child: AllReviewsBottomSheet(
                                      productId: product.id,
                                    ),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.star_rounded,
                                    color: Color(0xFFFFC107),
                                    size: 18,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${product.rate}',
                                    style: AppTextStyles.noto14w400.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.darkColor,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '(${product.ratingsCount})',
                                    style: AppTextStyles.noto14w400.copyWith(
                                      color: AppColors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '$price ${S.of(context).currency}',
                                  style: AppTextStyles.noto24w500.copyWith(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                if (hasDiscount) ...[
                                  const SizedBox(width: 10),
                                  Text(
                                    '${numberFormat.format(originalPrice)} ${S.of(context).currency}',
                                    style: AppTextStyles.noto16w400.copyWith(
                                      fontSize: 14,
                                      color: AppColors.gray,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            if (product.availableSizes.isNotEmpty) ...[
                              const SizedBox(height: 18),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: product.availableSizes.map((size) {
                                  final isSelected = size.id == currentSize?.id;
                                  return GestureDetector(
                                    onTap: () =>
                                        setState(() => selectedSize = size),
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 180),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? AppColors.primaryColor
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isSelected
                                              ? AppColors.primaryColor
                                              : AppColors.borderColor,
                                        ),
                                      ),
                                      child: Text(
                                        size.size ?? '',
                                        style:
                                            AppTextStyles.noto14w400.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: isSelected
                                              ? Colors.white
                                              : AppColors.darkColor,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryColor.withOpacity(0.06),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                S.of(context).productDescription,
                                style: AppTextStyles.noto16w400.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.darkColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                showFullDescription
                                    ? product.description
                                    : (product.description.length > 120
                                        ? '${product.description.substring(0, 120)}...'
                                        : product.description),
                                style: AppTextStyles.noto14w400.copyWith(
                                  color: AppColors.grey,
                                  height: 1.5,
                                  fontSize: 14,
                                ),
                              ),
                              if (product.description.length > 120)
                                Align(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: TextButton(
                                    onPressed: () => setState(
                                      () => showFullDescription =
                                          !showFullDescription,
                                    ),
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: Text(
                                      showFullDescription
                                          ? S.of(context).showless
                                          : S.of(context).show_more,
                                      style: AppTextStyles.noto14w400.copyWith(
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        child: RelatedProductsList(
                          productId: widget.productId,
                        ),
                      ),
                    ),
                  ],
                ),
                bottomNavigationBar: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.10),
                        blurRadius: 20,
                        offset: const Offset(0, -6),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: BottomBar(
                      available: stock > 0,
                      image: product.imageUrl,
                      title: product.name,
                      size: currentSize?.size ?? '',
                      price: price,
                      productId: product.id,
                      sizeId: currentSize?.id ?? 0,
                    ),
                  ),
                ),
              ),
            );
          }

          return WillPopScope(
            onWillPop: _onWillPop,
            child: const Scaffold(
              backgroundColor: Color(0xFFF5FAFD),
              body: ProductDetailsShimmer(),
            ),
          );
        },
      ),
    );
  }

  Widget _circleButton({
    required Widget icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColors.light,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(width: 40, height: 40, child: Center(child: icon)),
      ),
    );
  }

  Widget _buildFavouriteButton(BuildContext context, int productId) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isLoggedIn = state.status == AuthStatus.authenticated;
        return Padding(
          padding: const EdgeInsetsDirectional.only(end: 8),
          child: _circleButton(
            icon: SvgPicture.asset(
              isLoggedIn && isFav ? Assets.iconsFav2 : Assets.iconsFav,
              width: 18,
              height: 18,
            ),
            onTap: () {
              if (!isLoggedIn) {
                showGuestLoginDialog(context);
                return;
              }
              widget.onFavClick?.call();
              setState(() => isFav = !isFav);
            },
          ),
        );
      },
    );
  }
}
