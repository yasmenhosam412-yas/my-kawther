import 'package:elkawther/core/utils/discount_helpers.dart';
import 'package:elkawther/features/products/models/brand_products_model.dart';
import 'package:elkawther/features/products/widgets/product_grid_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';

import 'package:elkawther/features/products/cubit/brand_products_cubit.dart';
import 'package:elkawther/features/favorites/cubit/favourite_cubit.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_padding.dart';
import 'package:elkawther/generated/assets.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/features/products/widgets/product_item.dart';
import 'package:elkawther/features/products/widgets/filter_bottom_sheet.dart';

enum BrandFilterType { none, bestSelling, newArrival }

class BrandProductsView extends StatefulWidget {
  final int brandId;
  final String brandName;

  const BrandProductsView({
    super.key,
    required this.brandId,
    required this.brandName,
  });

  @override
  State<BrandProductsView> createState() => _BrandProductsViewState();
}

class _BrandProductsViewState extends State<BrandProductsView> {
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _selectedFilters = {};
  late final ScrollController _scrollController;

  List<BrandProduct> _filteredProducts = [];

  late final BrandProductsCubit _cubit;
  BrandFilterType _activeFilterType = BrandFilterType.none;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _cubit = GetIt.I<BrandProductsCubit>();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    _fetchProductsWithFilters();
    _searchController.addListener(_applyFiltersAndSearch);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 300 &&
        _cubit.canLoadMore &&
        !_isLoadingMore) {
      _loadMore();
    }
  }

  double _priceOf(BrandProduct product) {
    final sizes = product.availableSizes;
    if (sizes != null && sizes.isNotEmpty) {
      return sizes.first.price ?? product.finalPrice ?? 0;
    }
    return product.finalPrice ?? 0;
  }

  Future<void> _loadMore() async {
    setState(() => _isLoadingMore = true);
    await _cubit.fetchBrandProductsMore(widget.brandId, context);
    _applyFiltersAndSearch();
    setState(() => _isLoadingMore = false);
  }

  void _applyFiltersAndSearch() {
    final query = _searchController.text.trim();

    if (query.isNotEmpty) {
      _cubit.searchProducts(query, context).then((_) {
        setState(() {
          _filteredProducts = List<BrandProduct>.from(
            _cubit.searchResults.map(
              (p) => BrandProduct(
                id: p.id,
                name: p.name,
                description: p.description,
                imageUrl: p.imageUrl,
                availableSizes: p.availableSizes,
                discountType: p.discountType,
                rate: p.rate,
                ratingsCount: p.ratingsCount,
              ),
            ),
          );
        });
      });
      return;
    }

    List<BrandProduct> temp = List.from(_cubit.brandProducts);

    if (_selectedFilters.isNotEmpty) {
      final filter = _selectedFilters.first;

      if (filter == S.of(context).price_high_to_low) {
        temp.sort(
          (a, b) => _priceOf(b).compareTo(_priceOf(a)),
        );
      } else if (filter == S.of(context).price_low_to_high) {
        temp.sort(
          (a, b) => _priceOf(a).compareTo(_priceOf(b)),
        );
      } else if (filter == S.of(context).top_rated) {
        temp.sort((a, b) => (b.rate ?? 0).compareTo(a.rate ?? 0));
      }
    }

    setState(() {
      _filteredProducts = temp;
    });
  }

  Future<void> _fetchProductsWithFilters() async {
    final brandId = widget.brandId;

    switch (_activeFilterType) {
      case BrandFilterType.bestSelling:
        await _cubit.fetchBrandProductsBestSelling(brandId, context);
        break;
      case BrandFilterType.newArrival:
        await _cubit.fetchBrandProductsNewArrival(brandId, context);
        break;
      case BrandFilterType.none:
        await _cubit.fetchBrandProducts(brandId, context);
        break;
    }

    _applyFiltersAndSearch();
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (_) => FilterBottomSheet(
            selectedFilters: _selectedFilters,
            onFilterChanged: (filter, isSelected) {
              setState(() {
                _selectedFilters.clear();

                if (isSelected) {
                  _selectedFilters.add(filter);

                  if (filter == S.of(context).best_selling) {
                    _activeFilterType = BrandFilterType.bestSelling;
                  } else if (filter == S.of(context).newest) {
                    _activeFilterType = BrandFilterType.newArrival;
                  } else {
                    _activeFilterType = BrandFilterType.none;
                  }
                } else {
                  _activeFilterType = BrandFilterType.none;
                }

                if (_activeFilterType == BrandFilterType.none) {
                  _fetchProductsWithFilters();
                }

                if (_activeFilterType == BrandFilterType.bestSelling ||
                    _activeFilterType == BrandFilterType.newArrival) {
                  _fetchProductsWithFilters();
                } else {
                  _applyFiltersAndSearch();
                }
              });
            },
          ),
    );
  }

  Future<void> _resetAllFilters() async {
    setState(() {
      _selectedFilters.clear();
      _activeFilterType = BrandFilterType.none;
      _searchController.clear();
    });

    _cubit.searchResults.clear();
    await _cubit.fetchBrandProducts(widget.brandId, context);
    _applyFiltersAndSearch();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5FAFD),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF5FAFD),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          title: Text(
            S.of(context).brands,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.darkColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.medium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: AlignmentDirectional.topStart,
                      end: AlignmentDirectional.bottomEnd,
                      colors: [
                        AppColors.primaryColor,
                        AppColors.primaryColor.withOpacity(0.82),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.18),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(17),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.24),
                          ),
                        ),
                        child: const Icon(
                          Icons.storefront_rounded,
                          size: 29,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.brandName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              S.of(context).brands,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Colors.white.withOpacity(0.85),
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.16),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          '${_filteredProducts.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 52,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.lightDarker),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.darkColor.withOpacity(0.04),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              Assets.iconsSearchIcon,
                              height: 20,
                              width: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  hintText: S.of(context).searchFor,
                                  border: InputBorder.none,
                                  isCollapsed: true,
                                  hintStyle: TextStyle(
                                    color: AppColors.grey.withOpacity(0.75),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        onTap: _showFilterBottomSheet,
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: _selectedFilters.isNotEmpty
                                  ? AppColors.primaryColor
                                  : AppColors.lightDarker,
                            ),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SvgPicture.asset(
                                Assets.iconsFilterIcon,
                                height: 22,
                                width: 22,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.primaryColor,
                                  BlendMode.srcIn,
                                ),
                              ),
                              if (_selectedFilters.isNotEmpty)
                                PositionedDirectional(
                                  top: 8,
                                  end: 8,
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: AppColors.teal,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (_selectedFilters.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Wrap(
                      spacing: 8,
                      children: _selectedFilters.map((filter) {
                        return InputChip(
                          label: Text(filter),
                          onDeleted: _resetAllFilters,
                          deleteIconColor: AppColors.primaryColor,
                          backgroundColor: AppColors.light,
                          side: BorderSide(
                            color: AppColors.primaryColor.withOpacity(0.14),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          labelStyle: const TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                const SizedBox(height: 16),
                Expanded(child: _buildProductGrid(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductGrid(BuildContext context) {
    return BlocBuilder<BrandProductsCubit, BrandProductsState>(
      builder: (context, state) {
        if (state is BrandProductsLoading && _filteredProducts.isEmpty) {
          return const Center(child: ShimmerLoading());
        } else if (state is BrandProductsLoaded ||
            _filteredProducts.isNotEmpty) {
          if (_filteredProducts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(Assets.unfound, width: 70, height: 70),
                  const SizedBox(height: AppPadding.medium),
                  Text(
                    S.of(context).no_products_found,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 20,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.only(bottom: 18),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 14,
              childAspectRatio: ProductItem.cardAspectRatio,
            ),
            itemCount: _filteredProducts.length + (_isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (_isLoadingMore && index == _filteredProducts.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final product = _filteredProducts[index];

              return BlocBuilder<FavouriteCubit, FavouriteState>(
                builder: (context, state) {
                  final isFav = context
                      .read<FavouriteCubit>()
                      .isProductFavourite(product.id ?? 0);
                  return ProductItem(
                    productId: product.id ?? 0,
                    image: product.imageUrl ?? Assets.imagesCattest,
                    title: product.name ?? '',
                    subtitle: product.description ?? '',
                    price: _priceOf(product),
                    hasDiscount: product.discountType != null &&
                        product.availableSizes?.isNotEmpty == true,
                    discount: getDiscountBrand(product, context),
                    rating: product.rate ?? 0.0,
                    reviews: product.ratingsCount ?? 0,
                    sizesIds: product.availableSizes ?? [],
                    isFav: isFav,
                    onFavClick: () {
                      context.read<FavouriteCubit>().toggleFavourite(
                        productId: product.id ?? 0,
                        context: context,
                      );
                    },
                  );
                },
              );
            },
          );
        } else if (state is BrandProductsError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.wifi_off_rounded,
                  size: 42,
                  color: AppColors.grey.withOpacity(0.7),
                ),
                const SizedBox(height: 12),
                Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.grey),
                ),
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: _fetchProductsWithFilters,
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(S.of(context).retry),
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
