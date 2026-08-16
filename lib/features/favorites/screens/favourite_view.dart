import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/features/home/data/home_favorites_store.dart';
import 'package:elkawther/features/home/widgets/home_product_card.dart';
import 'package:elkawther/features/profile/widgets/profile_scaffold.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final store = HomeFavoritesStore.instance;

    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final products = store.items;
        return ProfileScaffold(
          title: S.of(context).favourite,
          subtitle: isAr
              ? 'منتجاتك المحفوظة للشراء لاحقاً'
              : 'Saved products to buy later',
          body: products.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.favorite_border_rounded,
                          size: 56,
                          color: AppColors.grey.withOpacity(0.7),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          S.of(context).favouriteEmpty,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.noto14w400.copyWith(
                            color: AppColors.grey,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.62,
                  ),
                  itemBuilder: (context, index) {
                    return HomeProductCard(product: products[index]);
                  },
                ),
        );
      },
    );
  }
}
