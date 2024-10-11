part of 'menu_category_bloc.dart';

abstract class MenuCategoryState extends Equatable {
  const MenuCategoryState();

  @override
  List<Object?> get props => [];
}

class MenuCategoryLoading extends MenuCategoryState {}

class MenuCategoryLoaded extends MenuCategoryState {
  final List<MenuCategory> menuCategories;
  final MenuCategory? selectedMenuCategory;

  const MenuCategoryLoaded({
    this.menuCategories = const [],
    this.selectedMenuCategory,
  });

  MenuCategoryLoaded copyWith({
    List<MenuCategory>? menuCategories,
    MenuCategory? selectedMenuCategory,
  }) {
    return MenuCategoryLoaded(
      menuCategories: menuCategories ?? this.menuCategories,
      selectedMenuCategory: selectedMenuCategory,
    );
  }

  @override
  List<Object?> get props => [menuCategories, selectedMenuCategory];
}

class MenuCategoryError extends MenuCategoryState {
  final String message;

  const MenuCategoryError({required this.message});

  @override
  List<Object?> get props => [message];
}
