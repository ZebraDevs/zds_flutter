import 'package:flutter/material.dart';
import 'package:zds_flutter/zds_flutter.dart';

class BigToggleButtonDemo extends StatefulWidget {
  const BigToggleButtonDemo({Key? key}) : super(key: key);

  @override
  State<BigToggleButtonDemo> createState() => _BigToggleButtonDemoState();
}

class _BigToggleButtonDemoState extends State<BigToggleButtonDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ZdsList(
        children: [
          ZdsToggleButton(
            values: const ['A', 'B', 'C', 'D'],
            onToggleCallback: print,
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(height: 10),
          const ZdsToggleButton(
            values: ['Approved', 'Rejected'],
            onToggleCallback: print,
            margin: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}
