import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/widgets/pharmacy_logo.dart';
import 'package:elkawther/features/home/cubit/home_cubit.dart';
import 'package:elkawther/features/home/cubit/home_state.dart';
import 'package:elkawther/features/home/data/home_demo_data.dart';
import 'package:elkawther/features/home/screens/home_navigation.dart';
import 'package:elkawther/features/home/widgets/home_catalog_image.dart';
import 'package:elkawther/generated/assets.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoriesView extends StatefulWidget {
  const CategoriesView({super.key});

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView>
    with AutomaticKeepAliveClientMixin {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<HomeCubit>().loadCategories();
    });
  }

  @override
  void dispose() {
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final categories = _categories(state);
        return Scaffold(
          backgroundColor: const Color(0xFFF5FAFD),
          body: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primaryColor.withOpacity(0.16),
                      AppColors.light,
                      const Color(0xFFF5FAFD),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).categories,
                      style: AppTextStyles.noto16w400.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.darkColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isAr
                          ? 'تصفح كل الأقسام والمنتجات'
                          : 'Browse every department and product',
                      style: AppTextStyles.noto14w400.copyWith(
                        color: AppColors.grey,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
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
                  ],
                ),
              ),
              Expanded(
                child: _buildCategoryContent(context, state, categories),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryContent(
    BuildContext context,
    HomeState state,
    List<HomeDemoCategory> categories,
  ) {
    if (categories.isEmpty) {
      if (state.isLoadingCategoriesMore) {
        return const Center(child: CircularProgressIndicator());
      }
      if (state.categoriesError != null) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  state.categoriesError!.localizedMessage(context),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.noto14w400.copyWith(
                    color: AppColors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => context.read<HomeCubit>().loadCategories(),
                  child: Text(S.of(context).retry),
                ),
              ],
            ),
          ),
        );
      }
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const PharmacyLogo(size: 72),
              const SizedBox(height: 16),
              Text(
                S.of(context).notFoundCat,
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

    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            itemCount: categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.78,
            ),
            itemBuilder: (context, index) {
              final category = categories[index];
              return _CategoryPoster(
                category: category,
                onTap:
                    () =>
                        HomeNavigation.openCategoryProducts(context, category),
              );
            },
          ),
        ),
        if (state.isLoadingCategoriesMore)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: CircularProgressIndicator(),
          )
        else if (state.categoriesError != null)
          TextButton(
            onPressed:
                () => context.read<HomeCubit>().loadCategories(loadMore: true),
            child: Text(state.categoriesError!.localizedMessage(context)),
          ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _CategoryPoster extends StatelessWidget {
  const _CategoryPoster({required this.category, required this.onTap});

  final HomeDemoCategory category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final subCount = category.subcategories.length;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.12),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Stack(
              fit: StackFit.expand,
              children: [
                ColoredBox(
                  color: AppColors.light,
                  child: HomeCatalogImage(
                    assetPath: category.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.05),
                        Colors.black.withOpacity(0.18),
                        AppColors.primaryColor.withOpacity(0.92),
                      ],
                      stops: const [0.35, 0.58, 1],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: AlignmentDirectional.topEnd,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.92),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 13,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        category.name(context),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.noto16w400.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          if (subCount > 0)
                            _MetaChip(
                              label:
                                  isAr ? '$subCount قسم فرعي' : '$subCount sub',
                            ),
                        ],
                      ),
                    ],
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

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.22)),
      ),
      child: Text(
        label,
        style: AppTextStyles.noto14w400.copyWith(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
