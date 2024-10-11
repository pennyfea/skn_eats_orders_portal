import 'package:flutter/material.dart';

import '../../components/components.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomLayout(
      header: [
        Text(
          'Item Availablity',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 10.0,),
        TextField(
          decoration: const InputDecoration(
            hintText: 'Search by name, email, or phone number',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (query) {},
        ),
        const SizedBox(height: 10.0,),
        const Divider(),
      ],
      widgets: const [
        MenuListView() 
      ],
    );
  }
}
