import 'package:flutter/material.dart';

import '../../../data/models.dart';
import '../components.dart';

class CustomerOrderListView extends StatefulWidget {
  final CustomerOrder customerOrder;

  const CustomerOrderListView({super.key, required this.customerOrder});

  @override
  State<CustomerOrderListView> createState() => _CustomerOrderListViewState();
}

class _CustomerOrderListViewState extends State<CustomerOrderListView> {
  @override
  Widget build(BuildContext context) {
    int totalItems = widget.customerOrder.cartItems
        .fold(0, (sum, item) => sum + item.quantity);

    return Container(
      height: MediaQuery.of(context).size.height / 2,
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$totalItems Items',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.customerOrder.cartItems.length,
            itemBuilder: (context, index) {
              final item = widget.customerOrder.cartItems[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Text('${item.quantity} x',
                        style:
                            Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
                    title: Text(item.menuItem.name,
                        style:
                            Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
                    trailing: Text(
                        '\$${(item.menuItem.price * item.quantity).toStringAsFixed(2)}',
                        style:
                            Theme.of(context).textTheme.titleMedium),
                  ),
                  if (item.menuItem.requiredOptions != null &&
                      item.menuItem.requiredOptions!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: item.menuItem.requiredOptions!
                            .map((option) => Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        '${option.category}: ${option.choices.join(", ")}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge),
                                    Text(
                                        option.price != null
                                            ? '\$${option.price!.toStringAsFixed(2)}'
                                            : '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall)
                                  ],
                                ))
                            .toList(),
                      ),
                    ),
                  if (item.menuItem.optionalAddOns != null &&
                      item.menuItem.optionalAddOns!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: item.menuItem.optionalAddOns!
                            .map((option) => Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        '${option.category}: ${option.choices.join(", ")}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge),
                                    Text(
                                        option.price != null
                                            ? '\$${option.price!.toStringAsFixed(2)}'
                                            : '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall)
                                  ],
                                ))
                            .toList(),
                      ),
                    ),
                  if (item.specialInstructions != null &&
                      item.specialInstructions!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                          'Special Instructions: ${item.specialInstructions!}',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w700)),
                    ),
                ],
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider();
            },
          ),
          const SizedBox(height: 16),
          if (widget.customerOrder.notes != null &&
              widget.customerOrder.notes!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: CustomTextFormField(
                maxLine: 2,
                title: "Notes",
                hasTitle: true,
                initialValue: widget.customerOrder.notes!,
                readOnly: true,
              ),
            ),
          const SizedBox(height: 16),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                  'Subtotal: \$${widget.customerOrder.calculateSubtotal().toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
