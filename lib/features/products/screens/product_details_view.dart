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
import 'package:elkawther/features/products/widgets/custom_review_list_item.dart';
import 'package:elkawther/features/profile/cubit/reviews_cubit.dart';
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
      Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false);
    }
  }

  Future<bool> _onWillPop() async {
    _goBack();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (_) => GetIt.I<ReviewCubit>()..getReview(widget.productId),
      child: BlocProvider(
        create:
            (_) =>
                ProductDetailsCubit(GetIt.I<ProductDetailsService>())
                  ..fetchProductDetails(widget.productId),
        child: BlocConsumer<ProductDetailsCubit, ProductDetailsState>(
          listener: (context, state) {
            if (state is ProductDetailsLoaded && selectedSize == null) {
              setState(() {
                isFav =
                    context.read<FavouriteCubit>().isProductFavourite(
                      state.product.id,
                    ) ||
                    state.product.isFavorite;
                if (state.product.availableSizes.isNotEmpty) {
                  selectedSize = state.product.availableSizes.first;
                }
              });
            }
          },
          buildWhen:
              (prev, curr) =>
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
                                    .fetchProductDetails(widget.productId);
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
              final currentSize =
                  selectedSize ??
                  (product.availableSizes.isNotEmpty
                      ? product.availableSizes.first
                      : null);
              final price = numberFormat.format(currentSize?.price ?? 0);
              final originalPrice = currentSize?.originalPrice;
              final hasDiscount =
                  originalPrice != null &&
                  originalPrice > (currentSize?.price ?? 0);
              final stock = currentSize?.stock ?? 0;

              return WillPopScope(
                onWillPop: _onWillPop,
                child: Scaffold(
                  backgroundColor: const Color(0xFFF5FAFD),
                  body: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        backgroundColor: const Color(0xFFF5FAFD),
                        pinned: true,
                        elevation: 0,
                        surfaceTintColor: Colors.transparent,
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
                        onImageSelected:
                            (index) =>
                                setState(() => selectedImageIndex = index),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                color: const Color(0xFFE6EEF5),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        product.name,
                                        style: AppTextStyles.noto24w500
                                            .copyWith(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w800,
                                              color: AppColors.darkColor,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    _StockChip(inStock: stock > 0),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                GestureDetector(
                                  onTap: () =>
                                      _showAllReviews(context, product.id),
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
                                        style: AppTextStyles.noto14w400
                                            .copyWith(
                                              fontWeight: FontWeight.w800,
                                              color: AppColors.darkColor,
                                            ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '(${product.ratingsCount})',
                                        style: AppTextStyles.noto14w400
                                            .copyWith(color: AppColors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor.withOpacity(
                                      0.08,
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        '$price ${S.of(context).currency}',
                                        style: AppTextStyles.noto24w500
                                            .copyWith(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w800,
                                              color: AppColors.primaryColor,
                                            ),
                                      ),
                                      if (hasDiscount) ...[
                                        const SizedBox(width: 10),
                                        Text(
                                          '${numberFormat.format(originalPrice)} ${S.of(context).currency}',
                                          style: AppTextStyles.noto16w400
                                              .copyWith(
                                                fontSize: 13,
                                                color: AppColors.gray,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                              ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                if (product.availableSizes.isNotEmpty) ...[
                                  const SizedBox(height: 16),
                                  Text(
                                    S.of(context).size,
                                    style: AppTextStyles.noto14w400.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.grey,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: product.availableSizes.map((
                                      size,
                                    ) {
                                      final isSelected =
                                          size.id == currentSize?.id;
                                      return GestureDetector(
                                        onTap: () => setState(
                                          () => selectedSize = size,
                                        ),
                                        child: AnimatedContainer(
                                          duration: const Duration(
                                            milliseconds: 180,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? AppColors.primaryColor
                                                : const Color(0xFFF3F7FB),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: Text(
                                            size.size ?? '',
                                            style: AppTextStyles.noto14w400
                                                .copyWith(
                                                  fontWeight: FontWeight.w700,
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
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                          child: _ProductReviewsSection(
                            onShowAll:
                                () => _showAllReviews(context, product.id),
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
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                color: const Color(0xFFE6EEF5),
                              ),
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
                                      onPressed:
                                          () => setState(
                                            () =>
                                                showFullDescription =
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
                                        style: AppTextStyles.noto14w400
                                            .copyWith(
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
      ),
    );
  }

  void _showAllReviews(BuildContext context, int productId) {
    final reviewCubit = context.read<ReviewCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder:
          (_) => BlocProvider.value(
            value: reviewCubit,
            child: BlocProvider(
              create: (_) => OrdersCubit(OrdersServices()),
              child: AllReviewsBottomSheet(productId: productId),
            ),
          ),
    );
  }

  Widget _circleButton({required Widget icon, required VoidCallback onTap}) {
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
        final isLoggedIn =
            state is AuthLoadedLogin || state is AuthLoadedRegister;
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

class _StockChip extends StatelessWidget {
  const _StockChip({required this.inStock});

  final bool inStock;

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final color = inStock ? AppColors.teal : const Color(0xFFEF4444);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        inStock
            ? (isAr ? 'متوفر' : 'In stock')
            : (isAr ? 'غير متوفر' : 'Out of stock'),
        style: AppTextStyles.noto14w400.copyWith(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _ProductReviewsSection extends StatelessWidget {
  const _ProductReviewsSection({required this.onShowAll});

  final VoidCallback onShowAll;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE6EEF5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  S.of(context).reviewsAndrev,
                  style: AppTextStyles.noto16w400.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkColor,
                  ),
                ),
              ),
              TextButton(
                onPressed: onShowAll,
                child: Text(S.of(context).show_more),
              ),
            ],
          ),
          BlocBuilder<ReviewCubit, ReviewState>(
            builder: (context, state) {
              if (state is ReviewLoading || state is ReviewInitial) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (state is ReviewError) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(state.message.localizedMessage(context)),
                );
              }
              if (state is ReviewRatesLoaded) {
                if (state.reviews.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(S.of(context).reviewsEmpty),
                  );
                }
                final reviews = state.reviews.take(3).toList();
                return Column(
                  children: [
                    for (var index = 0; index < reviews.length; index++) ...[
                      if (index > 0) const Divider(height: 24),
                      CustomReviewListItem(
                        rate: reviews[index].rate,
                        reviewerName: reviews[index].user.name,
                        reviewText: reviews[index].review ?? '',
                        createdAt: reviews[index].createdAt.toString(),
                      ),
                    ],
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
