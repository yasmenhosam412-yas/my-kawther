import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elkawther/features/favorites/cubit/favourite_cubit.dart';
import 'package:elkawther/core/utils/discount_helpers.dart';
import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/core/routes/route_extras.dart';
import 'package:elkawther/core/theme/app_padding.dart';
import 'package:elkawther/generated/assets.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/features/categories/models/category_products_model.dart';
import 'package:elkawther/features/products/models/product_model.dart';
import 'package:elkawther/features/products/widgets/product_item.dart';
import 'package:elkawther/features/home/widgets/section_header.dart';

class SearchSuggestions extends StatefulWidget {
  final List<ProductModel> products;

  const SearchSuggestions({super.key, required this.products});

  @override
  State<SearchSuggestions> createState() => _SearchSuggestionsState();
}

class _SearchSuggestionsState extends State<SearchSuggestions> {
  @override
  Widget build(BuildContext context) {
    if (widget.products.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppPadding.medium),
        SectionHeader(
          title: S.of(context).suggestedForYou,
          actionText: S.of(context).viewMore,
          onPressed:
              () => Navigator.pushNamed(
                context,
                Routes.viewMoreProducts,
                arguments: ViewMoreProductsArgs(
                  title: S.of(context).suggestedForYou,
                  productType: "all_prods",
                ),
              ),
        ),
        const SizedBox(height: AppPadding.medium),
        SizedBox(
          height:
              MediaQuery.sizeOf(context).width *
              0.42 /
              ProductItem.cardAspectRatio,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.products.length,
            itemBuilder: (context, index) {
              final product = widget.products[index];

              return BlocBuilder<FavouriteCubit, FavouriteState>(
                builder: (context, state) {
                  var isFav = context.read<FavouriteCubit>().isProductFavourite(
                    product.id ?? 0,
                  );

                  return Padding(
                    padding: const EdgeInsets.only(right: 12, bottom: 5),
                    child: SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.42,
                      child: ProductItem(
                        image: product.imageUrl ?? Assets.imagesCattest,
                        title: product.name,
                        subtitle: product.description ?? '',
                        discount: getDiscountProductModel(product, context),
                        productId: product.id ?? 0,
                        rating: product.rate,
                        reviews: product.ratingsCount,
                        hasDiscount: product.discountType != null,
                        sizesIds: List<AvailableSize>.from(
                          product.availableSizes ?? [],
                        ),
                        price: product.availableSizes?.first.price ?? 0.0,
                        isFav: isFav,
                        onFavClick: () {
                          context.read<FavouriteCubit>().toggleFavourite(
                            productId: product.id ?? 0,
                            context: context,
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
