import 'package:flutter/material.dart';

import '../../../data/models.dart';

class ReadyOrderTile extends StatelessWidget {
  final CustomerOrder order;
  
  const ReadyOrderTile({super.key, required this.order});
  

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      child: Card(
        elevation: 2,
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
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${order.id.substring(0, 5)} • ${order.cartItems.length} item${order.cartItems.length > 1 ? 's' : ''}',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Arriving in',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(width: 8),
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

  // void _showCustomerOrderDialog(BuildContext context, CustomerOrder order) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return CustomerOrderDialog(customerOrder: order);
  //     },
  //   );
  // }
}