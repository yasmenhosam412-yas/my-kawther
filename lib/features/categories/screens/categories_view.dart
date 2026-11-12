import 'dart:async';

import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/widgets/pharmacy_logo.dart';
import 'package:elkawther/features/home/cubit/home_cubit.dart';
import 'package:elkawther/features/home/cubit/home_state.dart';
import 'package:elkawther/features/home/data/home_demo_data.dart';
import 'package:elkawther/features/home/models/banners_model.dart';
import 'package:elkawther/features/home/screens/home_navigation.dart';
import 'package:elkawther/features/home/utils/home_banners.dart';
import 'package:elkawther/features/home/widgets/home_banner.dart';
import 'package:elkawther/features/home/widgets/home_catalog_image.dart';
import 'package:elkawther/features/home/widgets/shimmer_box.dart';
import 'package:elkawther/generated/assets.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoriesView extends StatefulWidget {
  const CategoriesView({
    super.key,
    this.fromBanner = false,
    this.bannerTitle,
    this.showBanner = false,
  });

  final bool fromBanner;
  final String? bannerTitle;
  final bool showBanner;

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView>
    with AutomaticKeepAliveClientMixin {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _bannerScheduleTimer;

  bool get _shouldShowBanner => widget.showBanner || widget.fromBanner;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final cubit = context.read<HomeCubit>();
      cubit.loadCategories();
      if (_shouldShowBanner) {
        cubit.loadBanners(force: true);
      }
    });
    if (_shouldShowBanner) {
      _bannerScheduleTimer = Timer.periodic(const Duration(seconds: 30), (_) {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _bannerScheduleTimer?.cancel();
    _searchController.dispose();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients || _searchController.text.isNotEmpty) {
      return;
    }

    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 220) {
      context.read<HomeCubit>().loadCategories(loadMore: true);
    }
  }

  List<HomeDemoCategory> _categories(HomeState state) {
    final query = _searchController.text.trim().toLowerCase();
    final categories =
        state.allCategories?.data
            .map(
              (category) => HomeDemoCategory(
                id: category.id,
                nameAr: category.name,
                nameEn: category.name,
                imageUrl: category.imageUrl,
                subcategories:
                    category.subcategories
                        .map(
                          (subcategory) => HomeDemoSubcategory(
                            id: subcategory.id,
                            nameAr: subcategory.name,
                            nameEn: subcategory.name,
                            imageUrl: subcategory.imageUrl,
                          ),
                        )
                        .toList(),
              ),
            )
            .toList() ??
        const <HomeDemoCategory>[];
    if (query.isEmpty) return categories;
    return categories
        .where(
          (category) => category.name(context).toLowerCase().contains(query),
        )
        .toList();
  }

  Future<void> _onRefresh() async {
    final cubit = context.read<HomeCubit>();
    if (_shouldShowBanner) {
      await Future.wait([
        cubit.loadBanners(force: true),
        cubit.loadCategories(force: true),
      ]);
      return;
    }
    await cubit.loadCategories(force: true);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final title =
        widget.bannerTitle?.trim().isNotEmpty == true
            ? widget.bannerTitle!.trim()
            : S.of(context).categories;

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final categories = _categories(state);
        final categoryBanners =
            _shouldShowBanner
                ? HomeBanners.of(state.banners, BannerPosition.category)
                : const <HomeDemoBanner>[];
        final crossAxisCount = MediaQuery.sizeOf(context).width >= 700 ? 3 : 2;

        return Scaffold(
          backgroundColor: const Color(0xFFF5FAFD),
          body: SafeArea(
            child: RefreshIndicator(
              color: AppColors.primaryColor,
              onRefresh: _onRefresh,
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: _CategoriesHero(
                      title: title,
                      subtitle:
                          isAr
                              ? 'تصفح كل الأقسام في مكان واحد'
                              : 'Browse every department in one place',
                      count:
                          state.allCategories?.count ??
                          state.allCategories?.data.length,
                      showBack: _shouldShowBanner,
                      onBack: () => Navigator.of(context).maybePop(),
                      searchField: _SearchField(
                        controller: _searchController,
                        onChanged: (_) => setState(() {}),
                        onClear: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                  if (categoryBanners.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                        child: HomeBanner(banners: categoryBanners),
                      ),
                    ),
                  ..._buildBodySlivers(
                    context: context,
                    state: state,
                    categories: categories,
                    crossAxisCount: crossAxisCount,
                    isAr: isAr,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildBodySlivers({
    required BuildContext context,
    required HomeState state,
    required List<HomeDemoCategory> categories,
    required int crossAxisCount,
    required bool isAr,
  }) {
    if (categories.isEmpty) {
      if (state.isLoadingCategoriesMore && state.allCategories == null) {
        return [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.86,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => const _CategoryTileShimmer(),
                childCount: 6,
              ),
            ),
          ),
        ];
      }

      if (state.categoriesError != null) {
        return [
          SliverFillRemaining(
            hasScrollBody: false,
            child: _EmptyState(
              message: state.categoriesError!.localizedMessage(context),
              actionLabel: S.of(context).retry,
              onAction: () => context.read<HomeCubit>().loadCategories(),
            ),
          ),
        ];
      }

      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: _EmptyState(
            message: S.of(context).notFoundCat,
            showLogo: true,
          ),
        ),
      ];
    }

    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: Row(
            children: [
              Text(
                isAr ? 'كل الأقسام' : 'All departments',
                style: AppTextStyles.noto16w400.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.darkColor,
                ),
              ),
              const Spacer(),
              Text(
                isAr
                    ? '${categories.length} قسم'
                    : '${categories.length} items',
                style: AppTextStyles.noto14w400.copyWith(
                  color: AppColors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: crossAxisCount == 3 ? 0.92 : 0.84,
          ),
          delegate: SliverChildBuilderDelegate((context, index) {
            final category = categories[index];
            return _CategoryTile(
              category: category,
              onTap:
                  () => HomeNavigation.openCategoryProducts(context, category),
            );
          }, childCount: categories.length),
        ),
      ),
      if (state.isLoadingCategoriesMore)
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(bottom: 24, top: 4),
            child: Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2.4),
              ),
            ),
          ),
        )
      else if (state.categoriesError != null)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Center(
              child: TextButton(
                onPressed:
                    () => context.read<HomeCubit>().loadCategories(
                      loadMore: true,
                    ),
                child: Text(state.categoriesError!.localizedMessage(context)),
              ),
            ),
          ),
        )
      else
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
    ];
  }

  @override
  bool get wantKeepAlive => true;
}

