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

  double _priceOf(HealthIssueProducts product) {
    final sizes = product.avaiableSize;
    if (sizes != null && sizes.isNotEmpty) {
      return sizes.first.price ?? product.price ?? 0;
    }
    return product.price ?? 0;
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
      temp.sort((a, b) => _priceOf(a).compareTo(_priceOf(b)));
    } else if (filter == S.of(context).price_high_to_low) {
      temp.sort((a, b) => _priceOf(b).compareTo(_priceOf(a)));
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
        backgroundColor: const Color(0xFFF5FAFD),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF5FAFD),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          title: Text(
            S.of(context).shopByProblem,
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
                        AppColors.teal,
                        AppColors.teal.withOpacity(0.82),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.teal.withOpacity(0.18),
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
                          Icons.health_and_safety_rounded,
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
                              widget.issueName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(
                                context,
                              ).textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              S.of(context).shopByProblem,
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(
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
                              color:
                                  _selectedFilters.isNotEmpty
                                      ? AppColors.teal
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
                              ),
                              if (_selectedFilters.isNotEmpty)
                                PositionedDirectional(
                                  top: 8,
                                  end: 8,
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: AppColors.primaryColor,
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
                      children:
                          _selectedFilters.map((filter) {
                            return InputChip(
                              label: Text(filter),
                              onDeleted: _resetAllFilters,
                              deleteIconColor: AppColors.teal,
                              backgroundColor: AppColors.light,
                              side: BorderSide(
                                color: AppColors.teal.withOpacity(0.18),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              labelStyle: const TextStyle(
                                color: AppColors.teal,
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
    return BlocBuilder<HealthIssueProductsCubit, HealthIssueProductsState>(
      builder: (context, state) {
        if (state is HealthIssueProductsLoading) {
          return const Center(child: ShimmerLoading());
        }

        if (state is HealthIssueProductsLoaded) {
          final products = state.healthIssueProducts;
          if (_allProducts != products) {
            _allProducts = products;
            _filteredProducts = List.from(_allProducts);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _applyFiltersAndSearch();
            });
          }

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
                      color: AppColors.teal,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.only(bottom: 18),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 14,
              childAspectRatio: ProductItem.cardAspectRatio,
            ),
            itemCount: _filteredProducts.length,
            itemBuilder: (context, index) {
              final product = _filteredProducts[index];
              final isFav = context.read<FavouriteCubit>().isProductFavourite(
                product.id ?? 0,
              );

              return ProductItem(
                productId: product.id ?? 0,
                image: product.imageUrl ?? Assets.imagesCattest,
                title: product.name ?? '',
                subtitle: product.description,
                price: _priceOf(product),
                rating: product.averageRating ?? 0.0,
                reviews: product.ratingsCount ?? 0,
                sizesIds: List.from(product.avaiableSize ?? []),
                hasDiscount:
                    product.discountType != null &&
                    product.avaiableSize?.isNotEmpty == true,
                discount: getDiscountHealth(product, context),
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
        }

        if (state is HealthIssueProductsError) {
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
                  onPressed: _fetchProducts,
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
