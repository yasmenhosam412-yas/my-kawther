import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/features/orders/cubit/orders_cubit.dart';
import 'package:elkawther/features/profile/widgets/profile_scaffold.dart';
import 'package:elkawther/features/returns/widgets/returns_card.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return ProfileScaffold(
      title: S.of(context).returns,
      subtitle: isAr ? 'طلبات الاسترجاع واسترداد المبلغ' : 'Return requests and refunds',
      body: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) {
          if (state is OrdersLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          }
          if (state is OrdersError) {
            return _ReturnsNotice(
              message: state.error.localizedMessage(context),
              action: S.of(context).retry,
              onTap: () => context.read<OrdersCubit>().getAllReturns(),
            );
          }
          if (state is! OrderReturnsLoaded) return const SizedBox();
          if (state.allReturns.isEmpty) {
            return _ReturnsNotice(message: S.of(context).noReturns);
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            itemCount: state.allReturns.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return ReturnCard(item: state.allReturns[index]);
            },
          );
        },
      ),
    );
  }
}

class _ReturnsNotice extends StatelessWidget {
  const _ReturnsNotice({required this.message, this.action, this.onTap});

  final String message;
  final String? action;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.noto14w400.copyWith(color: AppColors.grey),
            ),
            if (action != null) ...[
              const SizedBox(height: 12),
              ElevatedButton(onPressed: onTap, child: Text(action!)),
            ],
          ],
        ),
      ),
    );
  }
}
