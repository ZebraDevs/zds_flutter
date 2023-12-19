import 'package:flutter/material.dart';
import 'package:zds_flutter/zds_flutter.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarDemo extends StatefulWidget {
  const CalendarDemo({Key? key}) : super(key: key);

  @override
  _CalendarDemoState createState() => _CalendarDemoState();
}

class _CalendarDemoState extends State<CalendarDemo> {
  DateTime currentDate = DateTime.now();
  DateTime focusedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextButton(
                onPressed: () {
                  setState(() {
                    focusedDate = focusedDate.add(const Duration(days: 1));
                  });
                },
                child: const Text('increase day')),
            ZdsCalendar(
              selectedDay: focusedDate,
              events: [
                CalendarEvent(id: 'a', date: DateTime.now()),
                CalendarEvent(id: 'b', date: DateTime.now().subtract(const Duration(days: 1))),
                CalendarEvent(id: 'c', date: DateTime.now().add(const Duration(days: 1))),
              ],
              holidayEvents: [DateUtils.dateOnly(DateTime(2023, 05, 23))],
              onDaySelected: (selectedDay, focusedDay) {
                debugPrint('Focused day is $focusedDay');
                debugPrint('Selected day is $selectedDay');
              },
              onFormatChanged: (format) => debugPrint('The format has changed and it is now $format'),
              onPageChanged: (focusedDay) => debugPrint('The page has changed and the focused day is now $focusedDay'),
            ),
            const SizedBox(height: 50),
            ZdsCalendar.monthly(
              isRangeSelectable: true,
              events: [
                CalendarEvent(id: 'a', date: DateTime.now()),
                CalendarEvent(id: 'b', date: DateTime.now().subtract(const Duration(days: 1))),
                CalendarEvent(id: 'c', date: DateTime.now().add(const Duration(days: 1))),
              ],
              onRangeSelected: (start, end, focusedDay) {
                debugPrint('A range has been selected, from $start to $end. The focused day is $focusedDay');
              },
            ),
            const SizedBox(
              height: 50,
            ),
            ZdsCalendar.weekly(
              startingDayOfWeek: StartingDayOfWeek.thursday,
              initialSelectedDay: DateTime(currentDate.year, currentDate.month, currentDate.day + 1),
              events: [
                CalendarEvent(id: 'a', date: DateTime.now()),
                CalendarEvent(id: 'b', date: DateTime.now().subtract(const Duration(days: 1))),
                CalendarEvent(id: 'c', date: DateTime.now().add(const Duration(days: 1))),
              ],
              onDaySelected: (selectedDay, focusedDay) {
                debugPrint('Focused day is $focusedDay');
                debugPrint('Selected day is $selectedDay');
              },
              onAllSelected: (start, end, focusedDay) {
                debugPrint('A Week has been selected, from $start to $end. The focused day is $focusedDay');
              },
            ),
            const SizedBox(height: 50),
            ZdsCalendar.weekly(
              initialSelectedWeek: DateTime(2022, 09, 10),
              startingDayOfWeek: StartingDayOfWeek.wednesday,
              showAllButton: true,
              events: const [],
              onDaySelected: (selectedDay, focusedDay) {
                debugPrint('Focused day is $focusedDay');
                debugPrint('Selected day is $selectedDay');
              },
              onAllSelected: (start, end, focusedDay) {
                debugPrint('A Week has been selected, from $start to $end. The focused day is $focusedDay');
              },
            ),
            const SizedBox(height: 50),
            ZdsCalendar.monthly(
              headerPadding: const EdgeInsets.fromLTRB(4, 14, 8, 14),
              events: [
                CalendarEvent(id: 'a', date: DateTime.now()),
                CalendarEvent(id: 'b', date: DateTime.now().subtract(const Duration(days: 1))),
                CalendarEvent(id: 'c', date: DateTime.now().add(const Duration(days: 1))),
              ],
              isRangeSelectable: true,
              holidayEvents: List.generate(12, (index) {
                return DateTime(DateTime.now().year, index + 1, 10);
              }),
              isGridShown: true,
              singleMarkerBuilder: (BuildContext context, DateTime date, dynamic _) {
                return Container(
                  decoration: BoxDecoration(
                    color: date.isAfter(DateTime.now()) ? Zeta.of(context).colors.red : Zeta.of(context).colors.green,
                    shape: BoxShape.circle,
                  ),
                  width: 5,
                  height: 5,
                ).paddingOnly(top: 7);
              },
              onRangeSelected: (start, end, focusedDay) {
                debugPrint('A range has been selected, from $start to $end. The focused day is $focusedDay');
              },
              weekIcons: [
                WeekIcon(
                  child: const Icon(Icons.abc_sharp),
                  firstDayOfWeek: DateTime.now().getFirstDayOfWeek().toMidnight,
                ),
                WeekIcon(
                  child: const Icon(Icons.accessibility_new_outlined),
                  firstDayOfWeek: DateTime.now().add(const Duration(days: 7)).getFirstDayOfWeek().toMidnight,
                ),
              ],
            ),
            const SizedBox(height: 50),
            ZdsButton.filled(
              child: const Text('DateRangePickerDialog'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: ZdsDateRangePickerDialog(
                        lastDate: DateTime.now().add(const Duration(days: 50)),
                        firstDate: DateTime.now().subtract(const Duration(days: 50)),
                        startDayOfWeek: 5,
                        shortMonthDayFormat: 'MM/dd',
                        shortDateFormat: 'MM/dd/yyyy',
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
