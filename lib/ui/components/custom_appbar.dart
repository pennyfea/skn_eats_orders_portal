import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../config/responsive.dart';
import '../../data/app_state_manager.dart';
import '../../data/blocs.dart';
import '../../data/menu_app_controller.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      title: Text('SKN Eats',
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(color: Colors.white)),
      titleSpacing:
          (Responsive.isMobile(context) || Responsive.isTablet(context))
              ? 0
              : -30,
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
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Row(
            children: [
              BlocListener<AppAuthBloc, AppAuthState>(
                listener: (context, state) {
                  if (state is AppUnauthenticated) {
                    GoRouter.of(context).go('/login');
                  } else if (state is AppError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: TextButton(
                  onPressed: () async {
                    context.read<AppAuthBloc>().add(AppLogoutRequested());
                    context.read<AppStateManager>().logout();
                  },
                  child: const Text('Logout',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}
