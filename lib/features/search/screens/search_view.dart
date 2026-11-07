import 'dart:async';

import 'package:elkawther/core/errors/errors.dart';
import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:elkawther/features/favorites/cubit/favourite_cubit.dart';
import 'package:elkawther/features/home/cubit/home_cubit.dart';
import 'package:elkawther/features/home/cubit/home_state.dart';
import 'package:elkawther/features/search/services/search_history.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_padding.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/features/products/models/product_model.dart';
import 'package:elkawther/features/search/widgets/recent_search.dart';
import 'package:intl/intl.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<String> _recentSearches = [];
  String _lastQuery = "";
  Timer? _searchDebounce;
  bool _isWaitingForSearch = false;

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
    _searchController.addListener(_onSearchChanged);
    _scrollController.addListener(_onScroll);
  }

  Future<void> _loadRecentSearches() async {
    final searches = await SearchHistory.getSearches();
    if (!mounted) return;
    setState(() {
      _recentSearches = searches;
    });
  }

  Future<void> _clearAllSearches() async {
    await SearchHistory.clear();
    if (!mounted) return;
    setState(() => _recentSearches = []);
  }

  Future<void> _removeItem(String term) async {
    await SearchHistory.removeItem(term);
    if (!mounted) return;
    setState(() => _recentSearches.remove(term));
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    _lastQuery = query;
    _searchDebounce?.cancel();
    if (query.isEmpty) {
      _isWaitingForSearch = false;
      context.read<HomeCubit>().searchProducts('');
    } else {
      _isWaitingForSearch = true;
      _searchDebounce = Timer(const Duration(milliseconds: 350), () {
        if (!mounted || query != _searchController.text.trim()) return;
        unawaited(context.read<HomeCubit>().searchProducts(query));
        setState(() => _isWaitingForSearch = false);
      });
    }
    if (mounted) setState(() {});
  }

  void _onScroll() {
    if (!_scrollController.hasClients ||
        _lastQuery.isEmpty ||
        _isWaitingForSearch ||
        _scrollController.position.pixels <
            _scrollController.position.maxScrollExtent - 100) {
      return;
    }

    final state = context.read<HomeCubit>().state;
    if (state.searchHasMore &&
        !state.isSearching &&
        !state.isLoadingSearchMore) {
      unawaited(
        context.read<HomeCubit>().searchProducts(_lastQuery, loadMore: true),
      );
    }
  }

  Widget _buildLoadingList() {
    return Skeletonizer(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 6,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, __) => Container(
          height: 76,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }

  Future<void> _handleProductTap(ProductModel selectedProduct) async {
    if (selectedProduct.id == null) return;

    bool isFav = context.read<FavouriteCubit>().isProductFavourite(
      selectedProduct.id!,
    );

    await SearchHistory.addSearch(selectedProduct.name ?? "");
    await _loadRecentSearches();

    if (!mounted) return;
    // The favourite callback runs later on the details route.
    // ignore: use_build_context_synchronously
    Navigator.pushNamed(
      context,
      Routes.productDetails,
      arguments: {
        "id": selectedProduct.id,
        "click": () {
          context.read<FavouriteCubit>().toggleFavourite(
            productId: selectedProduct.id!,
            context: context,
          );
          setState(() {
            isFav = !isFav;
          });
        },
        "isFav": isFav,
        "isView": false,
      },
    );
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _scrollController.removeListener(_onScroll);
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FB),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(8, 8, 16, 18),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF085A94),
                  AppColors.primaryColor,
                  Color(0xFF1A8FCF),
                ],
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
            ),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 46,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search_rounded,
                            color: AppColors.primaryColor,
                            size: 22,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: S.of(context).searchFor,
                                border: InputBorder.none,
                                isCollapsed: true,
                                hintStyle: AppTextStyles.noto14w400.copyWith(
                                  color: AppColors.grey,
                                ),
                              ),
                              style: AppTextStyles.noto14w400.copyWith(
                                color: AppColors.darkColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (_searchController.text.isNotEmpty)
                            GestureDetector(
                              onTap: _searchController.clear,
                              child: const Icon(
                                Icons.close_rounded,
                                size: 18,
                                color: AppColors.grey,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Expanded(
                child: BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    final searchText = _searchController.text.trim();

                    return SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (searchText.isEmpty && _recentSearches.isNotEmpty)
                            SearchRecent(
                              items: _recentSearches,
                              onTapItem: (selectedName) {
                                _searchController.text = selectedName;
                                _lastQuery = selectedName;
                              },
                              onClearAll: _clearAllSearches,
                              onRemoveItem: _removeItem,
                            ),

                          const SizedBox(height: AppPadding.medium),
                          if (_recentSearches.isEmpty && searchText.isEmpty)
                            _SearchStatus(
                              icon: Icons.history_rounded,
                              message: S.of(context).no_resent,
                              detail: isAr
                                  ? 'ابدأ البحث لتظهر هنا'
                                  : 'Searches you make will show up here',
                            ),

                          if (searchText.isNotEmpty)
                            if (_isWaitingForSearch || state.isSearching)
                              _buildLoadingList()
                            else if (state.searchError != null)
                              _SearchStatus(
                                icon: Icons.error_outline_rounded,
                                iconColor: const Color(0xFFEF4444),
                                message: Errors(
                                  message: state.searchError!,
                                ).localizedMessage(context),
                                action: S.of(context).retry,
                                onAction: () => context
                                    .read<HomeCubit>()
                                    .searchProducts(searchText),
                              )
                            else if (state.searchResults.isEmpty)
                              _SearchStatus(
                                icon: Icons.search_off_rounded,
                                message: S.of(context).noResultsFound,
                              )
                            else
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount:
                                    state.searchResults.length +
                                    (state.isLoadingSearchMore ? 1 : 0),
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 10),
                                itemBuilder: (context, index) {
                                  if (index == state.searchResults.length &&
                                      state.isLoadingSearchMore) {
                                    return const Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                    );
                                  }
                                  return _SearchProductCard(
                                    product: state.searchResults[index],
                                    onTap: () => _handleProductTap(
                                      state.searchResults[index],
                                    ),
                                  );
                                },
                              ),

                          if (state.isLoadingSearchMore)
                            const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(child: CircularProgressIndicator()),
                            ),
                          const SizedBox(height: AppPadding.medium),
                        ],
                      ),
                    );
                  },
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

