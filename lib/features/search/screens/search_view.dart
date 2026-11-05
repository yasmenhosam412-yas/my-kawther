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
import 'package:elkawther/core/widgets/custom_search_bar.dart';
import 'package:elkawther/features/search/widgets/recent_search.dart';

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
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 6,
        itemBuilder:
            (_, __) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.withOpacity(0.2),
                ),
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.medium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: CircleAvatar(
                      backgroundColor: AppColors.gry,
                      child: const Icon(Icons.arrow_back, color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomSearchBar(
                      searchHint: S.of(context).searchFor,
                      controller: _searchController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppPadding.medium),
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
                            Center(
                              child: Text(
                                S.of(context).no_resent,
                                style: AppTextStyles.noto16w400,
                              ),
                            ),

                          if (searchText.isNotEmpty)
                            if (_isWaitingForSearch || state.isSearching)
                              _buildLoadingList()
                            else if (state.searchError != null)
                              Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  children: [
                                    Text(
                                      Errors(
                                        message: state.searchError!,
                                      ).localizedMessage(context),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                    const SizedBox(height: 8),
                                    TextButton(
                                      onPressed:
                                          () => context
                                              .read<HomeCubit>()
                                              .searchProducts(searchText),
                                      child: Text(S.of(context).retry),
                                    ),
                                  ],
                                ),
                              )
                            else if (state.searchResults.isEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 36,
                                ),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.search_off_rounded,
                                        size: 48,
                                        color: AppColors.grey.withOpacity(0.7),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        S.of(context).noResultsFound,
                                        textAlign: TextAlign.center,
                                        style: AppTextStyles.noto16w400
                                            .copyWith(color: AppColors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            else
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount:
                                    state.searchResults.length +
                                    (state.isLoadingSearchMore ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index == state.searchResults.length &&
                                      state.isLoadingSearchMore) {
                                    return const Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  }
                                  final product = state.searchResults[index];
                                  return ListTile(
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child:
                                          (product.imageUrl ?? product.image)
                                                      ?.isNotEmpty ==
                                                  true
                                              ? Image.network(
                                                product.imageUrl ??
                                                    product.image!,
                                                width: 48,
                                                height: 48,
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (_, __, ___) => const Icon(
                                                      Icons
                                                          .local_pharmacy_rounded,
                                                      color:
                                                          AppColors
                                                              .primaryColor,
                                                    ),
                                              )
                                              : const Icon(
                                                Icons.local_pharmacy_rounded,
                                                color: AppColors.primaryColor,
                                              ),
                                    ),
                                    title: Text(
                                      product.name ?? "Unnamed",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    onTap: () => _handleProductTap(product),
                                    trailing: const Icon(
                                      Icons.chevron_right_rounded,
                                      color: AppColors.grey,
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return const Divider(
                                    color: Color(0xffD2D2D2),
                                    thickness: 0.5,
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
    );
  }
}
