import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/app_state_manager.dart';
import '../../../data/blocs.dart';
import '../../../data/models.dart';
import '../components.dart';

class PendingOrderTile extends StatelessWidget {
  final CustomerOrder order;
  
  const PendingOrderTile({super.key, required this.order});

  void _handleOrderUpdate(BuildContext context, CustomerOrder order, OrderStatus status) {
    final appStateManager = context.read<AppStateManager>();
    context.read<CustomerOrderBloc>().add(
      CustomerOrderUpdated(
        customerOrder: order.copyWith(status: status),
        locationId: appStateManager.locationId!,
        restaurantId: appStateManager.restaurantId!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.green,
        child: Container(
          height: 80,
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${order.firstName} ${order.lastName.isNotEmpty ? order.lastName[0] : ''}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    '${order.id.substring(0, 5)} • ${order.cartItems.length} item${order.cartItems.length > 1 ? 's' : ''}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'New',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () => _showOrderDialog(context),
    );
  }

  void _showOrderDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => NewCustomerOrderDialog(
        customerOrders: [order],
        onAccept: (order) => _handleOrderUpdate(context, order, OrderStatus.preparing),
        onCancel: (order) => _handleOrderUpdate(context, order, OrderStatus.cancel),
        onClose: () => Navigator.of(context).pop(),
      ),
    );
  }
}