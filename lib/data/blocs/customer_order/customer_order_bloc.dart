import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';

import '../../models.dart';
import '../../repository.dart';

part 'customer_order_event.dart';
part 'customer_order_state.dart';

class CustomerOrderBloc extends Bloc<CustomerOrderEvent, CustomerOrderState> {
  final CustomerOrderRepository _customerOrderRepository;
  final Logger logger = Logger(printer: PrettyPrinter());

  CustomerOrderBloc({required CustomerOrderRepository customerOrderRepository})
      : _customerOrderRepository = customerOrderRepository,
        super(CustomerOrderLoading()) {
    on<CustomerOrderSubscriptionRequested>(_onSubscriptionRequested);
    on<LoadCustomerOrders>(_onLoadCustomerOrders);
    on<CustomerOrderUpdated>(_onUpdatedCustomerOrder);
    on<FilterOrdersByDate>(_onFilterOrdersByDate);
    on<FilterOrdersByStatus>(_onFilterOrdersByStatus);
    on<SearchOrders>(_onSearchOrders);
    on<SelectedCustomerOrder>(_onSelectedCustomerOrder);
    on<UnSelectCustomerOrder>(_onUnSelectCustomerOrder);
    on<ResetCustomerOrders>(_onResetCustomerOrders);
  }

  Future<void> _onSubscriptionRequested(
    CustomerOrderSubscriptionRequested event,
    Emitter<CustomerOrderState> emit,
  ) async {
    emit(CustomerOrderLoading());
    await emit.forEach<List<CustomerOrder>>(
      _customerOrderRepository.getCustomerOrders(
        restaurantId: event.restaurantId,
        locationId: event.locationId,
      ),
      onData: (orders) {
        logger.d("Received ${orders.length} orders");
        return CustomerOrderLoaded(orders: orders);
      },
      onError: (error, stackTrace) {
        logger.e("Error in subscription: $error\n$stackTrace");
        return CustomerOrderError(
            message: "Failed to load orders: ${error.toString()}");
      },
    );
  }

  void _onLoadCustomerOrders(
      LoadCustomerOrders event, Emitter<CustomerOrderState> emit) {
    emit(CustomerOrderLoaded(orders: event.orders));
  }

  Future<void> _onUpdatedCustomerOrder(
    CustomerOrderUpdated event,
    Emitter<CustomerOrderState> emit,
  ) async {
    try {
      await _customerOrderRepository.updateCustomerOrder(
        restaurantId: event.restaurantId,
        locationId: event.locationId,
        customerOrder: event.customerOrder,
      );
    } catch (e, stackTrace) {
      logger.w('Error while updating order: $e\nStack trace: $stackTrace');
      emit(CustomerOrderError(message: "Failed to update order: $e"));
    }
  }

  void _onFilterOrdersByDate(
      FilterOrdersByDate event, Emitter<CustomerOrderState> emit) {
    final currentState = state;
    if (currentState is CustomerOrderLoaded) {
      final filteredOrders =
          _filterOrdersByDate(currentState.orders, event.dateFilter);
      emit(CustomerOrderLoaded(
        orders: currentState.orders,
        filteredOrders: filteredOrders,
        dateFilter: event.dateFilter,
        statusFilter: currentState.statusFilter,
        searchQuery: currentState.searchQuery,
      ));
    }
  }

  void _onFilterOrdersByStatus(
      FilterOrdersByStatus event, Emitter<CustomerOrderState> emit) {
    final currentState = state;
    if (currentState is CustomerOrderLoaded) {
      final filteredOrders =
          _filterOrdersByStatus(currentState.orders, event.statusFilter);
      emit(CustomerOrderLoaded(
        orders: currentState.orders,
        filteredOrders: filteredOrders,
        dateFilter: currentState.dateFilter,
        statusFilter: event.statusFilter,
        searchQuery: currentState.searchQuery,
      ));
    }
  }

  void _onSearchOrders(SearchOrders event, Emitter<CustomerOrderState> emit) {
    final currentState = state;
    if (currentState is CustomerOrderLoaded) {
      final searchedOrders =
          _searchOrders(currentState.orders, event.searchQuery);
      emit(CustomerOrderLoaded(
        orders: currentState.orders,
        filteredOrders: searchedOrders,
        dateFilter: currentState.dateFilter,
        statusFilter: currentState.statusFilter,
        searchQuery: event.searchQuery,
      ));
    }
  }

  List<CustomerOrder> _filterOrdersByDate(
      List<CustomerOrder> orders, String dateFilter) {
    final now = DateTime.now();
    switch (dateFilter) {
      case 'Today':
        return orders
            .where((order) =>
                order.createdAt.isAfter(DateTime(now.year, now.month, now.day)))
            .toList();
      case 'Yesterday':
        final yesterday = now.subtract(const Duration(days: 1));
        return orders
            .where((order) =>
                order.createdAt.isAfter(
                    DateTime(yesterday.year, yesterday.month, yesterday.day)) &&
                order.createdAt
                    .isBefore(DateTime(now.year, now.month, now.day)))
            .toList();
      case 'Last 7 days':
        return orders
            .where((order) =>
                order.createdAt.isAfter(now.subtract(const Duration(days: 7))))
            .toList();
      case 'Last 30 days':
        return orders
            .where((order) =>
                order.createdAt.isAfter(now.subtract(const Duration(days: 30))))
            .toList();
      default:
        return orders;
    }
  }

  List<CustomerOrder> _filterOrdersByStatus(
      List<CustomerOrder> orders, String statusFilter) {
    if (statusFilter == 'All orders') {
      return orders;
    }
    final status = OrderStatus.values.firstWhere(
      (e) => e.toString().split('.').last == statusFilter,
      orElse: () => OrderStatus.pending,
    );
    return orders.where((order) => order.status == status).toList();
  }

  List<CustomerOrder> _searchOrders(
      List<CustomerOrder> orders, String searchQuery) {
    final query = searchQuery.toLowerCase();
    return orders.where((order) {
      return order.firstName.toLowerCase().contains(query) ||
          order.lastName.toLowerCase().contains(query) ||
          order.id.toLowerCase().contains(query);
    }).toList();
  }

  void _onSelectedCustomerOrder(
      SelectedCustomerOrder event, Emitter<CustomerOrderState> emit) {
    final state = this.state;
    if (state is CustomerOrderLoaded) {
      logger.d("Selected Customer order!");
      final selectedCustomerOrder = state.orders.firstWhere(
        (order) => order.id == event.customerOrder.id,
        orElse: () => event.customerOrder,
      );
      logger.d("Emit customer order loaded");
      emit(CustomerOrderLoaded(
        orders: state.orders,
        selectedCustomerOrder: selectedCustomerOrder,
      ));
    }
  }

  void _onUnSelectCustomerOrder(
      UnSelectCustomerOrder event, Emitter<CustomerOrderState> emit) {
    if (state is CustomerOrderLoaded) {
      emit(CustomerOrderLoaded(
          orders: (state as CustomerOrderLoaded).orders,
          selectedCustomerOrder: null));
    }
  }

  void _onResetCustomerOrders(
      ResetCustomerOrders event, Emitter<CustomerOrderState> emit) {
    emit(CustomerOrderLoading());
    add(CustomerOrderSubscriptionRequested(
      restaurantId: event.restaurantId,
      locationId: event.locationId,
    ));
  }
}
