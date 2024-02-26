import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../zds_flutter.dart';

const double _screenColumnBreakpoint = 240;
const double _padding = 20;
const double _fontLineHeight = 26;

/// Encapsulates a start and end [DateTime] that represent the range of dates.
///
/// Unlike [DateTimeRange], start can be before end. This allows for validation in [ZdsDateRangePickerTileForm]
/// and allows for more flexibility.
///
/// See also:
/// * [DateTimeRange]
class ZdsDateTimeRange {
  /// Constructor for [ZdsDateTimeRange].
  const ZdsDateTimeRange({this.start, this.end});

  /// Constructs a [ZdsDateTimeRange] from a [DateTimeRange].
  ZdsDateTimeRange.fromDateTimeRange(DateTimeRange dateTimeRange)
      : start = dateTimeRange.start,
        end = dateTimeRange.end;

  /// The start of the range of dates.
  final DateTime? start;

  /// The end of the range of dates.
  final DateTime? end;

  /// Creates a new [ZdsDateTimeRange] from this one by updating individual properties.
  ZdsDateTimeRange copyWith({DateTime? start, DateTime? end}) {
    return ZdsDateTimeRange(start: start ?? this.start, end: end ?? this.end);
  }

  /// Checks validity of DateTimeRange.
  bool get isValid => start != null && end != null && start!.compareTo(end!) <= 0;

  /// Checks if either start or end is not set.
  bool get isIncomplete => start == null || end == null;

  /// Constructs a [DateTimeRange] from an instance of [ZdsDateTimeRange] only if [isValid].
  DateTimeRange? get toDateTimeRange {
    if (isValid) return DateTimeRange(start: start!, end: end!);
    return null;
  }
}

/// A DateRange picker tile that allows to select the from and to dates separately with [Form] validation.
///
/// See also:
/// * [Form]
/// * [FormField]
/// * [ZdsDateTimeRange]
/// * [ZdsDateRangePickerTile]
class ZdsDateRangePickerTileForm extends FormField<ZdsDateTimeRange> {
  /// Constructor for [ZdsDateRangePickerTileForm].
  ///
  /// Default values:
  /// * [initialValue] : `const ZdsDateTimeRange()`
  /// * [validator] : `d.isValid ? null : ''`
  /// * [format] : `dd/MM/yyyy`
  /// * [autovalidateMode] : `AutovalidateMode.onUserInteraction`
  ZdsDateRangePickerTileForm({
    String? Function(ZdsDateTimeRange)? validator,
    ZdsDateTimeRange initialValue = const ZdsDateTimeRange(),
    String? initialHelpText,
    String? finalHelpText,
    DateTime? earliestSelectableDate,
    DateTime? latestSelectableDate,
    String format = 'dd/MM/yyyy',
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    void Function(ZdsDateTimeRange)? onSaved,
    int? startDayOfWeek,
    String? okClickText,
    String? cancelClickText,
    super.key,
  }) : super(
          validator: (ZdsDateTimeRange? d) {
            if (d == null) return null;
            if (validator != null) return validator(d);
            return d.isValid ? null : '';
          },
          initialValue: initialValue,
          autovalidateMode: autovalidateMode,
          onSaved: (ZdsDateTimeRange? d) {
            if (d != null && onSaved != null) onSaved(d);
          },
          builder: (FormFieldState<ZdsDateTimeRange> state) {
            return Builder(
              builder: (BuildContext context) {
                return ZdsCard(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: LayoutBuilder(
                              builder: (
                                BuildContext context,
                                BoxConstraints constraints,
                              ) {
                                final double width = _calculateWidth(constraints);
                                final bool isColumn = constraints.maxWidth <= _screenColumnBreakpoint;
                                final List<Widget> fields = <Widget>[
                                  _DateField(
                                    date: state.value?.start ?? initialValue.start,
                                    format: format,
                                    initialSelectableDate: earliestSelectableDate,
                                    finalSelectableDate: latestSelectableDate,
                                    helpText: initialHelpText,
                                    updateDate: (DateTime? newValue) {
                                      state.didChange(
                                        (state.value ?? initialValue).copyWith(start: newValue),
                                      );
                                    },
                                    validator: (DateTime? value) => state.hasError ? '' : null,
                                    isInitialDate: true,
                                    width: width,
                                    startDayOfWeek: startDayOfWeek,
                                    okClickText: okClickText,
                                    cancelClickText: cancelClickText,
                                  ),
                                  SizedBox(
                                    width: isColumn ? 0 : (constraints.maxWidth - (width * 2)) / 2,
                                    height: isColumn ? 8 : 0,
                                  ),
                                  _DateField(
                                    date: state.value?.end ?? initialValue.end,
                                    format: format,
                                    initialSelectableDate: earliestSelectableDate,
                                    finalSelectableDate: latestSelectableDate,
                                    validator: (DateTime? value) => state.hasError ? '' : null,
                                    helpText: finalHelpText,
                                    updateDate: (DateTime? newValue) {
                                      state.didChange(
                                        (state.value ?? initialValue).copyWith(end: newValue),
                                      );
                                    },
                                    width: width,
                                    startDayOfWeek: startDayOfWeek,
                                    okClickText: okClickText,
                                    cancelClickText: cancelClickText,
                                  ),
                                ];
                                DateTime.now().copyWith();
                                if (isColumn) {
                                  return Column(
                                    children: fields.divide(const SizedBox(height: 8)).toList(),
                                  );
                                }
                                return Row(children: fields);
                              },
                            ),
                          ),
                        ],
                      ),
                      if (state.hasError)
                        Text(
                          state.errorText ?? '',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.error,
                              ),
                        ).paddingOnly(top: 4),
                    ],
                  ),
                );
              },
            );
          },
        );
}

