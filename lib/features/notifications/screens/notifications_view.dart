import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/features/notifications/cubit/notification_cubit.dart';
import 'package:elkawther/features/notifications/cubit/notification_state.dart';
import 'package:elkawther/features/notifications/models/notification_model.dart';
import 'package:elkawther/features/notifications/widgets/no_notifications.dart';
import 'package:elkawther/features/notifications/widgets/notification_item.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationCubit>().getNotifications();
  }

  List<_NotificationSection> _sections(List<NotificationModel> items) {
    final l10n = S.of(context);
    final locale = Localizations.localeOf(context).toString();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final format = DateFormat.yMMMd(locale);
    final grouped = <String, _NotificationSection>{};

    for (final item in items) {
      final parsed = DateTime.tryParse(item.createdAt)?.toLocal();
      final day = parsed == null
          ? null
          : DateTime(parsed.year, parsed.month, parsed.day);

      late final String title;
      late final DateTime sort;
      if (day == null) {
        title = item.createdAt;
        sort = DateTime.fromMillisecondsSinceEpoch(0);
      } else if (day == today) {
        title = l10n.today;
        sort = today;
      } else if (day == yesterday) {
        title = l10n.yesterday;
        sort = yesterday;
      } else {
        title = format.format(day);
        sort = day;
      }

      grouped.putIfAbsent(
        title,
        () => _NotificationSection(title: title, sort: sort),
      );
      grouped[title]!.items.add(item);
    }

    final sections = grouped.values.toList()
      ..sort((a, b) => b.sort.compareTo(a.sort));
    return sections;
  }

  Future<void> _reload() {
    return context.read<NotificationCubit>().getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5FAFD),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 12, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.maybePop(context),
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 22,
                      color: AppColors.darkColor,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      l10n.notifications,
                      style: AppTextStyles.noto24w500.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.darkColor,
                      ),
                    ),
                  ),
                  BlocBuilder<NotificationCubit, NotificationState>(
                    builder: (context, state) {
                      final unread = state is NotificationLoaded
                          ? state.notifications
                                .where((item) => item.isRead != 1)
                                .length
                          : 0;
                      if (unread == 0) return const SizedBox.shrink();
                      return Flexible(
                        child: TextButton(
                          onPressed: () =>
                              context.read<NotificationCubit>().markAllAsRead(),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primaryColor,
                            backgroundColor: AppColors.light,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            minimumSize: const Size(0, 36),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            l10n.readAll,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.noto14w400.copyWith(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primaryColor,
                onRefresh: _reload,
                child: BlocBuilder<NotificationCubit, NotificationState>(
                  builder: (context, state) {
                    if (state is NotificationLoading ||
                        state is NotificationInitial) {
                      return const _NotificationsLoading();
                    }

                    if (state is NotificationError) {
                      return _StatusScroll(
                        child: _ErrorState(
                          message: state.message.localizedMessage(context),
                          onRetry: _reload,
                        ),
                      );
                    }

                    if (state is NotificationLoaded) {
                      if (state.notifications.isEmpty) {
                        return const _StatusScroll(child: NoNotifications());
                      }

                      final sections = _sections(state.notifications);
                      final unread = state.notifications
                          .where((item) => item.isRead != 1)
                          .length;

                      return ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
                        itemCount: sections.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return _UnreadSummary(count: unread);
                          }
                          final section = sections[index - 1];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _SectionLabel(
                                  title: section.title,
                                  count: section.items.length,
                                ),
                                const SizedBox(height: 10),
                                ...section.items.map(
                                  (item) => NotificationItem(
                                    id: item.id,
                                    isRead: item.isRead == 1,
                                    description: item.body,
                                    createdAt: item.createdAt,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }

                    return const _StatusScroll(child: SizedBox.shrink());
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationSection {
  _NotificationSection({required this.title, required this.sort});

  final String title;
  final DateTime sort;
  final List<NotificationModel> items = [];
}

class _UnreadSummary extends StatelessWidget {
  const _UnreadSummary({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final label = count == 0
        ? (isAr ? 'كل الإشعارات مقروءة' : 'You are all caught up')
        : (isAr ? '$count غير مقروء' : '$count unread');

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryColor.withOpacity(0.14),
              AppColors.light,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(
              count == 0
                  ? Icons.mark_email_read_outlined
                  : Icons.notifications_active_outlined,
              color: AppColors.primaryColor,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.noto14w400.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.title, required this.count});

  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: AppTextStyles.noto16w400.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: AppColors.darkColor,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(99),
            border: Border.all(color: const Color(0xFFE6EEF5)),
          ),
          child: Text(
            '$count',
            style: AppTextStyles.noto14w400.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.grey,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusScroll extends StatelessWidget {
  const _StatusScroll({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: constraints.maxHeight,
              child: child,
            ),
          ],
        );
      },
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.light,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.wifi_off_rounded,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.noto14w400.copyWith(
                color: AppColors.darkColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 14),
            FilledButton(
              onPressed: onRetry,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(isAr ? 'إعادة المحاولة' : 'Try again'),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationsLoading extends StatelessWidget {
  const _NotificationsLoading();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, __) => Container(
        height: 84,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE6EEF5)),
        ),
      ),
    );
  }
}
