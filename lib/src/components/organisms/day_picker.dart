import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

import '../../utils/localizations/translation.dart';
import '../../utils/tools/modifiers.dart';
import '../../utils/tools/utils.dart';
import '../atoms/button.dart';
import '../atoms/card.dart';
import '../atoms/selection_pills.dart';

/// Model for  days used in [ZdsDayPicker].
class DayDetails {
  /// Constructs a [DayDetails].
  DayDetails({
    required this.date,
    required this.dayText,
    required this.isDisabled,
    this.isChecked = false,
  });

  /// Index for the day.
  final DateTime date;

  /// Text for displaying day.
  final String dayText;

  /// Enable or disable day.
  final bool isDisabled;

  /// Selected or unselected.
  bool isChecked;
}

/// A widget that allow to select days.
class ZdsDayPicker extends StatefulWidget {
  /// Constructs a [ZdsDayPicker].
  const ZdsDayPicker({
    required this.startingWeekDate,
    this.initialSelectedDates,
    this.header,
    this.allText,
    this.disableDaysList = const <int>[],
    this.onDaySelected,
    this.allowMultiSelect = false,
    this.showInCard = true,
    this.enabled = true,
    super.key,
  }) : assert(
          (initialSelectedDates?.length ?? 0) <= 1 || allowMultiSelect,
          'Wrong configuration allowMultiSelect=false and initialSelectedDates has multiple dates',
        );

  /// Starting date of the week.
  final DateTime startingWeekDate;

  /// The default selected dates.
  final List<DateTime>? initialSelectedDates;

  /// Text used for showing header at the beginning.
  final String? header;

  /// Text for All button.
  ///
  /// Defaults to 'All'.
  final String? allText;

  /// Disable days selection based on the days index, Sunday = 1, Monday = 2, ...
  ///
  /// Defaults to empty list.
  final List<int> disableDaysList;

  /// Method gets triggered on the click of a day.
  final void Function(List<DateTime>)? onDaySelected;

  /// Used to enable the selection of multiple days.
  ///
  /// Defaults to false.
  final bool allowMultiSelect;

  /// Used to move the component inside/outside a card;
  ///
  /// Defaults to 'true'.
  final bool showInCard;

  /// Used to enable / disable the component.
  ///
  /// Defaults to true.
  final bool enabled;

  @override
  State<ZdsDayPicker> createState() => _ZdsDayPickerState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<DateTime>('startingWeekDate', startingWeekDate))
      ..add(IterableProperty<DateTime>('initialSelectedDates', initialSelectedDates))
      ..add(StringProperty('header', header))
      ..add(StringProperty('allText', allText))
      ..add(IterableProperty<int>('disableDaysList', disableDaysList))
      ..add(ObjectFlagProperty<void Function(List<DateTime> p1)?>.has('onDaySelected', onDaySelected))
      ..add(DiagnosticsProperty<bool>('allowMultiSelect', allowMultiSelect))
      ..add(DiagnosticsProperty<bool>('showInCard', showInCard))
      ..add(DiagnosticsProperty<bool>('enabled', enabled));
  }
}

