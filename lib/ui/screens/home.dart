import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/responsive.dart';
import '../../data/menu_app_controller.dart';
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

  @override
  void initState() {
    super.initState();
    screenMap = {
      'orders': const OrdersScreen(),
      'order-history': const OrderHistoryScreen(),
      'menu': const MenuScreen(),
      'settings': const SettingsScreen(),
    };
  }

  // @override
  // Widget build(BuildContext context) {
  //   return MultiBlocListener(
  //       listeners: [],
  //       child: Scaffold(
  //         key: context.read<MenuAppController>().scaffoldKey,
//           appBar: const CustomAppBar(),
  //         drawer: const CustomDrawer(),
  //         body: SafeArea(
  //             child: Row(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             if (Responsive.isWideDesktop(context) ||
  //                 Responsive.isDesktop(context))
  //               const Expanded(
  //                 child: CustomDrawer(),
  //               ),
  //             Expanded(flex: 5, child: _getScreenWidget(widget.currentScreen)),
  //           ],
  //         )),
  //       ));
  // }

  @override
  Widget build(BuildContext context) {
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
              const Expanded(
                child: CustomDrawer(),
              ),
            Expanded(flex: 5, child: _getScreenWidget(widget.currentScreen)),
          ],
        ),
      ),
    );
  }

  Widget _getScreenWidget(String screen) {
    return screenMap[screen] ?? const OrdersScreen();
  }
}
