import 'package:flutter/material.dart';
import 'package:zds_flutter/zds_flutter.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

class IconTextButtonDemo extends StatelessWidget {
  const IconTextButtonDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Row(
            // Replace with a Column for vertical
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const ZdsIconTextButton(
                icon: ZdsIcons.timecard,
                label: 'Timecard',
              ),
              ZdsIconTextButton(
                onTap: () => {onButtonTapped(context)},
                icon: ZdsIcons.clock_switch,
                label: 'Shift Trade',
                backgroundColor: ZetaColors.of(context).orange,
              ),
              ZdsIconTextButton(
                onTap: () => {onButtonTapped(context)},
                icon: ZdsIcons.clock_available,
                label: 'Availability',
                backgroundColor: ZetaColors.of(context).pink,
              )
            ],
          ),
        ),
      ),
    );
  }
}

void onButtonTapped(BuildContext context) {
  // Button click event handled here
}
