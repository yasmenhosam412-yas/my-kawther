import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
    _searchController.addListener(_onSearchChanged);


    _scrollController.addListener(() {
      context.read<HomeCubit>();
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        if (_lastQuery.isNotEmpty) {
        } else {
        }
      }
    });
  }

  Future<void> _loadRecentSearches() async {
    final searches = await SearchHistory.getSearches();
    setState(() {
      _recentSearches = searches;
    });
  }

  Future<void> _clearAllSearches() async {
    await SearchHistory.clear();
    setState(() => _recentSearches = []);
  }

  Future<void> _removeItem(String term) async {
    await SearchHistory.removeItem(term);
    setState(() => _recentSearches.remove(term));
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    _lastQuery = query;
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
                    context.read<HomeCubit>();
                    final searchText = _searchController.text.trim();

                    if (state.status == HomeStatus.loading &&
                        !state.isLoadingMore) {
                      return _buildLoadingList();
                    }

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
                            if (state.isSearching)
                              _buildLoadingList()
                            else if (state.searchError != null)
                              Center(
                                child: Text(
                                  state.searchError!,
                                  style: const TextStyle(color: Colors.red),
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
                                    leading: SvgPicture.asset(
                                      Assets.iconsSearchIcon,
                                      color: AppColors.darkColor,
                                    ),
                                    title: Text(product.name ?? "Unnamed"),
                                    onTap: () => _handleProductTap(product),
                                    trailing: const Icon(
                                      Icons.trending_up,
                                      color: Colors.black,
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