/// A DateRange picker tile that allows to select the from and to dates separately.
/// This can be used if we want to allow the user to select all the dates before a certain date, or all the dates after
/// one.
///
/// This Widget keeps track of the dates selected. If you want to synchronise these dates with the parent's state, use
/// [onInitialDateChanged] and [onFinalDateChanged].
///
/// See also:
///
///  * [ZdsDateTimePicker], which allows to select a day and hour together or separately
///  * [showDatePicker] to show a date picker directly
class ZdsDateRangePickerTile extends StatefulWidget {
  /// A DateRangePicker that allows to pick the "From" and "To" dates separately.
  ///
  /// If both are set, [earliestSelectableDate] must be on or before [latestSelectableDate].
  ZdsDateRangePickerTile({
    super.key,
    this.initialDate,
    this.finalDate,
    this.onInitialDateChanged,
    this.onFinalDateChanged,
    this.earliestSelectableDate,
    this.latestSelectableDate,
    this.initialDateController,
    this.finalDateController,
    this.format = 'dd/MM/yyyy',
    this.initialHelpText,
    this.finalHelpText,
    this.errorMessage = '',
    this.formKey,
    this.startDayOfWeek,
    this.okClickText,
    this.cancelClickText,
  }) : assert(
          (earliestSelectableDate != null && latestSelectableDate != null)
              ? earliestSelectableDate.isBefore(latestSelectableDate)
              : earliestSelectableDate == null,
          'Earliest selectable date must be before latest selectable date',
        );

  /// The DateTime selected in the "From" field. Set this if you want pre-initialized dates.
  ///
  /// If no date is selected, the field will be blank.
  final DateTime? initialDate;

  /// The DateTime selected in the "To" field. Set this if you want pre-initialized dates.
  ///
  /// If no date is selected, the field will be blank.
  final DateTime? finalDate;

  /// The text displayed at the top of the initial date picker window.
  final String? initialHelpText;

  /// The text displayed at the top of the final date picker window.
  final String? finalHelpText;

