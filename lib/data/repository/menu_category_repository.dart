import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import '../models.dart';

class MenuCategoryRepository {
  final FirebaseFirestore _firebaseFirestore;
  final Logger logger = Logger(printer: PrettyPrinter());

  MenuCategoryRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  // Stream method to watch menu categories by location
  Stream<List<MenuCategory>> watchMenuCategoriesByLocation(
      String restaurantId, String locationId) {
    return _firebaseFirestore
        .collection('restaurants')
        .doc(restaurantId)
        .collection('locations')
        .doc(locationId)
        .collection('menuCategories')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) {
              final data = doc.data();
              data['id'] = doc.id;
              return MenuCategory.fromFirestore(data);
            })
            .toList());
  }

  // Future method to get menu categories by location
  Future<List<MenuCategory>> getMenuCategoriesByLocation(
      String restaurantId, String locationId) async {
    try {
      final querySnapshot = await _firebaseFirestore
          .collection('restaurants')
          .doc(restaurantId)
          .collection('locations')
          .doc(locationId)
          .collection('menuCategories')
          .get();

      return querySnapshot.docs
          .map((doc) {
            final data = doc.data();
            data['id'] = doc.id; // Add the document ID to the data
            return MenuCategory.fromFirestore(data);
          })
          .toList();
    } catch (e) {
      logger.w("Failed to get menu categories by location: $e");
      rethrow;
    }
  }

  Future<void> addMenuCategory(
      String restaurantId, String locationId, MenuCategory menuCategory) async {
    try {
      final categoriesRef = _firebaseFirestore
          .collection('restaurants')
          .doc(restaurantId)
          .collection('locations')
          .doc(locationId)
          .collection('menuCategories');

      // Use the pre-generated ID when adding the document
      await categoriesRef.doc(menuCategory.id).set(menuCategory.toFirestore());
    } catch (e) {
      logger.w("Failed to add menu category: $e");
      rethrow;
    }
  }

  Future<void> updateMenuCategory(
      String restaurantId, String locationId, MenuCategory menuCategory) async {
    try {
      final categoryRef = _firebaseFirestore
          .collection('restaurants')
          .doc(restaurantId)
          .collection('locations')
          .doc(locationId)
          .collection('menuCategories')
          .doc(menuCategory.id);

      await categoryRef.update(menuCategory.toFirestore());
    } catch (e) {
      logger.w("Failed to update menu category: $e");
      rethrow;
    }
  }

  Future<void> deleteMenuCategory(
      String restaurantId, String locationId, String categoryId) async {
    try {
      final categoryRef = _firebaseFirestore
          .collection('restaurants')
          .doc(restaurantId)
          .collection('locations')
          .doc(locationId)
          .collection('menuCategories')
          .doc(categoryId);

      await categoryRef.delete();
    } catch (e) {
      logger.w("Failed to delete menu category: $e");
      rethrow;
    }
  }
}