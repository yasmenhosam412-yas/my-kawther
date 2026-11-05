import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/features/home/data/home_demo_data.dart';
import 'package:elkawther/features/home/screens/home_products_list_view.dart';
import 'package:elkawther/features/home/services/home_service.dart';
import 'package:elkawther/features/home/widgets/shimmer_box.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

class HomeBannerProductsView extends StatefulWidget {
  const HomeBannerProductsView({
    super.key,
    required this.title,
    required this.link,
  });

  final String title;
  final String link;

  @override
  State<HomeBannerProductsView> createState() => _HomeBannerProductsViewState();
}

class _HomeBannerProductsViewState extends State<HomeBannerProductsView> {
  late Future<List<HomeDemoProduct>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = _loadProducts();
  }

  Future<List<HomeDemoProduct>> _loadProducts() async {
    final products = await GetIt.I<HomeService>().getBannerProducts(
      widget.link,
    );
    return products.map((product) => _toHomeProduct(product)).toList();
  }

  HomeDemoProduct _toHomeProduct(Map<String, dynamic> json) {
    final sizes = json['available_sizes'];
    final size =
        sizes is List && sizes.isNotEmpty && sizes.first is Map
            ? Map<String, dynamic>.from(sizes.first as Map)
            : <String, dynamic>{};
    final currentPrice =
        _number(
          json['price_after_discount'] ??
              json['final_price'] ??
              size['price_after_discount'] ??
              size['price'],
        ) ??
        0;
    final originalPrice = _number(
      json['price_before_discount'] ?? size['original_price'],
    );
    final hasSale =
        originalPrice != null &&
        originalPrice > currentPrice &&
        originalPrice > 0;
    final discountType =
        (json['_banner_discount_type'] ?? json['discount_type'])
            ?.toString()
            .toLowerCase();
    final sectionDiscount = _number(json['_banner_discount_value']);

    return HomeDemoProduct(
      id: _integer(json['id']) ?? 0,
      nameAr: json['name']?.toString() ?? '',
      nameEn: json['name']?.toString() ?? '',
      subtitleAr: json['description']?.toString() ?? '',
      subtitleEn: json['description']?.toString() ?? '',
      price: currentPrice,
      imageUrl:
          (json['image_url'] ?? json['main_image'] ?? json['image'])
              ?.toString() ??
          '',
      categoryId: _integer(json['category_id']) ?? 0,
      originalPrice: hasSale ? originalPrice : null,
      discountLabel:
          hasSale
              ? _discountLabel(
                discountType,
                sectionDiscount,
                originalPrice,
                currentPrice,
              )
              : null,
      rating: _number(json['average_rating'] ?? json['rate']) ?? 0,
      reviews: _integer(json['ratings_count']) ?? 0,
      productSizeId: _integer(size['id']),
    );
  }

  double? _number(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '');
  }

  int? _integer(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }

  String _discountLabel(
    String? type,
    double? sectionDiscount,
    double? originalPrice,
    double currentPrice,
  ) {
    final numberFormat = NumberFormat('#,##0.##');
    if (type == 'fixed') {
      final amount = sectionDiscount ?? (originalPrice! - currentPrice);
      return '${numberFormat.format(amount)} ${S.of(context).currency}';
    }

    final percent =
        sectionDiscount ??
        ((originalPrice! - currentPrice) / originalPrice) * 100;
    final formattedPercent = numberFormat.format(percent);
    final discount = S.of(context).discount;
    return Localizations.localeOf(context).languageCode == 'ar'
        ? '$discount $formattedPercent٪'
        : '$formattedPercent% $discount';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<HomeDemoProduct>>(
      future: _productsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HomeProductsListView(
            title: widget.title,
            products: snapshot.data!,
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF5FAFD),
          body: SafeArea(
            child: Column(
              children: [
                _BannerProductsHeader(title: widget.title),
                Expanded(
                  child:
                      snapshot.hasError
                          ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.wifi_off_rounded,
                                    size: 44,
                                    color: AppColors.grey,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    S.of(context).unexpectedNetworkError,
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.noto14w400.copyWith(
                                      color: AppColors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  FilledButton(
                                    onPressed:
                                        () => setState(
                                          () =>
                                              _productsFuture = _loadProducts(),
                                        ),
                                    child: Text(S.of(context).retry),
                                  ),
                                ],
                              ),
                            ),
                          )
                          : const _BannerProductsLoading(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BannerProductsLoading extends StatelessWidget {
  const _BannerProductsLoading();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - 44) / 2;
        final cardHeight = cardWidth / 0.62;

        return SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const ShimmerBox(height: 22, width: 22, radius: 11),
                  const SizedBox(width: 10),
                  ShimmerBox(
                    height: 18,
                    width: MediaQuery.sizeOf(context).width * 0.38,
                    radius: 9,
                  ),
                  const Spacer(),
                  const ShimmerBox(height: 40, width: 40, radius: 14),
                ],
              ),
              const SizedBox(height: 20),
              ShimmerBox(
                height: 14,
                width: MediaQuery.sizeOf(context).width * 0.32,
                radius: 7,
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 12,
                runSpacing: 14,
                children: List.generate(
                  6,
                  (_) =>
                      _ProductCardShimmer(width: cardWidth, height: cardHeight),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProductCardShimmer extends StatelessWidget {
  const _ProductCardShimmer({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.lightDarker.withOpacity(0.7)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: height * 0.48,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: ShimmerBox(
                height: height * 0.48,
                width: width,
                radius: 14,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const ShimmerBox(height: 13, width: double.infinity, radius: 7),
          const SizedBox(height: 7),
          const ShimmerBox(height: 12, width: 0.7 * 150, radius: 6),
          const Spacer(),
          const ShimmerBox(height: 15, width: 90, radius: 7),
        ],
      ),
    );
  }
}

class _BannerProductsHeader extends StatelessWidget {
  const _BannerProductsHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.noto16w400.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.darkColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
