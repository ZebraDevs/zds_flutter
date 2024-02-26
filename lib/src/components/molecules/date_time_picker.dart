import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:interval_time_picker/interval_time_picker.dart' as interval_picker;

import 'package:intl/intl.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

import '../../utils/localizations/translation.dart';
import '../../utils/theme/input_border.dart';
import '../../utils/theme/theme.dart';
import '../../utils/tools/controller.dart';
import '../organisms/date_range_picker_tile.dart';
import '../organisms/fiscal_date_picker.dart';

/// Variants of [ZdsDateTimePicker].
enum DateTimePickerMode {
  /// Creates and shows a [ZdsDatePickerDialog] with Zebra style and behavior.
  date,

  /// Creates and shows a [TimePickerDialog] with Zebra style and behavior.
  time,

  /// Creates  and shows first a [ZdsDatePickerDialog] and then a [TimePickerDialog] with Zebra style and behavior.
  dateAndTime
}

/// A widget that allow to select a date, a time, or both.
///
/// A [controller] can be used to handle this date and use it to manage state.
///
/// This widget is typically used as a non-editable text field by using [ZdsInputDecoration] for [inputDecoration].
/// It can also be used as a button on its own by not assigning any [inputDecoration].
///
/// ```dart
/// // As a text field
/// ZdsDateTimePicker(
///   emptyLabel: 'select date',
///   minDate: DateTime.now(),
///   mode: DateTimePickerMode.date,
///   controller: _controller,
///   inputDecoration: ZdsInputDecoration(
///     labelText: 'Optional Date',
///     suffixIcon: IconButton(
///       icon: const Icon(ZdsIcons.close_circle, size: 24,),
///       onPressed: () => _controller.value = null,
///     ),
///   ),
///   onChange: (dateTime) => handleTime(dateTime),
/// ),
///
/// // As a button
/// ZdsDateTimePicker(
///   emptyLabel: 'select time',
///   textAlign: TextAlign.center,
///   minDate: DateTime.now(),
///   mode: DateTimePickerMode.time,
/// ),
/// ```
/// See also:
///
///  * [ZdsDateRangePickerTile], which allows to select a date range's start and end time separately.
class ZdsDateTimePicker extends StatefulWidget {
  /// Constructs a [ZdsDateTimePicker].
  ZdsDateTimePicker({
    required this.emptyLabel,
    super.key,
    String? format,
    this.mode = DateTimePickerMode.date,
    this.textAlign = TextAlign.start,
    this.helpText,
    this.helpTextStyle,
    this.minDate,
    this.maxDate,
    this.selectedDate,
    this.textStyle,
    this.onChange,
    this.padding,
    this.inputDecoration,
    this.controller,
    this.readOnly = false,
    this.interval,
    this.visibleStep = interval_picker.VisibleStep.fifths,
    this.timePickerErrorText,
    this.use24HourFormat,
    this.timePickerEntryMode = TimePickerEntryMode.inputOnly,
    this.okClickText,
    this.cancelClickText,
    this.startDayOfWeek,
  })  : format = (format?.isNotEmpty ?? false)
            ? format!
            : (mode == DateTimePickerMode.date
                ? 'MMM dd, yyyy'
                : mode == DateTimePickerMode.time
                    ? 'hh:mm a'
                    : 'MMM dd, yyyy hh:mm a'),
        assert(
          (minDate != null && maxDate != null) ? minDate.isBefore(maxDate) : (minDate == null || maxDate == null),
          'minDate must be before maxDate.',
        );

  /// The type of picker to show - `date`, `time` or `dateAndTime`.
  final DateTimePickerMode mode;

  /// The format in which the [DateTime] will be formatted.
  ///
  /// See [DateFormat] for more details.
  final String format;

  /// Text that will appear when no date has been selected.
  final String emptyLabel;

  /// The text displayed at the top of the date picker window.
  final String? helpText;

  /// The style applied to the help text. Defaults to [Theme.of(context).textTheme.labelSmall].
  final TextStyle? helpTextStyle;

  /// How the text will be aligned in this widget.
  ///
  /// Defaults to [TextAlign.start].
  final TextAlign textAlign;

  /// The earliest date that can be selected. Must be before the [maxDate].
  final DateTime? minDate;

  /// The latest date that can be selected. Must be after [minDate].
  final DateTime? maxDate;

  /// to enable the click of calendar icon.
  final bool readOnly;

  /// A pre-selected date.
  ///
  /// If null, no selected date will appear and [emptyLabel] will be shown instead.
  ///
  /// If [interval] is set, the selected date's minute will be rounded to the nearest denomination of that interval.
  final DateTime? selectedDate;

  /// The style used for this button's or field's appearance.
  final TextStyle? textStyle;

  /// Empty space to surround this widget.
  ///
  /// Defaults to EdgeInsets.all(16) if [inputDecoration] is null, const EdgeInsets.all(0) if it isn't.
  final EdgeInsets? padding;

