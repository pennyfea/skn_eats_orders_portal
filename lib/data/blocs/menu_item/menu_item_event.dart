part of 'menu_item_bloc.dart';

abstract class MenuItemEvent extends Equatable {
  const MenuItemEvent();

  @override
  List<Object?> get props => [];
}

class MenuItemsSubscriptionRequested extends MenuItemEvent {
  final String restaurantId;
  final String locationId;

  const MenuItemsSubscriptionRequested({
    required this.restaurantId,
    required this.locationId,
  });

  @override
  List<Object?> get props => [restaurantId, locationId];
}

class AddMenuItem extends MenuItemEvent {
  final String restaurantId;
  final String locationId;
  final MenuItem menuItem;

  const AddMenuItem({
    required this.restaurantId,
    required this.locationId,
    required this.menuItem,
  });

  @override
  List<Object?> get props => [restaurantId, locationId, menuItem];
}

class UpdateMenuItem extends MenuItemEvent {
  final String restaurantId;
  final String locationId;
  final MenuItem menuItem;

  const UpdateMenuItem({
    required this.restaurantId,
    required this.locationId,
    required this.menuItem,
  });

  @override
  List<Object?> get props => [restaurantId, locationId, menuItem];
}

class RemoveMenuItem extends MenuItemEvent {
  final String restaurantId;
  final String locationId;
  final String menuItemId;

  const RemoveMenuItem({
    required this.restaurantId,
    required this.locationId,
    required this.menuItemId,
  });

  @override
  List<Object?> get props => [restaurantId, locationId, menuItemId];
}

class SelectedMenuItem extends MenuItemEvent {
  final MenuItem menuItem;

  const SelectedMenuItem({required this.menuItem});

  @override
  List<Object?> get props => [menuItem];
}

class UnselectMenuItem extends MenuItemEvent {
  const UnselectMenuItem();
}

class ResetMenuItems extends MenuItemEvent {
  final String restaurantId;
  final String locationId;

  const ResetMenuItems({
    required this.restaurantId,
    required this.locationId,
  });

  @override
  List<Object?> get props => [restaurantId, locationId];
}

/// **New event: Add item category to menu item**
class AddItemCategoryToMenuItem extends MenuItemEvent {
  final String restaurantId;
  final String locationId;
  final String menuCategoryId;
  final String menuItemId;
  final String itemCategoryId;

  const AddItemCategoryToMenuItem({
    required this.restaurantId,
    required this.locationId,
    required this.menuCategoryId,
    required this.menuItemId,
    required this.itemCategoryId,
  });

  @override
  List<Object?> get props => [
        restaurantId,
        locationId,
        menuCategoryId,
        menuItemId,
        itemCategoryId,
      ];
}

/// **New event: Remove item category from menu item**
class RemoveItemCategoryFromMenuItem extends MenuItemEvent {
  final String restaurantId;
  final String locationId;
  final String menuCategoryId;
  final String menuItemId;
  final String itemCategoryId;

  const RemoveItemCategoryFromMenuItem({
    required this.restaurantId,
    required this.locationId,
    required this.menuCategoryId,
    required this.menuItemId,
    required this.itemCategoryId,
  });

  @override
  List<Object?> get props => [
        restaurantId,
        locationId,
        menuCategoryId,
        menuItemId,
        itemCategoryId,
      ];
}
