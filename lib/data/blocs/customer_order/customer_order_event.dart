part of 'customer_order_bloc.dart';

abstract class CustomerOrderEvent extends Equatable {
  const CustomerOrderEvent();

  @override
  List<Object?> get props => [];
}

class CustomerOrderSubscriptionRequested extends CustomerOrderEvent {
  final String restaurantId;
  final String locationId;

  const CustomerOrderSubscriptionRequested({
    required this.restaurantId,
    required this.locationId,
  });

  @override
  List<Object?> get props => [restaurantId, locationId];
}

class LoadCustomerOrders extends CustomerOrderEvent {
  final List<CustomerOrder> orders;

  const LoadCustomerOrders({required this.orders});

  @override
  List<Object?> get props => [orders];
}

class CustomerOrderUpdated extends CustomerOrderEvent {
  final String restaurantId;
  final String locationId;
  final CustomerOrder customerOrder;

  const CustomerOrderUpdated({
    required this.restaurantId,
    required this.locationId,
    required this.customerOrder,
  });

  @override
  List<Object?> get props => [restaurantId, locationId, customerOrder];
}

class FilterOrdersByDate extends CustomerOrderEvent {
  final String dateFilter;

  const FilterOrdersByDate({required this.dateFilter});

  @override
  List<Object?> get props => [dateFilter];
}

class FilterOrdersByStatus extends CustomerOrderEvent {
  final String statusFilter;

  const FilterOrdersByStatus({required this.statusFilter});

  @override
  List<Object?> get props => [statusFilter];
}

class SearchOrders extends CustomerOrderEvent {
  final String searchQuery;

  const SearchOrders({required this.searchQuery});

  @override
  List<Object?> get props => [searchQuery];
}

class SelectedCustomerOrder extends CustomerOrderEvent {
  final CustomerOrder customerOrder;

  const SelectedCustomerOrder({required this.customerOrder});

  @override
  List<Object?> get props => [customerOrder];
}

class UnSelectCustomerOrder extends CustomerOrderEvent {
  const UnSelectCustomerOrder();
}

class ResetCustomerOrders extends CustomerOrderEvent {
  final String restaurantId;
  final String locationId;

  const ResetCustomerOrders({
    required this.restaurantId,
    required this.locationId,
  });

  @override
  List<Object?> get props => [restaurantId, locationId];
}
