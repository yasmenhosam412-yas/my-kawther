import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/utils/helper_functions.dart';
import 'package:elkawther/core/utils/helpers.dart' show OrderState;
import 'package:elkawther/features/orders/data/orders_local_store.dart';
import 'package:elkawther/features/orders/models/order_details_model.dart';
import 'package:elkawther/features/orders/widgets/add_rate.dart';
import 'package:elkawther/features/orders/widgets/order_details_section.dart';
import 'package:elkawther/features/orders/widgets/order_info_card.dart';
import 'package:elkawther/features/orders/widgets/order_product_item.dart';
import 'package:elkawther/features/orders/widgets/track_order.dart';
import 'package:elkawther/features/profile/widgets/profile_scaffold.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({super.key});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  late final int orderId;
  bool _isInitialized = false;
  int? selectedProductId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      orderId = ModalRoute.of(context)!.settings.arguments as int;
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final order = OrdersLocalStore.instance.detailsFor(orderId);

    if (order == null) {
      return ProfileScaffold(
        title: S.of(context).order_details,
        body: Center(
          child: Text(
            S.of(context).noOrders,
            style: AppTextStyles.noto14w400.copyWith(color: AppColors.grey),
          ),
        ),
      );
    }

    return ProfileScaffold(
      title: S.of(context).order_details,
      subtitle: isAr ? 'ملخص الطلب والمنتجات' : 'Order summary and items',
      bottom: _buildActionButtons(order),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          ProfileFormCard(
            child: OrderInfoHeader(
              orderNumber: '#${order.orderId}',
              date: HelperFunctions.getTime(
                DateTime.tryParse(order.createdAt) ?? DateTime.now(),
                context,
              ),
              shipmentNumber: _orderMeaning(order.status),
              orderState: _mapStatusToEnum(order.status),
              orderMeaning: _orderMeaning(order.status),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            '${order.products.length} ${S.of(context).items}',
            style: AppTextStyles.noto16w400.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.darkColor,
            ),
          ),
          const SizedBox(height: 10),
          ...order.products.map((product) {
            final isSelected = selectedProductId == product.productId;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GestureDetector(
                onTap: () {
                  if (order.status == 'completed') {
                    setState(() => selectedProductId = product.productId);
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryColor
                          : Colors.transparent,
                      width: 1.6,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(12),
                  child: OrderProductItem(product: product),
                ),
              ),
            );
          }),
          const SizedBox(height: 6),
          ProfileFormCard(
            child: OrderDetailsSection(
              address: _formatFullAddress(order.address),
              totalPrice: order.totalPrice,
              deliveryFee: order.deliveryFee,
              paymentMethod: order.paymentMethod,
              points: order.pointsEarned.toString(),
              gift: order.giftDescription ?? S.of(context).nogitf,
            ),
          ),
        ],
      ),
    );
  }

  String _formatFullAddress(Address address) {
    if (address.city == '-' &&
        address.street == '-' &&
        address.apartment == '-' &&
        address.building == '-' &&
        address.landmark == '-') {
      return S.of(context).takeFromPharamcy;
    }
    return '${address.city} - ${address.street} ${address.apartment}';
  }

  Widget? _buildActionButtons(OrderDetailsModel order) {
    final orderState = _mapStatusToEnum(order.status);

    switch (orderState) {
      case OrderState.active:
      case OrderState.onDelivery:
        return ProfilePrimaryButton(
          title: S.of(context).track_order,
          onPressed: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (_) => TrackOrderBottomSheet(
                track: OrdersLocalStore.instance.trackFor(orderId),
              ),
            );
          },
        );
      case OrderState.delivered:
        if (selectedProductId == null) return null;
        return ProfilePrimaryButton(
          title: S.of(context).leave_review,
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: AddRateBottomSheet(productId: selectedProductId!),
              ),
            );
          },
        );
      case OrderState.canceled:
        return null;
    }
  }

  OrderState _mapStatusToEnum(String? status) {
    switch ((status ?? '').trim().toLowerCase()) {
      case 'completed':
        return OrderState.delivered;
      case 'canceled':
        return OrderState.canceled;
      case 'on_delivery':
        return OrderState.onDelivery;
      default:
        return OrderState.active;
    }
  }

  String _orderMeaning(String status) {
    switch (status) {
      case 'pending':
        return S.of(context).orderIsNowPending;
      case 'confirmed':
        return S.of(context).orderIsNowConfirmed;
      case 'completed':
        return S.of(context).orderDelivered;
      case 'canceled':
        return S.of(context).orderCacelled;
      case 'on_delivery':
        return S.of(context).onDelivery;
      default:
        return S.of(context).orderIsNowPending;
    }
  }
}
