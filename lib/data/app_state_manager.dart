import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'blocs.dart';

class SKNEatsOrdersPortal {
  static const String login = 'login';
  static const String orders = 'orders';
  static const String orderHistory = 'order-history';
  static const String menu = 'menu';
  // static const String settings = 'settings';
}

class AppStateManager extends ChangeNotifier {
  static const String _restaurantIdKey = 'restaurantId';
  static const String _locationIdKey = 'locationId';

  int _selectedScreen = 0;
  String? _restaurantId;
  String? _locationId;
  bool _subscriptionsInitialized = false;

  SharedPreferences? _prefs;
  final logger = Logger();

  int get selectedScreen => _selectedScreen;
  String? get restaurantId => _restaurantId;
  String? get locationId => _locationId;

  Future<void> initialize() async {
    logger.d('AJP AppStateManager: Initializing...');
    try {
      await _initSharedPreferences();
      await _loadPersistedState();
    } catch (e) {
      logger.e('AppStateManager: Error during initialization', error: e);
    }
    notifyListeners();
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> _loadPersistedState() async {
    logger.d('AppStateManager: Loading persisted state...');
    await _loadIds();
    logger.d('AppStateManager: Persisted state loaded. restaurantId: $_restaurantId, locationId: $_locationId');
  }

  Future<void> _loadIds() async {
    _restaurantId = _prefs?.getString(_restaurantIdKey);
    _locationId = _prefs?.getString(_locationIdKey);
  }

  Future<void> logout() async {
    _restaurantId = null;
    _locationId = null;
    await _prefs?.clear();
    notifyListeners();
  }

  Future<void> setRestaurantId(String restaurantId) async {
    _restaurantId = restaurantId;
    await _saveIds();
    notifyListeners();
  }

  Future<void> setLocationId(String locationId) async {
    _locationId = locationId;
    await _saveIds();
    _subscriptionsInitialized = false; 
    notifyListeners();
  }
  
  void goToScreen(int index) {
    _selectedScreen = index;
    notifyListeners();
  }

  Future<void> _saveIds() async {
    if (_restaurantId != null) {
      await _prefs?.setString(_restaurantIdKey, _restaurantId!);
    }
    if (_locationId != null) {
      await _prefs?.setString(_locationIdKey, _locationId!);
    }
  }

    void initializeSubscriptions(BuildContext context) {
    if (_restaurantId != null && _locationId != null && !_subscriptionsInitialized) {
      _initializeSubscriptions(context, _restaurantId!, _locationId!);
      _subscriptionsInitialized = true;
      notifyListeners();
    }
  }


   void _initializeSubscriptions(BuildContext context, String restaurantId, String locationId) {
    // context.read<RestaurantBloc>().add(RestaurantSubscriptionRequested(restaurantId: restaurantId));
    // context.read<SettingsBloc>().add(SettingsSubscriptionRequested(restaurantId: restaurantId, locationId: locationId));
    // context.read<CustomersBloc>().add(CustomersSubscriptionRequested(restaurantId: restaurantId, locationId: locationId));
    // context.read<DiscountBloc>().add(DiscountSubscriptionRequested(restaurantId: restaurantId, locationId: locationId));
    context.read<MenuCategoryBloc>().add(MenuCategorySubscriptionRequested(restaurantId: restaurantId, locationId: locationId));
    context.read<MenuItemBloc>().add(MenuItemsSubscriptionRequested(restaurantId: restaurantId, locationId: locationId));
    // context.read<ItemCategoryBloc>().add(ItemCategorySubscriptionRequested(restaurantId: restaurantId, locationId: locationId));
    context.read<CustomerOrderBloc>().add(CustomerOrderSubscriptionRequested(restaurantId: restaurantId, locationId: locationId));
    // context.read<UserBloc>().add(UsersSubscriptionRequested(restaurantId: restaurantId));
    
    logger.d('AppStateManager: Subscriptions initialized for restaurant $restaurantId and location $locationId');
  }
}
