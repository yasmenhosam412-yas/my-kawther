import 'package:elkawther/features/home/data/home_demo_data.dart';
import 'package:elkawther/features/home/screens/home_brands_browse_view.dart';
import 'package:elkawther/features/home/screens/home_cart_view.dart';
import 'package:elkawther/features/home/screens/home_categories_browse_view.dart';
import 'package:elkawther/features/home/screens/home_category_products_view.dart';
import 'package:elkawther/features/home/screens/home_notifications_view.dart';
import 'package:elkawther/features/home/screens/home_problems_browse_view.dart';
import 'package:elkawther/features/home/screens/home_product_details_view.dart';
import 'package:elkawther/features/home/screens/home_products_list_view.dart';
import 'package:elkawther/features/home/screens/home_search_view.dart';
import 'package:elkawther/features/home/widgets/home_ratings_sheet.dart';
import 'package:flutter/material.dart';

class HomeNavigation {
  const HomeNavigation._();

  static Future<T?> _push<T>(BuildContext context, Widget page) {
    return Navigator.of(context).push<T>(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  static void openProduct(BuildContext context, HomeDemoProduct product) {
    _push(context, HomeProductDetailsView(product: product));
  }

  static void openList(
    BuildContext context, {
    required String title,
    required List<HomeDemoProduct> products,
  }) {
    _push(
      context,
      HomeProductsListView(title: title, products: products),
    );
  }

  static void openCategories(
    BuildContext context, {
    int? selectedCategoryId,
  }) {
    if (selectedCategoryId != null) {
      for (final category in HomeDemoData.catalogCategories) {
        if (category.id == selectedCategoryId) {
          openCategoryProducts(context, category);
          return;
        }
      }
    }
    _push(context, const HomeCategoriesBrowseView());
  }

  static void openBrand(BuildContext context, HomeDemoBrand brand) {
    openList(
      context,
      title: brand.name(context),
      products: HomeDemoData.productsForBrand(brand.id),
    );
  }

  static void openBrands(BuildContext context) {
    _push(context, const HomeBrandsBrowseView());
  }

  static void openProblem(BuildContext context, HomeDemoProblem problem) {
    openList(
      context,
      title: problem.name(context),
      products: HomeDemoData.productsForProblem(problem.id),
    );
  }

  static void openProblems(BuildContext context) {
    _push(context, const HomeProblemsBrowseView());
  }

  static void openCategoryProducts(
    BuildContext context,
    HomeDemoCategory category,
  ) {
    _push(context, HomeCategoryProductsView(category: category));
  }

  static void openSearch(BuildContext context) {
    _push(context, const HomeSearchView());
  }

  static void openCart(BuildContext context) {
    _push(context, const HomeCartView());
  }

  static void openNotifications(BuildContext context) {
    _push(context, const HomeNotificationsView());
  }

  static void openRatings(BuildContext context, HomeDemoProduct product) {
    HomeRatingsSheet.show(context, product);
  }
}
