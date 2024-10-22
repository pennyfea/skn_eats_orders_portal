import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/app_state_manager.dart';
import '../../../data/models.dart';
import '../../../data/blocs.dart';
import '../components.dart';

class CustomerOrderDialog extends StatelessWidget {
  final CustomerOrder customerOrder;
  final VoidCallback onClose;

  const CustomerOrderDialog({
    super.key,
    required this.customerOrder,
    required this.onClose,
  });

  String get _firstName => customerOrder.firstName;
  String get _lastName => customerOrder.lastName;
  String get _orderId => customerOrder.id.substring(0, 5);
  String get _phoneNumber => customerOrder.contactPhone;

  void _handleReady(BuildContext context, CustomerOrder order) {
    final now = DateTime.now();
    final newProgress = OrderProgress(
      timestamp: now,
      status: OrderStatus.ready,
    );

    final updatedOrder = order.copyWith(
      progress: [...order.progress, newProgress],
      status: OrderStatus.ready,
    );

    final appStateManager = context.read<AppStateManager>();
    context.read<CustomerOrderBloc>().add(
          CustomerOrderUpdated(
            customerOrder: updatedOrder,
            locationId: appStateManager.locationId!,
            restaurantId: appStateManager.restaurantId!,
          ),
        );
    onClose();
  }

  void _handleCancel(BuildContext context, CustomerOrder order) {
    final now = DateTime.now();
    final newProgress = OrderProgress(
      timestamp: now,
      status: OrderStatus.cancel,
    );

    final updatedOrder = order.copyWith(
      progress: [...order.progress, newProgress],
      status: OrderStatus.cancel,
    );

    final appStateManager = context.read<AppStateManager>();
    context.read<CustomerOrderBloc>().add(
          CustomerOrderUpdated(
            customerOrder: updatedOrder,
            locationId: appStateManager.locationId!,
            restaurantId: appStateManager.restaurantId!,
          ),
        );
    onClose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerOrderBloc, CustomerOrderState>(
      buildWhen: (previous, current) {
        if (current is CustomerOrderLoaded) {
          final currentOrder = current.orders.firstWhere(
            (o) => o.id == customerOrder.id,
            orElse: () => customerOrder,
          );
          if (previous is CustomerOrderLoaded) {
            final previousOrder = previous.orders.firstWhere(
              (o) => o.id == customerOrder.id,
              orElse: () => customerOrder,
            );
            return currentOrder != previousOrder;
          }
          return true;
        }
        return false;
      },
      builder: (context, state) {
        final currentOrder = state is CustomerOrderLoaded
            ? state.orders.firstWhere(
                (o) => o.id == customerOrder.id,
                orElse: () => customerOrder,
              )
            : customerOrder;

        final bool isOrderCancelled = currentOrder.status == OrderStatus.cancel;
        final bool isOrderReady = currentOrder.status == OrderStatus.ready;

        return Dialog.fullscreen(
          backgroundColor: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              CustomerOrderListView(customerOrder: currentOrder),
              const Divider(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MaterialButton(
                      height: 50.0,
                      textColor: Colors.white,
                      color: Colors.red,
                      disabledColor: Colors.grey,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0)),
                      onPressed: isOrderCancelled || isOrderReady
                          ? null
                          : () => _handleCancel(context, currentOrder),
                      child:
                          const Text('Cancel', style: TextStyle(fontSize: 18)),
                    ),
                    const SizedBox(height: 8),
                    MaterialButton(
                      height: 50.0,
                      textColor: Colors.white,
                      color: Colors.green,
                      disabledColor: Colors.grey,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0)),
                      onPressed: isOrderCancelled || isOrderReady
                          ? null
                          : () => _handleReady(context, currentOrder),
                      child:
                          const Text('Ready', style: TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(width: 6),
        const Icon(Icons.circle, size: 10.0),
        const SizedBox(width: 6),
        Text(_orderId, style: Theme.of(context).textTheme.headlineSmall),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Row(
            children: [
              IconButton(
                  icon: const Icon(Icons.phone),
                  onPressed: () => _showPhoneDialog(context)),
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
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
