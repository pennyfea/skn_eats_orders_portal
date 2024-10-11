import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
import '../../models.dart';
import '../../repository/menu_item_repository.dart';

part 'menu_item_event.dart';
part 'menu_item_state.dart';

class MenuItemBloc extends Bloc<MenuItemEvent, MenuItemState> {
  final MenuItemRepository _menuItemRepository;
  final Logger logger = Logger(printer: PrettyPrinter());

  MenuItemBloc({required MenuItemRepository menuItemRepository})
      : _menuItemRepository = menuItemRepository,
        super(MenuItemLoading()) {
    on<MenuItemsSubscriptionRequested>(_onSubscriptionRequested);
    on<AddMenuItem>(_onAddMenuItem);
    on<UpdateMenuItem>(_onUpdateMenuItem);
    on<RemoveMenuItem>(_onRemoveMenuItem);
    on<SelectedMenuItem>(_onSelectedMenuItem);
    on<UnselectMenuItem>(_onUnselectMenuItem);
    on<ResetMenuItems>(_onResetMenuItems);
  }

  Future<void> _onSubscriptionRequested(
      MenuItemsSubscriptionRequested event, Emitter<MenuItemState> emit) async {
    emit(MenuItemLoading());

    await emit.forEach<List<MenuItem>>(
      _menuItemRepository.watchMenuItemsByLocation(event.restaurantId, event.locationId),
      onData: (menuItems) => MenuItemLoaded(menuItems: menuItems),
      onError: (error, stackTrace) {
        logger.e("Menu items subscription error: $error");
        return MenuItemError(message: error.toString());
      },
    );
  }

  Future<void> _onAddMenuItem(
      AddMenuItem event, Emitter<MenuItemState> emit) async {
    try {
      await _menuItemRepository.addMenuItem(
        event.restaurantId,
        event.locationId,
        event.menuItem,
      );
    } catch (e) {
      logger.e("Failed to add menu item: $e");
      emit(MenuItemError(message: e.toString()));
    }
  }

  Future<void> _onUpdateMenuItem(
      UpdateMenuItem event, Emitter<MenuItemState> emit) async {
    try {
      await _menuItemRepository.updateMenuItem(
        event.restaurantId,
        event.locationId,
        event.menuItem,
      );
    } catch (e) {
      logger.e("Failed to update menu item: $e");
      emit(MenuItemError(message: e.toString()));
    }
  }

  Future<void> _onRemoveMenuItem(
      RemoveMenuItem event, Emitter<MenuItemState> emit) async {
    try {
      await _menuItemRepository.deleteMenuItem(
        event.restaurantId,
        event.locationId,
        event.menuItemId,
      );
    } catch (e) {
      logger.e("Failed to remove menu item: $e");
      emit(MenuItemError(message: e.toString()));
    }
  }

  void _onSelectedMenuItem(
      SelectedMenuItem event, Emitter<MenuItemState> emit) {
    final state = this.state;
    if (state is MenuItemLoaded) {
      emit(MenuItemLoaded(
        menuItems: state.menuItems,
        selectedMenuItem: event.menuItem,
      ));
    }
  }

  void _onUnselectMenuItem(
      UnselectMenuItem event, Emitter<MenuItemState> emit) {
    if (state is MenuItemLoaded) {
      emit(MenuItemLoaded(
        menuItems: (state as MenuItemLoaded).menuItems,
        selectedMenuItem: null,
      ));
    }
  }

  void _onResetMenuItems(ResetMenuItems event, Emitter<MenuItemState> emit) {
    emit(MenuItemLoading());
    add(MenuItemsSubscriptionRequested(
      restaurantId: event.restaurantId,
      locationId: event.locationId,
    ));
  }

  @override
  void onChange(Change<MenuItemState> change) {
    super.onChange(change);
    logger.d(change);
  }

  @override
  void onTransition(Transition<MenuItemEvent, MenuItemState> transition) {
    super.onTransition(transition);
    logger.d(transition);
  }
}
