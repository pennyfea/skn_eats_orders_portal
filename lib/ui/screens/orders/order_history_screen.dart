import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/blocs.dart';
import '../../../data/models.dart';
import '../../components/components.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomLayout(
      header: [
        Text(
          'Order History',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        _buildFilterBar(context),
      ],
      widgets: [
        BlocBuilder<CustomerOrderBloc, CustomerOrderState>(
          builder: (context, state) {
            if (state is CustomerOrderLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CustomerOrderLoaded) {
              final ordersToDisplay = state.filteredOrders?.isNotEmpty ?? false
                  ? state.filteredOrders!
                  : state.orders;

              if (ordersToDisplay.isEmpty) {
                return  Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'No orders available for the selected filters.',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                );
              }

              return SingleChildScrollView(
                primary: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildFilteredOrders(
                        ordersToDisplay, state.statusFilter ?? 'All orders'),
                  ],
                ),
              );
            } else if (state is CustomerOrderError) {
              return Center(
                  child: Text('Error loading orders: ${state.message}'));
            } else {
              return const Center(child: Text('No orders available'));
            }
          },
        ),
      ],
    );
  }

  Widget _buildFilterBar(BuildContext context) {
    return BlocBuilder<CustomerOrderBloc, CustomerOrderState>(
      builder: (context, state) {
        if (state is CustomerOrderLoaded) {
          // Define default values for filters
          String defaultDateFilter = state.dateFilter ?? 'Today';
          String defaultStatusFilter = state.statusFilter ?? 'All orders';

          return Row(
            children: [
              DropdownButton<String>(
                value: defaultDateFilter,
                items: ['Today', 'Yesterday', 'Last 7 days', 'Last 30 days']
                    .map((String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    context
                        .read<CustomerOrderBloc>()
                        .add(FilterOrdersByDate(dateFilter: value));
                  }
                },
              ),
              const SizedBox(width: 16),
              DropdownButton<String>(
                value: defaultStatusFilter,
                items: [
                  'All orders',
                  'Completed',
                  'Delivery In progress',
                  'Preparing',
                  'Pending',
                  'Cancelled'
                ]
                    .map((String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    context
                        .read<CustomerOrderBloc>()
                        .add(FilterOrdersByStatus(statusFilter: value));
                  }
                },
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => _showSearchDialog(context),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String searchQuery = '';
        return AlertDialog(
          title: const Text('Search Orders'),
          content: TextField(
            onChanged: (value) {
              searchQuery = value;
            },
            decoration: const InputDecoration(
                hintText: "Enter customer name or order ID"),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Search'),
              onPressed: () {
                context
                    .read<CustomerOrderBloc>()
                    .add(SearchOrders(searchQuery: searchQuery));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilteredOrders(List<CustomerOrder> orders, String statusFilter) {
    final filteredOrders = _filterOrdersByStatus(orders, statusFilter);

    if (filteredOrders.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'No orders available for the selected filters.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    if (statusFilter == 'All orders') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOrderSection(
              'Orders pending',
              filteredOrders
                  .where((order) => order.status == OrderStatus.pending)
                  .toList()),
          const SizedBox(height: 24),
          _buildOrderSection(
              'Orders being prepared',
              filteredOrders
                  .where((order) =>
                      order.status == OrderStatus.preparing ||
                      order.status == OrderStatus.ready)
                  .toList()),
          const SizedBox(height: 24),
          _buildOrderSection(
              'Completed',
              filteredOrders
                  .where((order) => order.status == OrderStatus.completed)
                  .toList()),
          const SizedBox(height: 24),
          _buildOrderSection(
              'Delivery in progress',
              filteredOrders
                  .where(
                      (order) => order.status == OrderStatus.deliveryInPorgress)
                  .toList()),
          const SizedBox(height: 24),
          _buildOrderSection(
              'Cancelled',
              filteredOrders
                  .where((order) => order.status == OrderStatus.cancel)
                  .toList()),
        ],
      );
    } else {
      return _buildOrderSection(statusFilter, filteredOrders);
    }
  }

  List<CustomerOrder> _filterOrdersByStatus(
      List<CustomerOrder> orders, String statusFilter) {
    switch (statusFilter) {
      case 'Pending':
        return orders
            .where((order) => order.status == OrderStatus.pending)
            .toList();
      case 'Preparing':
        return orders
            .where((order) =>
                order.status == OrderStatus.preparing ||
                order.status == OrderStatus.ready)
            .toList();
      case 'Completed':
        return orders
            .where((order) => order.status == OrderStatus.completed)
            .toList();
      case 'Delivery In progress':
        return orders
            .where((order) => order.status == OrderStatus.deliveryInPorgress)
            .toList();
      case 'Cancelled':
        return orders
            .where((order) => order.status == OrderStatus.cancel)
            .toList();
      default:
        return orders;
    }
  }

  Widget _buildOrderSection(String title, List<CustomerOrder> orders) {
    if (orders.isEmpty) {
      return Padding(
        padding:  const EdgeInsets.all(16.0),
        child: Text(
          'No orders available for $title.',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title (${orders.length})',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: orders.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) =>
              OrderHistoryTile(order: orders[index]),
        ),
      ],
    );
  }
}
