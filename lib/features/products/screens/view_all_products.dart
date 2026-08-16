import 'package:cached_network_image/cached_network_image.dart';
import 'package:elkawther/core/routes/route_extras.dart';
import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/utils/discount_helpers.dart';
import 'package:elkawther/core/widgets/custom_elevated_button.dart';
import 'package:elkawther/core/widgets/pharmacy_logo.dart';
import 'package:elkawther/core/widgets/pharmacy_placeholder.dart';
import 'package:elkawther/features/categories/models/categories_model.dart';
import 'package:elkawther/features/categories/models/category_products_model.dart';
import 'package:elkawther/features/favorites/cubit/favourite_cubit.dart';
import 'package:elkawther/features/home/cubit/home_cubit.dart';
import 'package:elkawther/features/home/cubit/home_state.dart';
import 'package:elkawther/features/home/models/brands_model.dart';
import 'package:elkawther/features/home/models/health_issue_model.dart';
import 'package:elkawther/features/products/models/best_selling_products_model.dart';
import 'package:elkawther/features/products/models/big_discount_products_model.dart';
import 'package:elkawther/features/products/models/latest_products_model.dart';
import 'package:elkawther/features/products/models/product_model.dart'
    hide parseToDouble;
import 'package:elkawther/features/products/models/special_packages_model.dart';
import 'package:elkawther/features/products/widgets/product_item.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class ViewMoreProductsView extends StatefulWidget {
  final String title;
  final String productType;

  const ViewMoreProductsView({
    super.key,
    required this.title,
    required this.productType,
  });

  @override
  State<ViewMoreProductsView> createState() => _ViewMoreProductsViewState();
}

class _ViewMoreProductsViewState extends State<ViewMoreProductsView> {
  final _scrollController = ScrollController();
  bool _isFetchingMore = false;
  int _selectedCategoryId = -1;
  int? _selectedSubcategoryId;

  bool get _isTileGrid =>
      widget.productType == 'categories' ||
      widget.productType == 'health_issues' ||
      widget.productType == 'brands';

