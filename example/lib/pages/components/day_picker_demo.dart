import 'package:flutter/material.dart';
import 'package:zds_flutter/zds_flutter.dart';

class DayPickerDemo extends StatefulWidget {
  const DayPickerDemo({Key? key}) : super(key: key);

  @override
  State<DayPickerDemo> createState() => _DayPickerDemoState();
}

class _DayPickerDemoState extends State<DayPickerDemo> {
  int inc = 0;
  List<DateTime> initialSelectedDates = [DateTime.now().add(const Duration(days: 2))];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Text('Select individual'),
          ZdsDayPicker(
            startingWeekDate: DateTime.now().add(const Duration(days: -2)),
            header: 'Days',
            disableDaysList: const [0, 1],
            onDaySelected: (List<DateTime> selectedDates) {
              debugPrint('selected day details $selectedDates');
            },
          ).padding(10),
          const Text('Select multiple').paddingOnly(top: 20),
          ZdsDayPicker(
            allowMultiSelect: true,
            startingWeekDate: DateTime.now().add(const Duration(days: 1)),
            header: 'Days',
            disableDaysList: const [2, 3],
            onDaySelected: (List<DateTime> selectedDates) {
              debugPrint('selected day details $selectedDates');
            },
          ).padding(10),
          const Text('Select multiple').paddingOnly(top: 20),
          ZdsButton(
            child: const Text('change initial selected dates'),
            onTap: () {
              setState(() {
                initialSelectedDates = [DateTime.now().add(Duration(days: inc))];
                inc++;
                if (inc > 6) {
                  inc = 0;
                }
              });
            },
          ),
          ZdsDayPicker(
            startingWeekDate: DateTime.now(),
            initialSelectedDates: initialSelectedDates,
            header: 'Days',
            onDaySelected: (List<DateTime> selectedDates) {
              debugPrint('selected day details $selectedDates');
            },
            allowMultiSelect: true,
          ).padding(10),
          const Text('Show outside card').paddingOnly(top: 20),
          ZdsCard(
            child: ZdsDayPicker(
              startingWeekDate: DateTime.now(),
              showInCard: false,
              initialSelectedDates: [DateTime.now().add(const Duration(days: 2))],
              header: 'Days',
              onDaySelected: (List<DateTime> selectedDates) {
                debugPrint('selected day details $selectedDates');
              },
              allowMultiSelect: true,
            ).padding(10),
          ),
        ],
      ),
    );
  }
}
