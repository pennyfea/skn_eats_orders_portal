part of 'customer_order_bloc.dart';

abstract class CustomerOrderState extends Equatable {
  const CustomerOrderState();

  @override
  List<Object?> get props => [];
}

class CustomerOrderLoading extends CustomerOrderState {}

class CustomerOrderLoaded extends CustomerOrderState {
  final List<CustomerOrder> orders;
  final List<CustomerOrder>? filteredOrders;
  final CustomerOrder? selectedCustomerOrder;
  final String? dateFilter;
  final String? statusFilter;
  final String? searchQuery;

  const CustomerOrderLoaded({
    required this.orders,
    this.filteredOrders,
    this.selectedCustomerOrder,
    this.dateFilter,
    this.statusFilter,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [
        orders,
        filteredOrders,
        selectedCustomerOrder,
        dateFilter,
        statusFilter,
        searchQuery,
      ];
}

class CustomerOrderError extends CustomerOrderState {
  final String message;

  const CustomerOrderError({required this.message});

  @override
  List<Object?> get props => [message];
}
