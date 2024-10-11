part of 'app_auth_bloc.dart';

enum AuthenticatingType { signIn, signOut, passwordReset }

abstract class AppAuthState extends Equatable {
  const AppAuthState();

  @override
  List<Object?> get props => [];
}

class AppAuthenticating extends AppAuthState {
  final AuthenticatingType type;

  const AppAuthenticating(this.type);

  @override
  List<Object?> get props => [type];
}

class AppAuthenticated extends AppAuthState {
  final User? user;
  final RestaurantLocation? restaurantLocation;

  const AppAuthenticated({ this.user, this.restaurantLocation});

  @override
  List<Object?> get props => [user, restaurantLocation];
}

class AppUnauthenticated extends AppAuthState {}

class AppPasswordResetSent extends AppAuthState {
  final String email;

  const AppPasswordResetSent(this.email);

  @override
  List<Object?> get props => [email];
}

class AppError extends AppAuthState {
  final String message;

  const AppError(this.message);

  @override
  List<Object?> get props => [message];
}
