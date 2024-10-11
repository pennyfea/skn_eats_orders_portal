part of 'app_auth_bloc.dart';

abstract class AppAuthEvent extends Equatable {
  const AppAuthEvent();

  @override
  List<Object> get props => [];
}

class AppSignInRequested extends AppAuthEvent {}

class AppSignUpRequested extends AppAuthEvent {}

class AppLogoutRequested extends AppAuthEvent {}

class AppPasswordResetRequested extends AppAuthEvent {
  final String email;

  const AppPasswordResetRequested({required this.email});

  @override
  List<Object> get props => [email];
}

class AppAuthenticationFailed extends AppAuthEvent {
  final String error;

  const AppAuthenticationFailed(this.error);

  @override
  List<Object> get props => [error];
}
