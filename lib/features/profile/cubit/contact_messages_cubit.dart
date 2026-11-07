import 'package:dio/dio.dart';
import 'package:elkawther/core/errors/errors.dart';
import 'package:elkawther/features/profile/models/contact_message.dart';
import 'package:elkawther/features/profile/services/profile_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactMessagesState {
  const ContactMessagesState({
    this.loading = false,
    this.sending = false,
    this.messages = const [],
    this.error,
    this.threadLoading = false,
    this.replying = false,
    this.thread,
    this.replies = const [],
    this.threadError,
  });

  final bool loading;
  final bool sending;
  final List<ContactMessage> messages;
  final String? error;
  final bool threadLoading;
  final bool replying;
  final ContactMessage? thread;
  final List<ContactReply> replies;
  final String? threadError;

  ContactMessagesState copyWith({
    bool? loading,
    bool? sending,
    List<ContactMessage>? messages,
    String? error,
    bool clearError = false,
    bool? threadLoading,
    bool? replying,
    ContactMessage? thread,
    List<ContactReply>? replies,
    String? threadError,
    bool clearThreadError = false,
  }) {
    return ContactMessagesState(
      loading: loading ?? this.loading,
      sending: sending ?? this.sending,
      messages: messages ?? this.messages,
      error: clearError ? null : error ?? this.error,
      threadLoading: threadLoading ?? this.threadLoading,
      replying: replying ?? this.replying,
      thread: thread ?? this.thread,
      replies: replies ?? this.replies,
      threadError: clearThreadError ? null : threadError ?? this.threadError,
    );
  }
}

class ContactMessagesCubit extends Cubit<ContactMessagesState> {
  ContactMessagesCubit(this._services) : super(const ContactMessagesState());

  final ProfileServices _services;

  Future<void> load() async {
    emit(state.copyWith(loading: true, clearError: true));
    try {
      final messages = await _services.getContactMessages();
      emit(state.copyWith(loading: false, messages: messages));
    } catch (error) {
      emit(state.copyWith(loading: false, error: _message(error)));
    }
  }

  Future<bool> send({
    required String name,
    required String email,
    required String message,
  }) async {
    emit(state.copyWith(sending: true, clearError: true));
    try {
      await _services.contactUs(name, email, message);
      final messages = await _services.getContactMessages();
      emit(state.copyWith(sending: false, messages: messages));
      return true;
    } catch (error) {
      emit(state.copyWith(sending: false, error: _message(error)));
      return false;
    }
  }

  Future<void> open(int id) async {
    emit(
      ContactMessagesState(
        loading: state.loading,
        sending: state.sending,
        messages: state.messages,
        error: state.error,
        threadLoading: true,
      ),
    );
    try {
      final detail = await _services.getContactMessage(id);
      emit(
        state.copyWith(
          threadLoading: false,
          thread: detail,
          replies: detail.replies,
        ),
      );
    } catch (error) {
      emit(state.copyWith(threadLoading: false, threadError: _message(error)));
    }
  }

  Future<bool> reply(String message) async {
    final id = state.thread?.id;
    if (id == null || id == 0) return false;
    emit(state.copyWith(replying: true, clearThreadError: true));
    try {
      final created = await _services.replyToContactMessage(id, message);
      final detail = await _services.getContactMessage(id);
      final replies =
          detail.replies.isNotEmpty
              ? detail.replies
              : [
                ...state.replies,
                created ??
                    ContactReply(
                      id: 0,
                      message: message,
                      isMine: true,
                    ),
              ];
      emit(
        state.copyWith(
          replying: false,
          thread: detail,
          replies: replies,
        ),
      );
      return true;
    } catch (error) {
      emit(state.copyWith(replying: false, threadError: _message(error)));
      return false;
    }
  }

  String _message(Object error) {
    if (error is DioException) return Errors.fromDioError(error).message;
    return error.toString();
  }
}
