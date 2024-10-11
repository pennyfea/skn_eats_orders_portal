import 'package:flutter/material.dart';

import '../../../data/models.dart';
import '../components.dart';

class PreparingOrderTile extends StatelessWidget {
  final CustomerOrder order;
  
  const PreparingOrderTile({super.key, required this.order});
  

  @override
  Widget build(BuildContext context) {

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
      // context.read<CustomerOrderBloc>().add(CustomerOrderUpdated(customerOrder: customerOrder));
    }

    return GestureDetector(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${order.firstName} ${order.lastName[0]}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${order.id.substring(0, 5)} • ${order.cartItems.length} item${order.cartItems.length > 1 ? 's' : ''}',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Ready in',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  _buildCountdown(order),
                ],
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  _handleReady(order);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Ready'),
              ),
            ],
          ),
        ),
      ),
      // onTap: () {
      //   context.read<CustomerOrderBloc>().add(SelectedCustomerOrder(customerOrder: order));
      //   _showCustomerOrderDialog(context, order);
      // },
    );

    

    
  }

  Widget _buildCountdown(CustomerOrder order) {
    final preparingTime = order.progress
        .firstWhere((progress) => progress.status == OrderStatus.preparing)
        .timestamp;

    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        final now = DateTime.now();
        final remainingTime = preparingTime.difference(now);
        final isOverdue = remainingTime.isNegative;

        return Text(
          isOverdue ? "Overdue" : _formatDuration(remainingTime),
          style: TextStyle(
            color: isOverdue ? Colors.red : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.abs().remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.abs().remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _showCustomerOrderDialog(BuildContext context, CustomerOrder order) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomerOrderDialog(customerOrder: order);
      },
    );
  }
}