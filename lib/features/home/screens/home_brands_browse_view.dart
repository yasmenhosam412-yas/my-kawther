import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/features/home/data/home_demo_data.dart';
import 'package:elkawther/features/home/cubit/home_cubit.dart';
import 'package:elkawther/features/home/cubit/home_state.dart';
import 'package:elkawther/features/home/screens/home_navigation.dart';
import 'package:elkawther/features/home/widgets/home_brands_row.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBrandsBrowseView extends StatelessWidget {
  const HomeBrandsBrowseView({super.key});

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: const Color(0xFFF5FAFD),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 20, 8),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).brands,
                          style: AppTextStyles.noto16w400.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.darkColor,
                          ),
                        ),
                        Text(
                          isAr ? 'ماركات موثوقة' : 'Trusted brands',
                          style: AppTextStyles.noto14w400.copyWith(
                            fontSize: 12,
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  final brands =
                      state.brands.where((brand) => brand.id != null).toList();
                  if (brands.isEmpty) {
                    if (state.status == HomeStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return Center(child: Text(S.of(context).no_products_found));
                  }
                  const colors = [
                    Color(0xFF0B76B9),
                    Color(0xFF06A786),
                    Color(0xFFEC4899),
                  ];
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
                          color: colors[entry.key % colors.length],
                          productIds: const [],
                        );
                      }).toList();
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Text(
                          isAr
                              ? '${items.length} ماركة موثوقة'
                              : '${items.length} trusted brands',
                          style: AppTextStyles.noto14w400.copyWith(
                            fontSize: 12,
                            color: AppColors.grey,
                          ),
                        ),
                      ),
                      Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                          itemCount: items.length,
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 560,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                mainAxisExtent: 220,
                              ),
                          itemBuilder: (context, index) {
                            final brand = items[index];
                            return HomeBrandCard(
                              brand: brand,
                              compact: false,
                              onTap:
                                  () =>
                                      HomeNavigation.openBrand(context, brand),
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
      ),
    );
  }
}
