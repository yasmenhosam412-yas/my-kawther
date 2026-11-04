import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/features/cart/cubit/cart_cubit.dart';
import 'package:elkawther/features/cart/models/cart_model.dart';
import 'package:elkawther/features/home/widgets/home_catalog_image.dart';
import 'package:elkawther/features/profile/widgets/profile_scaffold.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<CartCubit>().loadCart(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final numberFormat = NumberFormat('#,##0');

    return BlocConsumer<CartCubit, CartState>(
      listener: (context, state) {
        final message =
            state is CartError
                ? state.message
                : state is CartLoaded
                ? state.errorMessage?.localizedMessage(context)
                : null;
        if (message != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(message)));
        }
      },
      builder: (context, state) {
        final cubit = context.read<CartCubit>();
        final cart = cubit.cart;
        final isLoading = state is CartLoading;
        final isEmpty = cart.isEmpty;

        return ProfileScaffold(
          title: S.of(context).cart,
          subtitle:
              isAr
                  ? 'راجع منتجاتك قبل إتمام الطلب'
                  : 'Review your items before checkout',
          bottom: ProfilePrimaryButton(
            title:
                isEmpty ? S.of(context).startShopping : S.of(context).checkout,
            onPressed:
                isLoading
                    ? null
                    : isEmpty
                    ? _goShopping
                    : () => Navigator.pushNamed(context, Routes.checkout),
          ),
          body: RefreshIndicator(
            color: AppColors.primaryColor,
            onRefresh: () => cubit.loadCart(context),
            child:
                isLoading && isEmpty
                    ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(
                          height: 300,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      ],
                    )
                    : isEmpty
                    ? _emptyCart(state)
                    : ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      children: [
                        for (final item in cart) ...[
                          _cartItem(context, item, numberFormat),
                          const SizedBox(height: 12),
                        ],
                        ProfileFormCard(
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
                                '${numberFormat.format(cubit.totalAfterDiscount)} ${S.of(context).currency}',
                                style: AppTextStyles.noto16w400.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primaryColor,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
          ),
        );
      },
    );
  }

  Widget _emptyCart(CartState state) {
    final error = state is CartError ? state.message : null;
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: 360,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    error == null
                        ? Icons.shopping_bag_outlined
                        : Icons.cloud_off_outlined,
                    size: 56,
                    color: AppColors.grey.withOpacity(0.7),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    error ?? S.of(context).cartEmpty,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.noto16w400.copyWith(
                      color: AppColors.darkColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (error == null) ...[
                    const SizedBox(height: 8),
                    Text(
                      S.of(context).cartEmptySubtitle,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.noto14w400.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                  if (error != null) ...[
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed:
                          () => context.read<CartCubit>().loadCart(context),
                      child: Text(S.of(context).retry),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _cartItem(
    BuildContext context,
    CartModel item,
    NumberFormat numberFormat,
  ) {
    final cubit = context.read<CartCubit>();
    final updating = cubit.isItemUpdating(item.productId, item.size);
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap:
            () => Navigator.pushNamed(
              context,
              Routes.productDetails,
              arguments: {
                'id': item.productId,
                'isFav': false,
                'isView': false,
              },
            ),
        child: Ink(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.08),
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
                  child: HomeCatalogImage(
                    assetPath: item.mainImage,
                    width: 76,
                    height: 76,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.noto14w400.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.darkColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${numberFormat.format(item.lineTotal)} ${S.of(context).currency}',
                      style: AppTextStyles.noto14w400.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _QtyButton(
                          icon: Icons.remove_rounded,
                          label: isAr ? 'تقليل الكمية' : 'Decrease quantity',
                          onTap:
                              updating || item.quantity <= 1
                                  ? null
                                  : () => cubit.updateQuantitySafe(
                                    context,
                                    item.productId,
                                    'decrement',
                                    item.size,
                                  ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            '${item.quantity}',
                            style: AppTextStyles.noto14w400.copyWith(
                              fontWeight: FontWeight.w800,
                              color: AppColors.darkColor,
                            ),
                          ),
                        ),
                        _QtyButton(
                          icon: Icons.add_rounded,
                          label: isAr ? 'زيادة الكمية' : 'Increase quantity',
                          onTap:
                              updating
                                  ? null
                                  : () => cubit.updateQuantitySafe(
                                    context,
                                    item.productId,
                                    'increment',
                                    item.size,
                                  ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => cubit.removeItem(context, item.id),
                          icon: const Icon(
                            Icons.delete_outline_rounded,
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
  }

  void _goShopping() {
    if (Navigator.of(context).canPop()) {
      Navigator.pop(context);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false);
    }
  }
}

class _QtyButton extends StatelessWidget {
  const _QtyButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: Semantics(
        button: true,
        enabled: onTap != null,
        label: label,
        child: Material(
          color:
              onTap == null
                  ? AppColors.light
                  : AppColors.primaryColor.withOpacity(0.10),
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              width: 48,
              height: 48,
              child: Icon(
                icon,
                size: 22,
                color: onTap == null ? AppColors.grey : AppColors.primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
