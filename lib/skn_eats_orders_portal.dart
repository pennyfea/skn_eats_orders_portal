import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'data/app_state_manager.dart';
import 'data/blocs.dart';
import 'data/menu_app_controller.dart';
import 'data/repository.dart';
import 'navigation/app_router.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

class SknEatsOrdersPanel extends StatefulWidget {
  const SknEatsOrdersPanel({super.key});

  @override
  State<SknEatsOrdersPanel> createState() => _SknEatsOrdersPanelState();
}

class _SknEatsOrdersPanelState extends State<SknEatsOrdersPanel> {
  late final RestaurantRepository _restaurantRepository;
  late final CustomerOrderRepository _customerOrderRepository;
  late final MenuItemRepository _menuItemRepository;
  late final MenuCategoryRepository _menuCategoryRepository;
  late final UserRepository _userRepository;
  late final AuthRepository _authRepository;
  late final AppStateManager _appStateManager;
  late final AppAuthBloc _appAuthBloc;
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _restaurantRepository = RestaurantRepository();
    _customerOrderRepository = CustomerOrderRepository();
    _menuItemRepository = MenuItemRepository();
    _menuCategoryRepository = MenuCategoryRepository();
    _userRepository = UserRepository();
    _authRepository = AuthRepository();
    _appStateManager = AppStateManager();

    _appAuthBloc = AppAuthBloc(
        authRepository: _authRepository,
        userRepository: _userRepository,
        restaurantRepository: _restaurantRepository);

    _appRouter = AppRouter(
      appStateManager: _appStateManager,
      appAuthBloc: _appAuthBloc,
    );

    _initializeAppStateManager();
  }

  Future<void> _initializeAppStateManager() async {
    await _appStateManager.initialize();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Repository Providers
        RepositoryProvider<RestaurantRepository>.value(
            value: _restaurantRepository),
        RepositoryProvider<CustomerOrderRepository>.value(
            value: _customerOrderRepository),
        RepositoryProvider<AuthRepository>.value(value: _authRepository),
        RepositoryProvider<MenuItemRepository>.value(
            value: _menuItemRepository),
        RepositoryProvider<MenuCategoryRepository>.value(
            value: _menuCategoryRepository),
        RepositoryProvider<UserRepository>.value(value: _userRepository),
        // Change Notifiers
        ChangeNotifierProvider<AppStateManager>.value(value: _appStateManager),
        ChangeNotifierProvider<MenuAppController>(
            create: (_) => MenuAppController()),
        // Bloc Providers
        BlocProvider<AppAuthBloc>.value(value: _appAuthBloc),
        BlocProvider<MenuCategoryBloc>(
            create: (context) => MenuCategoryBloc(
                menuCategoryRepository: _menuCategoryRepository)),
        BlocProvider<MenuItemBloc>(
            create: (context) =>
                MenuItemBloc(menuItemRepository: _menuItemRepository)),
        BlocProvider<CustomerOrderBloc>(
            create: (context) => CustomerOrderBloc(
                customerOrderRepository: _customerOrderRepository)),
      ],
      child: Builder(
        builder: (context) {
          return MultiBlocListener(
            listeners: [
              BlocListener<AppAuthBloc, AppAuthState>(
                listener: (context, state) {
                  _appRouter.router.refresh();
                  if (state is AppAuthenticated) {
                    _appStateManager.setRestaurantId(state.user!.restaurantId!);
                    _appStateManager.setLocationId(
                        state.user!.restaurantLocationIds!.first);
                    _appStateManager.initializeSubscriptions(context);
                  }
                },
              ),
            ],
            child: MaterialApp.router(
              theme: FlexThemeData.light(
                  scheme: FlexScheme.blackWhite,
                  subThemesData: const FlexSubThemesData(
                      appBarBackgroundSchemeColor: SchemeColor.tertiary),
                  useMaterial3: true),
              title: 'SKN Eats Orders',
              debugShowCheckedModeBanner: false,
              routerDelegate: _appRouter.router.routerDelegate,
              routeInformationParser: _appRouter.router.routeInformationParser,
              routeInformationProvider:
                  _appRouter.router.routeInformationProvider,
              builder: (context, child) {
                _appStateManager.initializeSubscriptions(context);
                return child ?? const SizedBox.shrink();
              },
            ),
          );
        },
      ),
    );
  }
}
