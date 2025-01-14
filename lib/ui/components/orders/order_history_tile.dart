import 'package:flutter/material.dart';

import '../../../data/models.dart';

class OrderHistoryTile extends StatelessWidget {
  final CustomerOrder order;

  const OrderHistoryTile({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${order.firstName} ${order.lastName[0]}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(order.id.substring(0,5), style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                  const SizedBox(width: 40.0,),
                  SizedBox(height: 47,
                  child: Text('\$${order.total.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18) ,
                    ),
                  )
                ],
              ),
            ),
            Text(order.status.toDisplayString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.phone),
              onPressed: () {
                // TODO: Implement call action
              },
            ),
          ],
        ),
      ),
    );
  }
}