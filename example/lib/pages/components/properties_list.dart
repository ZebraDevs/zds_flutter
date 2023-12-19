import 'package:flutter/material.dart';

import 'package:zds_flutter/zds_flutter.dart';

class PropertiesListDemo extends StatelessWidget {
  const PropertiesListDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(14),
              child: ZdsCard(
                child: ZdsPropertiesList(
                  title: Text('4 # Walks'),
                  properties: {
                    'Points Scored': '380',
                    'Total Points': '700',
                    'Score (%)': '42.12',
                    'Passed (%)': '25.00',
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(14),
              child: ZdsCard(
                child: ZdsPropertiesList(
                  direction: ZdsPropertiesListDirection.vertical,
                  properties: {
                    'Walk Description': 'A monthly store walk that Field Leadership should conduct with their stores.',
                    'Start Date': '04/19/2021 03:35 PM',
                    'End Date': '04/19/2021 11:59 PM',
                    'Assign Unit': 'SR-ROC-Rockford IL.00102',
                    'Type of Visit': 'Ad hoc',
                    'Claim Date': '04/19/2021 03:35 PM',
                    'User Name': 'Jason',
                    'Announced Visit': 'Yes',
                    'Walk Unique ID': 'WALK_688',
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
