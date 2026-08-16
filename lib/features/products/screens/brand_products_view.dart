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
import 'package:elkawther/core/widgets/custom_search_bar.dart';
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
          (a, b) => (b.availableSizes?.first.price ?? 0).compareTo(
            a.availableSizes?.first.price ?? 0,
          ),
        );
      } else if (filter == S.of(context).price_low_to_high) {
        temp.sort(
          (a, b) => (a.availableSizes?.first.price ?? 0).compareTo(
            b.availableSizes?.first.price ?? 0,
          ),
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
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: Text(
            widget.brandName,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(AppPadding.medium),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomSearchBar(
                      controller: _searchController,
                      searchHint: S.of(context).searchFor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: _showFilterBottomSheet,
                    child: SvgPicture.asset(
                      Assets.iconsFilterIcon,
                      height: 45,
                      width: 45,
                    ),
                  ),
                ],
              ),
              if (_selectedFilters.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Wrap(
                    spacing: 8,
                    children:
                        _selectedFilters.map((filter) {
                          return Chip(
                            label: Text(
                              filter,
                              style: const TextStyle(fontSize: 12),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            deleteIcon: const Icon(Icons.close),
                            onDeleted: _resetAllFilters,
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
                      fontSize: 22,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            controller: _scrollController,
            padding: EdgeInsets.zero,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.55,
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
                    price: product.availableSizes?.first.price ?? 0.0,
                    hasDiscount: product.discountType != null,
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
          return Center(child: Text(state.message));
        }

        return const SizedBox.shrink();
      },
    );
  }
}
