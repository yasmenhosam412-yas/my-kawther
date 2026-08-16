import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:elkawther/core/errors/errors.dart';
import 'package:elkawther/features/notifications/services/main_notification_service.dart';
import 'package:elkawther/features/notifications/cubit/notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final MainNotiService service;

  NotificationCubit(this.service) : super(NotificationInitial());

  Future<void> getNotifications() async {
    emit(NotificationLoading());
    try {
      final data = await service.getUserNotification();
      emit(NotificationLoaded(data));
    } on DioException catch (e) {
      emit(NotificationError(Errors.fromDioError(e)));
    } catch (e) {
      emit(NotificationError(Errors(message: e.toString())));
    }
  }

  Future<void> markAsRead(int id) async {
    try {
      await service.markAsRead(id);

      if (state is NotificationLoaded) {
        final current = (state as NotificationLoaded).notifications;

        final updated =
            current.map((n) {
              if (n.id == id) {
                return n.copyWith(isRead: 1);
              }
              return n;
            }).toList();

        emit(NotificationLoaded(updated));
      }
    } on DioException catch (e) {
      emit(NotificationError(Errors.fromDioError(e)));
    } catch (e) {
      emit(NotificationError(Errors(message: e.toString())));
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await service.readAll();

      if (state is NotificationLoaded) {
        final current = (state as NotificationLoaded).notifications;

        final updated = current.map((n) => n.copyWith(isRead: 1)).toList();

        emit(NotificationLoaded(updated));
      }
    } on DioException catch (e) {
      emit(NotificationError(Errors.fromDioError(e)));
    } catch (e) {
      emit(NotificationError(Errors(message: e.toString())));
    }
  }
}
