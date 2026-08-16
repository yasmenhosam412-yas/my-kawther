import 'package:easy_localization/easy_localization.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/features/profile/data/profile_local_store.dart';
import 'package:elkawther/features/profile/widgets/profile_scaffold.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = ProfileLocalStore.instance;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    late final int total;
    late final List<OrderPoints> orders;
    late final String hint;

    switch (_tabController.index) {
      case 1:
        total = store.redeemedTotal;
        orders = store.redeemedPoints;
        hint = S.of(context).redeemedAt;
      case 2:
        total = store.expiredTotal;
        orders = store.expiredPoints;
        hint = S.of(context).expired_at;
      default:
        total = store.validTotal;
        orders = store.validPoints;
        hint = S.of(context).expiresIn;
    }

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
              labelColor: AppColors.primaryColor,
              unselectedLabelColor: AppColors.grey,
              indicatorColor: AppColors.primaryColor,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: [
                Tab(text: S.of(context).valid),
                Tab(text: S.of(context).notValid),
                Tab(text: S.of(context).expired),
              ],
            ),
          ),
          const SizedBox(height: 8),
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
}
