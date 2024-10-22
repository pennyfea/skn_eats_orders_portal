import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/app_state_manager.dart';
import '../../../data/blocs.dart';
import '../../../data/models.dart';
import '../components.dart';

class PreparingOrderTile extends StatelessWidget {
  final CustomerOrder order;
  
  const PreparingOrderTile({super.key, required this.order});

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
  }

  void _showOrderDetails(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => CustomerOrderDialog(
        customerOrder: order,
        onClose: () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerOrderBloc, CustomerOrderState>(
      buildWhen: (previous, current) {
        if (current is CustomerOrderLoaded) {
          // Only rebuild if this specific order has changed
          final currentOrder = current.orders.firstWhere(
            (o) => o.id == order.id,
            orElse: () => order,
          );
          if (previous is CustomerOrderLoaded) {
            final previousOrder = previous.orders.firstWhere(
              (o) => o.id == order.id,
              orElse: () => order,
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
                (o) => o.id == order.id,
                orElse: () => order,
              )
            : order;
        
        // If the order is no longer preparing, we don't need to show this tile
        if (currentOrder.status != OrderStatus.preparing) {
          return const SizedBox.shrink();
        }
        
        return GestureDetector(
          onTap: () => _showOrderDetails(context),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            color: Colors.grey[200],
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${currentOrder.firstName} ${currentOrder.lastName.isNotEmpty ? currentOrder.lastName[0] : ''}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${currentOrder.id.substring(0, 5)} • ${currentOrder.cartItems.length} item${currentOrder.cartItems.length > 1 ? 's' : ''}',
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
                          _buildCountdown(currentOrder),
                        ],
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed:  () => _handleReady(context, currentOrder),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child:  const Text('Ready'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCountdown(CustomerOrder order) {
    final preparingProgress = order.progress
        .firstWhere((progress) => progress.status == OrderStatus.preparing);

    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        final now = DateTime.now();
        final elapsedTime = now.difference(preparingProgress.timestamp);
        const targetDuration = Duration(minutes: 35); // Adjust as needed
        final remainingTime = targetDuration - elapsedTime;
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
}