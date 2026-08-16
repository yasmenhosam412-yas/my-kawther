import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/features/orders/data/orders_local_store.dart';
import 'package:elkawther/features/orders/models/orders_model.dart';
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

  List<Order> _ordersFor(int index) {
    final store = OrdersLocalStore.instance;
    switch (index) {
      case 1:
        return store.past();
      case 2:
        return store.canceled();
      default:
        return store.current();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final store = OrdersLocalStore.instance;

    return PopScope(
      canPop: !widget.afterConfrim,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _goBack();
      },
      child: ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          final orders = _ordersFor(activeIndex);
          return ProfileScaffold(
            title: S.of(context).myOrders,
            subtitle: isAr
                ? 'تابع طلباتك الحالية والسابقة'
                : 'Track current and previous orders',
            onBack: _goBack,
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Row(
                    children: [
                      _buildTabButton(0, S.of(context).currentNow),
                      const SizedBox(width: 8),
                      _buildTabButton(1, S.of(context).past),
                      const SizedBox(width: 8),
                      _buildTabButton(2, S.of(context).canceled),
                    ],
                  ),
                ),
                Expanded(
                  child: orders.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.receipt_long_outlined,
                                  size: 56,
                                  color: AppColors.grey.withOpacity(0.7),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  S.of(context).noOrders,
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

  Widget _buildTabButton(int index, String text) {
    final isActive = activeIndex == index;
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (activeIndex == index) return;
            setState(() => activeIndex = index);
          },
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            height: 44,
            decoration: BoxDecoration(
              color: isActive ? AppColors.primaryColor : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isActive
                    ? AppColors.primaryColor
                    : AppColors.primaryColor.withOpacity(0.12),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(isActive ? 0.16 : 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Center(
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
          ),
        ),
      ),
    );
  }
}
