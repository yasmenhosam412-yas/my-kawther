import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/features/home/cubit/home_cubit.dart';
import 'package:elkawther/features/home/cubit/home_state.dart';
import 'package:elkawther/features/home/data/home_demo_data.dart';
import 'package:elkawther/features/home/screens/home_navigation.dart';
import 'package:elkawther/features/home/widgets/home_catalog_image.dart';
import 'package:elkawther/features/home/widgets/home_section_empty.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBrandsBrowseView extends StatefulWidget {
  const HomeBrandsBrowseView({super.key});

  @override
  State<HomeBrandsBrowseView> createState() => _HomeBrandsBrowseViewState();
}

class _HomeBrandsBrowseViewState extends State<HomeBrandsBrowseView> {
  static const _colors = [
    Color(0xFF0B76B9),
    Color(0xFF06A786),
    Color(0xFFEC4899),
  ];

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<HomeCubit>().loadBrands();
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 220) {
      context.read<HomeCubit>().loadBrands(loadMore: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FB),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(8, 8, 20, 18),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).brands,
                          style: AppTextStyles.noto16w400.copyWith(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isAr ? 'ماركات موثوقة' : 'Trusted brands',
                          style: AppTextStyles.noto14w400.copyWith(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.82),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                final brands =
                    state.brands.where((brand) => brand.id != null).toList();
                if (brands.isEmpty) {
                  if (state.status == HomeStatus.loading ||
                      state.isLoadingBrandsMore) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    );
                  }
                  final isAr =
                      Localizations.localeOf(context).languageCode == 'ar';
                  return HomePageEmpty(
                    message: isAr ? 'لا توجد ماركات' : 'No brands found',
                  );
                }

                final items =
                    brands.asMap().entries.map((entry) {
                      final brand = entry.value;
                      return HomeDemoBrand(
                        id: brand.id!,
                        nameAr: brand.name ?? '',
                        nameEn: brand.name ?? '',
                        categoryAr: '',
                        categoryEn: '',
                        logoUrl: brand.imageUrl ?? brand.image ?? '',
                        color: _colors[entry.key % _colors.length],
                        productIds: const [],
                      );
                    }).toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
                      child: Text(
                        isAr
                            ? '${state.brandsModel?.count ?? items.length} ماركة موثوقة'
                            : '${state.brandsModel?.count ?? items.length} trusted brands',
                        style: AppTextStyles.noto14w400.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                        itemCount:
                            items.length + (state.isLoadingBrandsMore ? 1 : 0),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 0.78,
                            ),
                        itemBuilder: (context, index) {
                          if (index >= items.length) {
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
                          final brand = items[index];
                          return _BrandTile(
                            brand: brand,
                            onTap:
                                () => HomeNavigation.openBrand(context, brand),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandTile extends StatelessWidget {
  const _BrandTile({required this.brand, required this.onTap});

  final HomeDemoBrand brand;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE6EEF5)),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: brand.color.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: HomeCatalogImage(
                      assetPath: brand.logoUrl,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  brand.name(context),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.noto14w400.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                    color: AppColors.darkColor,
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

