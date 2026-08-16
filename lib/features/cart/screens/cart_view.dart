import 'package:cached_network_image/cached_network_image.dart';
import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/widgets/pharmacy_placeholder.dart';
import 'package:elkawther/features/home/data/home_cart_store.dart';
import 'package:elkawther/features/home/screens/home_navigation.dart';
import 'package:elkawther/features/profile/widgets/profile_scaffold.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final store = HomeCartStore.instance;
    final numberFormat = NumberFormat('#,##0');

    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final lines = store.lines;
        return ProfileScaffold(
          title: S.of(context).cart,
          subtitle: isAr
              ? 'راجع منتجاتك قبل إتمام الطلب'
              : 'Review your items before checkout',
          bottom: lines.isEmpty
              ? ProfilePrimaryButton(
                  title: S.of(context).startShopping,
                  onPressed: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.pop(context);
                    } else {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        Routes.home,
                        (route) => false,
                      );
                    }
                  },
                )
              : ProfilePrimaryButton(
                  title: S.of(context).checkout,
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.checkout);
                  },
                ),
          body: lines.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.shopping_bag_outlined,
                          size: 56,
                          color: AppColors.grey.withOpacity(0.7),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          S.of(context).cartEmpty,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.noto16w400.copyWith(
                            color: AppColors.darkColor,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          S.of(context).cartEmptySubtitle,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.noto14w400.copyWith(
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        itemCount: lines.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final line = lines[index];
                          final product = line.product;
                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () =>
                                  HomeNavigation.openProduct(context, product),
                              child: Ink(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primaryColor
                                          .withOpacity(0.08),
                                      blurRadius: 16,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: ColoredBox(
                                        color: AppColors.light,
                                        child: CachedNetworkImage(
                                          imageUrl: product.imageUrl,
                                          width: 76,
                                          height: 76,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              const PharmacyImageLoading(),
                                          errorWidget:
                                              (context, url, error) =>
                                                  const PharmacyPlaceholder(
                                            size: 40,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.name(context),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppTextStyles.noto14w400
                                                .copyWith(
                                              fontWeight: FontWeight.w800,
                                              color: AppColors.darkColor,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            '${numberFormat.format(line.lineTotal)} ${S.of(context).currency}',
                                            style: AppTextStyles.noto14w400
                                                .copyWith(
                                              color: AppColors.primaryColor,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              _QtyButton(
                                                icon: Icons.remove_rounded,
                                                onTap: () => store.decrement(
                                                  product.id,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                ),
                                                child: Text(
                                                  '${line.quantity}',
                                                  style: AppTextStyles
                                                      .noto14w400
                                                      .copyWith(
                                                    fontWeight: FontWeight.w800,
                                                    color: AppColors.darkColor,
                                                  ),
                                                ),
                                              ),
                                              _QtyButton(
                                                icon: Icons.add_rounded,
                                                onTap: () => store.increment(
                                                  product.id,
                                                ),
                                              ),
                                              const Spacer(),
                                              IconButton(
                                                onPressed: () =>
                                                    store.removeAt(index),
                                                icon: const Icon(
                                                  Icons
                                                      .delete_outline_rounded,
                                                  color: AppColors.grey,
                                                ),
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
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                      child: ProfileFormCard(
                        child: Row(
                          children: [
                            Text(
                              S.of(context).total,
                              style: AppTextStyles.noto16w400.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.darkColor,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${numberFormat.format(store.total)} ${S.of(context).currency}',
                              style: AppTextStyles.noto16w400.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.primaryColor,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class _QtyButton extends StatelessWidget {
  const _QtyButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.light,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: 32,
          height: 32,
          child: Icon(icon, size: 18, color: AppColors.primaryColor),
        ),
      ),
    );
  }
}
