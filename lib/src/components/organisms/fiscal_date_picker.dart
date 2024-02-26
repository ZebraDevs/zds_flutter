import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

import '../../utils/tools/modifiers.dart';
import '../../utils/tools/utils.dart';
import '../atoms/button.dart';
import 'calendar.dart';

const Size _inputPortraitDialogSize = Size(330, 530);
const Size _inputRangeLandscapeDialogSize = Size(500, 480);
const Duration _dialogSizeAnimationDuration = Duration(milliseconds: 200);

/// Shows a material design date picker dialog.
Future<DateTime?> showZdsFiscalDatePicker({
  required BuildContext context,
  required DateTime firstDate,
  required DateTime lastDate,
  required String cancelText,
  required String okText,
  required String titleText,
  Key? key,
  RouteSettings? routeSettings,
  TransitionBuilder? builder,
  DateTime? initialDate,
  int startDayOfWeek = 1,
  bool useRootNavigator = true,
  String format = 'dd/MM/yyyy',
}) {
  final Widget dialog = ZdsDatePickerDialog(
    firstDate: firstDate,
    lastDate: lastDate,
    cancelText: cancelText,
    okText: okText,
    initialDate: initialDate,
    helpText: titleText,
    startDayOfWeek: startDayOfWeek,
    selectedDateFormat: format,
  );

  return showDialog<DateTime?>(
    context: context,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    useSafeArea: false,
    builder: (BuildContext context) {
      return builder == null ? dialog : builder(context, dialog);
    },
  );
}

/// A copy of material design date picker dialog with choice of first day of week.
class ZdsDatePickerDialog extends StatefulWidget {
  /// Creates a date picker dialog.
  const ZdsDatePickerDialog({
    required this.firstDate,
    required this.lastDate,
    required this.cancelText,
    required this.okText,
    super.key,
    this.selectedDateFormat = 'dd/MM/yyyy',
    this.initialDate,
    this.helpText,
    this.onDateChanged,
    this.startDayOfWeek = 1,
  });

  /// The date that is initially selected when the dialog is shown.
  final String selectedDateFormat;

  /// Called when the user picks a day.
  final void Function(DateTime? dateTime)? onDateChanged;

  /// Starting day of week 1, 2, 3, Sunday, Monday, Tuesday respectively.
  final int startDayOfWeek;

  /// The initially selected [DateTime] that the picker should display.
  final DateTime? initialDate;

  /// The earliest allowable [DateTime] that the user can select.
  final DateTime firstDate;

  /// The latest allowable [DateTime] that the user can select.
  final DateTime lastDate;

  /// The text that is displayed on the cancel button.
  final String cancelText;

  /// The text that is displayed on the Ok button.
  final String okText;

  /// The text that is displayed at the top of the header.
  ///
  /// This is used to indicate to the user what they are selecting a date for.
  final String? helpText;

  @override
  State<ZdsDatePickerDialog> createState() => _ZdsDatePickerDialogState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('helpText', helpText))
      ..add(StringProperty('selectedDateFormat', selectedDateFormat))
      ..add(ObjectFlagProperty<void Function(DateTime? dateTime)?>.has('onDateChanged', onDateChanged))
      ..add(IntProperty('startDayOfWeek', startDayOfWeek))
      ..add(DiagnosticsProperty<DateTime?>('initialDate', initialDate))
      ..add(DiagnosticsProperty<DateTime>('firstDate', firstDate))
      ..add(DiagnosticsProperty<DateTime>('lastDate', lastDate))
      ..add(StringProperty('cancelText', cancelText))
      ..add(StringProperty('okText', okText));
  }
}

class _ZdsDatePickerDialogState extends State<ZdsDatePickerDialog> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    _selectedDate = widget.initialDate ?? DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final Size size = orientation == Orientation.portrait ? _inputPortraitDialogSize : _inputRangeLandscapeDialogSize;
    final theme = Theme.of(context);

    final fixContent = [
      Material(
        color: theme.colorScheme.primary,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(orientation == Orientation.portrait ? 16 : 16),
              child: Text(
                widget.helpText ?? 'Select Date',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(orientation == Orientation.portrait ? 16 : 16),
              child: Text(
                _selectedDate.format(widget.selectedDateFormat),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ).paddingInsets(const EdgeInsets.symmetric(horizontal: 12)),
      ),
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ZdsCalendar.monthly(
              initialSelectedDay: _selectedDate,
              initialSelectedWeek: _selectedDate,
              calendarRowHeight: orientation == Orientation.portrait ? 44 : 38,
              headerPadding: EdgeInsets.zero,
              calendarHeaderIconColor: Zeta.of(context).colors.iconDefault,
              calendarHeaderTextColor: Zeta.of(context).colors.textSubtle,
              startingDayOfWeek: _getStartingDayOfWeek(widget.startDayOfWeek),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDate = selectedDay;
                });
                widget.onDateChanged?.call(selectedDay);
              },
              events: const [],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ZdsButton.text(
                  child: Text(widget.cancelText),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                ZdsButton.text(
                  child: Text(widget.okText),
                  onTap: () {
                    Navigator.pop(context, _selectedDate);
                  },
                ),
              ],
            ),
          ],
        ).paddingInsets(EdgeInsets.symmetric(horizontal: 12, vertical: (orientation == Orientation.portrait ? 8 : 0))),
      ),
    ];

    final content = orientation == Orientation.portrait
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: fixContent,
          )
        : Row(
            children: fixContent,
          );

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: Theme.of(context).dialogTheme.shape,
      elevation: Theme.of(context).dialogTheme.elevation ?? 24,
      clipBehavior: Clip.antiAlias,
      child: AnimatedContainer(
        width: size.width,
        height: size.longestSide,
        duration: _dialogSizeAnimationDuration,
        curve: Curves.easeIn,
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 1.3),
          ),
          child: Builder(
            builder: (BuildContext context) {
              return content;
            },
          ),
        ),
      ),
    );
  }

  StartingDayOfWeek _getStartingDayOfWeek(int startDayOfWeek) {
    StartingDayOfWeek startingDayOfWeek = StartingDayOfWeek.sunday;
    switch (startDayOfWeek) {
      case 1:
        startingDayOfWeek = StartingDayOfWeek.sunday;
      case 2:
        startingDayOfWeek = StartingDayOfWeek.monday;
      case 3:
        startingDayOfWeek = StartingDayOfWeek.tuesday;
      case 4:
        startingDayOfWeek = StartingDayOfWeek.wednesday;
      case 5:
        startingDayOfWeek = StartingDayOfWeek.thursday;
      case 6:
        startingDayOfWeek = StartingDayOfWeek.friday;
      case 7:
        startingDayOfWeek = StartingDayOfWeek.saturday;
    }
    return startingDayOfWeek;
  }
}
