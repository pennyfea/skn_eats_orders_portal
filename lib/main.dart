import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'data/app_state_manager.dart';
import 'data/menu_app_controller.dart';
import 'data/repository.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;

import 'navigation/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Configure Firebase UI Auth providers
  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
    // ... other providers
  ]);

  final appStateManager = AppStateManager();
  final customerOrderRepository = CustomerOrderRepository();
  final restaurantRepository = RestaurantRepository();

  try {
    runApp(SknEatsOrderPortal(
      appStateManager: appStateManager,
      restaurantRepository: restaurantRepository,
      customerOrderRepository: customerOrderRepository,
    ));
  } catch (e, stackTrace) {
    print('Error in main: $e');
    print('Stack trace: $stackTrace');
  }
}

class SknEatsOrderPortal extends StatelessWidget {
  final AppStateManager appStateManager;
  final CustomerOrderRepository customerOrderRepository;
  final RestaurantRepository restaurantRepository;

  SknEatsOrderPortal({
    super.key,
    required this.restaurantRepository,
    required this.customerOrderRepository,
    required this.appStateManager,
  });

  late final appRouter = AppRouter(
    appStateManager: appStateManager,
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => appStateManager),
        ChangeNotifierProvider(create: (context) => MenuAppController()),
        Provider<CustomerOrderRepository>(create: (_) => customerOrderRepository),
        Provider<RestaurantRepository>(create: (_) => restaurantRepository),
        // BlocProvider(create: (context) => RestaurantBloc(restaurantRepository: context.read<RestaurantRepository>())..add(const SettingsSubscriptionRequested())),


      ],
      child: MaterialApp.router(
        title: 'SKN Eats Orders',
        debugShowCheckedModeBanner: false,
        routerDelegate: appRouter.router.routerDelegate,
        routeInformationParser: appRouter.router.routeInformationParser,
        routeInformationProvider
        : appRouter.router.routeInformationProvider,
      ),
    );
  }
}
