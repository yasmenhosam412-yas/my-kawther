import 'package:elkawther/features/notifications/widgets/no_notifications.dart';
import 'package:elkawther/features/notifications/widgets/notification_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:elkawther/features/notifications/cubit/notification_cubit.dart';
import 'package:elkawther/features/notifications/cubit/notification_state.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/core/theme/app_padding.dart';
import 'package:elkawther/features/notifications/models/notification_model.dart';

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

  Map<String, List<NotificationModel>> groupByDate(
    List<NotificationModel> items,
  ) {
    final Map<String, List<NotificationModel>> grouped = {};
    DateTime now = DateTime.now();

    for (var item in items) {
      DateTime date = DateTime.parse(item.createdAt);
      String key;

      if (date.year == now.year &&
          date.month == now.month &&
          date.day == now.day) {
        key = S.of(context).today;
      } else if (date.year == now.year &&
          date.month == now.month &&
          date.day == now.day - 1) {
        key = S.of(context).yesterday;
      } else {
        key = "${date.year}-${date.month}-${date.day}";
      }

      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(item);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<NotificationCubit>().getNotifications();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            S.of(context).notifications,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () {
                context.read<NotificationCubit>().markAllAsRead();
              },
              child: Text(S.of(context).readAll),
            ),
          ],
        ),

        body: BlocBuilder<NotificationCubit, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is NotificationError) {
              return Center(
                child: Text(state.message.localizedMessage(context)),
              );
            }

            if (state is NotificationLoaded) {
              if (state.notifications.isEmpty) {
                return const NoNotifications();
              }

              final grouped = groupByDate(state.notifications);

              final keys = grouped.keys.toList();

              return ListView.builder(
                padding: const EdgeInsets.all(AppPadding.medium),
                itemCount: keys.length,
                itemBuilder: (context, sectionIndex) {
                  final sectionTitle = keys[sectionIndex];
                  final sectionItems = grouped[sectionTitle]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          sectionTitle,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),

                      ...sectionItems.map((item) {
                        return NotificationItem(
                          id: item.id,
                          isRead: item.isRead == 1,
                          description: item.body,
                          createdAt: item.createdAt,
                        );
                      }),

                      const SizedBox(height: 10),
                    ],
                  );
                },
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
