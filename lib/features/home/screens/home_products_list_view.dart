import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/features/home/data/home_demo_data.dart';
import 'package:elkawther/features/home/screens/home_product_list_source.dart';
import 'package:elkawther/features/home/services/home_service.dart';
import 'package:elkawther/features/home/widgets/home_product_card.dart';
import 'package:elkawther/features/home/widgets/home_section_empty.dart';
import 'package:elkawther/features/home/widgets/home_sort_sheet.dart';
import 'package:elkawther/features/products/models/best_selling_products_model.dart';
import 'package:elkawther/features/products/models/latest_products_model.dart';
import 'package:elkawther/features/products/models/special_packages_model.dart';
import 'package:elkawther/generated/assets.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

class HomeProductsListView extends StatefulWidget {
  const HomeProductsListView({
    super.key,
    required this.title,
    required this.products,
    this.source,
  });

  final String title;
  final List<HomeDemoProduct> products;
  final HomeProductListSource? source;

  @override
  State<HomeProductsListView> createState() => _HomeProductsListViewState();
}

class _HomeProductsListViewState extends State<HomeProductsListView> {
  static const _pageSize = 10;

  final _scrollController = ScrollController();
  final _homeService = GetIt.I<HomeService>();

  late List<HomeDemoProduct> _products;
  HomeProductSort _sort = HomeProductSort.none;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _products = List<HomeDemoProduct>.from(widget.products);
    _hasMore = widget.source != null && _products.length >= _pageSize;
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients ||
        widget.source == null ||
        !_hasMore ||
        _isLoadingMore) {
      return;
    }
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 280) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    final source = widget.source;
    if (source == null || _isLoadingMore || !_hasMore) return;

    setState(() => _isLoadingMore = true);
    try {
      final next = await _fetchPage(source, offset: _products.length);
      if (!mounted) return;

      final existingIds = _products.map((product) => product.id).toSet();
      final unique =
          next.where((product) => existingIds.add(product.id)).toList();

      setState(() {
        _products = [..._products, ...unique];
        _hasMore = next.length >= _pageSize;
        _isLoadingMore = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _hasMore = false;
        _isLoadingMore = false;
      });
    }
  }

  Future<List<HomeDemoProduct>> _fetchPage(
    HomeProductListSource source, {
    required int offset,
  }) async {
    switch (source) {
      case HomeProductListSource.bigDiscounts:
        final model = await _homeService.getSpecialPackages(
          limit: _pageSize,
          offset: offset,
        );
        if (!mounted) return const [];
        return _mapDiscountProducts(
          context,
          model.topPercentDiscount?.products ?? const [],
          discountType: 'percent',
        );
      case HomeProductListSource.specialPackages:
        final model = await _homeService.getSpecialPackages(
          limit: _pageSize,
          offset: offset,
        );
        if (!mounted) return const [];
        return _mapDiscountProducts(
          context,
          model.topFixedDiscount?.products ?? const [],
          discountType: 'fixed',
        );
      case HomeProductListSource.bestSelling:
        final model = await _homeService.getBestSellingProducts(
          limit: _pageSize,
          offset: offset,
        );
        if (!mounted) return const [];
        return _mapBestSelling(context, model.data ?? const []);
      case HomeProductListSource.newArrival:
        final model = await _homeService.getLatestProducts(
          limit: _pageSize,
          offset: offset,
        );
        if (!mounted) return const [];
        return _mapLatest(context, model.data ?? const []);
    }
  }

  List<HomeDemoProduct> get _visibleProducts {
    return sortedHomeProducts(_products, _sort);
  }

  @override
  Widget build(BuildContext context) {
    final products = _visibleProducts;

    return Scaffold(
      backgroundColor: const Color(0xFFF5FAFD),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18,
                      color: AppColors.darkColor,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.noto16w400.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.darkColor,
                      ),
                    ),
                  ),
                  Material(
                    color:
                        _sort == HomeProductSort.none
                            ? AppColors.light
                            : AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(14),
                    child: InkWell(
                      onTap:
                          () => showHomeSortSheet(
                            context: context,
                            selected: _sort,
                            onSelected: (sort) => setState(() => _sort = sort),
                          ),
                      borderRadius: BorderRadius.circular(14),
                      child: SizedBox(
                        width: 44,
                        height: 44,
                        child: Center(
                          child: SvgPicture.asset(
                            Assets.iconsFilterIcon,
                            height: 22,
                            width: 22,
                            colorFilter: ColorFilter.mode(
                              _sort == HomeProductSort.none
                                  ? AppColors.primaryColor
                                  : Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_sort != HomeProductSort.none)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: InputChip(
                    backgroundColor: AppColors.light,
                    label: Text(
                      _sort.label(context),
                      style: AppTextStyles.noto14w400.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkColor,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: AppColors.lightDarker),
                    ),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted:
                        () => setState(() {
                          _sort = HomeProductSort.none;
                        }),
                  ),
                ),
              ),
            Expanded(
              child:
                  products.isEmpty
                      ? HomePageEmpty(message: S.of(context).no_products_found)
                      : GridView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        itemCount: products.length + (_isLoadingMore ? 1 : 0),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 14,
                              crossAxisSpacing: 12,
                              childAspectRatio: 0.62,
                            ),
                        itemBuilder: (context, index) {
                          if (index >= products.length) {
                            return const Center(
                              child: SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.4,
                                ),
                              ),
                            );
                          }
                          return HomeProductCard(product: products[index]);
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

List<HomeDemoProduct> _mapDiscountProducts(
  BuildContext context,
  List<SpecialPackagesData> products, {
  required String discountType,
}) {
  final numberFormat = NumberFormat('#,##0.##');
  return products
      .map(
        (product) => HomeDemoProduct(
          id: product.id ?? 0,
          nameAr: product.name ?? '',
          nameEn: product.name ?? '',
          subtitleAr: product.description ?? '',
          subtitleEn: product.description ?? '',
          price: product.priceAfterDiscount ?? 0,
          imageUrl: product.image ?? '',
          originalPrice: product.priceBeforeDiscountDouble,
          discountLabel: _discountLabel(
            context,
            product,
            discountType,
            numberFormat,
          ),
          rating: product.averageRating ?? product.rate ?? 0,
          reviews: product.ratingsCount ?? 0,
          productSizeId:
              product.availableSizes?.isNotEmpty == true
                  ? product.availableSizes!.first.id
                  : null,
        ),
      )
      .toList();
}

String? _discountLabel(
  BuildContext context,
  SpecialPackagesData product,
  String discountType,
  NumberFormat numberFormat,
) {
  final sectionDiscount = product.sectionDiscount;
  if (sectionDiscount != null && discountType == 'percent') {
    return _percentDiscountLabel(context, numberFormat.format(sectionDiscount));
  }
  if (sectionDiscount != null && discountType == 'fixed') {
    return '${numberFormat.format(sectionDiscount)} ${S.of(context).currency}';
  }

  final original = product.priceBeforeDiscountDouble;
  final current = product.priceAfterDiscount;
  if (original <= 0 || current == null || current >= original) return null;
  final discount = original - current;
  if (discountType == 'fixed') {
    return '${numberFormat.format(discount)} ${S.of(context).currency}';
  }
  return _percentDiscountLabel(
    context,
    numberFormat.format((discount / original) * 100),
  );
}

String _percentDiscountLabel(BuildContext context, String percentage) {
  final discount = S.of(context).discount;
  if (Localizations.localeOf(context).languageCode == 'ar') {
    return '$discount $percentage٪';
  }
  return '$percentage% $discount';
}

List<HomeDemoProduct> _mapBestSelling(
  BuildContext context,
  List<BestSellingProductsData> items,
) {
  final numberFormat = NumberFormat('#,##0.##');
  return items
      .where((item) => item.product != null)
      .map((item) {
        final product = item.product!;
        final size =
            product.availableSizes?.isNotEmpty == true
                ? product.availableSizes!.first
                : null;
        final currentPrice =
            size?.priceAfterDiscount ?? size?.price ?? product.finalPrice ?? 0;
        final originalPrice = size?.originalPrice;
        final hasSale = originalPrice != null && originalPrice > currentPrice;
        return HomeDemoProduct(
          id: product.id ?? 0,
          nameAr: product.name ?? '',
          nameEn: product.name ?? '',
          subtitleAr: product.description ?? '',
          subtitleEn: product.description ?? '',
          price: currentPrice,
          imageUrl: product.imageUrl ?? product.image ?? '',
          categoryId: product.categoryId ?? 0,
          originalPrice: hasSale ? originalPrice : null,
          discountLabel:
              hasSale
                  ? _saleDiscountLabel(
                    context,
                    product.discountType,
                    originalPrice,
                    currentPrice,
                    numberFormat,
                  )
                  : null,
          rating: product.averageRating ?? product.rate ?? 0,
          reviews: product.ratingsCount ?? 0,
          productSizeId: size?.id,
        );
      })
      .toList();
}

List<HomeDemoProduct> _mapLatest(
  BuildContext context,
  List<LatestProductsData> items,
) {
  final numberFormat = NumberFormat('#,##0.##');
  return items.map((product) {
    final size =
        product.availableSizes?.isNotEmpty == true
            ? product.availableSizes!.first
            : null;
    final currentPrice =
        size?.priceAfterDiscount ?? size?.price ?? product.finalPrice ?? 0;
    final originalPrice = size?.originalPrice;
    final hasSale = originalPrice != null && originalPrice > currentPrice;
    return HomeDemoProduct(
      id: product.id ?? 0,
      nameAr: product.name ?? '',
      nameEn: product.name ?? '',
      subtitleAr: product.description ?? '',
      subtitleEn: product.description ?? '',
      price: currentPrice,
      imageUrl: product.imageUrl ?? product.image ?? '',
      categoryId: product.category?.id ?? 0,
      originalPrice: hasSale ? originalPrice : null,
      discountLabel:
          hasSale
              ? _saleDiscountLabel(
                context,
                product.discountType,
                originalPrice,
                currentPrice,
                numberFormat,
              )
              : null,
      rating: product.averageRating ?? product.rate ?? 0,
      reviews: product.ratingsCount ?? 0,
      productSizeId: size?.id,
    );
  }).toList();
}

String _saleDiscountLabel(
  BuildContext context,
  String? discountType,
  double originalPrice,
  double salePrice,
  NumberFormat numberFormat,
) {
  if (discountType?.toLowerCase() == 'fixed') {
    return '${numberFormat.format(originalPrice - salePrice)} ${S.of(context).currency}';
  }
  final percent = ((originalPrice - salePrice) / originalPrice) * 100;
  return _percentDiscountLabel(context, numberFormat.format(percent));
}
