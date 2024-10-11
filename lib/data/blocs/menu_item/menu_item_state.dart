part of 'menu_item_bloc.dart';

abstract class MenuItemState extends Equatable {
  const MenuItemState();

  @override
  List<Object?> get props => [];
}

class MenuItemLoading extends MenuItemState {}

class MenuItemLoaded extends MenuItemState {
  final List<MenuItem> menuItems;
  final MenuItem? selectedMenuItem;

  const MenuItemLoaded({
    this.menuItems = const [],
    this.selectedMenuItem,
  });

  @override
  List<Object?> get props => [menuItems, selectedMenuItem];
}

class MenuItemError extends MenuItemState {
  final String message;

  const MenuItemError({required this.message});

  @override
  List<Object?> get props => [message];
}
