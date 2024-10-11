import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:logger/logger.dart';

import '../../../data/blocs.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final logger = Logger(printer: PrettyPrinter());

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppAuthBloc, AppAuthState>(
      listener: (context, state) {
        if (state is AppPasswordResetSent) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Password reset email sent to ${state.email}')),
          );
        } else if (state is AppError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Authentication Error: ${state.message}')),
          );
        }
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: Text(
                'SKN Eats',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(color: Colors.white),
              ),
              centerTitle: false,
            ),
            body: SignInScreen(
              showPasswordVisibilityToggle: true,
              actions: [
                AuthStateChangeAction<SignedIn>((context, state) {
                  if (state.user != null) {
                    context.read<AppAuthBloc>().add(AppSignInRequested());
                  } else {
                    logger.e("SignedIn state has null user");
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Sign in failed. Please try again.')),
                    );
                  }
                }),
                ForgotPasswordAction((context, email) {
                  if (email != null && email.isNotEmpty) {
                    context
                        .read<AppAuthBloc>()
                        .add(AppPasswordResetRequested(email: email));
                  } else {
                    logger
                        .e("ForgotPasswordAction received null or empty email");
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please enter a valid email address.')),
                    );
                  }
                }),
                AuthStateChangeAction<AuthFailed>((context, state) {
                  context
                      .read<AppAuthBloc>()
                      .add(AppAuthenticationFailed(state.exception.toString()));
                }),
              ],
              subtitleBuilder: (context, action) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Welcome to SKN Eats Order Portal'),
                );
              },
            ),
          ),
          BlocBuilder<AppAuthBloc, AppAuthState>(
            builder: (context, state) {
              if (state is AppAuthenticating) {
                return Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(child: CircularProgressIndicator()),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
