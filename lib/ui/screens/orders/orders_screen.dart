import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/blocs.dart';
import '../../../data/models.dart';
import '../../components/components.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomLayout(
      header: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Orders',
              style: Theme.of(context).textTheme.headlineSmall,
            )
          ],
        ),
        BlocBuilder<CustomerOrderBloc, CustomerOrderState>(
          builder: (context, state) {
            int customerOrderCount = 0;
            if (state is CustomerOrderLoaded) {
              customerOrderCount = state.orders.length;
            }
            return Text(
              'Results: $customerOrderCount',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontSize: 16),
            );
          },
        ),
      ],
      widgets: [
        BlocBuilder<CustomerOrderBloc, CustomerOrderState>(
          builder: (context, state) {
            if (state is CustomerOrderLoading) {
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (state is CustomerOrderLoaded) {
              List<CustomerOrder> customerOrders = state.orders;
              final pendingOrders = customerOrders
                  .where((order) => order.status == OrderStatus.pending)
                  .toList();
              final preparingOrders = customerOrders
                  .where((order) => order.status == OrderStatus.preparing)
                  .toList();
              final combinedOrders = [...preparingOrders, ...pendingOrders];
              final readyOrders = customerOrders
                  .where((order) => order.status == OrderStatus.ready)
                  .toList();
              if (customerOrders.isEmpty) {
                return Container(
                    color: Colors.white,
                    child: Center(
                        child: Text(
                      "No orders available",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(fontSize: 20),
                    )));
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Preparing (${combinedOrders.length})',
                            style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 10),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: combinedOrders.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final order = combinedOrders[index];
                            return order.status == OrderStatus.pending
                                ? PendingOrderTile(order: order)
                                : PreparingOrderTile(order: order);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ready (${readyOrders.length})',
                            style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 10),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: readyOrders.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final order = readyOrders[index];
                            return ReadyOrderTile(order: order);
                          },
                        ),
                      ],
                    ),
                  )
                ],
              );
            } else {
              return const Text('Something went wrong with loading orders');
            }
          },
        ),
      ],
    );
  }
}
