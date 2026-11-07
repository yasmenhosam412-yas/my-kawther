import 'package:dio/dio.dart';
import 'package:elkawther/core/errors/errors.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/utils/helper_functions.dart';
import 'package:elkawther/core/utils/helpers.dart' show OrderState;
import 'package:elkawther/core/widgets/app_snack_bar.dart';
import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/features/orders/cubit/orders_cubit.dart';
import 'package:elkawther/features/orders/models/order_details_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:elkawther/features/orders/widgets/add_rate.dart';
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
            body: const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            ),
          );
        }
        if (state is OrdersError) {
          return ProfileScaffold(
            title: S.of(context).order_details,
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
    final orderState = _mapStatusToEnum(order.status);
    final statusColor = _statusColor(orderState);
    final canReview = order.status == 'completed';
    final placedAt = HelperFunctions.getTime(
      DateTime.tryParse(order.createdAt) ?? DateTime.now(),
      context,
    );

    return ProfileScaffold(
      title: S.of(context).order_details,
      subtitle: isAr ? 'ملخص الطلب والمنتجات' : 'Order summary and items',
      bottom: _buildActionButtons(order),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        children: [
          _OrderHero(
            orderNumber: '#${order.orderId}',
            date: placedAt,
            meaning: _orderMeaning(order.status),
            statusLabel: _statusLabel(orderState),
            statusIcon: _statusIcon(orderState),
            statusColor: statusColor,
          ),
          const SizedBox(height: 14),
          if (orderState == OrderState.canceled)
            _NoticeBanner(
              icon: Icons.cancel_outlined,
              color: const Color(0xFFDC2626),
              text: S.of(context).orderCacelled,
            )
          else
            _OrderProgress(
              current: _progressIndex(order.status),
              labels: [
                S.of(context).order_status_pending,
                S.of(context).order_status_confirmed,
                S.of(context).order_status_on_delivery,
                S.of(context).order_status_completed,
              ],
            ),
          const SizedBox(height: 18),
          _SectionTitle(
            title: '${order.products.length} ${S.of(context).items}',
            caption: canReview
                ? (isAr ? 'اضغط على منتج لتقييمه' : 'Tap a product to review it')
                : null,
          ),
          const SizedBox(height: 10),
          ...order.products.map((product) {
            final isSelected = selectedProductId == product.productId;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GestureDetector(
                onTap: canReview
                    ? () => setState(() => selectedProductId = product.productId)
                    : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryColor
                          : AppColors.primaryColor.withOpacity(0.08),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(
                          isSelected ? 0.14 : 0.06,
                        ),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(child: OrderProductItem(product: product)),
                      if (isSelected)
                        const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.primaryColor,
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 8),
          _ReceiptCard(
            address: _formatFullAddress(order.address),
            payment: _paymentLabel(order.paymentMethod),
            deliveryFee:
                '${_money(order.deliveryFee)} ${S.of(context).currency}',
            total: '${_money(order.totalPrice)} ${S.of(context).currency}',
            points: order.pointsEarned.toString(),
            gift: order.giftDescription,
          ),
          if (_paymentStatus != null && _paymentStatus!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _NoticeBanner(
              icon: Icons.payments_outlined,
              color: AppColors.primaryColor,
              text: _paymentStatus!,
            ),
          ],
        ],
      ),
    );
  }

  String _money(String raw) {
    final value = double.tryParse(raw) ?? 0;
    if (value == value.roundToDouble()) return value.toStringAsFixed(0);
    return value.toStringAsFixed(2);
  }

  String _paymentLabel(String method) {
    switch (method) {
      case 'cash':
      case 'cod':
        return S.of(context).cash;
      case 'qicard':
        return S.of(context).qiCard;
      default:
        return S.of(context).zainCach;
    }
  }

  int _progressIndex(String status) {
    switch (status.trim().toLowerCase()) {
      case 'confirmed':
        return 1;
      case 'on_delivery':
        return 2;
      case 'completed':
        return 3;
      default:
        return 0;
    }
  }

  Color _statusColor(OrderState state) {
    switch (state) {
      case OrderState.delivered:
        return const Color(0xFF059669);
      case OrderState.canceled:
        return const Color(0xFFDC2626);
      case OrderState.onDelivery:
        return AppColors.teal;
      case OrderState.active:
        return const Color(0xFFD97706);
    }
  }

  IconData _statusIcon(OrderState state) {
    switch (state) {
      case OrderState.delivered:
        return Icons.verified_rounded;
      case OrderState.canceled:
        return Icons.cancel_rounded;
      case OrderState.onDelivery:
        return Icons.local_shipping_rounded;
      case OrderState.active:
        return Icons.schedule_rounded;
    }
  }

  String _statusLabel(OrderState state) {
    switch (state) {
      case OrderState.delivered:
        return S.of(context).accepted;
      case OrderState.canceled:
        return S.of(context).rejected;
      case OrderState.onDelivery:
        return S.of(context).onDelivery;
      case OrderState.active:
        return S.of(context).pending;
    }
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
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ProfilePrimaryButton(
              title: S.of(context).return_product,
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  Routes.returnProduct,
                  arguments: order,
                );
              },
            ),
            if (selectedProductId != null) ...[
              const SizedBox(height: 8),
              ProfilePrimaryButton(
                title: S.of(context).leave_review,
                color: AppColors.teal,
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
              ),
            ],
          ],
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
      final failure = _failureMessage(message);
      if (failure != null) {
        AppSnackBar.error(failure);
        return;
      }
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
    final text = error.toString().replaceFirst(
      RegExp(r'^(?:Exception|Error)\s*:\s*'),
      '',
    );
    return _failureMessage(text) ?? text.trim();
  }

  String? _failureMessage(String message) {
    final match = RegExp(
      r'^error\s*:\s*(.*)$',
      caseSensitive: false,
    ).firstMatch(message.trim());
    if (match == null) return null;
    final body = match.group(1)?.trim() ?? '';
    return body.isEmpty ? message.trim() : body;
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

class _OrderHero extends StatelessWidget {
  const _OrderHero({
    required this.orderNumber,
    required this.date,
    required this.meaning,
    required this.statusLabel,
    required this.statusIcon,
    required this.statusColor,
  });

  final String orderNumber;
  final String date;
  final String meaning;
  final String statusLabel;
  final IconData statusIcon;
  final Color statusColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.12),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(statusIcon, color: statusColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${S.of(context).orderNumber} $orderNumber',
                        style: AppTextStyles.noto16w400.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColors.darkColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        meaning,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.noto14w400.copyWith(
                          color: AppColors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 13,
                            color: AppColors.grey,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              date,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.noto14w400.copyWith(
                                fontSize: 12,
                                color: AppColors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    statusLabel,
                    style: AppTextStyles.noto14w400.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderProgress extends StatelessWidget {
  const _OrderProgress({required this.current, required this.labels});

  final int current;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: List.generate(labels.length, (index) {
          final done = index <= current;
          final active = index == current;
          return Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 3,
                        color: index == 0
                            ? Colors.transparent
                            : (index <= current
                                  ? AppColors.primaryColor
                                  : AppColors.greyBorder),
                      ),
                    ),
                    Container(
                      width: active ? 22 : 16,
                      height: active ? 22 : 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: done ? AppColors.primaryColor : Colors.white,
                        border: Border.all(
                          color: done
                              ? AppColors.primaryColor
                              : AppColors.greyBorder,
                          width: 2,
                        ),
                      ),
                      child: done
                          ? Icon(
                              Icons.check,
                              size: active ? 12 : 9,
                              color: Colors.white,
                            )
                          : null,
                    ),
                    Expanded(
                      child: Container(
                        height: 3,
                        color: index == labels.length - 1
                            ? Colors.transparent
                            : (index < current
                                  ? AppColors.primaryColor
                                  : AppColors.greyBorder),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  labels[index],
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.noto14w400.copyWith(
                    fontSize: 11,
                    height: 1.2,
                    fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                    color: done ? AppColors.darkColor : AppColors.grey,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, this.caption});

  final String title;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.noto16w400.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.darkColor,
          ),
        ),
        if (caption != null) ...[
          const SizedBox(height: 2),
          Text(
            caption!,
            style: AppTextStyles.noto14w400.copyWith(
              fontSize: 12,
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }
}

class _ReceiptCard extends StatelessWidget {
  const _ReceiptCard({
    required this.address,
    required this.payment,
    required this.deliveryFee,
    required this.total,
    required this.points,
    required this.gift,
  });

  final String address;
  final String payment;
  final String deliveryFee;
  final String total;
  final String points;
  final String? gift;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).orderDetails,
            style: AppTextStyles.noto16w400.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.darkColor,
            ),
          ),
          const SizedBox(height: 12),
          _ReceiptRow(
            icon: Icons.location_on_outlined,
            label: S.of(context).shippingAddress,
            value: address,
          ),
          _ReceiptRow(
            icon: Icons.account_balance_wallet_outlined,
            label: S.of(context).paymentMethod,
            value: payment,
          ),
          _ReceiptRow(
            icon: Icons.local_shipping_outlined,
            label: S.of(context).deliveryFee,
            value: deliveryFee,
          ),
          _ReceiptRow(
            icon: Icons.stars_rounded,
            label: S.of(context).pointsEarned,
            value: points,
          ),
          if (gift != null && gift!.trim().isNotEmpty)
            _ReceiptRow(
              icon: Icons.card_giftcard_outlined,
              label: S.of(context).gift,
              value: gift!,
            ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.light,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    S.of(context).totalPrice,
                    style: AppTextStyles.noto14w400.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.darkColor,
                    ),
                  ),
                ),
                Text(
                  total,
                  style: AppTextStyles.noto16w400.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReceiptRow extends StatelessWidget {
  const _ReceiptRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.primaryColor),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.noto14w400.copyWith(
                    fontSize: 12,
                    color: AppColors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTextStyles.noto14w400.copyWith(
                    color: AppColors.darkColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NoticeBanner extends StatelessWidget {
  const _NoticeBanner({
    required this.icon,
    required this.color,
    required this.text,
  });

  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.noto14w400.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
