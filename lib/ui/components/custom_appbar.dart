import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/responsive.dart';
import '../../data/menu_app_controller.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      title: Text(' Eats', style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.white)),
      titleSpacing: (Responsive.isMobile(context) || Responsive.isTablet(context)) ? 0 : -30,
      centerTitle: false,
      leading: Builder(
        builder: (BuildContext context) {
          if (Responsive.isMobile(context) || Responsive.isTablet(context)) {
            return IconButton(
              icon: const Icon(Icons.menu),
              color: Colors.white,
              onPressed: () => context.read<MenuAppController>().controlMenu(),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}
