part of 'menu_category_bloc.dart';

abstract class MenuCategoryEvent extends Equatable {
  const MenuCategoryEvent();

  @override
  List<Object?> get props => [];
}

class MenuCategorySubscriptionRequested extends MenuCategoryEvent {
  final String restaurantId;
  final String locationId;

  const MenuCategorySubscriptionRequested({
    required this.restaurantId,
    required this.locationId,
  });

  @override
  List<Object?> get props => [restaurantId, locationId];
}

class AddMenuCategory extends MenuCategoryEvent {
  final String restaurantId;
  final String locationId;
  final MenuCategory menuCategory;

  const AddMenuCategory({
    required this.restaurantId,
    required this.locationId,
    required this.menuCategory,
  });

  @override
  List<Object?> get props => [restaurantId, locationId, menuCategory];
}

class UpdateMenuCategory extends MenuCategoryEvent {
  final String restaurantId;
  final String locationId;
  final MenuCategory menuCategory;

  const UpdateMenuCategory({
    required this.restaurantId,
    required this.locationId,
    required this.menuCategory,
  });

  @override
  List<Object?> get props => [restaurantId, locationId, menuCategory];
}

class RemoveMenuCategory extends MenuCategoryEvent {
  final String restaurantId;
  final String locationId;
  final String menuCategoryId;

  const RemoveMenuCategory({
    required this.restaurantId,
    required this.locationId,
    required this.menuCategoryId,
  });

  @override
  List<Object?> get props => [restaurantId, locationId, menuCategoryId];
}

class SelectMenuCategory extends MenuCategoryEvent {
  final MenuCategory menuCategory;

  const SelectMenuCategory({required this.menuCategory});

  @override
  List<Object?> get props => [menuCategory];
}

class UnselectMenuCategory extends MenuCategoryEvent {
  const UnselectMenuCategory();
}

class SortMenuCategories extends MenuCategoryEvent {
  final int oldIndex;
  final int newIndex;

  const SortMenuCategories({
    required this.oldIndex,
    required this.newIndex,
  });

  @override
  List<Object?> get props => [oldIndex, newIndex];
}

class ResetMenuCategories extends MenuCategoryEvent {
  final String restaurantId;
  final String locationId;

  const ResetMenuCategories({
    required this.restaurantId,
    required this.locationId,
  });

  @override
  List<Object?> get props => [restaurantId, locationId];
}