  /// Optional decoration for this widget.
  ///
  /// Typically [ZdsInputDecoration].
  final InputDecoration? inputDecoration;

  /// A function called whenever the date or time selected has changed.
  final void Function(DateTime? dateTime)? onChange;

  /// A controller used to keep track of the selected date.
  final ZdsValueController<DateTime>? controller;

  /// The interval that the picker will step up in. Only valid for time pickers.
  final int? interval;

  /// The minute labels that are visible on the ring of the picker. Only valid for time pickers.
  final interval_picker.VisibleStep visibleStep;

  /// The error text used on the time picker.
  final String? timePickerErrorText;

  /// Overrides the 24 hour format of the locale.
  final bool? use24HourFormat;

  /// Initial entry mode for time pickers.
  final TimePickerEntryMode timePickerEntryMode;

  /// The text displayed on the ok button.
  final String? okClickText;

  /// The text displayed on the cancel button.
  final String? cancelClickText;

  /// Starting day of week 1, 2, 3, Sunday, Monday, Tuesday respectively.
  final int? startDayOfWeek;

  @override
  ZdsDateTimePickerState createState() => ZdsDateTimePickerState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<DateTimePickerMode>('mode', mode))
      ..add(StringProperty('format', format))
      ..add(StringProperty('emptyLabel', emptyLabel))
      ..add(StringProperty('helpText', helpText))
      ..add(DiagnosticsProperty<TextStyle?>('helpTextStyle', helpTextStyle))
      ..add(EnumProperty<TextAlign>('textAlign', textAlign))
      ..add(DiagnosticsProperty<DateTime?>('minDate', minDate))
      ..add(DiagnosticsProperty<DateTime?>('maxDate', maxDate))
      ..add(DiagnosticsProperty<bool>('readOnly', readOnly))
      ..add(DiagnosticsProperty<DateTime?>('selectedDate', selectedDate))
      ..add(DiagnosticsProperty<TextStyle?>('textStyle', textStyle))
      ..add(DiagnosticsProperty<EdgeInsets?>('padding', padding))
      ..add(DiagnosticsProperty<InputDecoration?>('inputDecoration', inputDecoration))
      ..add(ObjectFlagProperty<void Function(DateTime? dateTime)?>.has('onChange', onChange))
      ..add(DiagnosticsProperty<ZdsValueController<DateTime>?>('controller', controller))
      ..add(IntProperty('interval', interval))
      ..add(EnumProperty<interval_picker.VisibleStep>('visibleStep', visibleStep))
      ..add(StringProperty('timePickerErrorText', timePickerErrorText))
      ..add(DiagnosticsProperty<bool?>('use24HourFormat', use24HourFormat))
      ..add(EnumProperty<TimePickerEntryMode>('timePickerEntryMode', timePickerEntryMode))
      ..add(StringProperty('okClickText', okClickText))
      ..add(StringProperty('cancelClickText', cancelClickText))
      ..add(IntProperty('startDayOfWeek', startDayOfWeek));
  }
}

/// State for [ZdsDateTimePicker].
class ZdsDateTimePickerState extends State<ZdsDateTimePicker> {
  /// Constructs a [ZdsDateTimePickerState].
  ZdsDateTimePickerState();

  late DateTime? _dateTime;

  String get _formattedDate => _dateTime == null ? widget.emptyLabel : DateFormat(widget.format).format(_dateTime!);

  @override
  void initState() {
    if (widget.interval != null && widget.mode != DateTimePickerMode.date && widget.selectedDate != null) {
      setState(() => _dateTime = _roundDate(widget.selectedDate!));
    } else {
      setState(() => _dateTime = widget.selectedDate);
    }

    widget.controller?.updateListener = (value) {
      setState(() {
        _dateTime = value;
      });
      widget.controller?.notifyListeners(value);
    };
    super.initState();
  }

  DateTime _roundDate(DateTime date) {
    DateTime roundedDate = date;
    final diff = roundedDate.minute % widget.interval!;

    if (diff > (widget.interval! / 2)) {
      roundedDate = roundedDate.add(Duration(minutes: widget.interval! - diff));
    } else {
      roundedDate = roundedDate.subtract(Duration(minutes: diff));
    }

    return roundedDate;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final zetaColors = Zeta.of(context).colors;
    Widget child = Text(
      _formattedDate.toLowerCase(),
      textAlign: widget.textAlign,
      style: widget.textStyle ??
          textTheme.bodyLarge?.copyWith(
            color: _dateTime == null ? zetaColors.textSubtle : textTheme.bodyLarge?.color,
          ),
    );

    if (widget.inputDecoration != null) {
      child = InputDecorator(
        decoration: widget.inputDecoration!,
        child: child,
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: zetaColors.surfaceSelected,
        hoverColor: zetaColors.surfaceSelectedHovered,
        radius: MediaQuery.of(context).size.width,
        onTap: () {
          if (!widget.readOnly) unawaited(onShowPicker(context, _dateTime));
        },
        borderRadius: BorderRadius.circular(
          widget.inputDecoration == null ? 30 : 15,
        ),
        child: Semantics(
          label: _formattedDate == widget.emptyLabel ? '' : _formattedDate,
          excludeSemantics: true,
          onTap: () {
            if (!widget.readOnly) unawaited(onShowPicker(context, _dateTime));
          },
          child: Padding(
            padding: widget.padding ?? (widget.inputDecoration == null ? const EdgeInsets.all(16) : EdgeInsets.zero),
            child: child,
          ),
        ),
      ),
    );
  }