class _CategoriesHero extends StatelessWidget {
  const _CategoriesHero({
    required this.title,
    required this.subtitle,
    required this.searchField,
    required this.showBack,
    required this.onBack,
    this.count,
  });

  final String title;
  final String subtitle;
  final Widget searchField;
  final bool showBack;
  final VoidCallback onBack;
  final int? count;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(showBack ? 8 : 20, 10, 20, 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryColor.withOpacity(0.16),
            AppColors.primaryColor.withOpacity(0.05),
            const Color(0xFFF5FAFD),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (showBack)
                IconButton(
                  onPressed: onBack,
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
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkColor,
                  ),
                ),
              ),
              if (count != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.92),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '$count',
                    style: AppTextStyles.noto14w400.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: EdgeInsetsDirectional.only(start: showBack ? 48 : 0),
            child: Text(
              subtitle,
              style: AppTextStyles.noto14w400.copyWith(
                color: AppColors.grey,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(height: 16),
          searchField,
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
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
            controller.text.isEmpty
                ? null
                : IconButton(
                  onPressed: onClear,
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppColors.grey,
                    size: 20,
                  ),
                ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: AppColors.primaryColor.withOpacity(0.1),
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
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category, required this.onTap});

  final HomeDemoCategory category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final subCount = category.subcategories.length;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.primaryColor.withOpacity(0.08)),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: ColoredBox(
                      color: AppColors.light,
                      child: HomeCatalogImage(
                        assetPath: category.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  category.name(context),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.noto16w400.copyWith(
                    color: AppColors.darkColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                  ),
                ),
                if (subCount > 0) ...[
                  const SizedBox(height: 6),
                  Text(
                    isAr ? '$subCount قسم فرعي' : '$subCount subcategories',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.noto14w400.copyWith(
                      color: AppColors.grey,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryTileShimmer extends StatelessWidget {
  const _CategoryTileShimmer();

  @override
  Widget build(BuildContext context) {
    return const ShimmerBox(
      height: double.infinity,
      width: double.infinity,
      radius: 20,
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.message,
    this.actionLabel,
    this.onAction,
    this.showLogo = false,
  });

  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool showLogo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (showLogo) ...[
            const PharmacyLogo(size: 72),
            const SizedBox(height: 16),
          ],
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.noto14w400.copyWith(
              color: AppColors.grey,
              fontSize: 15,
            ),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 12),
            FilledButton(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ],
      ),
    );
  }
}
