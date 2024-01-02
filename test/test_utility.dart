import 'package:flutter/material.dart';

Widget getTestWidget(Widget widget) {
  return MediaQuery(
    data: const MediaQueryData(),
    child: MaterialApp(home: widget),
  );
}
