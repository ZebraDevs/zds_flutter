# ZDS_Flutter example

To use any part of ZDS_Flutter, your app must be wrapped in `ZdsApp` as shown:

```dart

import 'package:flutter/material.dart';
import 'package:zds_flutter/zds_flutter.dart';

import 'routes.dart';

void main() => runApp(const DemoApp());

class DemoApp extends StatelessWidget {
  const DemoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ZdsApp(
      title: 'zds_flutter Demo',
      routes: kAllRoutes, // To use built in router from Material package
      home: HomeWidget(), // To use another router
      zetaColors: ZetaColors(...), // Optional: To use theme from zeta_flutter package
    );
  }
}
```
