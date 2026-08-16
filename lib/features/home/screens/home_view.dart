import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/features/home/data/home_demo_data.dart';
import 'package:elkawther/features/home/screens/home_navigation.dart';
import 'package:elkawther/features/home/widgets/home_banner.dart';
import 'package:elkawther/features/home/widgets/home_brands_row.dart';
import 'package:elkawther/features/home/widgets/home_header.dart';
import 'package:elkawther/features/home/widgets/home_product_card.dart';
import 'package:elkawther/features/home/widgets/home_problems_row.dart';
import 'package:elkawther/features/home/widgets/home_search_row.dart';
import 'package:elkawther/features/home/widgets/section_header.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5FAFD),
      body: SingleChildScrollView(
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
                  HomeHeader(),
                  SizedBox(height: 16),
                  HomeSearchRow(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
              child: Column(
                children: [
                  const HomeBanner(),
                  const SizedBox(height: 22),
                  SectionHeader(
                    title: l10n.categories,
                    actionText: l10n.viewMore,
                    onPressed: () => HomeNavigation.openCategories(context),
                  ),
                  const SizedBox(height: 8),
                  HomeChipsRow(
                    items: HomeDemoData.categories,
                    products: HomeDemoData.allProducts,
                  ),
                  const SizedBox(height: 22),
                  SectionHeader(
                    title: l10n.bigDiscounts,
                    actionText: l10n.viewMore,
                    showFire: true,
                    onPressed: () => HomeNavigation.openList(
                      context,
                      title: l10n.bigDiscounts,
                      products: HomeDemoData.discounts,
                    ),
                  ),
                  const HomeProductsRow(products: HomeDemoData.discounts),
                  const SizedBox(height: 22),
                  SectionHeader(
                    title: l10n.brands,
                    actionText: l10n.viewMore,
                    onPressed: () => HomeNavigation.openBrands(context),
                  ),
                  const SizedBox(height: 8),
                  const HomeBrandsRow(),
                  const SizedBox(height: 22),
                  const HomeBanner(),
                  const SizedBox(height: 22),
                  SectionHeader(
                    title: l10n.shopByProblem,
                    actionText: l10n.viewMore,
                    onPressed: () => HomeNavigation.openProblems(context),
                  ),
                  const SizedBox(height: 8),
                  const HomeProblemsRow(),
                  const SizedBox(height: 22),
                  SectionHeader(
                    title: l10n.bestSellingProducts,
                    actionText: l10n.viewMore,
                    onPressed: () => HomeNavigation.openList(
                      context,
                      title: l10n.bestSellingProducts,
                      products: HomeDemoData.bestSelling,
                    ),
                  ),
                  const HomeProductsRow(products: HomeDemoData.bestSelling),
                  const SizedBox(height: 22),
                  SectionHeader(
                    title: l10n.newArrival,
                    actionText: l10n.viewMore,
                    onPressed: () => HomeNavigation.openList(
                      context,
                      title: l10n.newArrival,
                      products: HomeDemoData.newArrivals,
                    ),
                  ),
                  const HomeProductsRow(products: HomeDemoData.newArrivals),
                  const SizedBox(height: 22),
                  SectionHeader(
                    title: l10n.specialPackages,
                    actionText: l10n.viewMore,
                    onPressed: () => HomeNavigation.openList(
                      context,
                      title: l10n.specialPackages,
                      products: HomeDemoData.specialPackages,
                    ),
                  ),
                  const HomeProductsRow(
                    products: HomeDemoData.specialPackages,
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
