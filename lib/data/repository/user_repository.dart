import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

import '../models.dart';

class UserRepository {
  final FirebaseFirestore _firestore;
  final Logger logger;

  UserRepository({
    FirebaseFirestore? firestore,
    Logger? logger,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        logger = logger ?? Logger(printer: PrettyPrinter());

  /// **Add a user to Firestore under a specific restaurant**
  Future<void> addUser(String restaurantId, User user) async {
    try {
      await _firestore
          .collection('restaurants')
          .doc(restaurantId)
          .collection('users')
          .doc(user.id)
          .set(user.toFirestore());
      logger.d('User added to Firestore: ${user.id}');
    } catch (e) {
      logger.e("Failed to add user: $e");
      throw Exception("Failed to add user: $e");
    }
  }

  /// **Update user to Firestore under a specific restaurant**
  Future<void> updateUser(String restaurantId, User user) async {
    try {
      await _firestore
          .collection('restaurants')
          .doc(restaurantId)
          .collection('users')
          .doc(user.id)
          .update(user.toFirestore());
      logger.d('User updated to Firestore: ${user.id}');
    } catch (e) {
      logger.e("Failed to update user: $e");
      throw Exception("Failed to update user: $e");
    }
  }

  /// **Get a user by ID under a specific restaurant**
  Future<User?> getUserById(String restaurantId, String userId) async {
    try {
      final doc = await _firestore
          .collection('restaurants')
          .doc(restaurantId)
          .collection('users')
          .doc(userId)
          .get();
      if (doc.exists) {
        return User.fromFirestore(doc);
      } else {
        logger.w("User not found: $userId");
        return null;
      }
    } catch (e) {
      logger.e("Failed to get user: $e");
      throw Exception("Failed to get user: $e");
    }
  }

  /// **Get a user by UID (User ID) across all restaurants**
  Future<User?> getUserByUid(String uid) async {
    try {
      // Get all restaurants
      final restaurantsSnapshot =
          await _firestore.collection('restaurants').get();

      for (var restaurant in restaurantsSnapshot.docs) {
        final userDoc = await _firestore
            .collection('restaurants')
            .doc(restaurant.id)
            .collection('users')
            .doc(uid)
            .get();

        if (userDoc.exists) {
          final user = User.fromFirestore(userDoc);
          logger.d('User found: ${user.id} in restaurant: ${restaurant.id}');
          return user;
        }
      }

      logger.w("User not found: $uid");
      return null;
    } catch (e) {
      logger.e("Failed to get user by UID: $e");
      throw Exception("Failed to get user by UID: $e");
    }
  }

  /// **Get users for a specific restaurant**
  Stream<List<User>> getUsers(String restaurantId) {
    return _firestore
        .collection('restaurants')
        .doc(restaurantId)
        .collection('users')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) {
            try {
              return User.fromFirestore(doc);
            } catch (e, stackTrace) {
              logger.e('Error converting user data: $e\n$stackTrace');
              return null;
            }
          })
          .whereType<User>()
          .toList();
    });
  }
}
