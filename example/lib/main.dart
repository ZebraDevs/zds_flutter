import 'package:flutter/material.dart';
import 'package:zds_flutter/zds_flutter.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

import 'routes.dart';

void main() => runApp(const DemoApp());

class DemoApp extends StatefulWidget {
  const DemoApp({Key? key}) : super(key: key);

  @override
  State<DemoApp> createState() => DemoAppState();
}

class DemoAppState extends State<DemoApp> {
  ZetaColorSwatch? _zetaColors;
  ZetaColorSwatch? get zetaColors => _zetaColors;
  set zetaColors(ZetaColorSwatch? value) => setState(() => _zetaColors = value);

  BrandColors? _brandColors = BrandColors.zdsDefault();
  BrandColors? get brandColors => _brandColors;
  set brandColors(BrandColors? value) => setState(() => _brandColors = value);

  @override
  Widget build(BuildContext context) {
    return ZdsApp(
      title: 'zds_flutter Demo',
      routes: kAllRoutes,
      colors: _brandColors,
      zetaColors: _zetaColors != null ? ZetaColors(primary: _zetaColors!, secondary: _zetaColors!) : null,
    );
  }
}
