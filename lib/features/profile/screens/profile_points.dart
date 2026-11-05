import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:elkawther/core/errors/errors.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/widgets/app_snack_bar.dart';
import 'package:elkawther/features/profile/cubit/points_cubit.dart';
import 'package:elkawther/features/profile/services/loyalty_service.dart';
import 'package:elkawther/features/profile/widgets/profile_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/features/profile/widgets/points_tile_widget.dart';
import 'package:elkawther/features/profile/models/points_response.dart';

class ProfilePoints extends StatefulWidget {
  const ProfilePoints({super.key});

  @override
  State<ProfilePoints> createState() => _ProfilePointsState();
}

class _ProfilePointsState extends State<ProfilePoints>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _loadedTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      if (_tabController.index == _loadedTab) return;
      _loadedTab = _tabController.index;
      final cubit = context.read<PointsCubit>();
      switch (_tabController.index) {
        case 1:
          cubit.getUserPointsNotValid();
        case 2:
          cubit.getUserPointsExpired();
        case 3:
          cubit.getUserPointsHistory();
        default:
          cubit.getUserPointsValid();
      }
    });
    context.read<PointsCubit>().loadOverview();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return BlocBuilder<PointsCubit, PointsState>(
      builder: (context, state) {
        final loaded = state is PointsStateLoaded ? state : null;
        final orders = loaded?.orders ?? const <OrderPoints>[];
        final balance = loaded?.loyaltyBalance ?? 0;
        final total = balance > 0 ? balance : (loaded?.total ?? 0);
        final hint = switch (_tabController.index) {
          1 => S.of(context).redeemedAt,
          2 => S.of(context).expired_at,
          3 => isAr ? 'التاريخ' : 'Date',
          _ => S.of(context).expiresIn,
        };
        return _pointsBody(context, isAr, state, orders, total, hint);
      },
    );
  }

  Widget _pointsBody(
    BuildContext context,
    bool isAr,
    PointsState state,
    List<OrderPoints> orders,
    int total,
    String hint,
  ) {
    final rewards = state is PointsStateLoaded
        ? state.rewards
        : const <LoyaltyReward>[];
    final rules = state is PointsStateLoaded ? state.loyaltyRules : '';
    final expiring = state is PointsStateLoaded
        ? state.expiring
        : const <OrderPoints>[];
    final redemptions = state is PointsStateLoaded
        ? state.redemptions
        : const <OrderPoints>[];
    return ProfileScaffold(
      title: S.of(context).myPoints,
      subtitle: isAr ? 'رصيد نقاطك وحركاتها' : 'Your points balance and history',
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: ProfileFormCard(
              child: Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.teal.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.stars_rounded,
                      color: AppColors.teal,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '$total ${S.of(context).point}',
                    style: AppTextStyles.noto16w400.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.darkColor,
                    ),
                  ),
                  if (rules.trim().isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      rules.trim(),
                      textAlign: TextAlign.center,
                      style: AppTextStyles.noto14w400.copyWith(
                        fontSize: 12,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                  if (orders.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      '${orders.first.pointsEarned} $hint ${DateFormat('dd/MM/yyyy').format(orders.first.expiresAt ?? orders.first.redeemedAt ?? orders.first.expiredAt ?? orders.first.createdAt)}',
                      style: AppTextStyles.noto14w400.copyWith(
                        fontSize: 12,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: AppColors.primaryColor,
              unselectedLabelColor: AppColors.grey,
              indicatorColor: AppColors.primaryColor,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: [
                Tab(text: S.of(context).valid),
                Tab(text: S.of(context).notValid),
                Tab(text: S.of(context).expired),
                Tab(text: isAr ? 'السجل' : 'History'),
              ],
            ),
          ),
          if (rewards.isNotEmpty)
            SizedBox(
              height: 92,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                scrollDirection: Axis.horizontal,
                itemCount: rewards.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final reward = rewards[index];
                  return ActionChip(
                    label: Text('${reward.name} · ${reward.points}'),
                    onPressed: () => _openReward(context, isAr, reward, total),
                  );
                },
              ),
            ),
          if (expiring.isNotEmpty) _pointStrip(
            isAr ? 'تنتهي خلال 7 أيام' : 'Expiring in 7 days',
            expiring,
          ),
          if (redemptions.isNotEmpty)
            _pointStrip(
              isAr ? 'طلبات الاستبدال' : 'Redemptions',
              redemptions,
              onTap: (item) => _openRedemption(context, item),
            ),
          const SizedBox(height: 8),
          if (state is PointsStateLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (state is PointsStateError)
            Expanded(
              child: Center(
                child: Text(
                  state.error.message,
                  style: AppTextStyles.noto14w400.copyWith(
                    color: AppColors.grey,
                  ),
                ),
              ),
            )
          else
            Expanded(
            child: orders.isEmpty
                ? Center(
                    child: Text(
                      S.of(context).noPointsEarned,
                      style: AppTextStyles.noto14w400.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      return PointTileWidget(point: orders[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _pointStrip(
    String title,
    List<OrderPoints> items, {
    void Function(OrderPoints item)? onTap,
  }) {
    return SizedBox(
      height: 72,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final item = items[index];
          return ActionChip(
            label: Text('$title · ${item.orderName} · ${item.pointsEarned}'),
            onPressed: onTap == null ? () {} : () => onTap(item),
          );
        },
      ),
    );
  }

  Future<void> _openReward(
    BuildContext context,
    bool isAr,
    LoyaltyReward reward,
    int total,
  ) async {
    if (total > 0 && reward.points > total) {
      AppSnackBar.error(
        isAr
            ? 'النقاط الصالحة غير كافية: المطلوب ${reward.points} والمتاح $total.'
            : 'Not enough points: ${reward.points} required, $total available.',
      );
      return;
    }
    var details = reward;
    try {
      details = await context.read<PointsCubit>().rewardDetails(reward.id);
    } catch (_) {}
    if (!context.mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(details.name),
        content: Text(
          '${details.points} ${S.of(context).point}'
          '${details.description.trim().isEmpty ? '' : '\n${details.description}'}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(isAr ? 'استبدال' : 'Redeem'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    try {
      final message = await context.read<PointsCubit>().redeem(reward.id);
      if (!context.mounted || message.isEmpty) return;
      AppSnackBar.success(message);
    } catch (error) {
      if (!context.mounted) return;
      final message = error is Errors
          ? error.localizedMessage(context)
          : error.toString();
      AppSnackBar.error(message);
    }
  }

  Future<void> _openRedemption(BuildContext context, OrderPoints item) async {
    if (item.id == 0) return;
    try {
      final details = await context.read<PointsCubit>().redemptionDetails(
        item.id,
      );
      if (!context.mounted) return;
      final source = details['data'] is Map
          ? Map<String, dynamic>.from(details['data'] as Map)
          : details;
      final text = (source['message'] ??
              source['status'] ??
              source['description'] ??
              item.orderName)
          .toString();
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(item.orderName),
          content: Text(text),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(S.of(context).cancel),
            ),
          ],
        ),
      );
    } catch (error) {
      if (!context.mounted) return;
      final message = error is DioException
          ? Errors.fromDioError(error).localizedMessage(context)
          : error.toString();
      AppSnackBar.error(message);
    }
  }
}
