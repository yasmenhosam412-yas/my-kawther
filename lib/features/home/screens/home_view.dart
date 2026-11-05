import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/features/auth/cubit/auth_cubit.dart';
import 'package:elkawther/features/favorites/cubit/favourite_cubit.dart';
import 'package:elkawther/features/home/cubit/home_cubit.dart';
import 'package:elkawther/features/home/cubit/home_state.dart';
import 'package:elkawther/features/home/data/home_demo_data.dart';
import 'package:elkawther/features/home/screens/home_navigation.dart';
import 'package:elkawther/features/home/widgets/empty_products_placeholder.dart';
import 'package:elkawther/features/home/widgets/home_banner.dart';
import 'package:elkawther/features/home/widgets/home_error_view.dart';
import 'package:elkawther/features/home/widgets/home_brands_row.dart';
import 'package:elkawther/features/home/widgets/home_header.dart';
import 'package:elkawther/features/home/widgets/home_product_card.dart';
import 'package:elkawther/features/home/widgets/home_problems_row.dart';
import 'package:elkawther/features/home/widgets/home_search_row.dart';
import 'package:elkawther/features/home/widgets/shimmer_box.dart';
import 'package:elkawther/features/home/widgets/section_header.dart';
import 'package:elkawther/features/products/models/special_packages_model.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<HomeCubit>().loadHomeData();
      final auth = context.read<AuthCubit>().state;
      if (auth is AuthLoadedLogin || auth is AuthLoadedRegister) {
        context.read<FavouriteCubit>().fetchFavourites(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.status == HomeStatus.loading && !state.isHomeReady) {
          return Scaffold(
            backgroundColor: const Color(0xFFF5FAFD),
            body: SafeArea(
              child: RefreshIndicator(
                color: AppColors.primaryColor,
                onRefresh: () => context.read<HomeCubit>().loadHomeData(),
                child: const HomeViewShimmer(),
              ),
            ),
          );
        }

        if (state.status == HomeStatus.failure && state.error != null) {
          return Scaffold(
            backgroundColor: const Color(0xFFF5FAFD),
            body: SafeArea(
              child: RefreshIndicator(
                color: AppColors.primaryColor,
                onRefresh: () => context.read<HomeCubit>().loadHomeData(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.primaryColor.withOpacity(0.14),
                              const Color(0xFFF5FAFD),
                            ],
                          ),
                        ),
                        child: const _RiseIn(child: HomeHeader()),
                      ),
                      HomeErrorView(
                        message: state.error!.localizedMessage(context),
                        onRetry: () => context.read<HomeCubit>().loadHomeData(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        final discounts = _discountProducts(
          context: context,
          model: state.specialPackages,
          sections: [state.specialPackages?.topPercentDiscount],
          discountType: 'percent',
          sortBySaving: true,
        );
        final specialPackages = _discountProducts(
          context: context,
          model: state.specialPackages,
          sections: [state.specialPackages?.topFixedDiscount],
          discountType: 'fixed',
        );
        final bestSelling = _bestSellingProducts(state, context);
        final latestProducts = _latestProducts(state, context);

        return Scaffold(
          backgroundColor: const Color(0xFFF5FAFD),
          body: RefreshIndicator(
            color: AppColors.primaryColor,
            onRefresh: () => context.read<HomeCubit>().loadHomeData(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.primaryColor.withOpacity(0.14),
                          const Color(0xFFF5FAFD),
                        ],
                      ),
                    ),
                    child: const Column(
                      children: [
                        _RiseIn(child: HomeHeader()),
                        SizedBox(height: 16),
                        _RiseIn(
                          delay: Duration(milliseconds: 80),
                          child: HomeSearchRow(),
                        ),
                      ],
                    ),
                  ),
                  if (state.status == HomeStatus.loading)
                    const LinearProgressIndicator(minHeight: 2),
                  if (state.status == HomeStatus.failure && state.error != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      child: Text(
                        state.error!.localizedMessage(context),
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
                    child: Column(
                      children: [
                        _RiseIn(
                          delay: const Duration(milliseconds: 140),
                          child: HomeBanner(banners: _banners(state)),
                        ),
                        const SizedBox(height: 22),
                        _RiseIn(
                          delay: const Duration(milliseconds: 220),
                          child: Column(
                            children: [
                              SectionHeader(
                                title: l10n.categories,
                                actionText: l10n.viewMore,
                                onPressed:
                                    () =>
                                        HomeNavigation.openCategories(context),
                              ),
                              const SizedBox(height: 8),
                              HomeChipsRow(
                                items: _categoryChips(state),
                                products: latestProducts,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 22),
                        _RiseIn(
                          delay: const Duration(milliseconds: 300),
                          child: _ProductBlock(
                            title: l10n.bigDiscounts,
                            showFire: true,
                            actionText: l10n.viewMore,
                            products: discounts,
                            onPressed:
                                () => HomeNavigation.openList(
                                  context,
                                  title: l10n.bigDiscounts,
                                  products: discounts,
                                ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        _RiseIn(
                          delay: const Duration(milliseconds: 380),
                          child: Column(
                            children: [
                              SectionHeader(
                                title: l10n.brands,
                                actionText: l10n.viewMore,
                                onPressed:
                                    () => HomeNavigation.openBrands(context),
                              ),
                              const SizedBox(height: 8),
                              HomeBrandsRow(brands: _brands(state)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 22),
                        _RiseIn(
                          delay: const Duration(milliseconds: 460),
                          child: HomeBanner(banners: _banners(state)),
                        ),
                        const SizedBox(height: 22),
                        _RiseIn(
                          delay: const Duration(milliseconds: 540),
                          child: Column(
                            children: [
                              SectionHeader(
                                title: l10n.shopByProblem,
                                actionText: l10n.viewMore,
                                onPressed:
                                    () => HomeNavigation.openProblems(context),
                              ),
                              const SizedBox(height: 8),
                              HomeProblemsRow(problems: _healthIssues(state)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 22),
                        _RiseIn(
                          delay: const Duration(milliseconds: 620),
                          child: _ProductBlock(
                            title: l10n.bestSellingProducts,
                            actionText: l10n.viewMore,
                            products: bestSelling,
                            onPressed:
                                () => HomeNavigation.openList(
                                  context,
                                  title: l10n.bestSellingProducts,
                                  products: bestSelling,
                                ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        _RiseIn(
                          delay: const Duration(milliseconds: 700),
                          child: _ProductBlock(
                            title: l10n.newArrival,
                            actionText: l10n.viewMore,
                            products: latestProducts,
                            onPressed:
                                () => HomeNavigation.openList(
                                  context,
                                  title: l10n.newArrival,
                                  products: latestProducts,
                                ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        _RiseIn(
                          delay: const Duration(milliseconds: 780),
                          child: _ProductBlock(
                            title: l10n.specialPackages,
                            actionText: l10n.viewMore,
                            products: specialPackages,
                            onPressed:
                                () => HomeNavigation.openList(
                                  context,
                                  title: l10n.specialPackages,
                                  products: specialPackages,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

List<HomeDemoBanner> _banners(HomeState state) =>
    state.banners?.data
        ?.map(
          (banner) => HomeDemoBanner(
            titleAr: banner.title ?? '',
            titleEn: banner.title ?? '',
            imageUrl: banner.imageUrl ?? banner.image ?? '',
            link: banner.link,
          ),
        )
        .toList() ??
    const [];

List<HomeDemoChip> _categoryChips(HomeState state) =>
    state.categories?.data
        .map(
          (category) => HomeDemoChip(
            id: category.id,
            nameAr: category.name,
            nameEn: category.name,
            imageUrl: category.imageUrl,
          ),
        )
        .toList() ??
    const [];

List<HomeDemoBrand> _brands(HomeState state) {
  const colors = [Color(0xFF0B76B9), Color(0xFF06A786), Color(0xFFEC4899)];
  return state.brands
      .asMap()
      .entries
      .map(
        (entry) => HomeDemoBrand(
          id: entry.value.id ?? entry.key,
          nameAr: entry.value.name ?? '',
          nameEn: entry.value.name ?? '',
          categoryAr: '',
          categoryEn: '',
          logoUrl: entry.value.imageUrl ?? entry.value.image ?? '',
          color: colors[entry.key % colors.length],
          productIds: const [],
        ),
      )
      .toList();
}

List<HomeDemoProblem> _healthIssues(HomeState state) =>
    state.healthIssues?.data
        ?.asMap()
        .entries
        .map(
          (entry) => HomeDemoProblem(
            id: entry.value.id ?? entry.key,
            nameAr: entry.value.name ?? '',
            nameEn: entry.value.name ?? '',
            subtitleAr: '',
            subtitleEn: '',
            icon: Icons.health_and_safety_rounded,
            color: const Color(0xFF06A786),
            productIds: const [],
            imageUrl: entry.value.imageUrl ?? entry.value.image ?? '',
          ),
        )
        .toList() ??
    const [];

List<HomeDemoProduct> _bestSellingProducts(
  HomeState state,
  BuildContext context,
) =>
    state.bestSelling?.data?.where((item) => item.product != null).map((item) {
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
                ? _latestDiscountLabel(
                  context,
                  product.discountType,
                  originalPrice,
                  currentPrice,
                )
                : null,
        rating: product.averageRating ?? product.rate ?? 0,
        reviews: product.ratingsCount ?? 0,
        productSizeId: size?.id,
      );
    }).toList() ??
    const [];

List<HomeDemoProduct> _latestProducts(HomeState state, BuildContext context) =>
    state.latestProducts?.data?.map((product) {
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
                ? _latestDiscountLabel(
                  context,
                  product.discountType,
                  originalPrice,
                  currentPrice,
                )
                : null,
        rating: product.averageRating ?? product.rate ?? 0,
        reviews: product.ratingsCount ?? 0,
        productSizeId: size?.id,
      );
    }).toList() ??
    const [];

String _latestDiscountLabel(
  BuildContext context,
  String? discountType,
  double originalPrice,
  double salePrice,
) {
  final numberFormat = NumberFormat('#,##0.##');
  final discountTypeValue = discountType?.toLowerCase();
  if (discountTypeValue == 'fixed') {
    return '${numberFormat.format(originalPrice - salePrice)} ${S.of(context).currency}';
  }

  final percent = ((originalPrice - salePrice) / originalPrice) * 100;
  return _percentDiscountLabel(context, numberFormat.format(percent));
}

List<HomeDemoProduct> _discountProducts({
  required BuildContext context,
  required SpecialPackagesModel? model,
  required List<DiscountSection?> sections,
  required String discountType,
  bool sortBySaving = false,
}) {
  if (model == null) return const [];
  final seenIds = <int>{};
  final products = <HomeDemoProduct>[];

  for (final section in sections) {
    for (final product in section?.products ?? const <SpecialPackagesData>[]) {
      if (product.id != null && !seenIds.add(product.id!)) continue;
      products.add(
        HomeDemoProduct(
          id: product.id ?? 0,
          nameAr: product.name ?? '',
          nameEn: product.name ?? '',
          subtitleAr: product.description ?? '',
          subtitleEn: product.description ?? '',
          price: product.priceAfterDiscount ?? 0,
          imageUrl: product.image ?? '',
          originalPrice: product.priceBeforeDiscountDouble,
          discountLabel: _discountLabel(context, product, discountType),
          rating: product.averageRating ?? product.rate ?? 0,
          reviews: product.ratingsCount ?? 0,
          productSizeId:
              product.availableSizes?.isNotEmpty == true
                  ? product.availableSizes!.first.id
                  : null,
        ),
      );
    }
  }

  if (sortBySaving) {
    products.sort((a, b) {
      final percentA = _discountPercentOf(a) ?? 0;
      final percentB = _discountPercentOf(b) ?? 0;
      return percentB.compareTo(percentA);
    });
  }
  return products;
}

double? _discountPercentOf(HomeDemoProduct product) {
  final original = product.originalPrice;
  if (original == null || original <= 0 || product.price >= original) {
    return null;
  }
  return ((original - product.price) / original) * 100;
}

String? _discountLabel(
  BuildContext context,
  SpecialPackagesData product,
  String discountType,
) {
  final sectionDiscount = product.sectionDiscount;
  final numberFormat = NumberFormat('#,##0.##');

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
  if (discountType == 'percent') {
    return _percentDiscountLabel(
      context,
      numberFormat.format((discount / original) * 100),
    );
  }
  return null;
}

String _percentDiscountLabel(BuildContext context, String percentage) {
  final discount = S.of(context).discount;
  if (Localizations.localeOf(context).languageCode == 'ar') {
    return '$discount $percentage٪';
  }
  return '$percentage% $discount';
}

class _ProductBlock extends StatelessWidget {
  const _ProductBlock({
    required this.title,
    required this.actionText,
    required this.products,
    required this.onPressed,
    this.showFire = false,
  });

  final String title;
  final String actionText;
  final List<HomeDemoProduct> products;
  final VoidCallback onPressed;
  final bool showFire;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          title: title,
          actionText: actionText,
          showFire: showFire,
          onPressed: onPressed,
        ),
        if (products.isEmpty)
          const EmptyProductsPlaceholder()
        else
          HomeProductsRow(products: products),
      ],
    );
  }
}

class _RiseIn extends StatefulWidget {
  const _RiseIn({required this.child, this.delay = Duration.zero});

  final Widget child;
  final Duration delay;

  @override
  State<_RiseIn> createState() => _RiseInState();
}

class _RiseInState extends State<_RiseIn> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final CurvedAnimation _curve;
  bool _scheduled = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 560),
    );
    _curve = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_scheduled) return;
    _scheduled = true;
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 1;
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future<void>.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    });
  }

  @override
  void dispose() {
    _curve.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curve,
      builder: (context, child) {
        final t = _curve.value;
        return IgnorePointer(
          ignoring: t < 0.4,
          child: Opacity(
            opacity: t,
            child: Transform.translate(
              offset: Offset(0, (1 - t) * 18),
              child: Transform.scale(
                scale: 0.985 + (0.015 * t),
                alignment: Alignment.topCenter,
                child: child,
              ),
            ),
          ),
        );
      },
      child: widget.child,
    );
  }
}
