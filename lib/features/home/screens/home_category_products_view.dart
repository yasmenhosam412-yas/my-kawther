import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/widgets/pharmacy_logo.dart';
import 'package:elkawther/features/home/data/home_demo_data.dart';
import 'package:elkawther/features/home/screens/home_navigation.dart';
import 'package:elkawther/features/home/widgets/home_catalog_image.dart';
import 'package:elkawther/features/home/widgets/home_product_card.dart';
import 'package:elkawther/features/home/widgets/home_sort_sheet.dart';
import 'package:elkawther/features/home/widgets/section_header.dart';
import 'package:elkawther/generated/assets.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeCategoryProductsView extends StatefulWidget {
  const HomeCategoryProductsView({super.key, required this.category});

  final HomeDemoCategory category;

  @override
  State<HomeCategoryProductsView> createState() =>
      _HomeCategoryProductsViewState();
}

class _HomeCategoryProductsViewState extends State<HomeCategoryProductsView> {
  final _searchController = TextEditingController();
  int? _selectedSubcategoryId;
  HomeProductSort _sort = HomeProductSort.none;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  HomeDemoSubcategory? get _selectedSubcategory {
    final id = _selectedSubcategoryId;
    if (id == null) return null;
    for (final sub in widget.category.subcategories) {
      if (sub.id == id) return sub;
    }
    return null;
  }

  List<HomeDemoProduct> get _baseProducts {
    return _selectedSubcategoryId != null
        ? HomeDemoData.productsFor(subcategoryId: _selectedSubcategoryId)
        : HomeDemoData.productsFor(categoryId: widget.category.id);
  }

  List<HomeDemoProduct> get _searchedProducts {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return _baseProducts;
    return _baseProducts.where((product) {
      return product.name(context).toLowerCase().contains(query) ||
          product.subtitle(context).toLowerCase().contains(query);
    }).toList();
  }

  List<HomeDemoProduct> get _products {
    return sortedHomeProducts(_searchedProducts, _sort);
  }

  List<HomeDemoProduct> get _bestSelling {
    return bestSellingHomeProducts(_baseProducts);
  }

  bool get _isSearching => _searchController.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final category = widget.category;
    final subcategories = category.subcategories;
    final products = _products;
    final heading =
        _selectedSubcategory?.name(context) ?? category.name(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5FAFD),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _CategoryHero(
              imageUrl: _selectedSubcategory?.imageUrl ?? category.imageUrl,
              title: heading,
              countLabel:
                  isAr
                      ? '${products.length} منتج'
                      : '${products.length} products',
              onBack: () => Navigator.of(context).pop(),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
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
                          onChanged: (_) => setState(() {}),
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
                                        setState(() {});
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
                      onClear:
                          () => setState(() {
                            _sort = HomeProductSort.none;
                          }),
                    ),
                  ],
                  if (subcategories.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _SubChip(
                            label: isAr ? 'الكل' : 'All',
                            selected: _selectedSubcategoryId == null,
                            onTap:
                                () => setState(() {
                                  _selectedSubcategoryId = null;
                                }),
                          ),
                          ...subcategories.map((sub) {
                            return _SubChip(
                              label: sub.name(context),
                              imageUrl: sub.imageUrl,
                              selected: sub.id == _selectedSubcategoryId,
                              onTap:
                                  () => setState(() {
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
              child: _EmptyCategoryProducts(),
            )
          else ...[
            if (!_isSearching && _bestSelling.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Column(
                    children: [
                      SectionHeader(
                        title: S.of(context).bestSellingProducts,
                        actionText: S.of(context).viewMore,
                        onPressed:
                            () => HomeNavigation.openList(
                              context,
                              title: S.of(context).bestSellingProducts,
                              products: sortedHomeProducts(
                                _baseProducts,
                                HomeProductSort.bestSelling,
                              ),
                            ),
                      ),
                      HomeProductsRow(products: _bestSelling),
                    ],
                  ),
                ),
              ),
            if (!_isSearching && _bestSelling.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
                  child: SectionHeader(title: S.of(context).all_products),
                ),
              ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.62,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  return HomeProductCard(product: products[index]);
                }, childCount: products.length),
              ),
            ),
          ],
        ],
      ),
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

  final String imageUrl;
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
          HomeCatalogImage(assetPath: imageUrl, fit: BoxFit.cover),
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

class _SubChip extends StatelessWidget {
  const _SubChip({
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
                if (imageUrl != null) ...[
                  ClipOval(
                    child: HomeCatalogImage(
                      assetPath: imageUrl!,
                      width: 24,
                      height: 24,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
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

class _EmptyCategoryProducts extends StatelessWidget {
  const _EmptyCategoryProducts();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const PharmacyLogo(size: 72),
          const SizedBox(height: 16),
          Text(
            S.of(context).no_products_found,
            style: AppTextStyles.noto14w400.copyWith(
              color: AppColors.grey,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
