import 'package:easy_localization/easy_localization.dart';
import 'package:elkawther/features/orders/cubit/orders_cubit.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/core/theme/app_padding.dart';
import 'package:elkawther/features/returns/widgets/returns_card.dart';

class ReturnsView extends StatefulWidget {
  const ReturnsView({super.key});

  @override
  State<ReturnsView> createState() => _ReturnsViewState();
}

class _ReturnsViewState extends State<ReturnsView> {
  @override
  void initState() {
    super.initState();
    context.read<OrdersCubit>().getAllReturns();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).returns,
          style: AppTextStyles.ibmPlexSans16w500.copyWith(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ),
      body: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) {
          if (state is OrdersLoading) {
            return const Center(child: ShimmerLoadingVertical());
          } else if (state is OrderReturnsLoaded) {
            final returns = state.allReturns;

            if (returns.isEmpty) {
              return Center(child: Text(S.of(context).noReturns));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(AppPadding.medium),
              itemCount: returns.length,
              separatorBuilder:
                  (context, index) => const SizedBox(height: AppPadding.medium),
              itemBuilder: (context, index) {
                final returnItem = returns[index];

                return ReturnCard(
                  orderNumber: returnItem.id,
                  orderId: returnItem.orderId,
                  totalPrice:
                      "${double.parse(returnItem.order.totalPrice).toStringAsFixed(0)} ${S.of(context).currency}",
                  date: DateFormat(
                    'd MMMM yyyy',
                    'ar',
                  ).format(returnItem.order.createdAt),

                  status: _mapStatus(returnItem.status),
                  returnItem: returnItem,
                );
              },
            );
          } else if (state is OrdersError) {
            return Center(child: Text(state.error.localizedMessage(context)));
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  ReturnStatus _mapStatus(String status) {
    switch (status.toLowerCase()) {
      case "accepted":
        return ReturnStatus.accepted;
      case "canceled":
        return ReturnStatus.canceled;
      case "rejected":
        return ReturnStatus.rejected;
      case "pending":
        return ReturnStatus.pending;
      default:
        return ReturnStatus.pending;
    }
  }
}

class ShimmerLoadingVertical extends StatelessWidget {
  const ShimmerLoadingVertical({super.key});

  @override
  Widget build(BuildContext context) {
    const itemCount = 6;

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: itemCount,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
    );
  }
}
