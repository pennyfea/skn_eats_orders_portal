import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/blocs.dart';
import '../../../data/models.dart';
import '../../components/components.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerOrderBloc, CustomerOrderState>(
      builder: (context, state) {
        return CustomLayout(
          header: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Orders',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                if (state is CustomerOrderLoaded)
                  Text(
                    'Results: ${state.orders.length}',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontSize: 16),
                  ),
              ],
            ),
          ],
          widgets: [
            if (state is CustomerOrderLoading)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (state is CustomerOrderLoaded)
              _buildOrderLists(context, state.orders)
            else if (state is CustomerOrderError)
              Center(
                child: Text(
                  'Error: ${state.message}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.red,
                  ),
                ),
              )
            else
              const Center(
                child: Text('Unexpected state'),
              ),
          ],
        );
      },
    );
  }

  Widget _buildOrderLists(BuildContext context, List<CustomerOrder> orders) {
    if (orders.isEmpty) {
      return Container(
        color: Colors.white,
        child: Center(
          child: Text(
            "No orders available",
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontSize: 20),
          ),
        ),
      );
    }

    final preparingOrders = <CustomerOrder>[];
    final pendingOrders = <CustomerOrder>[];
    final readyOrders = <CustomerOrder>[];

    // Sort orders into appropriate lists
    for (final order in orders) {
      switch (order.status) {
        case OrderStatus.preparing:
          preparingOrders.add(order);
          break;
        case OrderStatus.pending:
          pendingOrders.add(order);
          break;
        case OrderStatus.ready:
          readyOrders.add(order);
          break;
        default:
          break;
      }
    }

    // Combine preparing and pending orders
    final combinedOrders = [...preparingOrders, ...pendingOrders];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildOrderSection(
            context,
            'Preparing',
            combinedOrders,
            (order) => order.status == OrderStatus.pending
                ? PendingOrderTile(order: order)
                : PreparingOrderTile(order: order),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _buildOrderSection(
            context,
            'Ready',
            readyOrders,
            (order) => ReadyOrderTile(order: order),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSection(
    BuildContext context,
    String title,
    List<CustomerOrder> orders,
    Widget Function(CustomerOrder) buildTile,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$title (${orders.length})',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (orders.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text(
                'No $title orders',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey,
                ),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: orders.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) => buildTile(orders[index]),
          ),
      ],
    );
  }
}