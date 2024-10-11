import '../data/app_state_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

import '../data/blocs.dart';
import '../ui/screens/screens.dart';

class AppRouter {
  final AppStateManager appStateManager;
  final AppAuthBloc appAuthBloc;

  var logger = Logger(
    printer: PrettyPrinter(),
  );

  AppRouter({
    required this.appStateManager,
    required this.appAuthBloc,
  });

  late final router = GoRouter(
    debugLogDiagnostics: true,
    refreshListenable: appAuthBloc,
    initialLocation: '/${SKNEatsOrdersPortal.login}',
    routes: [
            GoRoute(
        name: SKNEatsOrdersPortal.login,
        path: '/${SKNEatsOrdersPortal.login}',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        name: 'home',
        path: '/:screen',
        builder: (context, state) {
          final screen = state.pathParameters['screen'] ?? 'orders';
          logger.d('Navigating to HomeScreen with screen: $screen');
          return Home(key: state.pageKey, currentScreen: screen);
        },
      ),
    ],
    redirect: (context, state) {
      final authState = appAuthBloc.state;
      final loggingIn =
          state.matchedLocation == '/${SKNEatsOrdersPortal.login}';

      if (authState is AppAuthenticating) {
        // Don't redirect while authenticating
        return null;
      }

      if (authState is AppUnauthenticated) {
        // If not logging in, redirect to login
        return loggingIn ? null : '/${SKNEatsOrdersPortal.login}';
      }

      if (authState is AppAuthenticated) {
        if (loggingIn) {
          return '/${SKNEatsOrdersPortal.orders}';
        }
      }
      // In all other cases, don't redirect
      return null;
    },
  );
}
