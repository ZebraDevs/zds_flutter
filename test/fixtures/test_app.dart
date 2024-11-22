import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:zds_flutter/zds_flutter.dart';

class TestApp extends StatelessWidget {
  const TestApp({super.key, required this.builder});
  final WidgetBuilder builder;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: <LocalizationsDelegate<dynamic>>[
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        ComponentDelegate(testing: true),
      ],
      home: ZetaProvider(
        builder: (context, themeData, themeMode) {
          return Scaffold(body: builder.call(context));
        },
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<WidgetBuilder>.has('builder', builder));
  }
}
