import 'package:elkawther/features/categories/models/categories_model.dart'
    as category_models;
import 'package:elkawther/features/categories/screens/category_products_view.dart';
import 'package:elkawther/features/categories/screens/categories_view.dart';
import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/core/routes/route_extras.dart';
import 'package:elkawther/features/favorites/cubit/favourite_cubit.dart';
import 'package:elkawther/features/auth/cubit/auth_cubit.dart';
import 'package:elkawther/core/widgets/guest_user_dialog.dart';
import 'package:elkawther/features/home/data/home_demo_data.dart';
import 'package:elkawther/features/home/cubit/home_cubit.dart';
import 'package:elkawther/features/home/screens/home_brands_browse_view.dart';
import 'package:elkawther/features/home/screens/home_cart_view.dart';
import 'package:elkawther/features/home/screens/home_notifications_view.dart';
import 'package:elkawther/features/home/screens/home_problems_browse_view.dart';
import 'package:elkawther/features/home/screens/home_products_list_view.dart';
import 'package:elkawther/features/home/screens/home_search_view.dart';
import 'package:elkawther/features/home/widgets/home_ratings_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeNavigation {
  const HomeNavigation._();

  static Future<T?> _push<T>(BuildContext context, Widget page) {
    return Navigator.of(
      context,
    ).push<T>(MaterialPageRoute(builder: (_) => page));
  }

  static void openProduct(BuildContext context, HomeDemoProduct product) {
    final favourites = context.read<FavouriteCubit>();
    Navigator.of(context).pushNamed(
      Routes.productDetails,
      arguments: {
        'id': product.id,
        'click':
            () => favourites.toggleFavourite(
              productId: product.id,
              context: context,
            ),
        'isFav': favourites.isProductFavourite(product.id),
        'isView': false,
      },
    );
  }

  static void openList(
    BuildContext context, {
    required String title,
    required List<HomeDemoProduct> products,
  }) {
    _push(context, HomeProductsListView(title: title, products: products));
  }

  static void openCategories(BuildContext context, {int? selectedCategoryId}) {
    if (selectedCategoryId != null) {
      final categories =
          context.read<HomeCubit>().state.allCategories?.data ?? const [];
      for (final category in categories) {
        if (category.id == selectedCategoryId) {
          openCategoryProducts(
            context,
            HomeDemoCategory(
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
          );
          return;
        }
      }
    }
    _push(context, const CategoriesView());
  }

  static void openBrand(BuildContext context, HomeDemoBrand brand) {
    Navigator.of(context).pushNamed(
      Routes.brandProducts,
      arguments: BrandProductsArgs(id: brand.id, name: brand.name(context)),
    );
  }

  static void openBrands(BuildContext context) {
    _push(context, const HomeBrandsBrowseView());
  }

  static void openProblem(BuildContext context, HomeDemoProblem problem) {
    Navigator.of(context).pushNamed(
      Routes.healthIssueProducts,
      arguments: HealthIssueProductsArgs(
        id: problem.id,
        name: problem.name(context),
      ),
    );
  }

  static void openProblems(BuildContext context) {
    _push(context, const HomeProblemsBrowseView());
  }

  static void openCategoryProducts(
    BuildContext context,
    HomeDemoCategory category,
  ) {
    _push(
      context,
      CategoryProductsView(
        categoryId: category.id,
        categoryName: category.name(context),
        imageUrl: category.imageUrl,
        subcategory:
            category.subcategories
                .map(
                  (subcategory) => category_models.Subcategory(
                    id: subcategory.id,
                    parentId: category.id,
                    createdAt: '',
                    updatedAt: '',
                    image: subcategory.imageUrl,
                    name: subcategory.name(context),
                    imageUrl: subcategory.imageUrl,
                  ),
                )
                .toList(),
      ),
    );
  }

  static void openSearch(BuildContext context) {
    _push(context, const HomeSearchView());
  }

  static void openCart(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    if (authState is! AuthLoadedLogin && authState is! AuthLoadedRegister) {
      showGuestLoginDialog(context);
      return;
    }
    _push(context, const HomeCartView());
  }

  static void openNotifications(BuildContext context) {
    _push(context, const HomeNotificationsView());
  }

  static void openRatings(BuildContext context, HomeDemoProduct product) {
    HomeRatingsSheet.show(context, product);
  }
}
