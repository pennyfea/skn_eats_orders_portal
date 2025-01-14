import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import '../../models.dart';
import '../../repository.dart';

part 'app_auth_event.dart';
part 'app_auth_state.dart';

class AppAuthBloc extends Bloc<AppAuthEvent, AppAuthState>
    implements Listenable {
  final AuthRepository authRepository;
  final UserRepository userRepository;
  final RestaurantRepository restaurantRepository;

  var logger = Logger(printer: PrettyPrinter());

  // Error messages
  static const String _signInError = 'Sign In Error';
  static const String _logoutError = 'Logout Error';
  static const String _passwordResetError = 'Password Reset Error';

  AppAuthBloc(
      {required this.authRepository,
      required this.userRepository,
      required this.restaurantRepository})
      : super(authRepository.currentUser != null
            ? const AppAuthenticated(user: null, restaurantLocation: null)
            : AppUnauthenticated()) {
    on<AppSignInRequested>(_onSignInRequested);
    on<AppLogoutRequested>(_onLogoutRequested);
    on<AppPasswordResetRequested>(_onPasswordResetRequested);
    on<AppAuthenticationFailed>(_onAuthenticationFailed);
  }

  Future<void> _onSignInRequested(
      AppSignInRequested event, Emitter<AppAuthState> emit) async {
    emit(const AppAuthenticating(AuthenticatingType.signIn));
    try {
      final currentUser = authRepository.currentUser;
      if (currentUser != null) {
        final appUser = await userRepository.getUserByUid(currentUser.uid);
        final restaurantLocation = appUser != null
            ? await restaurantRepository
                .getRestaurantLocationById(appUser.restaurantId!, appUser.restaurantLocationIds!.first)
            : null;
        emit(AppAuthenticated(user: appUser, restaurantLocation: restaurantLocation));
      } else {
        throw Exception(_signInError);
      }
    } catch (e) {
      logger.e("Sign In Error: $e");
      emit(AppError(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
      AppLogoutRequested event, Emitter<AppAuthState> emit) async {
    emit(const AppAuthenticating(AuthenticatingType.signOut));
    try {
      await authRepository.signOut();
      emit(AppUnauthenticated());
    } catch (e) {
      logger.e("$_logoutError: $e");
      emit(AppError(e.toString()));
    }
  }

  Future<void> _onPasswordResetRequested(
      AppPasswordResetRequested event, Emitter<AppAuthState> emit) async {
    emit(const AppAuthenticating(AuthenticatingType.passwordReset));
    try {
      await authRepository.sendPasswordResetEmail(event.email);
      emit(AppPasswordResetSent(event.email));
    } catch (e) {
      logger.e("$_passwordResetError: $e");
      emit(AppError(e.toString()));
    }
  }

  void _onAuthenticationFailed(
      AppAuthenticationFailed event, Emitter<AppAuthState> emit) {
    logger.e("Authentication Error: ${event.error}");
    emit(AppError(event.error));
  }

  final ObserverList<VoidCallback> _listeners = ObserverList<VoidCallback>();

  @override
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  @override
  void onChange(Change<AppAuthState> change) {
    super.onChange(change);
    for (final listener in _listeners) {
      listener();
    }
    logger.d(change);
  }
}
