import 'dart:typed_data';

import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/widgets/app_snack_bar.dart';
import 'package:elkawther/features/orders/cubit/orders_cubit.dart';
import 'package:elkawther/features/orders/models/all_returns.dart';
import 'package:elkawther/features/profile/widgets/profile_scaffold.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RefundProductDetailsView extends StatefulWidget {
  const RefundProductDetailsView({super.key});

  @override
  State<RefundProductDetailsView> createState() =>
      _RefundProductDetailsViewState();
}

class _RefundProductDetailsViewState extends State<RefundProductDetailsView> {
  late final int returnId;
  var _ready = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_ready) return;
    returnId = ModalRoute.of(context)!.settings.arguments as int;
    context.read<OrdersCubit>().getOrderDetailsRefunded(returnId);
    _ready = true;
  }

  Future<void> _cancel(RefundedItem item) async {
    try {
      final message = await context.read<OrdersCubit>().cancelReturn(
        item.id,
        refreshList: false,
      );
      if (!mounted) return;
      if (message.isNotEmpty) AppSnackBar.success(message);
      await context.read<OrdersCubit>().getOrderDetailsRefunded(item.id);
    } catch (error) {
      if (mounted) AppSnackBar.error(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        final item = state is OrderDetailsRefnudedLoaded ? state.refundedItem : null;
        return ProfileScaffold(
          title: S.of(context).returns,
          subtitle: item == null ? null : '#${item.orderId}',
          bottom: item != null && (item.status ?? '').toLowerCase() == 'pending'
              ? ProfilePrimaryButton(
                  title: S.of(context).cancel,
                  color: const Color(0xFFDC2626),
                  onPressed: () => _cancel(item),
                )
              : null,
          body: switch (state) {
            OrdersLoading() => const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            ),
            OrdersError(:final error) => Center(
              child: Text(error.localizedMessage(context)),
            ),
            OrderDetailsRefnudedLoaded(:final refundedItem) =>
              _details(context, refundedItem, isAr),
            _ => const SizedBox(),
          },
        );
      },
    );
  }

  Widget _details(BuildContext context, RefundedItem item, bool isAr) {
    final rows = [
      _Row(S.of(context).return_reason, item.reason),
      if ((item.note ?? '').isNotEmpty) _Row(S.of(context).note, item.note!),
      _Row(S.of(context).refund_amount, item.refundAmount ?? ''),
      _Row(
        isAr ? 'طريقة الاسترداد' : 'Refund method',
        item.refundMethod ?? '',
      ),
      _Row(S.of(context).address, item.address ?? ''),
      _Row(isAr ? 'الحالة' : 'Status', item.status ?? ''),
    ];
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            children: [
              for (final row in rows) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        row.label,
                        style: AppTextStyles.noto14w400.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        row.value,
                        textAlign: TextAlign.end,
                        style: AppTextStyles.noto14w400.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkColor,
                        ),
                      ),
                    ),
                  ],
                ),
                if (row != rows.last) const Divider(height: 22),
              ],
            ],
          ),
        ),
        if (item.images.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            isAr ? 'صور المرتجع' : 'Return images',
            style: AppTextStyles.noto16w400.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.darkColor,
            ),
          ),
          const SizedBox(height: 10),
          ...item.images.map(
            (image) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _ReturnImage(image: image),
            ),
          ),
        ],
      ],
    );
  }
}

class _Row {
  const _Row(this.label, this.value);

  final String label;
  final String value;
}

class _ReturnImage extends StatefulWidget {
  const _ReturnImage({required this.image});

  final String image;

  @override
  State<_ReturnImage> createState() => _ReturnImageState();
}

class _ReturnImageState extends State<_ReturnImage> {
  late final Future<List<int>?> _bytes;

  @override
  void initState() {
    super.initState();
    _bytes = context.read<OrdersCubit>().ordersServices.fetchReturnImage(
      widget.image,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: FutureBuilder<List<int>?>(
        future: _bytes,
        builder: (context, snapshot) {
          final data = snapshot.data;
          if (data == null || data.isEmpty) {
            return Container(
              height: 160,
              color: AppColors.light,
              alignment: Alignment.center,
              child: snapshot.connectionState == ConnectionState.done
                  ? const Icon(Icons.image_not_supported_outlined)
                  : const CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
            );
          }
          return Image.memory(
            Uint8List.fromList(data),
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}
