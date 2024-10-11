import 'package:flutter/material.dart';

import '../../../data/models.dart';

class PendingOrderTile extends StatelessWidget {
  final CustomerOrder order;
  
  const PendingOrderTile({super.key, required this.order});

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
                    '${order.firstName} ${order.lastName[0]}',
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
      // onTap: () {
      //   context.read<CustomerOrderBloc>().add(SelectedCustomerOrder(customerOrder: order));
      //   showFullScreenOrderDialog(context, order);
      // },
    );
  }

  // void showFullScreenOrderDialog(BuildContext context, CustomerOrder pendingOrder) async {
  //   bool? accepted = await showDialog<bool>(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return NewCustomerOrderDialog(customerOrders: [pendingOrder]);
  //     },
  //   );
  // }
}