part of 'account_delete_cubit.dart';

@immutable
sealed class AccountDeleteState {}

final class AccountDeleteInitial extends AccountDeleteState {}

final class AccountDeleteLoading extends AccountDeleteState {}

final class AccountDeleteLoaded extends AccountDeleteState {}

final class AccountDeleteError extends AccountDeleteState {
  final Errors error;

  AccountDeleteError({required this.error});
}
