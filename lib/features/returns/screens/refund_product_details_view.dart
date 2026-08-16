import 'package:cached_network_image/cached_network_image.dart';
import 'package:elkawther/features/orders/models/all_returns.dart';
import 'package:elkawther/features/orders/widgets/order_info_card.dart';
import 'package:elkawther/features/returns/screens/refund_details_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elkawther/features/orders/cubit/orders_cubit.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/core/theme/app_padding.dart';
import 'package:elkawther/core/utils/helper_functions.dart';
import 'package:elkawther/core/utils/helpers.dart' show OrderState;

class RefundProductDetailsView extends StatefulWidget {
  const RefundProductDetailsView({super.key});

  @override
  State<RefundProductDetailsView> createState() =>
      _RefundProductDetailsViewState();
}

class _RefundProductDetailsViewState extends State<RefundProductDetailsView> {
  late final int orderId;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      orderId = ModalRoute.of(context)!.settings.arguments as int;
      context.read<OrdersCubit>().getOrderDetailsRefunded(orderId);
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).order_details,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) {
          if (state is OrdersLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrderDetailsRefnudedLoaded) {
            final order = state.refundedItem;
            return _buildOrderDetailsView(order);
          } else if (state is OrdersError) {
            return Center(child: Text(state.error.localizedMessage(context)));
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  Widget _buildOrderDetailsView(RefundedItem order) {
    final products = order.order;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(AppPadding.medium),
          sliver: SliverList.list(
            children: [
              OrderInfoHeader(
                orderNumber: "#${order.orderId}",
                date: HelperFunctions.getTime(
                  DateTime.parse("${products.createdAt}"),
                  context,
                ),
                shipmentNumber: order.status ?? "",
                orderState: _mapStatusToEnum(order.status),
                orderMeaning: getOrderMeaning(order.status ?? ""),
              ),
              const SizedBox(height: AppPadding.medium),
              const Divider(),
              const SizedBox(height: AppPadding.medium),
              // Text(
              //   "$order ${S.of(context).items}",
              //   style: Theme.of(
              //     context,
              //   ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              // ),
            ],
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index.isEven) {
                final imageIndex = index ~/ 2;
                return Padding(
                  padding: const EdgeInsets.all(AppPadding.medium),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child:
                        (order.images.isNotEmpty)
                            ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                imageUrl: order.images[imageIndex]['full_url'],
                                width: double.infinity,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            )
                            : Center(child: Text(S.of(context).no_images)),
                  ),
                );
              } else {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppPadding.medium),
                  child: Divider(),
                );
              }
            },
            childCount: order.images.isEmpty ? 1 : order.images.length * 2 - 1,
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(AppPadding.medium),
          sliver: SliverList.list(
            children: [
              RefundDetailsSection(
                address:
                    (order.address!.startsWith("https") == false)
                        ? order.address ?? ""
                        : S.of(context).takeFromPharamcy,
                totalPrice: order.refundAmount ?? "",
                // deliveryFee: order.order.deliveryFee,
                paymentMethod: order.refundMethod ?? "cash",
                points: order.order.pointsEarned.toString(),
                gift: order.order.giftDescription ?? S.of(context).nogitf,
                notes: order.note ?? "",
                reson: order.reason,
              ),
            ],
          ),
        ),
        // SliverToBoxAdapter(
        //   child: Padding(
        //     padding: const EdgeInsets.all(AppPadding.medium),
        //     child: _buildActionButtons(order),
        //   ),
        // ),
      ],
    );
  }

  OrderState _mapStatusToEnum(String? status) {
    if (status == null) {
      return OrderState.active;
    }

    final cleaned = status.trim().toLowerCase();

    switch (cleaned) {
      case 'pending':
        return OrderState.active;
      case 'accepted':
        return OrderState.delivered;
      case 'rejected':
        return OrderState.canceled;
      default:
        return OrderState.active;
    }
  }

  getOrderMeaning(String status) {
    switch (status) {
      case 'pending':
        return S.of(context).orderIsNowPending;
      case 'accepted':
        return S.of(context).orderIsNowConfirmed;
      case 'rejected':
        return S.of(context).orderRejected;
      default:
        return OrderState.active;
    }
  }
}
