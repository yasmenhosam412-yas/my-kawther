part of 'auth_cubit.dart';

enum AuthStatus { authenticated, visitor }

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoadedLogin extends AuthState {}

class AuthLoadedRegister extends AuthState {}

class AuthErrorRegister extends AuthState {
  final Errors error;
  const AuthErrorRegister({required this.error});

  @override
  List<Object> get props => [error];
}

class AuthErrorLogin extends AuthState {
  final Errors error;
  const AuthErrorLogin({required this.error});

  @override
  List<Object> get props => [error];
}

class AuthVisitor extends AuthState {
  const AuthVisitor();
}
