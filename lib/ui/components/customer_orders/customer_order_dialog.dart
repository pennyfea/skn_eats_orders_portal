import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models.dart';
import '../../../data/blocs.dart';
import '../components.dart';

class CustomerOrderDialog extends StatefulWidget {
  final CustomerOrder customerOrder;

  const CustomerOrderDialog({
    super.key,
    required this.customerOrder
  });

  @override
  State<CustomerOrderDialog> createState() => _CustomerOrderDialogState();
}

class _CustomerOrderDialogState extends State<CustomerOrderDialog> {
  int currentOrderIndex = 0;

  void _handleReady(CustomerOrder updatedOrder) {
    final now = DateTime.now();

    final newProgress = OrderProgress(
      timestamp: now,
      status: OrderStatus.ready,
    );

    final customerOrder = updatedOrder.copyWith(
      progress: [...updatedOrder.progress, newProgress],
      status: OrderStatus.ready,
    );
    
    // context.read<CustomerOrderBloc>().add(CustomerOrderUpdated(
    //   customerOrder: customerOrder,
    // ));
    Navigator.of(context).pop();
  }


  void _handleCancel(CustomerOrder updatedOrder) {
    final now = DateTime.now();

    final newProgress = OrderProgress(
      timestamp: now,
      status: OrderStatus.cancel,
    );

    final customerOrder = updatedOrder.copyWith(
      progress: [...updatedOrder.progress, newProgress],
      status: OrderStatus.cancel,
    );

    // context.read<CustomerOrderBloc>().add(CustomerOrderUpdated(
    //   customerOrder: customerOrder,
    // ));
    
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerOrderBloc, CustomerOrderState>(
      builder: (context, state) {
        if (state is CustomerOrderLoaded) {
          final customerOrder = state.selectedCustomerOrder ?? widget.customerOrder;
          final bool isOrderCancelled = customerOrder.status == OrderStatus.cancel;
          final bool isOrderReady = customerOrder.status == OrderStatus.ready;
          return Dialog.fullscreen(
            backgroundColor: Colors.white,
            child: CustomLayout(
              header: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        context.read<CustomerOrderBloc>().add(UnSelectCustomerOrder());
                        Navigator.of(context).pop();
                      }
                    ),
                    Text(
                      '${customerOrder.firstName} ${customerOrder.lastName[0]}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.circle, size: 10.0),
                    const SizedBox(width: 6),
                    Text(
                      customerOrder.id, 
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    IconButton(
                      icon: const Icon(Icons.phone), 
                      onPressed: () => _showPhoneDialog(context, customerOrder)
                    ),
                  ],
                )
              ],
              widgets: [
                Column(
                  children: [
                    CustomerOrderListView(customerOrder: customerOrder),
                    const Divider(),
                    MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      height: 50.0,
                      textColor: Colors.white,
                      color: Colors.red,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                      onPressed: isOrderCancelled || isOrderReady ? null : () => _handleCancel(customerOrder),
                      child: const Text('Cancel', style: TextStyle(fontSize: 18)),
                    ),
                    const SizedBox(height: 5,),
                    MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      height: 50.0,
                      textColor: Colors.white,
                      color: Colors.green,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                      onPressed: isOrderCancelled || isOrderReady ? null : () => _handleReady(customerOrder),
                      child: const Text('Ready', style: TextStyle(fontSize: 18)),
                    ),
                  ],
                )
              ],
            ),
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }

  void _showPhoneDialog(BuildContext context, CustomerOrder currentOrder) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Contact Information'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${currentOrder.firstName} ${currentOrder.lastName}'),
              const SizedBox(height: 8),
              Text('Phone: ${currentOrder.contactPhone}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}