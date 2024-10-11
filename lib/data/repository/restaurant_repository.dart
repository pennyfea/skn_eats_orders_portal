import 'dart:typed_data';
import 'package:logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:rxdart/rxdart.dart';

import '../models.dart';

class RestaurantRepository {
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseStorage _firebaseStorage;
  final Logger logger;

  RestaurantRepository({
    FirebaseFirestore? firebaseFirestore,
    FirebaseStorage? firebaseStorage,
    Logger? logger,
  })  : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance,
        logger = logger ?? Logger(printer: PrettyPrinter());

  /// **Get restaurant with locations as a stream**
  // Stream<RestaurantWithLocations> watchRestaurantWithLocations(String restaurantId) {
  //   final restaurantDoc = _firebaseFirestore.collection('restaurants').doc(restaurantId);

  //   final restaurantStream = restaurantDoc.snapshots().map((snapshot) {
  //     if (!snapshot.exists) {
  //       throw Exception('Restaurant not found');
  //     }
  //     return Restaurant.fromFirestore(snapshot, null);
  //   });

  //   final locationsStream = restaurantDoc.collection('locations').snapshots().map((snapshot) {
  //     return snapshot.docs.map((doc) => RestaurantLocation.fromFirestore(doc, null)).toList();
  //   });

  //   return Rx.combineLatest2(
  //     restaurantStream,
  //     locationsStream,
  //     (Restaurant restaurant, List<RestaurantLocation> locations) {
  //       return RestaurantWithLocations(restaurant: restaurant, locations: locations);
  //     },
  //   );
  // }

  /// **Get a specific restaurant as a stream**
  Stream<Restaurant> getRestaurant(String restaurantId) {
    logger.d('Getting restaurant - RestaurantID: $restaurantId');

    return _firebaseFirestore.collection('restaurants').doc(restaurantId).snapshots().map((snapshot) {
      if (!snapshot.exists) {
        logger.w('Restaurant document does not exist for restaurantId: $restaurantId');
        throw Exception('Restaurant document does not exist');
      }

      final restaurant = Restaurant.fromFirestore(snapshot, null);
      logger.d('Restaurant parsed: ${restaurant.toString()}');
      return restaurant;
    });
  }

  /// **Get a specific restaurant as a future**
  Future<Restaurant> getRestaurantById(String restaurantId) async {
    try {
      final docSnapshot = await _firebaseFirestore.collection('restaurants').doc(restaurantId).get();
      if (!docSnapshot.exists) {
        throw Exception('Restaurant not found');
      }
      return Restaurant.fromFirestore(docSnapshot, null);
    } catch (e) {
      logger.w("Failed to get restaurant: $e");
      rethrow;
    }
  }

  /// **Get a specific restaurant location as a stream**
  Stream<RestaurantLocation> getRestaurantLocation(String restaurantId, String locationId) {
    logger.d('Getting restaurant location - RestaurantID: $restaurantId, LocationID: $locationId');

    return _firebaseFirestore
        .collection('restaurants')
        .doc(restaurantId)
        .collection('locations')
        .doc(locationId)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) {
        logger.w('Location document does not exist for locationId: $locationId');
        throw Exception('Location document does not exist');
      }

      final location = RestaurantLocation.fromFirestore(snapshot, null);
      logger.d('Location parsed: ${location.toString()}');
      return location;
    });
  }

  /// **Get all locations of a restaurant as a stream**
  Stream<List<RestaurantLocation>> getRestaurantLocations(String restaurantId) {
    return _firebaseFirestore
        .collection('restaurants')
        .doc(restaurantId)
        .collection('locations')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        try {
          return RestaurantLocation.fromFirestore(doc, null);
        } catch (e, stackTrace) {
          logger.e('Error converting location data: $e\n$stackTrace');
          return null;
        }
      }).whereType<RestaurantLocation>().toList();
    });
  }

  /// **Get a specific restaurant location as a future**
  Future<RestaurantLocation> getRestaurantLocationById(String restaurantId, String locationId) async {
    try {
      final docSnapshot = await _firebaseFirestore
          .collection('restaurants')
          .doc(restaurantId)
          .collection('locations')
          .doc(locationId)
          .get();
      if (!docSnapshot.exists) {
        throw Exception('Location not found');
      }
      return RestaurantLocation.fromFirestore(docSnapshot, null);
    } catch (e) {
      logger.w("Failed to get location: $e");
      rethrow;
    }
  }


  
  /// **Add a restaurant location**
  Future<void> addRestaurantLocation(String restaurantId, RestaurantLocation location) async {
    try {
      if (location.id == null) {
        throw Exception('Location ID cannot be null');
      }
      await _firebaseFirestore
          .collection('restaurants')
          .doc(restaurantId)
          .collection('locations')
          .doc(location.id)
          .set(location.toFirestore());
    } catch (e) {
      logger.w("Failed to add restaurant location: $e");
      rethrow;
    }
  }

  /// **Update a restaurant location**
  Future<void> updateRestaurantLocation(String restaurantId, RestaurantLocation location) async {
    try {
      if (location.id == null) {
        throw Exception('Location ID cannot be null');
      }
      await _firebaseFirestore
          .collection('restaurants')
          .doc(restaurantId)
          .collection('locations')
          .doc(location.id)
          .update(location.toFirestore());
    } catch (e) {
      logger.w("Failed to update restaurant location: $e");
      rethrow;
    }
  }

  /// **Check if a restaurant exists**
  Future<bool> checkRestaurantExists(String restaurantId) async {
    try {
      final docSnapshot = await _firebaseFirestore.collection('restaurants').doc(restaurantId).get();
      return docSnapshot.exists;
    } catch (e) {
      logger.w("Failed to check restaurant existence: $e");
      rethrow;
    }
  }
}
