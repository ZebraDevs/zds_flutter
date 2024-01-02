import 'package:flutter/material.dart';
import 'package:zds_flutter/zds_flutter.dart';

class InformationBarDemo extends StatelessWidget {
  const InformationBarDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final zeta = Zeta.of(context);
    return Scaffold(
      body: Column(children: [
        ZdsInformationBar(
          zetaColorSwatch: zeta.colors.green,
          icon: ZdsIcons.check,
          label: 'Approved',
        ),
        SizedBox(height: 10),
        ZdsInformationBar(
          zetaColorSwatch: zeta.colors.blue,
          icon: ZdsIcons.hourglass,
          label: 'Pending',
        ),
        SizedBox(height: 10),
        ZdsInformationBar(
          zetaColorSwatch: zeta.colors.red,
          icon: ZdsIcons.close,
          label: 'Declined',
        ),
        SizedBox(height: 10),
        ZdsInformationBar(
          icon: Icons.category,
          label: 'Neutral text',
          zetaColorSwatch: zeta.colors.warm,
        )
      ]),
    );
  }
}
