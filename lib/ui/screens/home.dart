import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/responsive.dart';
import '../../data/app_state_manager.dart';
import '../../data/blocs.dart';
import '../../data/menu_app_controller.dart';
import '../../data/models.dart';
import '../components/components.dart';
import 'screens.dart';

class Home extends StatefulWidget {
  final String currentScreen;

  const Home({super.key, required this.currentScreen});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Map<String, Widget> screenMap;
  List<CustomerOrder>? currentOrders;

  @override
  void initState() {
    super.initState();
    screenMap = {
      'orders': const OrdersScreen(),
      'order-history': const OrderHistoryScreen(),
      'menu': const MenuScreen(),
      // 'settings': const SettingsScreen(),
    };
  }

  void _handleOrderUpdate(CustomerOrder order, OrderStatus status) {
    final appStateManager = context.read<AppStateManager>();
    context.read<CustomerOrderBloc>().add(
      CustomerOrderUpdated(
        customerOrder: order.copyWith(status: status),
        locationId: appStateManager.locationId!,
        restaurantId: appStateManager.restaurantId!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CustomerOrderBloc, CustomerOrderState>(
          listener: (context, state) {
            if (state is CustomerOrderLoaded) {
              final pendingOrders = state.orders
                  .where((order) => order.status == OrderStatus.pending)
                  .toList();

              // Only show dialog if we have new pending orders
              if (pendingOrders.isNotEmpty &&
                  (currentOrders == null || !_areOrderListsEqual(currentOrders!, pendingOrders))) {
                currentOrders = pendingOrders;
                showDialog<void>(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) => NewCustomerOrderDialog(
                    customerOrders: pendingOrders,
                    onAccept: (order) => _handleOrderUpdate(order, OrderStatus.preparing),
                    onCancel: (order) => _handleOrderUpdate(order, OrderStatus.cancel),
                    onClose: () {
                      currentOrders = null;
                      Navigator.of(context).pop();
                    },
                  ),
                );
              }
            }
          },
        ),
      ],
      child: Builder(
        builder: (context) {
          return Scaffold(
            key: context.read<MenuAppController>().scaffoldKey,
            appBar: const CustomAppBar(),
            drawer: const CustomDrawer(),
            body: SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (Responsive.isWideDesktop(context) ||
                      Responsive.isDesktop(context))
                    const Expanded(child: CustomDrawer()),
                  Expanded(flex: 5, child: _getScreenWidget(widget.currentScreen)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  bool _areOrderListsEqual(List<CustomerOrder> list1, List<CustomerOrder> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i].id != list2[i].id || list1[i].status != list2[i].status) {
        return false;
      }
    }
    return true;
  }

  Widget _getScreenWidget(String screen) {
    return screenMap[screen] ?? const OrdersScreen();
  }
}