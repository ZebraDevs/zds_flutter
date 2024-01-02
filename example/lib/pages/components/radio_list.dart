import 'package:flutter/material.dart';

import 'package:zds_flutter/zds_flutter.dart';

enum WalkDateRange {
  currentWeek,
  lastWeek,
  currentMonth,
  lastMonth,
  yearToDate,
  lastXDays,
  specificDates,
}

class WalkDate extends ZdsRadioItem<WalkDateRange> {
  const WalkDate(String label, WalkDateRange value) : super(label, value);
}

class RadioListDemo extends StatelessWidget {
  const RadioListDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            ZdsRadioList(
              initialValue: const WalkDate('Current Month', WalkDateRange.currentMonth),
              items: const [
                WalkDate('Current Week', WalkDateRange.currentWeek),
                WalkDate('Last Week', WalkDateRange.lastWeek),
                WalkDate('Current Month', WalkDateRange.currentMonth),
                WalkDate('Last Month', WalkDateRange.lastMonth),
                WalkDate('YTD', WalkDateRange.yearToDate),
                WalkDate('Last X days', WalkDateRange.lastXDays),
                WalkDate('Specific Dates', WalkDateRange.specificDates),
              ],
              onChange: (item) => debugPrint(item is WalkDate ? item.label : ''),
            ).space(),
            ZdsRadioList(
              initialValue: const WalkDate('Current Month', WalkDateRange.currentMonth),
              condensed: true,
              items: const [
                WalkDate('Current Week', WalkDateRange.currentWeek),
                WalkDate('Last Week', WalkDateRange.lastWeek),
                WalkDate('Current Month', WalkDateRange.currentMonth),
                WalkDate('Last Month', WalkDateRange.lastMonth),
                WalkDate('YTD', WalkDateRange.yearToDate),
                WalkDate('Last X days', WalkDateRange.lastXDays),
                WalkDate('Specific Dates', WalkDateRange.specificDates),
              ],
              onChange: (item) => debugPrint(item is WalkDate ? item.label : ''),
            ).space(),
            ZdsCard(
              padding: EdgeInsets.zero,
              child: ZdsExpansionTile(
                initiallyExpanded: true,
                title: const Text('Walk Date'),
                contentPadding: EdgeInsets.zero,
                child: ZdsRadioList(
                  items: const [
                    WalkDate('Current Week', WalkDateRange.currentWeek),
                    WalkDate('Last Week', WalkDateRange.lastWeek),
                    WalkDate('Current Month', WalkDateRange.currentMonth),
                    WalkDate('Last Month', WalkDateRange.lastMonth),
                    WalkDate('YTD', WalkDateRange.yearToDate),
                    WalkDate('Last X days', WalkDateRange.lastXDays),
                    WalkDate('Specific Dates', WalkDateRange.specificDates),
                  ],
                  onChange: (item) => debugPrint(item is WalkDate ? item.label : ''),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