  /// Shows correct date or time picker for component.
  Future<void> onShowPicker(BuildContext context, DateTime? currentValue) async {
    DateTime? newValue;

    if (widget.mode == DateTimePickerMode.date) {
      newValue = await _showDatePicker(context, currentValue);
    } else if (widget.mode == DateTimePickerMode.time) {
      final newTime = await _showTimePicker(context, currentValue);
      newValue = newTime != null ? _convert(newTime) : null;
    } else {
      final date = await _showDatePicker(context, currentValue ?? DateTime.now());
      if (date != null) {
        if (context.mounted) {
          final time = await _showTimePicker(context, currentValue ?? DateTime.now());
          if (time != null) {
            newValue = _combine(date, time);
          }
        }
      }
    }

    setState(() {
      _dateTime = newValue ?? currentValue;
      widget.onChange?.call(_dateTime);
      widget.controller?.notifyListeners(_dateTime);
    });
  }

  Future<DateTime?> _showDatePicker(BuildContext context, DateTime? currentValue) {
    final componentString = ComponentStrings.of(context);
    return showZdsFiscalDatePicker(
      format: widget.format,
      context: context,
      initialDate: currentValue ??
          (widget.minDate != null && DateTime.now().isBefore(widget.minDate!) ? widget.minDate! : DateTime.now()),
      firstDate: widget.minDate ?? DateTime(1900),
      lastDate: widget.maxDate ?? DateTime(2100),
      titleText: widget.helpText ?? componentString.get('SELECT_DATE', 'Select Date'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).zdsDateTimePickerTheme.copyWith(
                textTheme: Theme.of(context).textTheme.copyWith(labelSmall: widget.helpTextStyle),
              ),
          child: child!,
        );
      },
      cancelText: widget.cancelClickText ?? componentString.get('CANCEL', 'Cancel'),
      okText: widget.okClickText ?? componentString.get('OK', 'OK'),
      startDayOfWeek: widget.startDayOfWeek ?? 1,
    );
  }

  Future<TimeOfDay?> _showTimePicker(BuildContext context, DateTime? currentValue) async {
    Widget timePickerBuilder(BuildContext context, Widget? child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: widget.use24HourFormat),
        child: Theme(
          data: Theme.of(context).zdsDateTimePickerTheme,
          child: child!,
        ),
      );
    }

    final initialValue = widget.interval == null
        ? TimeOfDay.fromDateTime(currentValue ?? DateTime.now())
        : TimeOfDay.fromDateTime(currentValue ?? _roundDate(DateTime.now()));

    final timePickerResult = widget.interval == null && context.mounted
        ? await showTimePicker(
            context: context,
            initialTime: initialValue,
            initialEntryMode: widget.timePickerEntryMode,
            errorInvalidText: widget.timePickerErrorText,
            helpText: widget.helpText,
            builder: timePickerBuilder,
          )
        : context.mounted
            ? await interval_picker.showIntervalTimePicker(
                context: context,
                initialTime: initialValue,
                interval: widget.interval!,
                visibleStep: widget.visibleStep,
                errorInvalidText: widget.timePickerErrorText,
                initialEntryMode: _getIntervalPickerMode(),
                builder: timePickerBuilder,
                helpText: widget.helpText,
              )
            : null;

    // final selectedTime = timePickerResult ?? (currentValue != null ? TimeOfDay.fromDateTime(currentValue) : null);

    return timePickerResult;
  }

  interval_picker.TimePickerEntryMode _getIntervalPickerMode() {
    switch (widget.timePickerEntryMode) {
      case TimePickerEntryMode.dial:
        return interval_picker.TimePickerEntryMode.dial;
      case TimePickerEntryMode.input:
        return interval_picker.TimePickerEntryMode.input;
      case TimePickerEntryMode.dialOnly:
        return interval_picker.TimePickerEntryMode.dialOnly;
      case TimePickerEntryMode.inputOnly:
        return interval_picker.TimePickerEntryMode.inputOnly;
    }
  }

  /// Sets the hour and minute of a [DateTime] from a [TimeOfDay].
  DateTime _combine(DateTime date, TimeOfDay? time) => DateTime(
        date.year,
        date.month,
        date.day,
        time?.hour ?? 0,
        time?.minute ?? 0,
      );

  DateTime? _convert(TimeOfDay? time) => time == null
      ? null
      : DateTime(
          1,
          1,
          1,
          time.hour,
          time.minute,
        );
}
