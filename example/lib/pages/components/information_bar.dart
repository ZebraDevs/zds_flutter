import 'package:flutter/material.dart';
import 'package:zds_flutter/zds_flutter.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

class InformationBarDemo extends StatelessWidget {
  const InformationBarDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        ZdsInformationBar(
          zetaColorSwatch: ZetaColors.of(context).green,
          icon: ZdsIcons.check,
          label: 'Approved',
        ),
        SizedBox(height: 10),
        ZdsInformationBar(
          zetaColorSwatch: ZetaColors.of(context).blue,
          icon: ZdsIcons.hourglass,
          label: 'Pending',
        ),
        SizedBox(height: 10),
        ZdsInformationBar(
          zetaColorSwatch: ZetaColors.of(context).red,
          icon: ZdsIcons.close,
          label: 'Declined',
        ),
        SizedBox(height: 10),
        ZdsInformationBar(
          icon: Icons.category,
          label: 'Neutral text',
          zetaColorSwatch: ZetaColors.of(context).warm,
        )
      ]),
    );
  }
}
