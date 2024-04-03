part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthError extends AuthState {
  const AuthError({required this.message});

  final String message;

  @override
  List<String> get props => [message];
}

class SignedIn extends AuthState {
  const SignedIn(this.user);

  final UserEntity user;

  @override
  List<Object> get props => [user];
}
