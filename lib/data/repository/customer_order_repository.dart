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
              return CustomerOrder.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
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
    
    // Update in the restaurant's orders collection
    await _firebaseFirestore
        .collection('restaurants')
        .doc(restaurantId)
        .collection('locations')
        .doc(locationId)
        .collection('orders')
        .doc(customerOrder.id)
        .update(customerOrder.toFirestore());

    // Update in the customer_orders collection
    final customerOrderQuery = await _firebaseFirestore
        .collection('customer_orders')
        .where('id', isEqualTo: customerOrder.id)
        .get();

    if (customerOrderQuery.docs.isNotEmpty) {
      final customerOrderDoc = customerOrderQuery.docs.first;
      await customerOrderDoc.reference.update(customerOrder.toFirestore());
    } else {
      logger.w('No matching customer order found with ID: ${customerOrder.id}');
    }

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
}