  /// A function called whenever the initial date changes. Use this to synchronise the DateRange's date with a date in
  /// the parent's state.
  final void Function(DateTime?)? onInitialDateChanged;

  /// A function called whenever the final date changes. Use this to synchronise the DateRange's date with a date in
  /// the parent's state.
  final void Function(DateTime?)? onFinalDateChanged;

  /// The earliest date that can be selected. Must be before the [latestSelectableDate].
  ///
  /// Defaults to 10 years in the past.
  final DateTime? earliestSelectableDate;

  /// The latest date that can be selected. Must be after the [earliestSelectableDate].
  ///
  /// Defaults to 10 years in the future.
  final DateTime? latestSelectableDate;

  /// A controller used to keep track of the selected initial date.
  final ZdsValueController<DateTime>? initialDateController;

  /// A controller used to keep track of the selected final date.
  final ZdsValueController<DateTime>? finalDateController;

  /// The format in which the [DateTime] will be formatted.
  ///
  /// See [DateFormat] for more details.
  final String format;

  /// The error message shown when an invalid date range is entered.
  final String errorMessage;

  /// The key attached to the form within the picker that can be used to check the validation of the inputs.
  final GlobalKey<FormState>? formKey;

  /// Starting day of week 1, 2, 3, Sunday, Monday, Tuesday respectively.
  final int? startDayOfWeek;

  /// The text displayed on the ok button.
  final String? okClickText;

  /// The text displayed on the cancel button.
  final String? cancelClickText;

  @override
  State<ZdsDateRangePickerTile> createState() => _ZdsDateRangePickerTileState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<DateTime?>('initialDate', initialDate))
      ..add(DiagnosticsProperty<DateTime?>('finalDate', finalDate))
      ..add(StringProperty('initialHelpText', initialHelpText))
      ..add(StringProperty('finalHelpText', finalHelpText))
      ..add(
        ObjectFlagProperty<void Function(DateTime? p1)?>.has(
          'onInitialDateChanged',
          onInitialDateChanged,
        ),
      )
      ..add(
        ObjectFlagProperty<void Function(DateTime? p1)?>.has(
          'onFinalDateChanged',
          onFinalDateChanged,
        ),
      )
      ..add(
        DiagnosticsProperty<DateTime?>(
          'earliestSelectableDate',
          earliestSelectableDate,
        ),
      )
      ..add(
        DiagnosticsProperty<DateTime?>(
          'latestSelectableDate',
          latestSelectableDate,
        ),
      )
      ..add(
        DiagnosticsProperty<ZdsValueController<DateTime>?>(
          'initialDateController',
          initialDateController,
        ),
      )
      ..add(
        DiagnosticsProperty<ZdsValueController<DateTime>?>(
          'finalDateController',
          finalDateController,
        ),
      )
      ..add(StringProperty('format', format))
      ..add(StringProperty('errorMessage', errorMessage))
      ..add(DiagnosticsProperty<GlobalKey<FormState>?>('formKey', formKey))
      ..add(IntProperty('startDayOfWeek', startDayOfWeek))
      ..add(StringProperty('okClickText', okClickText))
      ..add(StringProperty('cancelClickText', cancelClickText));
  }
}

double _calculateWidth(BoxConstraints constraints) {
  const double maxWidthScale = _screenColumnBreakpoint;
  const double maxScale = _screenColumnBreakpoint / 2;
  if (constraints.maxWidth < maxWidthScale) {
    return maxWidthScale.clamp(0, maxScale);
  } else {
    final double calculatedWidth = (constraints.maxWidth - _padding) / 2;
    return calculatedWidth.clamp(0, maxScale);
  }
}

class _ZdsDateRangePickerTileState extends State<ZdsDateRangePickerTile> {
  DateTime? initialDate;
  DateTime? finalDate;

  late final GlobalKey<FormState> formKey;

