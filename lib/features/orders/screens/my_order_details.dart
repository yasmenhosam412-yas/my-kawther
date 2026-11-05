import 'package:dio/dio.dart';
import 'package:elkawther/core/errors/errors.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/utils/helper_functions.dart';
import 'package:elkawther/core/utils/helpers.dart' show OrderState;
import 'package:elkawther/core/widgets/app_snack_bar.dart';
import 'package:elkawther/features/orders/cubit/orders_cubit.dart';
import 'package:elkawther/features/orders/models/order_details_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
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
  String? _paymentStatus;
  bool _acting = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      orderId = ModalRoute.of(context)!.settings.arguments as int;
      _isInitialized = true;
      context.read<OrdersCubit>().getOrderDetails(orderId);
      _loadPaymentStatus();
    }
  }

  Future<void> _loadPaymentStatus() async {
    try {
      final status = await context.read<OrdersCubit>().paymentStatus(orderId);
      if (!mounted) return;
      final text =
          status['status'] ?? status['payment_status'] ?? status['message'];
      setState(() => _paymentStatus = text?.toString());
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        if (state is OrdersLoading) {
          return ProfileScaffold(
            title: S.of(context).order_details,
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        if (state is OrdersError) {
          return ProfileScaffold(
            title: S.of(context).order_details,
            body: Center(child: Text(state.error.message)),
          );
        }
        if (state is! OrderDetailsLoaded) {
          return ProfileScaffold(
            title: S.of(context).order_details,
            body: const SizedBox.shrink(),
          );
        }
        final order = state.orderDetails;
        return _details(context, isAr, order);
      },
    );
  }

  Widget _details(BuildContext context, bool isAr, OrderDetailsModel order) {
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
          if (_paymentStatus != null && _paymentStatus!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              _paymentStatus!,
              style: AppTextStyles.noto14w400.copyWith(color: AppColors.grey),
            ),
          ],
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
    final canPay =
        orderState == OrderState.active &&
        order.paymentMethod != 'cash' &&
        order.paymentMethod != 'cod';

    switch (orderState) {
      case OrderState.active:
      case OrderState.onDelivery:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ProfilePrimaryButton(
              title: S.of(context).track_order,
              isLoading: _acting,
              onPressed: _acting ? null : _track,
            ),
            if (orderState == OrderState.active) ...[
              const SizedBox(height: 8),
              ProfilePrimaryButton(
                title: S.of(context).cancel_order,
                color: const Color(0xFFEF4444),
                onPressed: _acting ? null : _cancel,
              ),
            ],
            if (canPay) ...[
              const SizedBox(height: 8),
              ProfilePrimaryButton(
                title: S.of(context).payment,
                onPressed: _acting ? null : _pay,
              ),
            ],
          ],
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

  Future<void> _track() async {
    setState(() => _acting = true);
    try {
      final track = await context.read<OrdersCubit>().fetchTrack(orderId);
      if (!mounted) return;
      await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (_) => TrackOrderBottomSheet(track: track),
      );
    } catch (error) {
      if (mounted) AppSnackBar.error(_apiMessage(error));
    } finally {
      if (mounted) setState(() => _acting = false);
    }
  }

  Future<void> _cancel() async {
    setState(() => _acting = true);
    try {
      final message = await context.read<OrdersCubit>().cancelOrder(orderId);
      if (!mounted) return;
      if (message.isNotEmpty) AppSnackBar.success(message);
      await context.read<OrdersCubit>().getOrderDetails(orderId);
    } catch (error) {
      if (mounted) AppSnackBar.error(_apiMessage(error));
    } finally {
      if (mounted) setState(() => _acting = false);
    }
  }

  Future<void> _pay() async {
    setState(() => _acting = true);
    try {
      final result = await context.read<OrdersCubit>().payOrder(orderId);
      if (!mounted) return;
      final link = result['payment_url'] ?? result['url'] ?? result['redirect_url'];
      final uri = link == null ? null : Uri.tryParse(link.toString());
      if (uri != null && uri.hasScheme) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else if (result['message'] != null) {
        AppSnackBar.success(result['message'].toString());
      }
      await _loadPaymentStatus();
    } catch (error) {
      if (mounted) AppSnackBar.error(_apiMessage(error));
    } finally {
      if (mounted) setState(() => _acting = false);
    }
  }

  String _apiMessage(Object error) {
    if (error is DioException) {
      return Errors.fromDioError(error).localizedMessage(context);
    }
    return error.toString();
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
