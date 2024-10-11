import 'package:flutter/material.dart';

import '../../../data/models.dart';
import '../components.dart';

class CustomerOrderListView extends StatelessWidget {

  
  final CustomerOrder customerOrder;
  
  const CustomerOrderListView({
    super.key,
    required this.customerOrder
  });


  @override
  Widget build(BuildContext context) {

    int totalItems = customerOrder.cartItems.fold(0, (sum, item) => sum + item.quantity);

    return Container(
      height: MediaQuery.of(context).size.height / 2,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$totalItems Items', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: customerOrder.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = customerOrder.cartItems[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Text('${item.quantity} x', style: Theme.of(context).textTheme.headlineSmall),
                            title: Text(item.menuItem.name, style: Theme.of(context).textTheme.headlineSmall),
                            trailing: Text('\$${(item.menuItem.price * item.quantity).toStringAsFixed(2)}', style: Theme.of(context).textTheme.headlineSmall),
                          ),
                          if (item.menuItem.requiredOptions != null && item.menuItem.requiredOptions!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: item.menuItem.requiredOptions!.map((option) => 
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('${option.category}: ${option.choices.join(", ")}',
                                        style: Theme.of(context).textTheme.titleLarge),
                                      Text(option.price != null ? '\$${option.price!.toStringAsFixed(2)}' : '',
                                       style: Theme.of(context).textTheme.headlineSmall)
                                    ],
                                  )
                                ).toList(),
                              ),
                            ),
                          if (item.menuItem.optionalAddOns != null && item.menuItem.optionalAddOns!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: item.menuItem.optionalAddOns!.map((option) => 
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('${option.category}: ${option.choices.join(", ")}',
                                        style: Theme.of(context).textTheme.titleLarge),
                                      Text(option.price != null ? '\$${option.price!.toStringAsFixed(2)}' : '',
                                      style: Theme.of(context).textTheme.headlineSmall
                                      )
                                    ],
                                  )
                                ).toList(),
                              ),
                            ),
                          if (item.specialInstructions != null && item.specialInstructions!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Text('Special Instructions: ${item.specialInstructions!}',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontStyle: FontStyle.italic, fontWeight: FontWeight.w700)),
                            ),
                        ],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider();
                    },
                  ),
                  const SizedBox(height: 16),
                  if (customerOrder.notes != null && customerOrder.notes!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: CustomTextFormField(
                        maxLine: 2,
                        title: "Notes",
                        hasTitle: true,
                        initialValue: customerOrder.notes!,
                        readOnly: true,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('Subtotal: \$${customerOrder.calculateSubtotal().toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.headlineSmall),
            ],
          ),
        ],
      ),
    );
  }
}