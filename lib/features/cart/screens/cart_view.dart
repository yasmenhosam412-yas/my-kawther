import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/core/widgets/app_snack_bar.dart';
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
    final currency = S.of(context).currency;

    return BlocConsumer<CartCubit, CartState>(
      listener: (context, state) {
        if (state is CouponRejected) {
          AppSnackBar.warning(state.message);
          return;
        }
        final message =
            state is CartError
                ? state.message
                : state is CartLoaded
                ? state.errorMessage?.localizedMessage(context)
                : null;
        if (message != null) {
          AppSnackBar.error(message);
        }
      },
      builder: (context, state) {
        final cubit = context.read<CartCubit>();
        final cart = cubit.cart;
        final isLoading = state is CartLoading;
        final isEmpty = cart.isEmpty;
        final discount = cubit.discount;

        return ProfileScaffold(
          title: S.of(context).cart,
          subtitle:
              isAr
                  ? 'راجع منتجاتك قبل إتمام الطلب'
                  : 'Review your items before checkout',
          bottom: ProfilePrimaryButton(
            isLoading: false,
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
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                      children: [
                        _itemsCountHeader(cart),
                        const SizedBox(height: 12),
                        for (final item in cart) ...[
                          _cartItem(context, item, numberFormat, currency),
                          const SizedBox(height: 12),
                        ],
                        ProfileFormCard(
                          child: Column(
                            children: [
                              _summaryRow(
                                S.of(context).subtotal,
                                '${numberFormat.format(cubit.subtotal)} $currency',
                                amountColor: AppColors.darkColor,
                              ),
                              if (discount > 0) ...[
                                const SizedBox(height: 8),
                                _summaryRow(
                                  S.of(context).discount,
                                  '-${numberFormat.format(discount)} $currency',
                                  amountColor: AppColors.teal,
                                  leading: const Icon(
                                    Icons.local_offer_rounded,
                                    size: 16,
                                    color: AppColors.teal,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 10),
                              const _SummaryDivider(),
                              const SizedBox(height: 8),
                              _summaryRow(
                                S.of(context).total,
                                '${numberFormat.format(cubit.totalAfterDiscount)} $currency',
                                amountColor: AppColors.primaryColor,
                                amountFontSize: 18,
                                labelFontSize: 16,
                                amountFontWeight: FontWeight.w800,
                                labelFontWeight: FontWeight.w800,
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

  Widget _itemsCountHeader(List<CartModel> cart) {
    final count = cart.fold<int>(0, (sum, item) => sum + item.quantity);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.10),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.inventory_2_outlined,
            size: 18,
            color: AppColors.primaryColor,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            '${S.of(context).cart} · $count',
            style: AppTextStyles.noto14w400.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _emptyCart(CartState state) {
    final error = state is CartError ? state.message : null;
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: 400,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      error == null
                          ? Icons.shopping_bag_outlined
                          : Icons.cloud_off_outlined,
                      size: 48,
                      color: AppColors.primaryColor.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 20),
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
    String currency,
  ) {
    final cubit = context.read<CartCubit>();
    final updating = cubit.isItemUpdating(item.productId, item.size);
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final hasSize = item.size.trim().isNotEmpty;

    return Dismissible(
      key: ValueKey('cart-${item.productId}-${item.size}'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => cubit.removeItem(context, item.id),
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        margin: const EdgeInsets.only(left: 1),
        padding: const EdgeInsets.symmetric(horizontal: 22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [AppColors.redOpacity, AppColors.redOpacity.withOpacity(0.7)],
          ),
        ),
        child: const Icon(
          Icons.delete_outline_rounded,
          size: 26,
          color: Colors.white,
        ),
      ),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: updating ? 0.55 : 1,
        child: Material(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: ColoredBox(
                          color: AppColors.light,
                          child: HomeCatalogImage(
                            assetPath: item.mainImage,
                            width: 78,
                            height: 78,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      if (item.discountPercentage > 0)
                        Positioned(
                          top: -6,
                          left: isAr ? -6 : null,
                          right: isAr ? null : -6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.redOpacity,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.white,
                                  blurRadius: 0,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Text(
                              '-${item.discountPercentage}%',
                              style: AppTextStyles.noto14w400.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                item.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.noto14w400.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.darkColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            _CircularIconButton(
                              tooltip: isAr ? 'حذف' : 'Remove item',
                              icon: Icons.delete_outline_rounded,
                              onTap: () => cubit.removeItem(context, item.id),
                            ),
                          ],
                        ),
                        if (hasSize) ...[
                          const SizedBox(height: 5),
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2.5,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.light,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${S.of(context).size}: ${item.size}',
                                style: AppTextStyles.noto14w400.copyWith(
                                  color: AppColors.grey,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                        if (item.discountedPrice != item.lineTotal / item.quantity) ...[
                          const SizedBox(height: 5),
                          Text(
                            '${numberFormat.format(item.discountedPrice)} $currency '
                            '/ 1',
                            style: AppTextStyles.noto14w400.copyWith(
                              color: AppColors.grey,
                              fontSize: 11,
                            ),
                          ),
                        ],
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            _QtyStepper(
                              isAr: isAr,
                              disabled: updating,
                              quantity: item.quantity,
                              canDecrease: item.quantity > 1,
                              onDecrease:
                                  () => cubit.updateQuantitySafe(
                                    context,
                                    item.productId,
                                    'decrement',
                                    item.size,
                                  ),
                              onIncrease:
                                  () => cubit.updateQuantitySafe(
                                    context,
                                    item.productId,
                                    'increment',
                                    item.size,
                                  ),
                            ),
                            const Spacer(),
                            Text(
                              '${numberFormat.format(item.lineTotal)} $currency',
                              style: AppTextStyles.noto14w400.copyWith(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
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
        ),
      ),
    );
  }

  Widget _summaryRow(
    String label,
    String amount, {
    Color? amountColor,
    Icon? leading,
    double labelFontSize = 14,
    double amountFontSize = 14,
    FontWeight labelFontWeight = FontWeight.w500,
    FontWeight amountFontWeight = FontWeight.w700,
  }) {
    return Row(
      children: [
        if (leading != null) ...[leading, const SizedBox(width: 6)],
        Text(
          label,
          style: AppTextStyles.noto14w400.copyWith(
            color: amountFontSize > 15 ? AppColors.darkColor : AppColors.grey,
            fontWeight: labelFontWeight,
            fontSize: labelFontSize,
          ),
        ),
        const Spacer(),
        Text(
          amount,
          style: AppTextStyles.noto14w400.copyWith(
            fontWeight: amountFontWeight,
            fontSize: amountFontSize,
            color: amountColor,
          ),
        ),
      ],
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

class _SummaryDivider extends StatelessWidget {
  const _SummaryDivider();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 1,
      child: DecoratedBox(
        decoration: BoxDecoration(color: Color(0xFFE9EFF4)),
      ),
    );
  }
}

class _QtyStepper extends StatelessWidget {
  const _QtyStepper({
    required this.isAr,
    required this.disabled,
    required this.quantity,
    required this.canDecrease,
    required this.onDecrease,
    required this.onIncrease,
  });

  final bool isAr;
  final bool disabled;
  final int quantity;
  final bool canDecrease;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    final decreaseEnabled = !disabled && canDecrease;
    final increaseEnabled = !disabled;

    return Material(
      color: AppColors.primaryColor.withOpacity(0.10),
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Row(
          children: [
            Semantics(
              button: true,
              enabled: decreaseEnabled,
              label: isAr ? 'تقليل الكمية' : 'Decrease quantity',
              child: InkWell(
                onTap: decreaseEnabled ? onDecrease : null,
                borderRadius: BorderRadius.circular(11),
                child: SizedBox(
                  width: 36,
                  height: 36,
                  child: Icon(
                    Icons.remove_rounded,
                    size: 18,
                    color:
                        decreaseEnabled
                            ? AppColors.primaryColor
                            : AppColors.grey.withOpacity(0.5),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 30,
              child: Text(
                '$quantity',
                textAlign: TextAlign.center,
                style: AppTextStyles.noto14w400.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.darkColor,
                ),
              ),
            ),
            Semantics(
              button: true,
              enabled: increaseEnabled,
              label: isAr ? 'زيادة الكمية' : 'Increase quantity',
              child: InkWell(
                onTap: increaseEnabled ? onIncrease : null,
                borderRadius: BorderRadius.circular(11),
                child: SizedBox(
                  width: 36,
                  height: 36,
                  child: Icon(
                    Icons.add_rounded,
                    size: 18,
                    color:
                        increaseEnabled
                            ? AppColors.primaryColor
                            : AppColors.grey.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircularIconButton extends StatelessWidget {
  const _CircularIconButton({
    required this.tooltip,
    required this.icon,
    required this.onTap,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Icon(icon, size: 20, color: AppColors.grey),
          ),
        ),
      ),
    );
  }
}
