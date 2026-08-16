import 'package:cached_network_image/cached_network_image.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/widgets/pharmacy_logo.dart';
import 'package:elkawther/core/widgets/pharmacy_placeholder.dart';
import 'package:elkawther/features/home/data/home_demo_data.dart';
import 'package:elkawther/features/home/widgets/home_product_card.dart';
import 'package:elkawther/features/home/widgets/home_sort_sheet.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';

class HomeCategoriesBrowseView extends StatefulWidget {
  const HomeCategoriesBrowseView({
    super.key,
    this.selectedCategoryId,
    this.showBackButton = true,
  });

  final int? selectedCategoryId;
  final bool showBackButton;

  @override
  State<HomeCategoriesBrowseView> createState() =>
      _HomeCategoriesBrowseViewState();
}

class _HomeCategoriesBrowseViewState extends State<HomeCategoriesBrowseView> {
  late int _selectedCategoryId;
  int? _selectedSubcategoryId;
  HomeProductSort _sort = HomeProductSort.none;

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.selectedCategoryId ?? -1;
  }

  HomeDemoCategory? get _selectedCategory {
    if (_selectedCategoryId == -1) return null;
    for (final category in HomeDemoData.catalogCategories) {
      if (category.id == _selectedCategoryId) return category;
    }
    return null;
  }

  HomeDemoSubcategory? get _selectedSubcategory {
    final id = _selectedSubcategoryId;
    if (id == null) return null;
    for (final sub in _selectedCategory?.subcategories ?? const []) {
      if (sub.id == id) return sub;
    }
    return null;
  }

  List<HomeDemoProduct> get _products {
    List<HomeDemoProduct> products;
    if (_selectedSubcategoryId != null) {
      products = HomeDemoData.productsFor(subcategoryId: _selectedSubcategoryId);
    } else if (_selectedCategoryId != -1) {
      products = HomeDemoData.productsFor(categoryId: _selectedCategoryId);
    } else {
      products = HomeDemoData.allProducts;
    }
    return sortedHomeProducts(products, _sort);
  }

  void _selectAll() {
    setState(() {
      _selectedCategoryId = -1;
      _selectedSubcategoryId = null;
    });
  }

  void _selectCategory(int id) {
    setState(() {
      _selectedCategoryId = id;
      _selectedSubcategoryId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    const categories = HomeDemoData.catalogCategories;
    final selectedCategory = _selectedCategory;
    final subcategories = selectedCategory?.subcategories ?? const [];
    final products = _products;
    final heading = _selectedSubcategory?.name(context) ??
        selectedCategory?.name(context) ??
        (isAr ? 'كل المنتجات' : 'All products');
    final countLabel = isAr
        ? '${products.length} منتج'
        : '${products.length} products';

    return Scaffold(
      backgroundColor: const Color(0xFFF5FAFD),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _BrowseHeader(
              imageUrl: selectedCategory?.imageUrl,
              title: heading,
              countLabel: countLabel,
              isAll: selectedCategory == null,
              onBack: widget.showBackButton
                  ? () => Navigator.of(context).pop()
                  : null,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          S.of(context).categories,
                          style: AppTextStyles.noto16w400.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.darkColor,
                          ),
                        ),
                      ),
                      HomeFilterButton(
                        sort: _sort,
                        onSelected: (sort) => setState(() => _sort = sort),
                      ),
                    ],
                  ),
                  if (_sort != HomeProductSort.none) ...[
                    const SizedBox(height: 10),
                    HomeSortChip(
                      sort: _sort,
                      onClear: () => setState(() {
                        _sort = HomeProductSort.none;
                      }),
                    ),
                  ],
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 92,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _CategoryAvatar(
                          label: isAr ? 'الكل' : 'All',
                          selected: selectedCategory == null,
                          onTap: _selectAll,
                        ),
                        ...categories.map((category) {
                          return _CategoryAvatar(
                            label: category.name(context),
                            imageUrl: category.imageUrl,
                            selected: category.id == _selectedCategoryId,
                            onTap: () => _selectCategory(category.id),
                          );
                        }),
                      ],
                    ),
                  ),
                  if (subcategories.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _SubcategoryChip(
                            label: isAr ? 'الكل' : 'All',
                            selected: _selectedSubcategoryId == null,
                            onTap: () => setState(() {
                              _selectedSubcategoryId = null;
                            }),
                          ),
                          ...subcategories.map((sub) {
                            return _SubcategoryChip(
                              label: sub.name(context),
                              imageUrl: sub.imageUrl,
                              selected: sub.id == _selectedSubcategoryId,
                              onTap: () => setState(() {
                                _selectedSubcategoryId = sub.id;
                              }),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (products.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: _EmptyProducts(),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.62,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return HomeProductCard(product: products[index]);
                  },
                  childCount: products.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BrowseHeader extends StatelessWidget {
  const _BrowseHeader({
    required this.title,
    required this.countLabel,
    required this.isAll,
    this.imageUrl,
    this.onBack,
  });

  final String? imageUrl;
  final String title;
  final String countLabel;
  final bool isAll;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 168,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (!isAll && imageUrl != null)
            CachedNetworkImage(
              imageUrl: imageUrl!,
              fit: BoxFit.cover,
              placeholder: (context, url) => const ColoredBox(
                color: AppColors.light,
              ),
              errorWidget: (context, url, error) => const ColoredBox(
                color: AppColors.light,
              ),
            )
          else
            const ColoredBox(color: AppColors.light),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.18),
                  AppColors.primaryColor.withOpacity(isAll ? 0.78 : 0.88),
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
                  if (onBack != null)
                    IconButton(
                      onPressed: onBack,
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                    )
                  else
                    const SizedBox(height: 12),
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
                      border: Border.all(color: Colors.white.withOpacity(0.28)),
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

class _CategoryAvatar extends StatelessWidget {
  const _CategoryAvatar({
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
      padding: const EdgeInsetsDirectional.only(end: 12),
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: 72,
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 58,
                height: 58,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? AppColors.primaryColor : Colors.white,
                  border: Border.all(
                    color: selected
                        ? AppColors.primaryColor
                        : AppColors.borderColor,
                    width: selected ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(
                        selected ? 0.18 : 0.06,
                      ),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: ColoredBox(
                    color: selected && imageUrl == null
                        ? AppColors.primaryColor
                        : AppColors.light,
                    child: imageUrl == null
                        ? Icon(
                            Icons.apps_rounded,
                            color: selected
                                ? Colors.white
                                : AppColors.primaryColor,
                            size: 22,
                          )
                        : CachedNetworkImage(
                            imageUrl: imageUrl!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                const PharmacyImageLoading(),
                            errorWidget: (context, url, error) =>
                                const PharmacyPlaceholder(size: 22),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: AppTextStyles.noto14w400.copyWith(
                  fontSize: 11,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? AppColors.primaryColor : AppColors.darkColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubcategoryChip extends StatelessWidget {
  const _SubcategoryChip({
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
        color: selected ? AppColors.teal : AppColors.light,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(6, 5, 12, 5),
            child: Row(
              children: [
                if (imageUrl != null)
                  ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: imageUrl!,
                      width: 24,
                      height: 24,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const PharmacyImageLoading(),
                      errorWidget: (context, url, error) =>
                          const PharmacyPlaceholder(size: 16),
                    ),
                  )
                else
                  Icon(
                    Icons.grid_view_rounded,
                    size: 16,
                    color: selected ? Colors.white : AppColors.primaryColor,
                  ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: AppTextStyles.noto14w400.copyWith(
                    fontSize: 12,
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

class _EmptyProducts extends StatelessWidget {
  const _EmptyProducts();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const PharmacyLogo(size: 72),
            const SizedBox(height: 16),
            Text(
              S.of(context).no_products_found,
              textAlign: TextAlign.center,
              style: AppTextStyles.noto14w400.copyWith(
                color: AppColors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
