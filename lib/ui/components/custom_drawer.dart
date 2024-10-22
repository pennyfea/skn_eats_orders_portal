import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> screens = {
      'Orders': {
        'icon': const Icon(Icons.shopping_bag, size: 25),
        'routeName': 'orders',
      },
      'Order History': {
        'icon': const Icon(Icons.store, size: 25),
        'routeName': 'order-history',
      },
      'Menu': {
        'icon': const Icon(Icons.restaurant, size: 25),
        'routeName': 'menu',
      },
      // 'Settings': {
      //   'icon': const Icon(Icons.settings, size: 25),
      //   'routeName': 'settings',
      // },
    };

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: screens.entries.map((entry) {
                return ListTile(
                  leading: entry.value['icon'],
                  title: Text(entry.key),
                  onTap: () {
                    context.goNamed(
                      'home',
                      pathParameters: {'screen': entry.value['routeName']},
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}