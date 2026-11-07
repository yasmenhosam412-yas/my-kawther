import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/features/orders/cubit/orders_cubit.dart';
import 'package:elkawther/features/orders/models/orders_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elkawther/features/orders/widgets/order_card.dart';
import 'package:elkawther/features/profile/widgets/profile_scaffold.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';

class MyOrders extends StatefulWidget {
  final bool afterConfrim;

  const MyOrders({super.key, required this.afterConfrim});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  int activeIndex = 0;

  void _goBack() {
    if (widget.afterConfrim) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.home,
        (route) => false,
      );
    } else {
      Navigator.pop(context);
    }
  }

  List<Order> _ordersFor(OrdersData data, int index) {
    switch (index) {
      case 1:
        return data.completed;
      case 2:
        return data.canceled;
      default:
        return [...data.pending, ...data.confirmed, ...data.onDelivery];
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return PopScope(
      canPop: !widget.afterConfrim,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _goBack();
      },
      child: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) {
          final data = state is OrdersGroupedLoaded
              ? state.data
              : OrdersData.empty();
          final orders = _ordersFor(data, activeIndex);
          final counts = [
            data.pending.length + data.confirmed.length + data.onDelivery.length,
            data.completed.length,
            data.canceled.length,
          ];
          if (state is OrdersLoading) {
            return ProfileScaffold(
              title: S.of(context).myOrders,
              onBack: _goBack,
              body: const Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              ),
            );
          }
          if (state is OrdersError) {
            return ProfileScaffold(
              title: S.of(context).myOrders,
              onBack: _goBack,
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        size: 48,
                        color: AppColors.grey.withOpacity(0.8),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        state.error.message,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.noto14w400.copyWith(
                          color: AppColors.grey,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return ProfileScaffold(
            title: S.of(context).myOrders,
            subtitle: isAr
                ? 'تابع طلباتك الحالية والسابقة'
                : 'Track current and previous orders',
            onBack: _goBack,
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryColor.withOpacity(0.08),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        _buildTabButton(0, S.of(context).currentNow, counts[0]),
                        _buildTabButton(1, S.of(context).past, counts[1]),
                        _buildTabButton(2, S.of(context).canceled, counts[2]),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: orders.isEmpty
                      ? _EmptyOrders(tab: activeIndex)
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                          itemCount: orders.length,
                          itemBuilder: (context, index) {
                            return OrderCard(order: orders[index]);
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabButton(int index, String text, int count) {
    final isActive = activeIndex == index;
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (activeIndex == index) return;
            setState(() => activeIndex = index);
          },
          borderRadius: BorderRadius.circular(14),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            height: 44,
            decoration: BoxDecoration(
              color: isActive ? AppColors.primaryColor : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.noto14w400.copyWith(
                      color: isActive ? Colors.white : AppColors.darkColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  constraints: const BoxConstraints(minWidth: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.white.withOpacity(0.22)
                        : AppColors.light,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$count',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.noto14w400.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: isActive ? Colors.white : AppColors.primaryColor,
                    ),
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

class _EmptyOrders extends StatelessWidget {
  const _EmptyOrders({required this.tab});

  final int tab;

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final icon = switch (tab) {
      1 => Icons.inventory_2_outlined,
      2 => Icons.cancel_outlined,
      _ => Icons.local_shipping_outlined,
    };
    final caption = switch (tab) {
      1 => isAr ? 'لا توجد طلبات مكتملة بعد' : 'No completed orders yet',
      2 => isAr ? 'لا توجد طلبات ملغاة' : 'No canceled orders',
      _ => isAr ? 'لا توجد طلبات قيد التنفيذ' : 'No orders in progress',
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: AppColors.light,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Icon(icon, size: 36, color: AppColors.primaryColor),
            ),
            const SizedBox(height: 14),
            Text(
              S.of(context).noOrders,
              textAlign: TextAlign.center,
              style: AppTextStyles.noto16w400.copyWith(
                color: AppColors.darkColor,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              caption,
              textAlign: TextAlign.center,
              style: AppTextStyles.noto14w400.copyWith(color: AppColors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
