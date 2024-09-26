import '../data/app_state_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

import '../ui/screens/screens.dart';

class AppRouter {
  final AppStateManager appStateManager;

  var logger = Logger(
    printer: PrettyPrinter(),
  );

    AppRouter({required this.appStateManager});

  late final router = GoRouter(
    debugLogDiagnostics: true,
    refreshListenable: appStateManager,
    initialLocation: '/:orders',
    routes: [
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
    redirect: (context, state) {},
  );
}