class _SearchProductCard extends StatelessWidget {
  const _SearchProductCard({required this.product, required this.onTap});

  final ProductModel product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final image = product.imageUrl ?? product.image;
    final price = product.price ?? 0;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE6EEF5)),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: image != null && image.isNotEmpty
                    ? Image.network(
                        image,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const _SearchImageFallback(),
                      )
                    : const _SearchImageFallback(),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.noto14w400.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.darkColor,
                      ),
                    ),
                    if (price > 0) ...[
                      const SizedBox(height: 4),
                      Text(
                        '${NumberFormat('#,##0').format(price)} ${S.of(context).currency}',
                        style: AppTextStyles.noto14w400.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: AppColors.grey.withOpacity(0.7),
                textDirection: Directionality.of(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchImageFallback extends StatelessWidget {
  const _SearchImageFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      color: AppColors.light,
      child: const Icon(
        Icons.local_pharmacy_rounded,
        color: AppColors.primaryColor,
      ),
    );
  }
}

class _SearchStatus extends StatelessWidget {
  const _SearchStatus({
    required this.icon,
    required this.message,
    this.detail,
    this.iconColor,
    this.action,
    this.onAction,
  });

  final IconData icon;
  final String message;
  final String? detail;
  final Color? iconColor;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final color = iconColor ?? AppColors.primaryColor;
    return Padding(
      padding: const EdgeInsets.only(top: 28),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: color.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.noto16w400.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.darkColor,
                fontSize: 15,
              ),
            ),
            if (detail != null) ...[
              const SizedBox(height: 6),
              Text(
                detail!,
                textAlign: TextAlign.center,
                style: AppTextStyles.noto14w400.copyWith(
                  color: AppColors.grey,
                  fontSize: 13,
                ),
              ),
            ],
            if (action != null && onAction != null)
              TextButton(
                onPressed: onAction,
                child: Text(
                  action!,
                  style: AppTextStyles.noto14w400.copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
