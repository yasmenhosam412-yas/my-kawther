import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/widgets/pharmacy_logo.dart';
import 'package:elkawther/features/home/data/home_demo_data.dart';
import 'package:elkawther/features/home/screens/home_navigation.dart';
import 'package:elkawther/features/home/widgets/home_product_card.dart';
import 'package:elkawther/generated/assets.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeSearchView extends StatefulWidget {
  const HomeSearchView({super.key});

  @override
  State<HomeSearchView> createState() => _HomeSearchViewState();
}

class _HomeSearchViewState extends State<HomeSearchView> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  bool get _hasQuery => _query.trim().isNotEmpty;

  List<HomeDemoProduct> get _results {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return const [];
    return HomeDemoData.allProducts.where((product) {
      return product.nameAr.toLowerCase().contains(query) ||
          product.nameEn.toLowerCase().contains(query) ||
          product.subtitleAr.toLowerCase().contains(query) ||
          product.subtitleEn.toLowerCase().contains(query);
    }).toList();
  }

  List<HomeDemoCategory> get _matchedCategories {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return HomeDemoData.catalogCategories;
    return HomeDemoData.catalogCategories
        .where((category) => category.name(context).toLowerCase().contains(query))
        .toList();
  }

  void _applyQuery(String value) {
    setState(() => _query = value);
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final results = _results;
    const popular = HomeDemoData.bestSelling;

    return Scaffold(
      backgroundColor: const Color(0xFFF5FAFD),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 12),
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
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      autofocus: true,
                      textInputAction: TextInputAction.search,
                      onChanged: _applyQuery,
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
                        suffixIcon: _hasQuery
                            ? IconButton(
                                onPressed: () {
                                  _controller.clear();
                                  _applyQuery('');
                                  _focusNode.requestFocus();
                                },
                                icon: const Icon(
                                  Icons.close_rounded,
                                  color: AppColors.grey,
                                  size: 20,
                                ),
                              )
                            : null,
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: const BorderSide(
                            color: AppColors.lightDarker,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: const BorderSide(
                            color: AppColors.primaryColor,
                            width: 1.4,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: !_hasQuery
                  ? _IdleSearch(
                      isAr: isAr,
                      categories: HomeDemoData.catalogCategories,
                      popular: popular,
                      onCategoryTap: (category) {
                        HomeNavigation.openCategoryProducts(context, category);
                      },
                      onSuggestionTap: (text) {
                        _controller.text = text;
                        _controller.selection = TextSelection.collapsed(
                          offset: text.length,
                        );
                        _applyQuery(text);
                      },
                    )
                  : results.isEmpty
                      ? _EmptySearch(query: _query.trim())
                      : CustomScrollView(
                          slivers: [
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                                child: Row(
                                  children: [
                                    Text(
                                      isAr
                                          ? '${results.length} نتيجة'
                                          : '${results.length} results',
                                      style: AppTextStyles.noto14w400.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.darkColor,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      isAr
                                          ? 'عن “${_query.trim()}”'
                                          : 'for “${_query.trim()}”',
                                      style: AppTextStyles.noto14w400.copyWith(
                                        color: AppColors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (_matchedCategories.isNotEmpty)
                              SliverToBoxAdapter(
                                child: SizedBox(
                                  height: 42,
                                  child: ListView.separated(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _matchedCategories.length,
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(width: 8),
                                    itemBuilder: (context, index) {
                                      final category = _matchedCategories[index];
                                      return ActionChip(
                                        backgroundColor: AppColors.light,
                                        side: BorderSide.none,
                                        label: Text(
                                          category.name(context),
                                          style: AppTextStyles.noto14w400
                                              .copyWith(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.primaryColor,
                                          ),
                                        ),
                                        onPressed: () {
                                          HomeNavigation.openCategoryProducts(
                                            context,
                                            category,
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            SliverPadding(
                              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                              sliver: SliverGrid(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 14,
                                  crossAxisSpacing: 12,
                                  childAspectRatio: 0.62,
                                ),
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    return HomeProductCard(
                                      product: results[index],
                                    );
                                  },
                                  childCount: results.length,
                                ),
                              ),
                            ),
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IdleSearch extends StatelessWidget {
  const _IdleSearch({
    required this.isAr,
    required this.categories,
    required this.popular,
    required this.onCategoryTap,
    required this.onSuggestionTap,
  });

  final bool isAr;
  final List<HomeDemoCategory> categories;
  final List<HomeDemoProduct> popular;
  final ValueChanged<HomeDemoCategory> onCategoryTap;
  final ValueChanged<String> onSuggestionTap;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      children: [
        Text(
          isAr ? 'اقتراحات البحث' : 'Search suggestions',
          style: AppTextStyles.noto16w400.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.darkColor,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final product in popular.take(6))
              ActionChip(
                backgroundColor: Colors.white,
                side: const BorderSide(color: AppColors.lightDarker),
                avatar: const Icon(
                  Icons.north_west_rounded,
                  size: 14,
                  color: AppColors.primaryColor,
                ),
                label: Text(
                  product.name(context),
                  style: AppTextStyles.noto14w400.copyWith(
                    fontSize: 12,
                    color: AppColors.darkColor,
                  ),
                ),
                onPressed: () => onSuggestionTap(product.name(context)),
              ),
          ],
        ),
        const SizedBox(height: 22),
        Text(
          S.of(context).categories,
          style: AppTextStyles.noto16w400.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.darkColor,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final category in categories)
              ActionChip(
                backgroundColor: AppColors.light,
                side: BorderSide.none,
                label: Text(
                  category.name(context),
                  style: AppTextStyles.noto14w400.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                  ),
                ),
                onPressed: () => onCategoryTap(category),
              ),
          ],
        ),
        const SizedBox(height: 22),
        Text(
          isAr ? 'الأكثر مبيعاً' : 'Popular products',
          style: AppTextStyles.noto16w400.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.darkColor,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: popular.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 12,
            childAspectRatio: 0.62,
          ),
          itemBuilder: (context, index) {
            return HomeProductCard(product: popular[index]);
          },
        ),
      ],
    );
  }
}

class _EmptySearch extends StatelessWidget {
  const _EmptySearch({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const PharmacyLogo(size: 72),
            const SizedBox(height: 16),
            Text(
              S.of(context).no_products_found,
              textAlign: TextAlign.center,
              style: AppTextStyles.noto14w400.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.darkColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              query,
              textAlign: TextAlign.center,
              style: AppTextStyles.noto14w400.copyWith(
                color: AppColors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
