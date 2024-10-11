import 'package:flutter/material.dart';

class CustomLayout extends StatelessWidget {

  final List<Widget>? header;
  final List<Widget> widgets;
  
  const CustomLayout({
    super.key,
    this.header,
    required this.widgets
  
    });

  @override
  Widget build(BuildContext context) {
    return  Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 4,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(title!, style: Theme.of(context).textTheme.headlineSmall,),
                    ...header!,
                    const SizedBox(height: 20,),
                    ...widgets,
                    const SizedBox(height: 20,),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}