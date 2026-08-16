import 'package:elkawther/core/utils/discount_helpers.dart';
import 'package:elkawther/features/products/services/brand_products_service.dart';
import 'package:elkawther/features/products/widgets/product_grid_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';

import 'package:elkawther/features/favorites/cubit/favourite_cubit.dart';
import 'package:elkawther/features/products/cubit/health_issue_products_cubit.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_padding.dart';
import 'package:elkawther/generated/assets.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/features/products/models/health_issue_products_model.dart';
import 'package:elkawther/features/products/services/health_issue_products_service.dart';
import 'package:elkawther/features/products/widgets/product_item.dart';
import 'package:elkawther/core/widgets/custom_search_bar.dart';
import 'package:elkawther/features/products/widgets/filter_bottom_sheet.dart';

class HealthIssueProductsView extends StatefulWidget {
  final int issueId;
  final String issueName;

  const HealthIssueProductsView({
    super.key,
    required this.issueId,
    required this.issueName,
  });

  @override
  State<HealthIssueProductsView> createState() =>
      _HealthIssueProductsViewState();
}

class _HealthIssueProductsViewState extends State<HealthIssueProductsView> {
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _selectedFilters = {};

  List<HealthIssueProducts> _allProducts = [];
  List<HealthIssueProducts> _filteredProducts = [];

  late final HealthIssueProductsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = HealthIssueProductsCubit(
      GetIt.I<HealthIssueProductsService>(),
      GetIt.I<BrandProductsService>(),
    );
    _fetchProducts();
    _searchController.addListener(_applyFiltersAndSearch);
  }

  Future<void> _fetchProducts() async {
    await _cubit.fetchHealthIssueProducts(widget.issueId, context);
  }

  void _applyFiltersAndSearch() {
    final query = _searchController.text.trim();

    if (query.isNotEmpty) {
      _cubit.searchProducts(query).then((_) {
        setState(() {
          _filteredProducts =
              _cubit.searchResults.map((p) {
                return HealthIssueProducts(
                  id: p.id,
                  name: p.name,
                  description: p.description,
                  imageUrl: p.imageUrl,
                  avaiableSize: p.avaiableSize,
                  discountType: p.discountType,
                  averageRating: p.rate,
                  ratingsCount: p.ratingsCount,
                );
              }).toList();
        });
      });
      return;
    }

    List<HealthIssueProducts> temp = List.from(_allProducts);
    final filter = _selectedFilters.isNotEmpty ? _selectedFilters.first : '';

    if (filter == S.of(context).top_rated) {
      temp.sort(
        (a, b) => (b.averageRating ?? 0).compareTo(a.averageRating ?? 0),
      );
    } else if (filter == S.of(context).price_low_to_high) {
      temp.sort(
        (a, b) => (a.avaiableSize!.first.price ?? 0).compareTo(
          b.avaiableSize!.first.price ?? 0,
        ),
      );
    } else if (filter == S.of(context).price_high_to_low) {
      temp.sort(
        (a, b) => (b.avaiableSize!.first.price ?? 0).compareTo(
          a.avaiableSize!.first.price ?? 0,
        ),
      );
    }

    setState(() => _filteredProducts = temp);
  }

  Future<void> _resetAllFilters() async {
    setState(() {
      _selectedFilters.clear();
      _searchController.clear();
      _filteredProducts = List.from(_allProducts);
    });

    _cubit.searchResults.clear();
    await _fetchProducts();
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
                if (isSelected) _selectedFilters.add(filter);

                final fetchId = widget.issueId;

                if (filter == S.of(context).best_selling && isSelected) {
                  _cubit.fetchHealthProductsBestSelling(fetchId, context);
                } else if (filter == S.of(context).newest && isSelected) {
                  _cubit.fetchHealthProductsNewArrival(fetchId, context);
                } else {
                  if (_selectedFilters.isEmpty) {
                    _resetAllFilters();
                  } else {
                    _applyFiltersAndSearch();
                  }
                }
              });
            },
          ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            widget.issueName,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          centerTitle: true,
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
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: _showFilterBottomSheet,
                    child: SvgPicture.asset(Assets.iconsFilterIcon),
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
              Expanded(
                child: BlocBuilder<
                  HealthIssueProductsCubit,
                  HealthIssueProductsState
                >(
                  builder: (context, state) {
                    if (state is HealthIssueProductsLoading) {
                      return const ShimmerLoading();
                    } else if (state is HealthIssueProductsLoaded) {
                      final products = state.healthIssueProducts;

                      if (_allProducts != products) {
                        _allProducts = products;
                        _filteredProducts = List.from(_allProducts);
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _applyFiltersAndSearch();
                        });
                      }

                      if (_filteredProducts.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                Assets.unfound,
                                width: 70,
                                height: 70,
                              ),
                              const SizedBox(height: AppPadding.medium),
                              Text(
                                S.of(context).no_products_found,
                                style: Theme.of(
                                  context,
                                ).textTheme.titleLarge?.copyWith(
                                  fontSize: 22,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return GridView.builder(
                        padding: EdgeInsets.zero,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.55,
                            ),
                        itemCount: _filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = _filteredProducts[index];
                          var isFav = context
                              .read<FavouriteCubit>()
                              .isProductFavourite(product.id ?? 0);

                          return ProductItem(
                            productId: product.id ?? 0,
                            image: product.imageUrl ?? Assets.imagesCattest,
                            title: product.name ?? '',
                            subtitle: product.description,
                            price: product.avaiableSize?.first.price ?? 0.0,
                            rating: product.averageRating ?? 0.0,
                            reviews: product.ratingsCount ?? 0,
                            sizesIds: List.from(product.avaiableSize ?? []),
                            hasDiscount: product.discountType != null,
                            discount: getDiscountHealth(product, context),
                            isFav: isFav,
                            onFavClick: () {
                              setState(() => isFav = !isFav);
                              context.read<FavouriteCubit>().toggleFavourite(
                                productId: product.id ?? 0,
                                context: context,
                              );
                            },
                          );
                        },
                      );
                    } else if (state is HealthIssueProductsError) {
                      return Center(child: Text(state.message));
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
