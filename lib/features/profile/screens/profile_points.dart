import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:elkawther/core/errors/errors.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/widgets/app_snack_bar.dart';
import 'package:elkawther/features/profile/cubit/points_cubit.dart';
import 'package:elkawther/features/profile/data/app_settings.dart';
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
  int _selectedTab = 0;
  PointsStateLoaded? _snapshot;

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
    return BlocConsumer<PointsCubit, PointsState>(
      listener: (context, state) {
        if (state is PointsStateLoaded) _snapshot = state;
      },
      builder: (context, state) {
        final loaded = state is PointsStateLoaded ? state : _snapshot;
        final orders = loaded?.orders ?? const <OrderPoints>[];
        final balance = loaded?.loyaltyBalance ?? 0;
        final total = balance > 0 ? balance : (loaded?.total ?? 0);
        final loading =
            state is PointsStateInitial || state is PointsStateLoading;
        final hint = switch (_tabController.index) {
          1 => S.of(context).redeemedAt,
          2 => S.of(context).expired_at,
          3 => isAr ? 'التاريخ' : 'Date',
          _ => S.of(context).expiresIn,
        };
        return _pointsBody(
          context,
          isAr,
          state,
          orders,
          total,
          hint,
          loading: loading,
          hasData: loaded != null,
        );
      },
    );
  }

  Widget _pointsBody(
    BuildContext context,
    bool isAr,
    PointsState state,
    List<OrderPoints> orders,
    int total,
    String hint, {
    required bool loading,
    required bool hasData,
  }) {
    final source = state is PointsStateLoaded ? state : _snapshot;
    final rewards = source?.rewards ?? const <LoyaltyReward>[];
    final rules = source?.loyaltyRules ?? '';
    final settingsRules = context.watch<AppSettings>().loyaltySummary(isAr) ?? '';
    final shownRules = rules.trim().isNotEmpty ? rules.trim() : settingsRules;
    final expiring = source?.expiring ?? const <OrderPoints>[];
    final redemptions = source?.redemptions ?? const <OrderPoints>[];
    final tabs = [
      S.of(context).valid,
      S.of(context).notValid,
      S.of(context).expired,
      isAr ? 'السجل' : 'History',
    ];
    final nextDate = orders.isEmpty
        ? null
        : orders.first.expiresAt ??
              orders.first.redeemedAt ??
              orders.first.expiredAt ??
              orders.first.createdAt;

    return ProfileScaffold(
      title: S.of(context).myPoints,
      subtitle: isAr ? 'رصيد نقاطك وحركاتها' : 'Your points balance and history',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          _BalanceCard(
            total: total,
            unit: S.of(context).point,
            rules: shownRules,
            loading: loading && !hasData,
            note: nextDate == null
                ? null
                : '${orders.first.pointsEarned} $hint ${DateFormat('dd/MM/yyyy').format(nextDate)}',
          ),
          const SizedBox(height: 12),
          _PointsTabs(
            labels: tabs,
            selected: _selectedTab,
            onSelected: (index) {
              setState(() => _selectedTab = index);
              _tabController.animateTo(index);
            },
          ),
          if (rewards.isNotEmpty) ...[
            _SectionLabel(isAr ? 'المكافآت' : 'Rewards'),
            for (final reward in rewards) ...[
              _RewardCard(
                name: reward.name,
                points: '${reward.points} ${S.of(context).point}',
                enabled: total <= 0 || reward.points <= total,
                onTap: () => _openReward(context, isAr, reward, total),
              ),
              const SizedBox(height: 10),
            ],
          ],
          if (expiring.isNotEmpty) ...[
            _SectionLabel(isAr ? 'تنتهي خلال 7 أيام' : 'Expiring in 7 days'),
            for (final item in expiring) ...[
              _MiniPointCard(
                title: item.orderName,
                points: '${item.pointsEarned}',
              ),
              const SizedBox(height: 10),
            ],
          ],
          if (redemptions.isNotEmpty) ...[
            _SectionLabel(isAr ? 'طلبات الاستبدال' : 'Redemptions'),
            for (final item in redemptions) ...[
              _MiniPointCard(
                title: item.orderName,
                points: '${item.pointsEarned}',
                onTap: () => _openRedemption(context, item),
              ),
              const SizedBox(height: 10),
            ],
          ],
          const SizedBox(height: 4),
          if (loading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 48),
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              ),
            )
          else if (state is PointsStateError)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: _PointsMessage(message: state.error.message),
            )
          else if (orders.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: _PointsMessage(message: S.of(context).noPointsEarned),
            )
          else
            ...orders.map((order) => PointTileWidget(point: order)),
        ],
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

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({
    required this.total,
    required this.unit,
    required this.rules,
    required this.loading,
    required this.note,
  });

  final int total;
  final String unit;
  final String rules;
  final bool loading;
  final String? note;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF067A62), AppColors.teal, Color(0xFF14C4A0)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.teal.withOpacity(0.22),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.stars_rounded, color: Colors.white, size: 26),
          ),
          const SizedBox(height: 10),
          if (loading)
            const SizedBox(
              width: 26,
              height: 26,
              child: CircularProgressIndicator(
                strokeWidth: 2.4,
                color: Colors.white,
              ),
            )
          else
            Text(
              '$total',
              style: AppTextStyles.noto16w400.copyWith(
                fontSize: 34,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                height: 1,
              ),
            ),
          const SizedBox(height: 4),
          Text(
            unit,
            style: AppTextStyles.noto14w400.copyWith(
              color: Colors.white.withOpacity(0.86),
              fontWeight: FontWeight.w700,
            ),
          ),
          if (rules.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              rules,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.noto14w400.copyWith(
                fontSize: 12,
                color: Colors.white.withOpacity(0.82),
              ),
            ),
          ],
          if (note != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.16),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                note!,
                style: AppTextStyles.noto14w400.copyWith(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PointsTabs extends StatelessWidget {
  const _PointsTabs({
    required this.labels,
    required this.selected,
    required this.onSelected,
  });

  final List<String> labels;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6EEF5)),
      ),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++)
            Expanded(
              child: GestureDetector(
                onTap: () => onSelected(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: i == selected ? AppColors.primaryColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    labels[i],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.noto14w400.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: i == selected ? Colors.white : AppColors.grey,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
      child: Text(
        label,
        style: AppTextStyles.noto14w400.copyWith(
          fontWeight: FontWeight.w800,
          color: AppColors.grey,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _RewardCard extends StatelessWidget {
  const _RewardCard({
    required this.name,
    required this.points,
    required this.enabled,
    required this.onTap,
  });

  final String name;
  final String points;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
          child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE6EEF5)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.card_giftcard_rounded,
                size: 20,
                color: enabled ? AppColors.teal : AppColors.grey,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.noto14w400.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                points,
                style: AppTextStyles.noto14w400.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: enabled ? AppColors.teal : AppColors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniPointCard extends StatelessWidget {
  const _MiniPointCard({
    required this.title,
    required this.points,
    this.onTap,
  });

  final String title;
  final String points;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE6EEF5)),
          ),
          child: Row(
            children: [
              const Icon(Icons.schedule_rounded, size: 16, color: AppColors.primaryColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.noto14w400.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: AppColors.darkColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                points,
                style: AppTextStyles.noto14w400.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.teal,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PointsMessage extends StatelessWidget {
  const _PointsMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: AppTextStyles.noto14w400.copyWith(color: AppColors.grey),
        ),
      ),
    );
  }
}
