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
              ? _FavoritesStatus(
                  icon: Icons.error_outline_rounded,
                  iconColor: const Color(0xFFEF4444),
                  message: error,
                  action: S.of(context).retry,
                  onAction: () => context
                      .read<FavouriteCubit>()
                      .fetchFavourites(context),
                )
              : products.isEmpty
              ? _FavoritesStatus(
                  icon: Icons.favorite_border_rounded,
                  iconColor: const Color(0xFFEF4444),
                  message: S.of(context).favouriteEmpty,
                  detail: isAr
                      ? 'احفظ المنتجات التي تريد شراءها لاحقاً'
                      : 'Save products you want to buy later',
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: _SavedSummary(
                        count: products.length,
                        label: isAr ? 'منتج محفوظ' : 'saved products',
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                        itemCount: products.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 14,
                              crossAxisSpacing: 12,
                              childAspectRatio: ProductItem.cardAspectRatio,
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
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class _SavedSummary extends StatelessWidget {
  const _SavedSummary({required this.count, required this.label});

  final int count;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFB42318), Color(0xFFEF4444), Color(0xFFFF7A7A)],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEF4444).withOpacity(0.18),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.favorite_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$count',
                  style: AppTextStyles.noto16w400.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: AppTextStyles.noto14w400.copyWith(
                    color: Colors.white.withOpacity(0.88),
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FavoritesStatus extends StatelessWidget {
  const _FavoritesStatus({
    required this.icon,
    required this.iconColor,
    required this.message,
    this.detail,
    this.action,
    this.onAction,
  });

  final IconData icon;
  final Color iconColor;
  final String message;
  final String? detail;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFE6EEF5)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 32),
              ),
              const SizedBox(height: 14),
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppTextStyles.noto16w400.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.darkColor,
                  fontSize: 15,
                ),
              ),
              if (detail != null) ...[
                const SizedBox(height: 6),
                Text(
                  detail!,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.noto14w400.copyWith(
                    color: AppColors.grey,
                    fontSize: 13,
                  ),
                ),
              ],
              if (action != null && onAction != null) ...[
                const SizedBox(height: 16),
                TextButton(
                  onPressed: onAction,
                  child: Text(
                    action!,
                    style: AppTextStyles.noto14w400.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
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
        border: Border.all(color: const Color(0xFFE6EEF5)),
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