  @override
  void initState() {
    super.initState();
    initialDate = widget.initialDate ?? widget.initialDateController?.value;
    finalDate = widget.finalDate ?? widget.finalDateController?.value;

    widget.initialDateController?.updateListener = (DateTime? value) {
      setState(() {
        initialDate = value;
      });
      widget.initialDateController?.notifyListeners(value);
    };
    widget.finalDateController?.updateListener = (DateTime? value) {
      setState(() {
        finalDate = value;
      });
      widget.finalDateController?.notifyListeners(value);
    };

    formKey = widget.formKey ?? GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    return ZdsCard(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      final double width = _calculateWidth(constraints);
                      final bool isColumn = constraints.maxWidth <= _screenColumnBreakpoint;
                      final List<Widget> fields = <Widget>[
                        _DateField(
                          date: initialDate,
                          format: widget.format,
                          onDateChanged: widget.onInitialDateChanged,
                          initialSelectableDate: widget.earliestSelectableDate,
                          finalSelectableDate: widget.latestSelectableDate,
                          helpText: widget.initialHelpText,
                          updateDate: (DateTime? newValue) {
                            setState(() => initialDate = newValue);
                            widget.initialDateController?.notifyListeners(newValue);
                          },
                          validator: (DateTime? value) {
                            if (value != null && (finalDate != null && value.isAfter(finalDate!))) {
                              return widget.errorMessage;
                            }
                            return null;
                          },
                          isInitialDate: true,
                          width: width,
                          startDayOfWeek: widget.startDayOfWeek,
                          okClickText: widget.okClickText,
                          cancelClickText: widget.cancelClickText,
                        ),
                        SizedBox(
                          width: isColumn ? 0 : (constraints.maxWidth - (width * 2)) / 2,
                          height: isColumn ? 8 : 0,
                        ),
                        _DateField(
                          date: finalDate,
                          format: widget.format,
                          onDateChanged: widget.onFinalDateChanged,
                          initialSelectableDate: widget.earliestSelectableDate,
                          finalSelectableDate: widget.latestSelectableDate,
                          helpText: widget.finalHelpText,
                          updateDate: (DateTime? newValue) {
                            setState(() => finalDate = newValue);
                            widget.finalDateController?.notifyListeners(newValue);
                          },
                          validator: (DateTime? value) {
                            if (value != null && (initialDate != null && value.isBefore(initialDate!))) {
                              return widget.errorMessage;
                            }
                            return null;
                          },
                          width: width,
                          startDayOfWeek: widget.startDayOfWeek,
                          okClickText: widget.okClickText,
                          cancelClickText: widget.cancelClickText,
                        ),
                      ];

                      if (isColumn) {
                        return Column(
                          children: fields.divide(const SizedBox(height: 8)).toList(),
                        );
                      }
                      return Row(children: fields);
                    },
                  ),
                ),
              ),
            ],
          ),
          if (initialDate != null &&
              finalDate != null &&
              formKey.currentState != null &&
              !formKey.currentState!.validate())
            Text(
              widget.errorMessage,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.error),
            ).paddingOnly(top: 4),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<DateTime?>('initialDate', initialDate))
      ..add(DiagnosticsProperty<DateTime?>('finalDate', finalDate))
      ..add(DiagnosticsProperty<GlobalKey<FormState>>('formKey', formKey));
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.updateDate,
    required this.date,
    required this.format,
    required this.width,
    this.validator,
    this.initialSelectableDate,
    this.finalSelectableDate,
    this.helpText,
    this.onDateChanged,
    this.isInitialDate = false,
    this.okClickText,
    this.cancelClickText,
    this.startDayOfWeek,
  });
  final DateTime? date;
  final DateTime? initialSelectableDate;
  final DateTime? finalSelectableDate;
  final bool isInitialDate;
  final void Function(DateTime?)? onDateChanged;
  final void Function(DateTime?) updateDate;
  final String format;
  final String? helpText;
  final double width;
  final String? Function(DateTime?)? validator;

  /// Starting day of week 1, 2, 3, Sunday, Monday, Tuesday respectively.
  final int? startDayOfWeek;

  /// The text displayed on the ok button.
  final String? okClickText;

  /// The text displayed on the cancel button.
  final String? cancelClickText;

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime>(
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (FormFieldState<DateTime> state) {
        final zetaColors = Zeta.of(context).colors;
        return Container(
          width: width,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: state.hasError ? Theme.of(context).colorScheme.error : zetaColors.borderSubtle,
              ),
            ),
          ),
          child: MergeSemantics(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  isInitialDate
                      ? ComponentStrings.of(context).get('FROM', 'From')
                      : ComponentStrings.of(context).get('TO', 'To'),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: zetaColors.textSubtle),
                ).paddingOnly(left: 2),
                InkWell(
                  onTap: () async {
                    final DateTime initialPickerDate;
                    if (date != null) {
                      initialPickerDate = date!;
                    } else if (initialSelectableDate != null) {
                      if (initialSelectableDate!.isAfter(DateTime.now())) {
                        initialPickerDate = initialSelectableDate!;
                      } else {
                        initialPickerDate = DateTime.now();
                      }
                    } else {
                      initialPickerDate = DateTime.now();
                    }
                    final DateTime? selectedDate = await showZdsFiscalDatePicker(
                      format: format,
                      context: context,
                      initialDate: initialPickerDate,
                      firstDate: initialSelectableDate ?? DateTime.now().subtract(const Duration(days: 365 * 10)),
                      lastDate: finalSelectableDate ?? DateTime.now().add(const Duration(days: 365 * 10)),
                      titleText: helpText ?? 'Select Date',
                      cancelText: cancelClickText ?? ComponentStrings.of(context).get('CANCEL', 'Cancel'),
                      okText: okClickText ?? ComponentStrings.of(context).get('OK', 'OK'),
                      startDayOfWeek: startDayOfWeek ?? 1,
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: Theme.of(context).zdsDateTimePickerTheme,
                          child: child!,
                        );
                      },
                    );
                    state.didChange(selectedDate);
                    if (selectedDate != null) updateDate(selectedDate);
                    if (onDateChanged != null) {
                      onDateChanged?.call(selectedDate);
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(
                        height: _fontLineHeight,
                        child: date != null
                            ? Text(
                                date!.format(format),
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      height: _fontLineHeight / Theme.of(context).textTheme.bodyLarge!.fontSize!,
                                    ),
                              )
                            : null,
                      ),
                      Icon(
                        ZdsIcons.calendar,
                        color: zetaColors.iconSubtle,
                        size: 22,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<DateTime?>('date', date))
      ..add(
        DiagnosticsProperty<DateTime?>(
          'initialSelectableDate',
          initialSelectableDate,
        ),
      )
      ..add(
        DiagnosticsProperty<DateTime?>(
          'finalSelectableDate',
          finalSelectableDate,
        ),
      )
      ..add(DiagnosticsProperty<bool>('isInitialDate', isInitialDate))
      ..add(
        ObjectFlagProperty<void Function(DateTime? p1)?>.has(
          'onDateChanged',
          onDateChanged,
        ),
      )
      ..add(
        ObjectFlagProperty<void Function(DateTime? p1)>.has(
          'updateDate',
          updateDate,
        ),
      )
      ..add(StringProperty('format', format))
      ..add(StringProperty('helpText', helpText))
      ..add(DoubleProperty('width', width))
      ..add(
        ObjectFlagProperty<String? Function(DateTime? p1)?>.has(
          'validator',
          validator,
        ),
      )
      ..add(IntProperty('startDayOfWeek', startDayOfWeek))
      ..add(StringProperty('okClickText', okClickText))
      ..add(StringProperty('cancelClickText', cancelClickText));
  }
}
