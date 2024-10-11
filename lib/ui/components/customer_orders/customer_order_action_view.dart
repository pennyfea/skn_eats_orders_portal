import 'package:flutter/material.dart';

import '../../../data/models.dart';

class CustomerOrderActionView extends StatefulWidget {
  final CustomerOrder customerOrder;
  final Function(CustomerOrder updatedOrder) onAccept;
  final Function(CustomerOrder updatedOrder) onCancel;
  

  const CustomerOrderActionView({
    super.key,
    required this.customerOrder,
    required this.onAccept,
    required this.onCancel,
  });

  @override
  State<CustomerOrderActionView> createState() => _CustomerOrderActionViewState();
}

class _CustomerOrderActionViewState extends State<CustomerOrderActionView> {
  late TimeOfDay selectedTime;

  @override
  void initState() {
    super.initState();
    selectedTime = const TimeOfDay(hour: 0, minute: 30); // Default 30 minutes
  }

  void _handleAccept() {
    final now = DateTime.now();
    final readyTime = now.add(Duration(minutes: selectedTime.minute));

    final newProgress = OrderProgress(
      timestamp: readyTime,
      status: OrderStatus.preparing,
    );

    final acceptedOrder = widget.customerOrder.copyWith(
      progress: [...widget.customerOrder.progress, newProgress],
      status: OrderStatus.preparing,
    );

    widget.onAccept(acceptedOrder);
  }

  void _handleCancel() {
    final now = DateTime.now();

    final newProgress = OrderProgress(
      timestamp: now,
      status: OrderStatus.cancel,
    );

    final cancelledOrder = widget.customerOrder.copyWith(
      progress: [...widget.customerOrder.progress, newProgress],
      status: OrderStatus.cancel,
    );

    widget.onCancel(cancelledOrder);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Ready time', style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 20)),
                  const SizedBox(height: 8),
                  Text('${selectedTime.minute} min', style: Theme.of(context).textTheme.headlineLarge),
                  if (selectedTime == const TimeOfDay(hour: 0, minute: 30))
                    Text(
                      'Suggested', 
                      style: Theme.of(context).textTheme.bodyMedium!
                        .copyWith(color: Colors.green, fontWeight: FontWeight.w700)
                    ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 80,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () => selectTime(context),
                      child: const Row(
                        children: [
                          SizedBox(width: 5,),
                          Icon(Icons.edit),
                          SizedBox(width: 5,),
                          Text('Edit'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            height: 50.0,
            textColor: Colors.white,
            color: Colors.red,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
            onPressed: _handleCancel,
            child: const Text('Cancel', style: TextStyle(fontSize: 18)),
          ),
          const SizedBox(height: 5,),
          MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            height: 50.0,
            textColor: Colors.white,
            color: Colors.black,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),

            onPressed: _handleAccept,
            child: const Text('Accept', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }

  Future<void> selectTime(BuildContext context) async {
    final int? picked = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        int selectedMinutes = selectedTime.minute;
        return AlertDialog(
          title: const Center(child: Text('Set Ready Time')),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('$selectedMinutes minutes', style: Theme.of(context).textTheme.headlineMedium),
                  Slider(
                    value: selectedMinutes.toDouble(),
                    min: 5,
                    max: 120,
                    divisions: 23,
                    label: selectedMinutes.toString(),
                    onChanged: (double value) {
                      setState(() {
                        selectedMinutes = value.round();
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(selectedMinutes)
            ),
          ],
        );
      },
    );

    if (picked != null && picked != selectedTime.minute) {
      setState(() {
        selectedTime = TimeOfDay(hour: 0, minute: picked);
      });
    }
  }
}