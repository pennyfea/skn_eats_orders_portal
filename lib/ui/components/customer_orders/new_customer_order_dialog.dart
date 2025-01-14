import 'package:flutter/material.dart';
import '../../../data/models.dart';
import '../components.dart';

class NewCustomerOrderDialog extends StatefulWidget {
  final List<CustomerOrder> customerOrders;
  final Function(CustomerOrder) onAccept;
  final Function(CustomerOrder) onCancel;
  final VoidCallback onClose;

  const NewCustomerOrderDialog({
    super.key,
    required this.customerOrders,
    required this.onAccept,
    required this.onCancel,
    required this.onClose,
  });

  @override
  State<NewCustomerOrderDialog> createState() => _NewCustomerOrderDialogState();
}

class _NewCustomerOrderDialogState extends State<NewCustomerOrderDialog> {
  int _currentOrderIndex = 0;

  void _moveToNextOrder() {
    if (_currentOrderIndex < widget.customerOrders.length - 1) {
      setState(() {
        _currentOrderIndex++;
      });
    } else {
      widget.onClose();
    }
  }

  String get _firstName => widget.customerOrders[_currentOrderIndex].firstName;
  String get _lastName => widget.customerOrders[_currentOrderIndex].lastName;
  String get _orderId =>
      widget.customerOrders[_currentOrderIndex].id.substring(0, 5);
  String get _phoneNumber =>
      widget.customerOrders[_currentOrderIndex].contactPhone;

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        _buildHeader(context),
                        Expanded(
                          child: CustomerOrderListView(
                            customerOrder:
                                widget.customerOrders[_currentOrderIndex],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    color: Colors.grey[300],
                  ),
                  Expanded(
                    child: CustomerOrderActionView(
                      customerOrder: widget.customerOrders[_currentOrderIndex],
                      onAccept: (order) {
                        widget.onAccept(order);
                        _moveToNextOrder();
                      },
                      onCancel: (order) {
                        widget.onCancel(order);
                        _moveToNextOrder();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        const SizedBox(width: 10),
        Text('$_firstName $_lastName',
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(width: 6),
        const Icon(Icons.circle, size: 10.0),
        const SizedBox(width: 6),
        Text(_orderId, style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold)),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Row(
            children: [
              IconButton(
                  icon: const Icon(Icons.phone),
                  onPressed: () => _showPhoneDialog(context)),
              const SizedBox(width: 6),
              Text(
                  'Order ${_currentOrderIndex + 1} of ${widget.customerOrders.length}',
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }

  void _showPhoneDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Contact Information'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: $_firstName $_lastName'),
              const SizedBox(height: 8),
              Text('Phone: $_phoneNumber'),
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
