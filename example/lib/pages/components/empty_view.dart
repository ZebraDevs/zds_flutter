import 'package:flutter/material.dart';

import 'package:zds_flutter/zds_flutter.dart';

class EmptyViewDemo extends StatelessWidget {
  const EmptyViewDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Custom').padding(16),
            const ZdsEmpty(
              icon: Icon(ZdsIcons.funnel),
              message: Text('No saved filters available'),
            ),
            const Divider().paddingOnly(top: 32, bottom: 16),
            const Text('Default'),
            const ZdsEmpty(),
          ],
        ),
      ),
    );
  }
}
