import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/utils/discount_helpers.dart';
import 'package:elkawther/features/products/models/related_product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:elkawther/features/favorites/cubit/favourite_cubit.dart';
import 'package:elkawther/features/products/cubit/product_details_cubit.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/features/products/widgets/product_item.dart';

class RelatedProductsList extends StatefulWidget {
  final int productId;

  const RelatedProductsList({super.key, required this.productId});

  @override
  State<RelatedProductsList> createState() => _RelatedProductsListState();
}

class _RelatedProductsListState extends State<RelatedProductsList> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      if (!mounted) return;
      context.read<ProductDetailsCubit>().fetchRelatedProducts(
        widget.productId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final productCardHeight = size.width * 0.4 / ProductItem.cardAspectRatio;

    return BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
      buildWhen:
          (previous, current) =>
              current is RelatedProductsLoading ||
              current is RelatedProductsLoaded ||
              current is RelatedProductsError,
      builder: (context, state) {
        if (state is RelatedProductsLoading) {
          return SizedBox(
            height: productCardHeight,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state is RelatedProductsLoaded && state.relatedProducts.isEmpty) {
          return const SizedBox.shrink();
        }

        if (state is RelatedProductsError) {
          return const SizedBox.shrink();
        }

        if (state is RelatedProductsLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  S.of(context).suggested_for_you,
                  style: AppTextStyles.noto24w500.copyWith(
                    fontSize: 17,
                    color: AppColors.darkColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(
                height: productCardHeight,
                child: SuggestionsForYou(
                  relatedProducts: state.relatedProducts,
                ),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class SuggestionsForYou extends StatefulWidget {
  final List<RelatedProductDataModel> relatedProducts;

  const SuggestionsForYou({super.key, required this.relatedProducts});

  @override
  State<SuggestionsForYou> createState() => _SuggestionsForYouState();
}

class _SuggestionsForYouState extends State<SuggestionsForYou> {
  @override
  Widget build(BuildContext context) {
    if (widget.relatedProducts.isEmpty) return const SizedBox();

    final screenWidth = MediaQuery.sizeOf(context).width;

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: widget.relatedProducts.length,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemBuilder: (context, index) {
        final relatedProduct = widget.relatedProducts[index];
        var isFav =
            relatedProduct.isFavorite ||
            context.read<FavouriteCubit>().isProductFavourite(
              relatedProduct.id,
            );
        return Padding(
          padding: const EdgeInsets.only(right: 12, bottom: 10),
          child: SizedBox(
            width: screenWidth * 0.4,
            child: ProductItem(
              productId: relatedProduct.id,
              image: relatedProduct.imageUrl ?? "",
              title: relatedProduct.name,
              subtitle: relatedProduct.description ?? "",
              price:
                  relatedProduct.availableSizes.isNotEmpty
                      ? relatedProduct.availableSizes.first.price ?? 0
                      : relatedProduct.finalPrice,
              rating: relatedProduct.averageRating,
              reviews: relatedProduct.ratingsCount,
              discount: getDiscountReltaed(relatedProduct, context),
              hasDiscount:
                  relatedProduct.discountType != null &&
                  relatedProduct.availableSizes.isNotEmpty,
              sizesIds: relatedProduct.availableSizes,
              isFav: isFav,
              onFavClick: () {
                setState(() {
                  isFav = !isFav;
                });
                context.read<FavouriteCubit>().toggleFavourite(
                  productId: relatedProduct.id,
                  context: context,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
