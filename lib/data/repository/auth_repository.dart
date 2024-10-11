import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:logger/logger.dart';

class AuthRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final Logger logger;

  AuthRepository({
    FirebaseFirestore? firestore,
    firebase_auth.FirebaseAuth? firebaseAuth,
    Logger? logger,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        logger = logger ?? Logger(printer: PrettyPrinter());

  /// Getter to retrieve the current user
  firebase_auth.User? get currentUser => _firebaseAuth.currentUser;

  /// **Sign out the current user**
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  /// **Send password reset email**
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on firebase_auth.FirebaseAuthException catch (e) {
      logger.e("Password Reset Error: $e");
      throw _handleFirebaseAuthException(e);
    }
  }

  /// **Handle Firebase Auth Exceptions**
  Exception _handleFirebaseAuthException(
      firebase_auth.FirebaseAuthException e) {
    String errorMessage;
    switch (e.code) {
      case 'wrong-password':
        errorMessage =
            "Sorry, your password was incorrect. Please double-check your password.";
        break;
      case 'invalid-email':
        errorMessage = "Sorry, the email address is not valid.";
        break;
      case 'user-not-found':
        errorMessage =
            "Sorry, there is no user corresponding to the given email.";
        break;
      case 'weak-password':
        errorMessage = "The password provided is not strong enough.";
        break;
      case 'email-already-in-use':
        errorMessage =
            "There already exists an account with the given email address.";
        break;
      default:
        errorMessage = "Authentication failed: ${e.message}";
    }
    return Exception(errorMessage);
  }
}
