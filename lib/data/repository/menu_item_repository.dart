import 'dart:async';
import 'package:logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models.dart';

class MenuItemRepository {
  final FirebaseFirestore _firebaseFirestore;
  final Logger logger = Logger(printer: PrettyPrinter());

  MenuItemRepository({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  // Stream method to watch menu items by location
  Stream<List<MenuItem>> watchMenuItemsByLocation(
      String restaurantId, String locationId) {
    return _firebaseFirestore
        .collection('restaurants')
        .doc(restaurantId)
        .collection('locations')
        .doc(locationId)
        .collection('menuItems')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => MenuItem.fromFirestore(doc)).toList());
  }

  // Future method to get menu items by location
  Future<List<MenuItem>> getMenuItemsByLocation(
      String restaurantId, String locationId) async {
    try {
      final querySnapshot = await _firebaseFirestore
          .collection('restaurants')
          .doc(restaurantId)
          .collection('locations')
          .doc(locationId)
          .collection('menuItems')
          .get();

      return querySnapshot.docs
          .map((doc) => MenuItem.fromFirestore(doc))
          .toList();
    } catch (e) {
      logger.w("Failed to get menu items by location: $e");
      rethrow;
    }
  }

  // Get menu items by category
  Stream<List<MenuItem>> getMenuItemsByCategory(
      String restaurantId, String locationId, String categoryId) {
    return _firebaseFirestore
        .collection('restaurants')
        .doc(restaurantId)
        .collection('locations')
        .doc(locationId)
        .collection('menuItems')
        .where('menuCategoryIds', arrayContains: categoryId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => MenuItem.fromFirestore(doc)).toList());
  }

  Future<void> addMenuItem(
      String restaurantId, String locationId, MenuItem menuItem) async {
    try {
      final menuItemsRef = _firebaseFirestore
          .collection('restaurants')
          .doc(restaurantId)
          .collection('locations')
          .doc(locationId)
          .collection('menuItems');

      await menuItemsRef.doc(menuItem.id).set(menuItem.toFirestore());
    } catch (e) {
      logger.w("Failed to add menu item: $e");
      rethrow;
    }
  }

  Future<void> updateMenuItem(
      String restaurantId, String locationId, MenuItem menuItem) async {
    try {
      final menuItemRef = _firebaseFirestore
          .collection('restaurants')
          .doc(restaurantId)
          .collection('locations')
          .doc(locationId)
          .collection('menuItems')
          .doc(menuItem.id);

      await menuItemRef.update(menuItem.toFirestore());
    } catch (e) {
      logger.w("Failed to update menu item: $e");
      rethrow;
    }
  }

  Future<void> deleteMenuItem(
      String restaurantId, String locationId, String menuItemId) async {
    try {
      final menuItemRef = _firebaseFirestore
          .collection('restaurants')
          .doc(restaurantId)
          .collection('locations')
          .doc(locationId)
          .collection('menuItems')
          .doc(menuItemId);

      await menuItemRef.delete();
    } catch (e) {
      logger.w("Failed to delete menu item: $e");
      rethrow;
    }
  }
}
