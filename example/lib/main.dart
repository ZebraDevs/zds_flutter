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
      routes: kAllRoutes,
    );
  }
}
