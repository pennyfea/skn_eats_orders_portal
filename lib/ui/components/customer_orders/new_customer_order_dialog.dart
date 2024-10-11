import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/responsive.dart';
import '../../../data/blocs.dart';
import '../../../data/models.dart';
import '../components.dart';

class NewCustomerOrderDialog extends StatefulWidget {
  final List<CustomerOrder> customerOrders;

  const NewCustomerOrderDialog({
    super.key,
    required this.customerOrders
  });

  @override
  State<NewCustomerOrderDialog> createState() => _NewCustomerOrderDialogState();
}

class _NewCustomerOrderDialogState extends State<NewCustomerOrderDialog> {
  int currentOrderIndex = 0;

  void _handleAccept(CustomerOrder updatedOrder) {
    // context.read<CustomerOrderBloc>().add(CustomerOrderUpdated(
    //   customerOrder: updatedOrder,
    // ));
  }

  void _handleCancel(CustomerOrder updatedOrder) {
    // context.read<CustomerOrderBloc>().add(CustomerOrderUpdated(
    //   customerOrder: updatedOrder,
    // ));
  }

  void _moveToNextOrder() {
    if (currentOrderIndex < widget.customerOrders.length - 1) {
      setState(() {
        currentOrderIndex++;
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CustomerOrderBloc, CustomerOrderState>(
      listener: (context, state) {
        if (state is CustomerOrderLoaded) {
          // Check if the current order has been accepted or cancelled
          if (state.orders.any((order) => 
              order.id == widget.customerOrders[currentOrderIndex].id && 
              order.status == OrderStatus.preparing)) {
            _moveToNextOrder();
          } else if (state.orders.any((order) => 
              order.id == widget.customerOrders[currentOrderIndex].id && 
              order.status == OrderStatus.cancel)) {
            _moveToNextOrder();
          }
        }
      },
      child: Dialog.fullscreen(
        backgroundColor: Colors.white,
        child: CustomLayout(
          header: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Text(
                  '${widget.customerOrders[currentOrderIndex].firstName} ${widget.customerOrders[currentOrderIndex].lastName[0]}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(width: 6),
                const Icon(Icons.circle, size: 10.0),
                const SizedBox(width: 6),
                Text(
                  widget.customerOrders[currentOrderIndex].id.substring(0,5), 
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                IconButton(
                  icon: const Icon(Icons.phone), 
                  onPressed: () => _showPhoneDialog(context, widget.customerOrders[currentOrderIndex])
                ),
                Text('Order ${currentOrderIndex + 1} of ${widget.customerOrders.length}'),
              ],
            )
          ],
          widgets: [
            if (Responsive.isWideDesktop(context) || Responsive.isDesktop(context))
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: CustomerOrderListView(customerOrder: widget.customerOrders[currentOrderIndex])),
                    Container(
                      width: 1,
                      color: Colors.grey[300],
                    ),
                    Expanded(child: CustomerOrderActionView(
                      customerOrder: widget.customerOrders[currentOrderIndex],
                      onAccept: _handleAccept,
                      onCancel: _handleCancel,
                    )),
                  ],
                ),
              )
            else
              Column(
                children: [
                  CustomerOrderListView(customerOrder: widget.customerOrders[currentOrderIndex]),
                  const Divider(),
                  CustomerOrderActionView(
                    customerOrder: widget.customerOrders[currentOrderIndex],
                    onAccept: _handleAccept,
                    onCancel: _handleCancel,
                  )
                ],
              )
          ],
        ),
      ),
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