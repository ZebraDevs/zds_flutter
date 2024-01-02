import 'package:flutter/material.dart';
import 'package:zds_flutter/zds_flutter.dart';

class StatsCardDemo extends StatelessWidget {
  const StatsCardDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ZdsList(
        children: [
          ZdsStatCard(
            stats: const [
              ZdsStat(value: 72.3, description: 'Par'),
            ],
            title: 'Course Details',
            subtitle: 'Really really long subtitle',
          ).padding(8),
          ZdsStatCard(
            stats: [
              const ZdsStat(value: 40, description: 'Total Hours'),
              ZdsStat(
                value: 32.4,
                description: 'Remaining',
                color: Zeta.of(context).colors.green,
              )
            ],
            title: 'Medical',
            subtitle: 'Accrual: 01/22/2022',
          ).padding(8),
          ZdsStatCard(
            stats: [
              const ZdsStat(value: 2.25, description: 'Total Days'),
              const ZdsStat(value: 1, description: 'Used'),
              ZdsStat(
                value: 1.75,
                description: 'Remaining',
                color: Zeta.of(context).colors.green,
              )
            ],
            title: 'Floating Holidays',
          ).padding(8),
          ZdsStatCard(
            stats: [
              const ZdsStat(value: 10, description: 'Total Hours'),
              const ZdsStat(value: 2, description: 'Used'),
              const ZdsStat(value: 3, description: 'Scheduled'),
              ZdsStat(
                value: 5,
                description: 'Remaining',
                color: Zeta.of(context).colors.green,
              )
            ],
            title: 'Vacation',
          ).padding(8),
          // Title-less card
          ZdsStatCard(
            subtitle: 'Subtitle',
            stats: const [
              ZdsStat(value: 7, description: 'Carbon'),
              ZdsStat(value: 16, description: 'Hydrogen'),
              ZdsStat(value: 1, description: 'Nitrogen'),
              ZdsStat(value: 2, description: 'Oxygen')
            ],
          ).padding(8),
        ],
      ),
    );
  }
}
