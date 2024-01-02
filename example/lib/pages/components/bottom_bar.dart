import 'package:flutter/material.dart';

import 'package:zds_flutter/zds_flutter.dart';

class BottomBarDemo extends StatelessWidget {
  const BottomBarDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ZdsBottomBar(
        child: Row(
          children: [
            ZdsButton.outlined(
              child: const Text('Save'),
              onTap: () {},
            ),
            const Spacer(),
            ZdsButton.outlined(
              child: const Text('Clear'),
              onTap: () {},
            ),
            const SizedBox(width: 8),
            ZdsButton(
              child: const Text('Cancel'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