class _ZdsDayPickerState extends State<ZdsDayPicker> {
  List<DayDetails> weekDays = <DayDetails>[];
  int disabledCount = 0;
  bool isSelectedAllDay = false;
  List<DateTime> selectedDates = <DateTime>[];
  final TextEditingController dayPickerController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.initialSelectedDates != null) {
      selectedDates.addAll(getDatesOnly(widget.initialSelectedDates!));
    }

    _computeWeekDaysDetails();
    _updateDayController(selectedDates);
  }

  @override
  void didUpdateWidget(ZdsDayPicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialSelectedDates != widget.initialSelectedDates && widget.initialSelectedDates != null) {
      selectedDates = getDatesOnly(widget.initialSelectedDates!);

      _computeWeekDaysDetails();
      _updateDayController(selectedDates);
    }
  }

  void _updateDayController(List<DateTime> selectedDates) {
    selectedDates.sort((DateTime first, DateTime next) => first.compareTo(next));
    final List<String> dayBuffer = <String>[];
    for (final DateTime date in selectedDates) {
      dayBuffer.add(DateFormat('EEE').format(date));
    }
    dayPickerController.value = dayPickerController.value.copyWith(text: dayBuffer.join(', '));
  }

  void _computeWeekDaysDetails() {
    weekDays = <DayDetails>[];
    disabledCount = widget.disableDaysList.isEmpty ? 0 : widget.disableDaysList.length;

    for (int index = 0; index < 7; index++) {
      final DateTime date = DateUtils.dateOnly(widget.startingWeekDate.add(Duration(days: index)));
      weekDays.add(
        DayDetails(
          date: date,
          isChecked: _isDateMatchingForSelectedDate(date),
          dayText: DateFormat('EEE').format(date),
          isDisabled: widget.disableDaysList.contains(index),
        ),
      );
    }
  }

  void _updateDayDetails(DayDetails selectedDayDetail) {
    setState(() {
      selectedDayDetail.isChecked = !selectedDayDetail.isChecked;
      if (widget.allowMultiSelect) {
        selectedDayDetail.isChecked
            ? selectedDates.add(DateUtils.dateOnly(selectedDayDetail.date))
            : selectedDates.remove(DateUtils.dateOnly(selectedDayDetail.date));
      } else {
        if (selectedDayDetail.isChecked) {
          if (selectedDates.length == 1) {
            for (final DayDetails dayDetail in weekDays) {
              if (selectedDayDetail.dayText != dayDetail.dayText && dayDetail.isChecked) {
                dayDetail.isChecked = false;
                selectedDates
                  ..remove(DateUtils.dateOnly(dayDetail.date))
                  ..add(DateUtils.dateOnly(selectedDayDetail.date));
                break;
              }
            }
          } else {
            selectedDates.add(DateUtils.dateOnly(selectedDayDetail.date));
          }
        } else {
          if (selectedDates.length > 1) {
            for (final DayDetails dayDetail in weekDays) {
              if (selectedDayDetail.dayText != dayDetail.dayText) {
                dayDetail.isChecked = false;
                selectedDates.remove(DateUtils.dateOnly(dayDetail.date));
              }
            }
            selectedDayDetail.isChecked = !selectedDayDetail.isChecked;
          } else {
            selectedDates.remove(DateUtils.dateOnly(selectedDayDetail.date));
          }
        }
      }
      widget.onDaySelected?.call(selectedDates);

      _updateDayController(selectedDates);
    });
  }

  void selectAll() {
    setState(() {
      if ((selectedDates.length + widget.disableDaysList.length) == 7) {
        selectedDates = <DateTime>[];
        for (final DayDetails dayDetail in weekDays) {
          if (!dayDetail.isDisabled) {
            dayDetail.isChecked = false;
          }
        }
      } else {
        selectedDates = <DateTime>[];
        for (final DayDetails dayDetail in weekDays) {
          if (!dayDetail.isDisabled) {
            dayDetail.isChecked = true;
            selectedDates.add(dayDetail.date);
          }
        }
      }
      _updateDayController(selectedDates);
    });
    widget.onDaySelected?.call(selectedDates);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        const double pillWidth = 68;
        const int pillSpacing = 4;
        const double horizontalPadding = 12;

        final double totalLength = (weekDays.length * (pillWidth + pillSpacing)) + (horizontalPadding * 2);
        final bool isWrapping = totalLength > constraints.maxWidth;

        final Row body = Row(
          children: <Widget>[
            Expanded(
              child: Wrap(
                alignment: isWrapping ? WrapAlignment.start : WrapAlignment.center,
                children: <Widget>[
                  ...weekDays.map(
                    (DayDetails dayDetail) {
                      return SizedBox(
                        width: pillWidth,
                        child: ZdsSelectionPill(
                          selected: dayDetail.isChecked,
                          label: dayDetail.dayText,
                          onTap: dayDetail.isDisabled || !widget.enabled
                              ? null
                              : () => setState(() => _updateDayDetails(dayDetail)),
                          padding: const EdgeInsets.all(4),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        );

        return Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                if (widget.header != null)
                  Text(
                    widget.header!,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Zeta.of(context).colors.textDefault),
                  ).paddingOnly(left: 6),
                if (widget.allowMultiSelect)
                  SizedBox(
                    height: 34,
                    width: 54,
                    child: ZdsButton.text(
                      textPadding: EdgeInsets.zero,
                      onTap: widget.enabled ? selectAll : null,
                      child: Text(widget.allText ?? ComponentStrings.of(context).get('ALL', 'All')),
                    ),
                  ),
              ],
            ).paddingInsets(
              widget.allowMultiSelect ? const EdgeInsets.only(left: 4) : const EdgeInsets.only(left: 4, bottom: 8),
            ),
            if (widget.showInCard)
              ZdsCard(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: horizontalPadding),
                child: body,
              )
            else
              body,
          ],
        );
      },
    );
  }

  /// This loop is to check if date falls in selected dates or not.
  bool _isDateMatchingForSelectedDate(DateTime date) {
    for (final DateTime selectedDate in selectedDates) {
      if (selectedDate.isSameDay(date)) {
        return true;
      }
    }
    return false;
  }

  List<DateTime> getDatesOnly(List<DateTime> dateList) {
    final List<DateTime> returnList = <DateTime>[];
    for (final DateTime completeDate in dateList) {
      returnList.add(DateUtils.dateOnly(completeDate));
    }
    return returnList;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<DayDetails>('weekDays', weekDays))
      ..add(IntProperty('disabledCount', disabledCount))
      ..add(DiagnosticsProperty<bool>('isSelectedAllDay', isSelectedAllDay))
      ..add(IterableProperty<DateTime>('selectedDates', selectedDates))
      ..add(DiagnosticsProperty<TextEditingController>('dayPickerController', dayPickerController));
  }
}
