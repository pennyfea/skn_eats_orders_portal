import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
import '../../models.dart';
import '../../repository.dart';

part 'menu_category_event.dart';
part 'menu_category_state.dart';

class MenuCategoryBloc extends Bloc<MenuCategoryEvent, MenuCategoryState> {
  final MenuCategoryRepository _menuCategoryRepository;
  final Logger logger = Logger(printer: PrettyPrinter());

  MenuCategoryBloc({required MenuCategoryRepository menuCategoryRepository})
      : _menuCategoryRepository = menuCategoryRepository,
        super(MenuCategoryLoading()) {
    on<MenuCategorySubscriptionRequested>(_onSubscriptionRequested);
    on<AddMenuCategory>(_onAddMenuCategory);
    on<UpdateMenuCategory>(_onUpdateMenuCategory);
    on<RemoveMenuCategory>(_onRemoveMenuCategory);
    on<SelectMenuCategory>(_onSelectMenuCategory);
    on<SortMenuCategories>(_onSortMenuCategories);
    on<UnselectMenuCategory>(_onUnselectMenuCategory);
    on<ResetMenuCategories>(_onResetMenuCategories);
  }

  Future<void> _onSubscriptionRequested(
      MenuCategorySubscriptionRequested event,
      Emitter<MenuCategoryState> emit) async {
    emit(MenuCategoryLoading());
    await emit.forEach<List<MenuCategory>>(
      _menuCategoryRepository.watchMenuCategoriesByLocation(
          event.restaurantId, event.locationId),
      onData: (menuCategories) => MenuCategoryLoaded(menuCategories: menuCategories),
      onError: (error, stackTrace) {
        logger.e("Menu category subscription error: $error");
        return MenuCategoryError(message: error.toString());
      },
    );
  }

  Future<void> _onAddMenuCategory(
      AddMenuCategory event, Emitter<MenuCategoryState> emit) async {
    try {
      await _menuCategoryRepository.addMenuCategory(
        event.restaurantId,
        event.locationId,
        event.menuCategory,
      );
    } catch (e) {
      logger.e("Failed to add menu category: $e");
      emit(MenuCategoryError(message: e.toString()));
    }
  }

  Future<void> _onUpdateMenuCategory(
      UpdateMenuCategory event, Emitter<MenuCategoryState> emit) async {
    try {
      await _menuCategoryRepository.updateMenuCategory(
        event.restaurantId,
        event.locationId,
        event.menuCategory,
      );

      // If you need to update menu items associated with this category,
      // you may need to interact with the MenuItemRepository here.
    } catch (e) {
      logger.e("Failed to update menu category: $e");
      emit(MenuCategoryError(message: e.toString()));
    }
  }

  Future<void> _onRemoveMenuCategory(
      RemoveMenuCategory event, Emitter<MenuCategoryState> emit) async {
    try {
      await _menuCategoryRepository.deleteMenuCategory(
        event.restaurantId,
        event.locationId,
        event.menuCategoryId,
      );

      // If you need to handle menu items associated with the deleted category,
      // consider adding logic here or in a separate service.
    } catch (e) {
      logger.e("Failed to remove menu category: $e");
      emit(MenuCategoryError(message: e.toString()));
    }
  }

  void _onSelectMenuCategory(
      SelectMenuCategory event, Emitter<MenuCategoryState> emit) {
    final state = this.state;
    if (state is MenuCategoryLoaded) {
      emit(state.copyWith(selectedMenuCategory: event.menuCategory));
    }
  }

  void _onSortMenuCategories(
      SortMenuCategories event, Emitter<MenuCategoryState> emit) {
    final state = this.state;
    if (state is MenuCategoryLoaded) {
      final categories = List<MenuCategory>.from(state.menuCategories);
      final category = categories.removeAt(event.oldIndex);
      categories.insert(event.newIndex, category);
      emit(state.copyWith(menuCategories: categories));
    }
  }

  void _onUnselectMenuCategory(
      UnselectMenuCategory event, Emitter<MenuCategoryState> emit) {
    final state = this.state;
    if (state is MenuCategoryLoaded) {
      emit(state.copyWith(selectedMenuCategory: null));
    }
  }

  void _onResetMenuCategories(
      ResetMenuCategories event, Emitter<MenuCategoryState> emit) {
    emit(MenuCategoryLoading());
    add(MenuCategorySubscriptionRequested(
      restaurantId: event.restaurantId,
      locationId: event.locationId,
    ));
  }

  @override
  void onChange(Change<MenuCategoryState> change) {
    super.onChange(change);
    logger.d(change);
  }

  @override
  void onTransition(
      Transition<MenuCategoryEvent, MenuCategoryState> transition) {
    super.onTransition(transition);
    logger.d(transition);
  }
}
