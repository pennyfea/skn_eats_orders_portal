import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:logger/logger.dart';

import '../../../data/blocs/app_auth/app_auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final logger = Logger(printer: PrettyPrinter());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isWideScreen = screenWidth > 800;

    return BlocListener<AppAuthBloc, AppAuthState>(
      listener: (context, state) {
        if (state is AppPasswordResetSent) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Password reset email sent to ${state.email}')),
          );
        } else if (state is AppError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Authentication Error: ${state.message}')),
          );
        }
      },
      child: Scaffold(
        body: SizedBox(
          width: screenWidth,
          height: screenHeight,
          child: Row(
            children: [
              if (isWideScreen)
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/login_background.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          color: Colors.black.withValues(alpha: 0.4),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'SKN Eats Orders',
                                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'Manage your restaurant orders efficiently.',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              Expanded(
                child: Column(
                  children: [
                    AppBar(
                      backgroundColor: Colors.black,
                      // title: Text(
                      //   'SKN Eats Admin',
                      //   style: Theme.of(context)
                      //       .textTheme
                      //       .headlineSmall!
                      //       .copyWith(color: Colors.white),
                      // ),
                      // centerTitle: false,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isWideScreen ? 48.0 : 24.0,
                          ),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: screenHeight - kToolbarHeight,
                              maxHeight: screenHeight - kToolbarHeight,
                            ),
                            child: SignInScreen(
                              showPasswordVisibilityToggle: true,
                              actions: [
                                AuthStateChangeAction<SignedIn>((context, state) {
                                  if (state.user != null) {
                                    context.read<AppAuthBloc>().add(AppSignInRequested());
                                  } else {
                                    logger.e("SignedIn state has null user");
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Sign in failed. Please try again.')),
                                    );
                                  }
                                }),
                                AuthStateChangeAction<UserCreated>((context, state) {
                                  if (state.credential.user != null) {
                                    context.read<AppAuthBloc>().add(AppSignUpRequested());
                                  } else {
                                    logger.e("UserCreated state has null user");
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Sign up failed. Please try again.')),
                                    );
                                  }
                                }),
                                ForgotPasswordAction((context, email) {
                                  if (email != null && email.isNotEmpty) {
                                    context.read<AppAuthBloc>().add(AppPasswordResetRequested(email: email));
                                  } else {
                                    logger.e("ForgotPasswordAction received null or empty email");
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Please enter a valid email address.')),
                                    );
                                  }
                                }),
                                AuthStateChangeAction<AuthFailed>((context, state) {
                                  context.read<AppAuthBloc>().add(AppAuthenticationFailed(state.exception.toString()));
                                }),
                              ],
                              subtitleBuilder: (context, action) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text('Welcome to SKN Eats for Orders'),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}