  bool get _isCategories => widget.productType == 'categories';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchProducts(refresh: true);
      context.read<FavouriteCubit>().fetchFavourites(context);
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isFetchingMore) return;
    if (_scrollController.position.pixels <
        _scrollController.position.maxScrollExtent - 350) {
      return;
    }

    
  }

  Future<void> _fetchProducts({bool refresh = false}) async {

    if (widget.productType == 'categories' && !refresh) {
      _isFetchingMore = true;
    }

    

    if (mounted) setState(() => _isFetchingMore = false);
  }

  List<dynamic> _items(HomeState state) {
    switch (widget.productType) {
      case 'categories':
        return state.allCategories?.data ?? state.categories?.data ?? [];
      case 'big_discounts':
      case 'special_packages':
      case 'getAll':
        return state.packageProducts;
      case 'best_selling':
        return state.bestSelling?.data ?? [];
      case 'new_arrival':
        return state.latestProducts?.data ?? [];
      case 'health_issues':
        return state.healthIssues?.data ?? [];
      case 'brands':
        return state.brands;
      case 'on/sale':
        return state.onSaleProducts;
      case 'all_prods':
        return state.allProducts;
      default:
        return [];
    }
  }

  void _openCategory(CategoryData category) {
    Navigator.pushNamed(
      context,
      Routes.categoryProducts,
      arguments: CategoryProductsArgs(
        id: category.id,
        name: category.name,
        subcategory: category.subcategories,
        imageUrl: category.imageUrl,
      ),
    );
  }

  void _openSubcategory(Subcategory sub) {
    Navigator.pushNamed(
      context,
      Routes.categoryProducts,
      arguments: CategoryProductsArgs(
        id: sub.id,
        name: sub.name,
        subcategory: const [],
        imageUrl: sub.imageUrl,
      ),
    );
  }

  void _openTile(dynamic item) {
    switch (widget.productType) {
      case 'categories':
        _openCategory(item as CategoryData);
      case 'brands':
        final brand = item as BrandsData;
        Navigator.pushNamed(
          context,
          Routes.brandProducts,
          arguments: BrandProductsArgs(
            id: brand.id ?? 0,
            name: brand.name ?? '',
          ),
        );
      case 'health_issues':
        final issue = item as HealthIssueData;
        Navigator.pushNamed(
          context,
          Routes.healthIssueProducts,
          arguments: HealthIssueProductsArgs(
            id: issue.id ?? 0,
            name: issue.name ?? '',
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FAFD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: AppColors.darkColor,
          ),
        ),
        title: Text(
          widget.title,
          style: AppTextStyles.noto16w400.copyWith(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.darkColor,
          ),
        ),
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.status == HomeStatus.loading && !state.isLoadingMore) {
            return _gridShimmer(isTile: _isTileGrid);
          }

          final items = _items(state);

          if (state.status == HomeStatus.failure && items.isEmpty) {
            return _EmptyState(
              message: S.of(context).unexpectedError,
              onRetry: () => _fetchProducts(refresh: true),
            );
          }

          if (items.isEmpty) {
            return _EmptyState(message: S.of(context).no_products_found);
          }

          if (_isCategories) {
            return _buildCategoriesBrowser(items.cast<CategoryData>());
          }

          return RefreshIndicator(
            color: AppColors.primaryColor,
            onRefresh: () => _fetchProducts(refresh: true),
            child: GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              itemCount: items.length + (_isFetchingMore ? 1 : 0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _isTileGrid ? 2 : 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: _isTileGrid ? 0.86 : 0.62,
              ),
              itemBuilder: (context, index) {
                if (index == items.length) {
                  return const Center(child: CircularProgressIndicator());
                }
                final item = items[index];
                if (_isTileGrid) {
                  return _BrowseTile(
                    imageUrl: item.imageUrl ?? '',
                    title: item.name ?? '',
                    onTap: () => _openTile(item),
                  );
                }
                return _productCard(item);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoriesBrowser(List<CategoryData> categories) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final selectedCategory = _selectedCategoryId == -1
        ? null
        : categories.cast<CategoryData?>().firstWhere(
            (category) => category?.id == _selectedCategoryId,
            orElse: () => null,
          );
    final subcategories = selectedCategory?.subcategories ?? [];
    final gridItems = _selectedCategoryId == -1
        ? categories
            .map(
              (category) => _BrowseTile(
                imageUrl: category.imageUrl,
                title: category.name,
                onTap: () => _openCategory(category),
              ),
            )
            .toList()
        : subcategories.isNotEmpty
        ? subcategories
            .map(
              (sub) => _BrowseTile(
                imageUrl: sub.imageUrl,
                title: sub.name,
                selected: sub.id == _selectedSubcategoryId,
                onTap: () => _openSubcategory(sub),
              ),
            )
            .toList()
        : [
            _BrowseTile(
              imageUrl: selectedCategory!.imageUrl,
              title: selectedCategory.name,
              onTap: () => _openCategory(selectedCategory),
            ),
          ];

    return Column(
      children: [
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Column(
            children: [
              SizedBox(
                height: 46,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _CategoryTab(
                      label: isAr ? 'الكل' : 'All',
                      selected: _selectedCategoryId == -1,
                      onTap: () => setState(() {
                        _selectedCategoryId = -1;
                        _selectedSubcategoryId = null;
                      }),
                    ),
                    ...categories.map((category) {
                      final selected = category.id == _selectedCategoryId;
                      return _CategoryTab(
                        label: category.name,
                        imageUrl: category.imageUrl,
                        selected: selected,
                        onTap: () => setState(() {
                          _selectedCategoryId = category.id;
                          _selectedSubcategoryId = null;
                        }),
                      );
                    }),
                  ],
                ),
              ),
              if (subcategories.isNotEmpty) ...[
                const SizedBox(height: 10),
                SizedBox(
                  height: 38,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: subcategories.map((sub) {
                      final selected = sub.id == _selectedSubcategoryId;
                      return _SubcategoryTab(
                        label: sub.name,
                        selected: selected,
                        onTap: () {
                          setState(() => _selectedSubcategoryId = sub.id);
                          _openSubcategory(sub);
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            color: AppColors.primaryColor,
            onRefresh: () => _fetchProducts(refresh: true),
            child: GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              itemCount: gridItems.length + (_isFetchingMore ? 1 : 0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.86,
              ),
              itemBuilder: (context, index) {
                if (index == gridItems.length) {
                  return const Center(child: CircularProgressIndicator());
                }
                return gridItems[index];
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _productCard(dynamic item) {
    int productId = 0;
    double price = 0;
    var hasDiscount = false;
    var discountText = '';
    var rating = 0.0;
    var reviews = 0;
    List<AvailableSize>? sizes = [];
    var image = '';
    var title = '';
    var desc = '';

    if (item is ProductModel) {
      productId = item.id ?? 0;
      image = item.imageUrl ?? '';
      title = item.name ?? '';
      desc = item.description ?? '';
      price = item.availableSizes?.first.price ?? 0;
      hasDiscount = item.discountType != null;
      discountText = getDiscountProductModel(item, context);
      rating = item.averageRating ?? 0;
      reviews = item.ratingsCount ?? 0;
      sizes = item.availableSizes ?? [];
    } else if (item is SpecialPackagesData) {
      productId = item.id ?? 0;
      image = item.image ?? '';
      title = item.name ?? '';
      desc = item.description ?? '';
      price = item.availableSizes?.first.price ?? 0;
      hasDiscount = true;
      discountText = getDiscountSpecial(item, context);
      rating = item.rate ?? 0;
      reviews = item.ratingsCount ?? 0;
      sizes = item.availableSizes ?? [];
    } else if (item is BestSellingProductsData) {
      final product = item.product!;
      productId = product.id ?? 0;
      image = product.imageUrl ?? '';
      title = product.name ?? '';
      desc = product.description ?? '';
      price = product.availableSizes?.first.price ?? 0;
      hasDiscount = product.discountType != null;
      discountText = getDiscountBestSelling(item, context);
      rating = product.rate ?? 0;
      reviews = product.ratingsCount ?? 0;
      sizes = product.availableSizes ?? [];
    } else if (item is LatestProductsData) {
      productId = item.id ?? 0;
      image = item.imageUrl ?? '';
      title = item.name ?? '';
      desc = item.description ?? '';
      price = item.availableSizes?.first.price ?? 0;
      hasDiscount = item.discountType != null;
      discountText = getDiscountLatest(item, context);
      rating = item.rate ?? 0;
      reviews = item.ratingsCount ?? 0;
      sizes = item.availableSizes ?? [];
    } else if (item is BigDiscountData) {
      productId = item.id ?? 0;
      image = item.image ?? '';
      title = item.name ?? '';
      desc = item.description ?? '';
      price = item.availableSizes!.first.price ?? 0;
      hasDiscount = item.discountType != null;
      discountText = getDiscountBig(item, context);
      rating = item.rate ?? 0;
      reviews = item.ratingsCount ?? 0;
      sizes = item.availableSizes ?? [];
    }

    return BlocBuilder<FavouriteCubit, FavouriteState>(
      builder: (context, _) {
        final cubit = context.read<FavouriteCubit>();
        return ProductItem(
          productId: productId,
          image: image,
          title: title,
          subtitle: desc,
          price: price,
          hasDiscount: hasDiscount,
          discount: discountText,
          rating: rating,
          reviews: reviews,
          sizesIds: sizes,
          isFav: cubit.isProductFavourite(productId),
          onFavClick: () {
            cubit.toggleFavourite(productId: productId, context: context);
          },
        );
      },
    );
  }
}

class _CategoryTab extends StatelessWidget {
  const _CategoryTab({
    required this.label,
    required this.selected,
    required this.onTap,
    this.imageUrl,
  });

  final String label;
  final String? imageUrl;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 8),
      child: Material(
        color: selected ? AppColors.primaryColor : AppColors.light,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: [
                if (imageUrl != null && imageUrl!.isNotEmpty) ...[
                  ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: imageUrl!,
                      width: 26,
                      height: 26,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const PharmacyImageLoading(),
                      errorWidget: (context, url, error) =>
                          const PharmacyPlaceholder(size: 18),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: AppTextStyles.noto14w400.copyWith(
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected ? Colors.white : AppColors.darkColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SubcategoryTab extends StatelessWidget {
  const _SubcategoryTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 8),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? AppColors.teal : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? AppColors.teal : AppColors.borderColor,
            ),
          ),
          child: Text(
            label,
            style: AppTextStyles.noto14w400.copyWith(
              fontSize: 12,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: selected ? Colors.white : AppColors.darkColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _BrowseTile extends StatelessWidget {
  const _BrowseTile({
    required this.imageUrl,
    required this.title,
    required this.onTap,
    this.selected = false,
  });

  final String imageUrl;
  final String title;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? AppColors.primaryColor : Colors.transparent,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.08),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: ColoredBox(
                    color: AppColors.light,
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const PharmacyImageLoading(),
                      errorWidget: (context, url, error) => const Center(
                        child: PharmacyPlaceholder(size: 56),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
                child: Text(
                  title,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.noto14w400.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkColor,
                    height: 1.25,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const PharmacyLogo(size: 88),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.noto14w400.copyWith(
                fontSize: 16,
                color: AppColors.darkColor,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              SizedBox(
                width: 160,
                child: CustomElevatedButton(
                  onPressed: onRetry,
                  title: S.of(context).retry,
                  backgroundColor: AppColors.primaryColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

Widget _gridShimmer({bool isTile = false}) {
  return GridView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: 8,
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: isTile ? 0.86 : 0.62,
    ),
    itemBuilder: (context, index) {
      return Shimmer.fromColors(
        baseColor: const Color(0xFFD6F0FA),
        highlightColor: Colors.white,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.light,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      );
    },
  );
}
