import 'package:cached_network_image/cached_network_image.dart';
import 'package:elkawther/core/widgets/pharmacy_placeholder.dart';
import 'package:elkawther/features/categories/models/category_products_model.dart';
import 'package:elkawther/features/categories/models/categories_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:shimmer/shimmer.dart';
import 'package:text_search/text_search.dart';

import 'package:elkawther/features/categories/cubit/category_products_cubit.dart';
import 'package:elkawther/features/favorites/cubit/favourite_cubit.dart';
import 'package:elkawther/core/utils/discount_helpers.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_padding.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/widgets/pharmacy_logo.dart';
import 'package:elkawther/generated/assets.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/features/products/widgets/product_item.dart';
import 'package:elkawther/features/categories/widgets/subcategory_chips.dart';
import 'package:elkawther/core/utils/string_normalizer.dart';
import 'package:elkawther/features/products/widgets/filter_bottom_sheet.dart';

class CategoryProductsView extends StatefulWidget {
  final int categoryId;
  final String categoryName;
  final String? imageUrl;
  final List<Subcategory> subcategory;

  const CategoryProductsView({
    super.key,
    required this.categoryId,
    required this.categoryName,
    this.imageUrl,
    required this.subcategory,
  });

  @override
  State<CategoryProductsView> createState() => _CategoryProductsViewState();
}

class _CategoryProductsViewState extends State<CategoryProductsView> {
  int? _selectedSubcategoryId;
  late final CategoryProductsCubit _cubit;
  final TextEditingController _searchController = TextEditingController();

  List<CategoryProductsData> _allProducts = [];
  List<CategoryProductsData> _filteredProducts = [];
  TextSearch? _textSearch;

  final Set<String> _selectedFilters = {};
  final ScrollController scrollController = ScrollController();
  bool _isLoadingMore = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _cubit = GetIt.I<CategoryProductsCubit>();
    _fetchProducts();

    scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearchChanged);
  }

  Subcategory? get _selectedSubcategory {
    final id = _selectedSubcategoryId;
    if (id == null) return null;
    for (final sub in widget.subcategory) {
      if (sub.id == id) return sub;
    }
    return null;
  }

  String? get _heroImage {
    final selected = _selectedSubcategory;
    if (selected != null && selected.imageUrl.isNotEmpty) {
      return selected.imageUrl;
    }
    if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty) {
      return widget.imageUrl;
    }
    if (widget.subcategory.isNotEmpty &&
        widget.subcategory.first.imageUrl.isNotEmpty) {
      return widget.subcategory.first.imageUrl;
    }
    return null;
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore) {
      _loadMore();
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().normalize();
    if (_searchQuery != query) {
      _searchQuery = query;
      _fetchProducts();
    }
  }

  Future<void> _fetchProducts() async {
    final fetchId = _selectedSubcategoryId ?? widget.categoryId;

    _allProducts.clear();
    _filteredProducts.clear();
    _textSearch = null;
    if (mounted) setState(() {});

    if (_searchQuery.isEmpty) {
      await _cubit.fetchCategoryProducts(fetchId, context, limit: 10);
    } else {
      await _cubit.searchCategoryProductsPaginated(
        fetchId,
        _searchQuery,
        limit: 50,
      );
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore) return;
    setState(() => _isLoadingMore = true);

    final fetchId = _selectedSubcategoryId ?? widget.categoryId;

    if (_searchQuery.isEmpty) {
      await _cubit.fetchMoreCategoryProducts(fetchId, context, limit: 10);
    } else {
      await _cubit.searchCategoryProductsPaginated(
        fetchId,
        _searchQuery,
        limit: 50,
      );
    }

    if (mounted) setState(() => _isLoadingMore = false);
  }

  void _applySelectedFilters() {
    if (_selectedFilters.isEmpty) return;

    final filter = _selectedFilters.first;

    if (filter == S.of(context).price_high_to_low ||
        filter == S.of(context).price_low_to_high ||
        filter == S.of(context).top_rated) {
      _filteredProducts.sort((a, b) {
        if (filter == S.of(context).price_high_to_low) {
          return _productPrice(b).compareTo(_productPrice(a));
        }
        if (filter == S.of(context).price_low_to_high) {
          return _productPrice(a).compareTo(_productPrice(b));
        }
        if (filter == S.of(context).top_rated) {
          return (b.rate ?? 0).compareTo(a.rate ?? 0);
        }
        return 0;
      });
    }
    setState(() {});
  }

  double _productPrice(CategoryProductsData product) {
    final sizes = product.availableSizes ?? const <AvailableSize>[];
    for (final size in sizes) {
      if ((size.stock ?? 0) > 0) return size.price ?? 0;
    }
    if (sizes.isNotEmpty) return sizes.first.price ?? 0;
    return product.finalPrice ??
        product.priceAfterDiscount ??
        double.tryParse(product.price ?? '') ??
        0;
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (_) => FilterBottomSheet(
            selectedFilters: _selectedFilters,
            onFilterChanged: (filter, isSelected) async {
              setState(() {
                if (isSelected) {
                  _selectedFilters.clear();
                  _selectedFilters.add(filter);
                } else {
                  _selectedFilters.remove(filter);
                }
              });

              final fetchId = _selectedSubcategoryId ?? widget.categoryId;

              if (_selectedFilters.isEmpty) {
                _resetAllFilters();
              } else {
                final currentFilter = _selectedFilters.first;

                if (currentFilter == S.of(context).best_selling) {
                  _allProducts.clear();
                  _filteredProducts.clear();
                  _textSearch = null;
                  await _cubit.fetchCategoryProductsBestSelling(
                    fetchId,
                    context,
                  );
                } else if (currentFilter == S.of(context).newest) {
                  _allProducts.clear();
                  _filteredProducts.clear();
                  _textSearch = null;
                  await _cubit.fetchCategoryProductsNewArrival(
                    fetchId,
                    context,
                  );
                } else {
                  _filterProductsLocally();
                }
              }
            },
          ),
    );
  }

  void _filterProductsLocally() {
    if (_textSearch == null || _searchQuery.isEmpty) {
      _filteredProducts = List.from(_allProducts);
    } else {
      final results = _textSearch!.search(_searchQuery);
      _filteredProducts =
          results.map((r) => r.object as CategoryProductsData).toList();
    }
    _applySelectedFilters();
  }

  Future<void> _resetAllFilters() async {
    setState(() {
      _selectedFilters.clear();
      _searchController.clear();
      _filteredProducts = [];
      _allProducts = [];
      _textSearch = null;
    });

    final fetchId = _selectedSubcategoryId ?? widget.categoryId;
    await _cubit.fetchCategoryProducts(fetchId, context, limit: 10);
  }

  @override
  void dispose() {
    _searchController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final heading = _selectedSubcategory?.name ?? widget.categoryName;

    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<CategoryProductsCubit, CategoryProductsState>(
        listener: (context, state) {
          if (state is CategoryProductsLoaded) {
            final products = state.categoryProducts;

            if (!state.isLoadMore || _allProducts.isEmpty) {
              _allProducts = List<CategoryProductsData>.from(products);
            } else {
              for (var product in products) {
                if (!_allProducts.any((p) => p.id == product.id)) {
                  _allProducts.add(product);
                }
              }
            }

            _textSearch = TextSearch(
              _allProducts
                  .map(
                    (p) => TextSearchItem.fromTerms(p, [
                      (p.name ?? '').normalize(),
                      (p.description ?? '').normalize(),
                    ]),
                  )
                  .toList(),
            );

            _filterProductsLocally();
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF5FAFD),
          body: Column(
            children: [
              _CategoryHero(
                imageUrl: _heroImage,
                title: heading,
                countLabel:
                    isAr
                        ? '${_filteredProducts.length} منتج'
                        : '${_filteredProducts.length} products',
                onBack: () => Navigator.pop(context),
              ),
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: S.of(context).searchFor,
                              hintStyle: AppTextStyles.noto14w400.copyWith(
                                color: AppColors.grey,
                                fontSize: 14,
                              ),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(12),
                                child: SvgPicture.asset(
                                  Assets.iconsSearchIcon,
                                  colorFilter: const ColorFilter.mode(
                                    AppColors.primaryColor,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                              suffixIcon:
                                  _searchController.text.isEmpty
                                      ? null
                                      : IconButton(
                                        onPressed: () {
                                          _searchController.clear();
                                        },
                                        icon: const Icon(
                                          Icons.close_rounded,
                                          size: 20,
                                          color: AppColors.grey,
                                        ),
                                      ),
                              filled: true,
                              fillColor: const Color(0xFFF5FAFD),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: AppColors.lightDarker,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: AppColors.primaryColor,
                                  width: 1.4,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Material(
                          color: AppColors.light,
                          borderRadius: BorderRadius.circular(14),
                          child: InkWell(
                            onTap: _showFilterBottomSheet,
                            borderRadius: BorderRadius.circular(14),
                            child: SizedBox(
                              width: 48,
                              height: 48,
                              child: Center(
                                child: SvgPicture.asset(
                                  Assets.iconsFilterIcon,
                                  height: 22,
                                  width: 22,
                                ),
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
                                return Chip(
                                  backgroundColor: AppColors.light,
                                  label: Text(
                                    filter,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    side: const BorderSide(
                                      color: AppColors.lightDarker,
                                    ),
                                  ),
                                  deleteIcon: const Icon(Icons.close, size: 16),
                                  onDeleted: _resetAllFilters,
                                );
                              }).toList(),
                        ),
                      ),
                    if (widget.subcategory.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      SubcategoryChips(
                        subcategories: widget.subcategory,
                        selected: _selectedSubcategoryId,
                        allLabel: isAr ? 'الكل' : 'All',
                        onSelected: (id) {
                          if (_selectedSubcategoryId == id) return;
                          setState(() => _selectedSubcategoryId = id);
                          _fetchProducts();
                        },
                      ),
                    ],
                  ],
                ),
              ),
              Expanded(child: _buildProductGrid(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductGrid(BuildContext context) {
    return BlocBuilder<CategoryProductsCubit, CategoryProductsState>(
      builder: (context, state) {
        if (state is CategoryProductsLoading && _allProducts.isEmpty) {
          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 14,
              childAspectRatio: 0.62,
            ),
            itemCount: 6,
            itemBuilder:
                (context, index) => Shimmer.fromColors(
                  baseColor: const Color(0xFFD6F0FA),
                  highlightColor: Colors.white,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.light,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
          );
        }

        if (_filteredProducts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const PharmacyLogo(size: 72),
                const SizedBox(height: AppPadding.medium),
                Text(
                  S.of(context).no_products_found,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 16,
                    color: AppColors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 14,
            childAspectRatio: 0.62,
          ),
          itemCount: _filteredProducts.length,
          itemBuilder: (context, index) {
            final product = _filteredProducts[index];
            var isFav = context.read<FavouriteCubit>().isProductFavourite(
              product.id ?? 0,
            );

            return ProductItem(
              productId: product.id ?? 0,
              image: product.imageUrl ?? Assets.imagesCattest,
              title: product.name ?? '',
              subtitle: product.description ?? '',
              price: _productPrice(product),
              hasDiscount: product.discountType != null,
              discount: getDiscount(product, context),
              rating: product.rate ?? 0.0,
              reviews: product.ratingsCount ?? 0,
              sizesIds: product.availableSizes ?? [],
              isFav: isFav,
              onFavClick: () {
                setState(() {
                  isFav = !isFav;
                });
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
  }
}

class _CategoryHero extends StatelessWidget {
  const _CategoryHero({
    required this.imageUrl,
    required this.title,
    required this.countLabel,
    required this.onBack,
  });

  final String? imageUrl;
  final String title;
  final String countLabel;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 168,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ColoredBox(
            color: AppColors.light,
            child:
                imageUrl == null
                    ? const Center(child: PharmacyPlaceholder(size: 72))
                    : CachedNetworkImage(
                      imageUrl: imageUrl!,
                      fit: BoxFit.cover,
                      placeholder:
                          (context, url) =>
                              const ColoredBox(color: AppColors.light),
                      errorWidget:
                          (context, url, error) => const Center(
                            child: PharmacyPlaceholder(size: 72),
                          ),
                    ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.18),
                  AppColors.primaryColor.withOpacity(0.88),
                ],
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: onBack,
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.noto16w400.copyWith(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.24)),
                    ),
                    child: Text(
                      countLabel,
                      style: AppTextStyles.noto14w400.copyWith(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
