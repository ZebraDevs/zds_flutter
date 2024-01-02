import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../zds_flutter.dart';

/// A date range selector that also allows to quickly change the range selected by jumping to the next or
/// previous set of dates.
@Deprecated('Use ZdsDateRange instead')
typedef DateRange = ZdsDateRange;

/// A date range selector that also allows to quickly change the range selected by jumping to the next or
/// previous set of dates.
///
/// This component is typically used as the title of a [ZdsToolbar], allowing to switch the body's content depending
/// on the selected range.
///
/// ```dart
/// ZdsToolbar(
///   title: DateRange(
///     emptyLabel: 'Select range',
///     actions: [
///       ZdsButton.text(
///         child: const Text('Fiscal View'),
///         onTap: () {},
///       ),
///     ],
///   ),
/// )
/// ```
///
/// When no range has been selected, the [emptyLabel] text will be shown. Tapping on this opens a full-screen date
/// range selector. Once the date range has been selected, it will be shown on the component.
///
/// The user can quickly jump forwards and backwards by pressing on the chevron icon buttons. For example, if the date
/// range is March 1 - March 5, the previous date range will be February 24 - February 28, and the next one will be
/// March 6 - March 10. You can keep track of these changes with [onChange].
///
/// See also:
///
///  * [ZdsDateRangePickerTile], which allows to select a date range's start and end time separately.
///  * [ZdsDateTimePicker], a widget that allow to select a single date, a single time, or both.
class ZdsDateRange extends StatefulWidget {
  /// Creates a date range selector.
  const ZdsDateRange({
    super.key,
    this.firstDate,
    this.lastDate,
    this.initialDateRange,
    this.onChange,
    this.actions,
    this.emptyLabel = '',
    this.textStyle,
    this.clearButtonString,
    this.applyButtonString,
    this.isSelectable = true,
    this.dateRangeSeparator = '-',
    this.nextTooltip,
    this.previousTooltip,
    this.isWeekMode = false,
    this.startDayOfWeek = 0,
    this.dateFormat,
  }) : assert(
          !isWeekMode || (startDayOfWeek >= 0 && startDayOfWeek <= 6),
          'startingDayOfWeek must be an int between 0 and 6',
        );
  static const int _kYearsFromNow = 20;

  /// The earliest date that can be chosen for the range.
  ///
  /// Defaults to 1/1/1999.
  final DateTime? firstDate;

  /// The last date that can be chosen for the range.
  ///
  /// Defaults to 20 years in the future from now.
  final DateTime? lastDate;

  /// The empty label to show when no date has been chosen.
  ///
  /// Defaults to an empty String.
  final String emptyLabel;

  /// Widgets shown when choosing a date range for additional actions other than clearing and applying.
  ///
  /// Typically a list of [IconButton].
  final List<Widget>? actions;

  /// The initial date range to show when first building this widget.
  ///
  /// If null, no range will be shown at first.
  final DateTimeRange? initialDateRange;

  /// Callback function called whenever the selected date range changes.
  final void Function(DateTimeRange?)? onChange;

  /// The textStyle to use for the button to open the date range selector.
  ///
  /// Defaults to [TextTheme.headlineMedium].
  final TextStyle? textStyle;

  /// The string to use for the clear range button.
  ///
  /// Defaults to 'Clear'.
  final String? clearButtonString;

  /// The string to use for the apply range button.
  ///
  /// Defaults to 'Apply'.
  final String? applyButtonString;

  /// Used for making the dateRange clickable
  ///
  /// Defaults to 'True'.
  final bool isSelectable;

  /// Used as a date range separator
  ///
  /// Defaults to '-'.
  final String dateRangeSeparator;

  /// Tooltip to go with the previous icon.
  final String? previousTooltip;

  /// Tooltip to go with the next icon.
  final String? nextTooltip;

  /// If true, user can only select weeks, not days in popup.
  ///
  /// If being used to show weeks, user should not be able to select a random selection of days.
  ///
  /// Defaults to false.
  final bool isWeekMode;

  /// 0 indexed where Sunday is 0 and Saturday is 6
  ///
  /// Defaults to 0.
  final int startDayOfWeek;

  /// to change date format of date range
  final String? dateFormat;

