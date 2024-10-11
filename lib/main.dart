import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:skneats_order_portal/skn_eats_orders_portal.dart';

import 'firebase_options.dart';

import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);


  // Configure Firebase UI Auth providers
  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
    // ... other providers
  ]);

  runApp(const SknEatsOrdersPanel());
}
