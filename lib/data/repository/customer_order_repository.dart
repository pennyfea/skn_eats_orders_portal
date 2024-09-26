import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

import '../models.dart';

class CustomerOrderRepository {
  final FirebaseFirestore _firebaseFirestore;
  final Logger logger = Logger(printer: PrettyPrinter());

  CustomerOrderRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Stream<List<CustomerOrder>> getCustomerOrders({
    required String restaurantId,
    required String locationId,
  }) {
    logger.d(
        "[CustomerOrderRepository] restaurantId: $restaurantId, locationId: $locationId");
    return _firebaseFirestore
        .collection('restaurants')
        .doc(restaurantId)
        .collection('locations')
        .doc(locationId)
        .collection('orders')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) {
            try {
              return CustomerOrder.fromFirestore(doc.data());
            } catch (e, stackTrace) {
              logger.e("Error converting order data: $e\n$stackTrace");
              return null;
            }
          })
          .whereType<CustomerOrder>()
          .toList();
    });
  }

  Future<void> updateCustomerOrder({
    required String restaurantId,
    required String locationId,
    required CustomerOrder customerOrder,
  }) async {
    try {
      logger.d(
          "Updating order for restaurant: $restaurantId, location: $locationId, order ID: ${customerOrder.id}");
      await _firebaseFirestore
          .collection('restaurants')
          .doc(restaurantId)
          .collection('locations')
          .doc(locationId)
          .collection('orders')
          .doc(customerOrder.id)
          .update(customerOrder.toFirestore());

      logger.d("Order updated successfully");
    } catch (e, stackTrace) {
      logger.w('Error in updateCustomerOrder: $e');
      logger.w('Stack trace: $stackTrace');
      if (e is FirebaseException) {
        logger.w('Firebase error code: ${e.code}');
        logger.w('Firebase error message: ${e.message}');
      }
      rethrow;
    }
  }

  Future<void> addCustomerOrder({
    required String restaurantId,
    required String locationId,
    required CustomerOrder customerOrder,
  }) async {
    try {
      logger.d(
          "Adding new order for restaurant: $restaurantId, location: $locationId");
      await _firebaseFirestore
          .collection('restaurants')
          .doc(restaurantId)
          .collection('locations')
          .doc(locationId)
          .collection('orders')
          .doc(customerOrder.id)
          .set(customerOrder.toFirestore());
      logger.d("Order added successfully");
    } catch (e, stackTrace) {
      logger.w('Error in addCustomerOrder: $e');
      logger.w('Stack trace: $stackTrace');
      if (e is FirebaseException) {
        logger.w('Firebase error code: ${e.code}');
        logger.w('Firebase error message: ${e.message}');
      }
      rethrow;
    }
  }
}
