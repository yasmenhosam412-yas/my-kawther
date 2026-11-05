import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/utils/discount_helpers.dart';
import 'package:elkawther/features/favorites/cubit/favourite_cubit.dart';
import 'package:elkawther/features/products/widgets/product_item.dart';
import 'package:elkawther/features/profile/widgets/profile_scaffold.dart';
import 'package:elkawther/generated/assets.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<FavouriteCubit>().fetchFavourites(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return BlocBuilder<FavouriteCubit, FavouriteState>(
      builder: (context, state) {
        final products = context.read<FavouriteCubit>().favourites;
        final loading =
            products.isEmpty &&
            (state is FavouriteFetchLoading || state is FavouriteInitial);
        final error = state is FavouriteFetchError ? state.error : null;

        return ProfileScaffold(
          title: S.of(context).favourite,
          subtitle: isAr
              ? 'منتجاتك المحفوظة للشراء لاحقاً'
              : 'Saved products to buy later',
          body: loading
              ? const _FavoritesSkeleton()
              : error != null && products.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      error,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.noto14w400.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                  ),
                )
              : products.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.favorite_border_rounded,
                          size: 56,
                          color: AppColors.grey.withOpacity(0.7),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          S.of(context).favouriteEmpty,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.noto14w400.copyWith(
                            color: AppColors.grey,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.62,
                  ),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductItem(
                      productId: product.id,
                      image: product.mainImageUrl.isEmpty
                          ? Assets.imagesCattest
                          : product.mainImageUrl,
                      title: product.name,
                      subtitle: product.description,
                      price: product.finalPrice,
                      hasDiscount: product.discountType != null,
                      discount: getDiscountFav(product, context),
                      rating: product.averageRating ?? product.rate,
                      reviews: product.ratingsCount ?? 0,
                      sizesIdsFav: product.availableSize,
                      isFav: true,
                      onFavClick: () {
                        context.read<FavouriteCubit>().toggleFavourite(
                          productId: product.id,
                          context: context,
                        );
                      },
                    );
                  },
                ),
        );
      },
    );
  }
}

class _FavoritesSkeleton extends StatelessWidget {
  const _FavoritesSkeleton();

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 6,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 12,
          childAspectRatio: 0.62,
        ),
        itemBuilder: (_, __) => const _FavoriteSkeletonCard(),
      ),
    );
  }
}

class _FavoriteSkeletonCard extends StatelessWidget {
  const _FavoriteSkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Color(0xFFE8EEF2),
                borderRadius: BorderRadius.all(Radius.circular(14)),
              ),
              child: SizedBox.expand(),
            ),
          ),
          SizedBox(height: 10),
          Text('Product name'),
          SizedBox(height: 6),
          Text('120 EGP'),
        ],
      ),
    );
  }
}