  @override
  ZdsDateRangeState createState() => ZdsDateRangeState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<DateTime?>('firstDate', firstDate))
      ..add(DiagnosticsProperty<DateTime?>('lastDate', lastDate))
      ..add(StringProperty('emptyLabel', emptyLabel))
      ..add(DiagnosticsProperty<DateTimeRange?>('initialDateRange', initialDateRange))
      ..add(ObjectFlagProperty<void Function(DateTimeRange? p1)?>.has('onChange', onChange))
      ..add(DiagnosticsProperty<TextStyle?>('textStyle', textStyle))
      ..add(StringProperty('clearButtonString', clearButtonString))
      ..add(StringProperty('applyButtonString', applyButtonString))
      ..add(DiagnosticsProperty<bool>('isSelectable', isSelectable))
      ..add(StringProperty('dateRangeSeparator', dateRangeSeparator))
      ..add(StringProperty('previousTooltip', previousTooltip))
      ..add(StringProperty('nextTooltip', nextTooltip))
      ..add(DiagnosticsProperty<bool>('isWeekMode', isWeekMode))
      ..add(IntProperty('startDayOfWeek', startDayOfWeek))
      ..add(StringProperty('dateFormat', dateFormat));
  }
}

/// State for [ZdsDateRange].
class ZdsDateRangeState extends State<ZdsDateRange> {
  DateTimeRange? _selectedDateRange;
  Duration? _diff;

  @override
  void didUpdateWidget(ZdsDateRange oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.initialDateRange != null && widget.initialDateRange != oldWidget.initialDateRange) {
      _selectedDateRange = DateTimeRange(
        start: widget.initialDateRange!.start.toMidnight,
        end: widget.initialDateRange!.end.toMidnight,
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (widget.initialDateRange != null) {
      _selectedDateRange = DateTimeRange(
        start: widget.initialDateRange!.start.toMidnight,
        end: widget.initialDateRange!.end.toMidnight,
      );
    }
  }

  Future<void> _showDateSelector(BuildContext context) async {
    final DateTimeRange? range = await showZdsDateRangePicker(
      context: context,
      actions: widget.actions,
      initialDateRange: _selectedDateRange,
      useRootNavigator: false,
      firstDate: widget.firstDate ?? DateTime(1999),
      lastDate: widget.lastDate ?? DateTime(DateTime.now().year + ZdsDateRange._kYearsFromNow),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      clearButtonString: widget.clearButtonString,
      applyButtonString: widget.applyButtonString,
      isWeekMode: widget.isWeekMode,
      startingDayOfWeek: widget.startDayOfWeek,
      shortDateFormat: widget.dateFormat,
      shortMonthDayFormat: widget.dateFormat,
    );
    if (mounted) {
      setState(() {
        if (range != null) {
          _selectedDateRange = range;
        }
      });

      widget.onChange?.call(range);
    }
  }

  void _nextDateRange() {
    if (_selectedDateRange == null) {
      return;
    }

    if (_diff == null) _setDiff();

    setState(() {
      // If current whole month is selected then select next whole month
      if (_selectedDateRange!.isWholeMonth) {
        final DateTime start = DateTime(
          _selectedDateRange!.start.year,
          _selectedDateRange!.start.month + 1,
          _selectedDateRange!.start.day,
        ).startOfMonth;
        _selectedDateRange = DateTimeRange(start: start, end: start.endOfMonth);
      } else {
        _selectedDateRange = DateTimeRange(
          start: _selectedDateRange!.start.add(_diff!),
          end: _selectedDateRange!.end.add(_diff!),
        );
      }

      widget.onChange?.call(_selectedDateRange);
    });
  }

  void _prevDateRange() {
    if (_selectedDateRange == null) {
      return;
    }
    if (_diff == null) _setDiff();
    setState(() {
      // If current whole month is selected then select previous whole month
      if (_selectedDateRange!.isWholeMonth) {
        final DateTime start = DateTime(
          _selectedDateRange!.start.year,
          _selectedDateRange!.start.month - 1,
          _selectedDateRange!.start.day,
        ).startOfMonth;

        _selectedDateRange = DateTimeRange(start: start, end: start.endOfMonth);
      } else {
        _selectedDateRange = DateTimeRange(
          start: _selectedDateRange!.start.subtract(_diff!),
          end: _selectedDateRange!.end.subtract(_diff!),
        );
      }

      widget.onChange?.call(_selectedDateRange);
    });
  }

  bool _isBeforeFirstDate() {
    if (_selectedDateRange != null && widget.firstDate != null) {
      return _selectedDateRange!.start.isBefore(widget.firstDate!);
    }
    return false;
  }

  bool _isAfterLastDate() {
    if (_selectedDateRange != null && widget.lastDate != null) {
      return _selectedDateRange!.end.isAfter(widget.lastDate!);
    }
    return false;
  }

  void _setDiff() {
    if (_selectedDateRange != null) {
      setState(
        () => _diff = _selectedDateRange!.end.add(const Duration(days: 1)).difference(_selectedDateRange!.start),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    if (_selectedDateRange != null) {
      _diff = _selectedDateRange!.end.add(const Duration(days: 1)).difference(_selectedDateRange!.start);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBeforeFirstDate = _isBeforeFirstDate();
    final isAfterLastDate = _isAfterLastDate();

    final text = Text(
      _selectedDateRange == null ? widget.emptyLabel : _formatRange(context, dateFormat: widget.dateFormat),
      style: widget.textStyle,
    );

    return Row(
      children: [
        Semantics(
          excludeSemantics: true,
          button: true,
          label: widget.previousTooltip,
          onTap: isBeforeFirstDate ? null : _prevDateRange,
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: isBeforeFirstDate ? null : _prevDateRange,
            tooltip: widget.previousTooltip,
            splashRadius: 24,
            icon: Opacity(
              opacity: isBeforeFirstDate ? 0.5 : 1,
              child: Icon(
                ZdsIcons.chevron_left,
                color: widget.textStyle?.color,
              ),
            ),
          ),
        ),
        if (!widget.isSelectable) text,
        if (widget.isSelectable)
          InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(71)),
            onTap: () async => _showDateSelector(context),
            child: text.paddingInsets(const EdgeInsets.symmetric(vertical: 8)),
          ),
        Semantics(
          excludeSemantics: true,
          button: true,
          label: widget.nextTooltip,
          onTap: isAfterLastDate ? null : _nextDateRange,
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: isAfterLastDate ? null : _nextDateRange,
            splashRadius: 24,
            tooltip: widget.nextTooltip,
            icon: Opacity(
              opacity: isAfterLastDate ? 0.5 : 1,
              child: Icon(
                ZdsIcons.chevron_right,
                color: widget.textStyle?.color,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Returns a locale-appropriate string to describe the start of a date range.
  String _formatRange(BuildContext context, {String? dateFormat}) {
    if (_selectedDateRange == null) return '';
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    if (_selectedDateRange!.isWholeMonth) {
      return localizations.formatMonthYear(_selectedDateRange!.start);
    }
    final String startDateFormatted = dateFormat != null
        ? DateFormat(dateFormat).format(_selectedDateRange!.start)
        : _formatStartDate(
            localizations,
            _selectedDateRange?.start,
            _selectedDateRange?.end,
          );

    final String endDateFormatted = dateFormat != null
        ? DateFormat(dateFormat).format(_selectedDateRange!.end)
        : _formatEndDate(
            localizations,
            _selectedDateRange?.start,
            _selectedDateRange?.end,
          );

    return '$startDateFormatted ${widget.dateRangeSeparator} $endDateFormatted';
  }

  /// Returns a locale-appropriate string to describe the start of a date range.
  ///
  /// If `startDate` is null, then it defaults to 'Start Date', otherwise if it
  /// is in the same year as the `endDate` then it will use the short month
  /// day format (i.e. 'Jan 21'). Otherwise it will return the short date format
  /// (i.e. 'Jan 21, 2020').
  String _formatStartDate(MaterialLocalizations localizations, DateTime? startDate, DateTime? endDate) {
    return startDate == null
        ? ''
        : (endDate == null || startDate.year == endDate.year)
            ? localizations.formatShortMonthDay(startDate)
            : localizations.formatShortDate(startDate);
  }

  /// Returns an locale-appropriate string to describe the end of a date range.
  ///
  /// If `endDate` is null, then it defaults to 'End Date', otherwise if it
  /// is in the same year as the `startDate` and the `currentDate` then it will
  /// just use the short month day format (i.e. 'Jan 21'), otherwise it will
  /// include the year (i.e. 'Jan 21, 2020').
  String _formatEndDate(MaterialLocalizations localizations, DateTime? startDate, DateTime? endDate) {
    return endDate == null
        ? ''
        : (startDate != null && startDate.year == endDate.year && startDate.year == DateTime.now().year)
            ? localizations.formatShortMonthDay(endDate)
            : localizations.formatShortDate(endDate);
  }
}
