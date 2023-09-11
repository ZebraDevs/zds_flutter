import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../zds_flutter.dart';

enum _ZdsCalendarVariant { switchable, monthly, weekly }

/// An adaptable calendar widget that can be used in a variety of ways, with selectable days and date ranges, as well
/// as event markers and different formats.
///
/// This calendar has three variants, each called with a different constructor:
/// * [ZdsCalendar], which allows to switch between a monthly and weekly format. It always has a header with the
/// current month and a format switcher.
/// * [ZdsCalendar.monthly], which shows a calendar with a fixed month format.
/// * [ZdsCalendar.weekly], which shows a calendar with a fixed week format.
///
/// For this widget, the [selectedDay] refers to the day currently selected (with a filled circle surrounding it),
/// while [TableCalendar.focusedDay] refers to the day that is currently in focus (shown on screen). The [TableCalendar.focusedDay] has no
/// special decoration and looks like any other day. The [selectedDay] may not be the [TableCalendar.focusedDay] and may not be
/// displayed on screen (the user selects a day on February and changes the month to March, making [selectedDay] a
/// day in February and [TableCalendar.focusedDay] a day in March).
///
/// Several callback functions are available to sync other widgets with this one. These are [onDaySelected],
/// [onRangeSelected], and [onPageChanged].
class ZdsCalendar extends StatefulWidget {
  /// The earliest date that will be shown on the calendar.
  final DateTime? firstDay;

  /// The last date that will be shown on the calendar.
  final DateTime? lastDay;

  /// set initial selected Date on the calendar
  final DateTime? initialSelectedDay;

  /// set and manage the selected day on the calendar. Will override intialSelectedDay.
  final DateTime? selectedDay;

  /// set Starting Day Of the week on the calendar
  final StartingDayOfWeek? startingDayOfWeek;

  /// set initial selected week on the calendar
  final DateTime? initialSelectedWeek;

  /// This enables all button to select current week of the calendar, Defaults to false.
  final bool showAllButton;

  /// Whether you can only select one unique day or can select a range of days. Defaults to false.
  final bool isRangeSelectable;

  /// A list with events. Can't be null. If markers are enabled, these events will be displayed on the calendar.
  final List<CalendarEvent> events;

  /// Whether the header should be shown or not. If using the [ZdsCalendar] constructor, the header will contain a
  /// format switcher. To not show a format switcher, use [ZdsCalendar.monthly] instead.
  final bool hasHeader;

  /// List of icons to be shown at the beginning of selected weeks.
  ///
  /// Defaults to empty.
  ///
  ///  See also:
  /// * [WeekIcon]
  final List<WeekIcon>? weekIcons;

  /// Whether to show a grid. Defaults to false.
  final bool isGridShown;

  /// Function called whenever the selected day changes. Takes two arguments, the selectedDay and the focusedDay.
  final void Function(DateTime, DateTime)? onDaySelected;

  /// Function called whenever a date range is selected. Takes three arguments, the starting day, the ending day, and
  /// the focusedDay. The starting and end day can be null.
  final void Function(DateTime?, DateTime?, DateTime)? onRangeSelected;

  /// Called whenever the user changes page. Takes one argument, the focused day.
  final void Function(DateTime)? onPageChanged;

  /// Function called whenever a all option is selected. Takes three arguments, the starting day, the ending day, and
  /// the focusedDay. The starting and end day can be null.
  final void Function(DateTime?, DateTime?, DateTime)? onAllSelected;

  /// Called whenever the format of the calendar is changed. Takes one argument, the new calendar format.
  final void Function(CalendarFormat)? onFormatChanged;

  final _ZdsCalendarVariant _variant;

  /// Padding around the header of the calendar
  ///
  /// Defaults to EdgeInsets.fromLTRB(4, 8, 8, 8)
  final EdgeInsets headerPadding;

  /// Function that creates a single event marker for a given `day`
  ///
  /// If this is null, the default marker is used
  final Widget? Function(BuildContext, DateTime, dynamic)? singleMarkerBuilder;

  /// Specifies swipe gestures available to `TableCalendar`.
  ///
  /// If `AvailableGestures.none` is used, the calendar will only be interactive via buttons.
  final AvailableGestures availableGestures;

  /// True if component is enabled and editable, false if read only.
  ///
  /// Defaults to true.
  final bool enabled;

  /// Color of the chevron icons on the calendar header
  ///
  /// Defaults to [ColorScheme.onSurface].
  final Color? calendarHeaderIconColor;

  /// Color of the text on the calendar header
  ///
  /// Defaults to [ColorScheme.onBackground].
  final Color? calendarHeaderTextColor;

  /// Custom color override for unselected days.
  ///
  /// Applies to both weekdays and weekends.
  final Color? calendarTextColor;

  /// A list of holiday dates. holiday will be shown on calendar with grey circle.
  ///
  /// /// Defaults to empty list
  final List<DateTime> holidayEvents;

  /// Label will be shown for all button.
  ///
  /// Defaults to 'All'.
  final String? allCustomLabel;

  /// Calendar widget that allows to switch between a monthly and weekly format. As such, the calendar header will
  /// always be shown. To not show the calendar header and use a monthly format, use [ZdsCalendar.monthly] instead.
  const ZdsCalendar({
    required this.events,
    super.key,
    this.showAllButton = false,
    this.onAllSelected,
    this.firstDay,
    this.lastDay,
    this.initialSelectedDay,
    this.selectedDay,
    this.startingDayOfWeek,
    this.initialSelectedWeek,
    this.weekIcons,
    this.isRangeSelectable = false,
    this.isGridShown = false,
    this.onDaySelected,
    this.onRangeSelected,
    this.onPageChanged,
    this.onFormatChanged,
    this.headerPadding = const EdgeInsets.fromLTRB(4, 8, 8, 8),
    this.singleMarkerBuilder,
    this.availableGestures = AvailableGestures.horizontalSwipe,
    this.enabled = true,
    this.calendarHeaderIconColor,
    this.calendarHeaderTextColor,
    this.calendarTextColor,
    this.holidayEvents = const [],
    this.allCustomLabel,
  })  : _variant = _ZdsCalendarVariant.switchable,
        hasHeader = true;

  /// Shows a calendar in a fixed monthly format.
  const ZdsCalendar.monthly({
    required this.events,
    super.key,
    this.showAllButton = false,
    this.onAllSelected,
    this.firstDay,
    this.lastDay,
    this.initialSelectedDay,
    this.selectedDay,
    this.startingDayOfWeek,
    this.initialSelectedWeek,
    this.hasHeader = true,
    this.weekIcons,
    this.isRangeSelectable = false,
    this.isGridShown = false,
    this.onDaySelected,
    this.onRangeSelected,
    this.onPageChanged,
    this.onFormatChanged,
    this.headerPadding = const EdgeInsets.fromLTRB(4, 8, 8, 8),
    this.singleMarkerBuilder,
    this.availableGestures = AvailableGestures.horizontalSwipe,
    this.enabled = true,
    this.calendarHeaderIconColor,
    this.calendarHeaderTextColor,
    this.calendarTextColor,
    this.holidayEvents = const [],
    this.allCustomLabel,
  }) : _variant = _ZdsCalendarVariant.monthly;

  /// Shows a calendar in a fixed weekly format.
  const ZdsCalendar.weekly({
    required this.events,
    super.key,
    this.showAllButton = false,
    this.onAllSelected,
    this.firstDay,
    this.lastDay,
    this.initialSelectedDay,
    this.selectedDay,
    this.startingDayOfWeek,
    this.initialSelectedWeek,
    this.isRangeSelectable = false,
    this.isGridShown = false,
    this.weekIcons,
    this.onDaySelected,
    this.onRangeSelected,
    this.onPageChanged,
    this.onFormatChanged,
    this.headerPadding = const EdgeInsets.fromLTRB(4, 8, 8, 8),
    this.singleMarkerBuilder,
    this.availableGestures = AvailableGestures.horizontalSwipe,
    this.enabled = true,
    this.calendarHeaderIconColor,
    this.calendarHeaderTextColor,
    this.calendarTextColor,
    this.holidayEvents = const [],
    this.allCustomLabel,
  })  : _variant = _ZdsCalendarVariant.weekly,
        hasHeader = false;

  @override
  State<ZdsCalendar> createState() => _ZdsCalendarState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<DateTime?>('firstDay', firstDay));
    properties.add(DiagnosticsProperty<DateTime?>('lastDay', lastDay));
    properties.add(DiagnosticsProperty<DateTime?>('initialSelectedDay', initialSelectedDay));
    properties.add(DiagnosticsProperty<DateTime?>('selectedDay', selectedDay));
    properties.add(EnumProperty<StartingDayOfWeek?>('startingDayOfWeek', startingDayOfWeek));
    properties.add(DiagnosticsProperty<DateTime?>('initialSelectedWeek', initialSelectedWeek));
    properties.add(DiagnosticsProperty<bool>('showAllButton', showAllButton));
    properties.add(DiagnosticsProperty<bool>('isRangeSelectable', isRangeSelectable));
    properties.add(IterableProperty<CalendarEvent>('events', events));
    properties.add(DiagnosticsProperty<bool>('hasHeader', hasHeader));
    properties.add(IterableProperty<WeekIcon>('weekIcons', weekIcons));
    properties.add(DiagnosticsProperty<bool>('isGridShown', isGridShown));
    properties.add(ObjectFlagProperty<void Function(DateTime p1, DateTime p2)?>.has('onDaySelected', onDaySelected));
    properties.add(
      ObjectFlagProperty<void Function(DateTime? p1, DateTime? p2, DateTime p3)?>.has(
        'onRangeSelected',
        onRangeSelected,
      ),
    );
    properties.add(ObjectFlagProperty<void Function(DateTime p1)?>.has('onPageChanged', onPageChanged));
    properties.add(
      ObjectFlagProperty<void Function(DateTime? p1, DateTime? p2, DateTime p3)?>.has(
        'onAllSelected',
        onAllSelected,
      ),
    );
    properties.add(ObjectFlagProperty<void Function(CalendarFormat p1)?>.has('onFormatChanged', onFormatChanged));
    properties.add(DiagnosticsProperty<EdgeInsets>('headerPadding', headerPadding));
    properties.add(
      ObjectFlagProperty<Widget? Function(BuildContext p1, DateTime p2, dynamic p3)?>.has(
        'singleMarkerBuilder',
        singleMarkerBuilder,
      ),
    );
    properties.add(EnumProperty<AvailableGestures>('availableGestures', availableGestures));
    properties.add(DiagnosticsProperty<bool>('enabled', enabled));
    properties.add(ColorProperty('calendarHeaderIconColor', calendarHeaderIconColor));
    properties.add(ColorProperty('calendarHeaderTextColor', calendarHeaderTextColor));
    properties.add(ColorProperty('calendarTextColor', calendarTextColor));
    properties.add(IterableProperty<DateTime>('holidayEvents', holidayEvents));
    properties.add(StringProperty('allCustomLabel', allCustomLabel));
  }
}

class _ZdsCalendarState extends State<ZdsCalendar> {
  late DateTime _focusedDay; // Used to be a ValueListenable?
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  DateTime? startOfweek;
  DateTime? endOfweek;
  late CalendarFormat _calendarFormat;

  @override
  void initState() {
    _focusedDay = widget.initialSelectedWeek ?? DateTime.now();
    _selectedDay = _selectedDay ?? widget.selectedDay ?? widget.initialSelectedDay;
    _calendarFormat = (widget._variant == _ZdsCalendarVariant.weekly) ? CalendarFormat.week : CalendarFormat.month;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ZdsCalendar oldWidget) {
    if (widget.selectedDay != null && oldWidget.selectedDay != widget.selectedDay) {
      setState(() {
        _selectedDay = widget.selectedDay;
      });
      widget.onDaySelected?.call(widget.selectedDay!, _focusedDay);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;
    final textTheme = Theme.of(context)
        .textTheme
        .titleSmall!
        .copyWith(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.w500);

    final StartingDayOfWeek startingDayOfWeek = widget.startingDayOfWeek ?? StartingDayOfWeek.sunday;
    final calendar = TableCalendar(
      startingDayOfWeek: startingDayOfWeek,
      availableGestures: widget.availableGestures,
      rowHeight: calendarRowHeight,
      // TODO(calendar): Determine initial and final dates
      firstDay: widget.firstDay ?? DateTime.fromMillisecondsSinceEpoch(0),
      lastDay: widget.lastDay ?? DateTime(17776),
      focusedDay: _focusedDay,
      rangeStartDay: _rangeStart,
      rangeEndDay: _rangeEnd,
      rangeSelectionMode: widget.isRangeSelectable ? RangeSelectionMode.enforced : RangeSelectionMode.disabled,
      calendarFormat: _calendarFormat,
      headerVisible: false,

      // Use `selectedDayPredicate` to determine which day is currently selected.
      // If this returns true, then `day` will be marked as selected.
      selectedDayPredicate: (day) {
        // Using `isSameDay` is recommended to disregard
        // the time-part of compared DateTime objects.
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(_selectedDay, selectedDay)) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        }
        widget.onDaySelected?.call(selectedDay, focusedDay);
      },
      onRangeSelected: (start, end, focusedDay) {
        setState(() {
          _focusedDay = focusedDay;
          _rangeStart = start;
          _rangeEnd = end;
        });
        widget.onRangeSelected?.call(start, end, focusedDay);
      },
      // TODO(calendar): Figure out why this onFormatChanged function doesn't seem to be called when changing the format
      // Currently, a workaround is being used.
      onFormatChanged: (format) {
        if (_calendarFormat != format) {
          setState(() {
            _calendarFormat = format;
          });
        }
      },
      onPageChanged: (focusedDay) {
        setState(() {
          _focusedDay = focusedDay;
          if (!widget.isRangeSelectable && !widget.showAllButton) {
            _selectedDay = focusedDay;
          }
        });
        widget.onPageChanged?.call(focusedDay);
      },
      locale: _getCurrentLocaleString(context),
      eventLoader: _getEventsForDay,
      holidayPredicate: _getHoliday,
      daysOfWeekHeight: widget._variant == _ZdsCalendarVariant.weekly ? 24 : calendarDaysOfWeekHeight,
      calendarBuilders: CalendarBuilders(
        dowBuilder: (context, day) {
          final text = DateFormat.E(languageCode).format(day)[0];
          return ExcludeSemantics(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                text,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.w500,
                      color: ZdsColors.greySwatch(
                        context,
                      )[Theme.of(context).colorScheme.brightness == Brightness.dark ? 700 : 900],
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
        singleMarkerBuilder: widget.singleMarkerBuilder,
      ),
      pageAnimationDuration: const Duration(milliseconds: 500),
      calendarStyle: CalendarStyle(
        tableBorder: widget.isGridShown
            ? TableBorder(
                borderRadius: BorderRadius.circular(4),
                horizontalInside: BorderSide(color: ZdsColors.greyCoolSwatch.shade100),
                verticalInside: BorderSide(color: ZdsColors.greyCoolSwatch.shade100),
                left: BorderSide(color: ZdsColors.greyCoolSwatch.shade100),
                right: BorderSide(color: ZdsColors.greyCoolSwatch.shade100),
              )
            : const TableBorder(),
        markersMaxCount: 1, // TODO(calendar): Redefine this if we want multiple dots.
        markerSize: 5,
        markerMargin: EdgeInsets.only(
          top: widget._variant == _ZdsCalendarVariant.weekly
              ? 8
              : widget.isGridShown
                  ? 6
                  : 8,
        ),
        cellMargin: EdgeInsets.all(widget.weekIcons != null && widget.weekIcons!.isNotEmpty ? 5 : 8),
        todayTextStyle: textTheme,
        defaultTextStyle: textTheme.copyWith(
          color: widget.calendarTextColor ?? Theme.of(context).colorScheme.onBackground,
        ),
        weekendTextStyle: textTheme.copyWith(
          color: widget.calendarTextColor ?? Theme.of(context).colorScheme.onBackground,
        ),
        holidayDecoration: BoxDecoration(
          color: ZdsColors.greyWarmSwatch[200],
          shape: BoxShape.circle,
        ),
        selectedTextStyle: textTheme.copyWith(color: Theme.of(context).colorScheme.onSecondary),
        outsideTextStyle: textTheme.copyWith(color: ZdsColors.blueGrey),
        rangeStartTextStyle: textTheme.copyWith(color: ZdsColors.white),
        rangeEndTextStyle: textTheme.copyWith(color: ZdsColors.white),
        rangeHighlightColor: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
        rangeStartDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          shape: BoxShape.circle,
        ),
        rangeEndDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          shape: BoxShape.circle,
        ),
        markerDecoration: BoxDecoration(
          color: ZdsColors.blueGrey,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.fromBorderSide(
            BorderSide(
              color: Theme.of(context).colorScheme.secondary,
              width: context.isSmallScreen() ? 0 : 1.5,
            ),
          ),
        ),
      ),
    )
        .paddingOnly(
          bottom: (widget._variant == _ZdsCalendarVariant.weekly) ? 6 : 10,
          top: (widget._variant == _ZdsCalendarVariant.weekly) ? 10 : 0,
        )
        .backgroundColor(Theme.of(context).colorScheme.surface);

    final calendarHeader = Container(
      color: Theme.of(context).colorScheme.surface,
      padding: widget.headerPadding,
      child: Material(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              color: widget.calendarHeaderIconColor ?? Theme.of(context).colorScheme.onSurface,
              splashRadius: 24,
              tooltip: MaterialLocalizations.of(context).previousMonthTooltip,
              onPressed: () => setState(
                () => _focusedDay = _focusedDay.startOfMonth.subtract(
                  const Duration(days: 1),
                ),
              ),
            ),
            ZdsPopupMenu(
              items: [
                for (int i = 1; i <= 12; i++)
                  ZdsPopupMenuItem(
                    value: i,
                    child: ListTile(
                      visualDensity: VisualDensity.compact,
                      // Shows the month's name
                      title: Text(DateFormat.MMMM(languageCode).format(DateTime(2000, i))),
                    ),
                  ),
              ],
              onSelected: (int monthNumber) => setState(() => _focusedDay = DateTime(_focusedDay.year, monthNumber)),
              builder: (_, open) => InkWell(
                onTap: open,
                borderRadius: BorderRadius.circular(8),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 110,
                    minHeight: 48,
                  ),
                  child: Align(
                    child: Semantics(
                      button: true,
                      child: Text(
                        _focusedDay.format('MMMM yyyy', languageCode),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: widget.calendarHeaderTextColor ?? Theme.of(context).colorScheme.onBackground,
                            ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              color: widget.calendarHeaderIconColor ?? Theme.of(context).colorScheme.onSurface,
              splashRadius: 24,
              tooltip: MaterialLocalizations.of(context).nextMonthTooltip,
              onPressed: () => setState(() => _focusedDay = _focusedDay.endOfMonth.add(const Duration(days: 1))),
            ),
            const Spacer(),
            if (widget._variant == _ZdsCalendarVariant.switchable)
              ZdsPopupMenu(
                onSelected: (CalendarFormat format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                    widget.onFormatChanged?.call(format);
                  }
                },
                items: [
                  ZdsPopupMenuItem(
                    value: CalendarFormat.month,
                    child: ListTile(
                      visualDensity: VisualDensity.compact,
                      title: Text(ComponentStrings.of(context).get('MONTH', 'Month')),
                    ),
                  ),
                  ZdsPopupMenuItem(
                    value: CalendarFormat.week,
                    child: ListTile(
                      visualDensity: VisualDensity.compact,
                      title: Text(ComponentStrings.of(context).get('WEEK', 'Week')),
                    ),
                  ),
                ],
                builder: (_, open) => InkWell(
                  onTap: open,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 4),
                    child: Row(
                      children: [
                        Text(
                          _calendarFormat == CalendarFormat.week
                              ? ComponentStrings.of(context).get('WEEK', 'Week')
                              : ComponentStrings.of(context).get('MONTH', 'Month'),
                          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );

    final List<int> weekNumbers = _focusedDay.getWeeksNumbersInMonth(startingDayOfWeek, _focusedDay);
    final List<DateTime> weekStartDays = () {
      DateTime firstDayOfWeeks = _focusedDay.startOfMonth.getFirstDayOfWeek();
      final List<DateTime> startDays = [];
      while (firstDayOfWeeks.month == _focusedDay.month || firstDayOfWeeks.month == _focusedDay.month - 1) {
        startDays.add(firstDayOfWeeks);
        firstDayOfWeeks = DateTime(firstDayOfWeeks.year, firstDayOfWeeks.month, firstDayOfWeeks.day + 7);
      }
      return startDays;
    }();

    final allButtonBody = [
      Container(
        alignment: Alignment.bottomCenter,
        height: context.isSmallScreen() ? 20 : calendarDaysOfWeekHeight - 3,
        child: Text(
          widget.allCustomLabel ?? ComponentStrings.of(context).get('ALL', 'All'),
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                fontWeight: FontWeight.w500,
                color: ZdsColors.greySwatch(
                  context,
                )[Theme.of(context).colorScheme.brightness == Brightness.dark ? 700 : 900],
              ),
        ),
      ),
      SizedBox(height: 2, width: context.isSmallScreen() ? 20 : 2),
      GestureDetector(
        onTap: () {
          setState(
            () {
              _selectedDay = null;
              startOfweek = getDate(
                _focusedDay.subtract(Duration(days: _focusedDay.weekday)),
              );
              endOfweek = getDate(
                _focusedDay.add(Duration(days: DateTime.daysPerWeek - _focusedDay.weekday - 1)),
              );
            },
          );
          widget.onAllSelected?.call(startOfweek, endOfweek, _focusedDay);
        },
        child: Container(
          alignment: Alignment.center,
          height: calendarRowHeight,
          width: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                _selectedDay == null ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.surface,
            border: Border.fromBorderSide(
              BorderSide(
                color: _selectedDay == null
                    ? Theme.of(context).colorScheme.secondary
                    : ZdsColors.greySwatch(context)[400]!,
                width: 1.5,
              ),
            ),
          ),
        ),
      ),
    ];

    final allButton = Semantics(
      selected: _selectedDay == null,
      label: ComponentStrings.of(context).get('ALL', 'All'),
      excludeSemantics: true,
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        height: context.isSmallScreen() ? null : calendarDaysOfWeekHeight + calendarRowHeight,
        width: context.isSmallScreen() ? null : 48,
        child: context.isSmallScreen()
            ? Row(mainAxisAlignment: MainAxisAlignment.center, children: allButtonBody)
            : Column(children: allButtonBody),
      ),
    );

    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.hasHeader) calendarHeader,
          if (widget.showAllButton && context.isSmallScreen()) Row(children: [Expanded(child: allButton)]),
          AbsorbPointer(
            absorbing: !widget.enabled,
            child: Opacity(
              opacity: widget.enabled ? 1.0 : 0.5,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.weekIcons != null)
                    Container(
                      color: Theme.of(context).colorScheme.surface,
                      width: context.isSmallScreen() ? 36 : 48,
                      child: () {
                        if (widget.weekIcons != null) {
                          final bool isWeekNumber = widget.weekIcons!.every(
                            (weekIcon) => weekIcon.weekNumber != null && weekIcon.year != null,
                          );
                          final bool isFirstDayOfWeek =
                              widget.weekIcons!.every((weekIcon) => weekIcon.firstDayOfWeek != null);
                          if (isWeekNumber || isFirstDayOfWeek) {
                            final List<dynamic> items = isWeekNumber ? weekNumbers : weekStartDays;
                            return Column(
                              children: [
                                const SizedBox(height: calendarDaysOfWeekHeight),
                                for (final index in items)
                                  SizedBox(
                                    height: calendarRowHeight,
                                    child: () {
                                      final WeekIcon? week = () {
                                        if (isWeekNumber) {
                                          if (widget.weekIcons!.any(
                                            (weeks) => weeks.year == _focusedDay.year && weeks.weekNumber == index,
                                          )) {
                                            return widget.weekIcons!.firstWhere(
                                              (weeks) => weeks.year == _focusedDay.year && weeks.weekNumber == index,
                                            );
                                          }
                                        } else {
                                          if (index is DateTime &&
                                              widget.weekIcons!
                                                  .any((weeks) => weeks.firstDayOfWeek?.isSameDay(index) ?? false)) {
                                            return widget.weekIcons!
                                                .firstWhere((weeks) => weeks.firstDayOfWeek == index);
                                          }
                                        }
                                      }();
                                      if (week != null) {
                                        return Semantics(
                                          label: week.semanticLabel,
                                          child: IconTheme(
                                            data: IconThemeData(
                                              color: ZdsColors.greySwatch(context)[
                                                  Theme.of(context).colorScheme.brightness == Brightness.dark
                                                      ? 700
                                                      : 900],
                                              size: context.isSmallScreen() ? 18 : 24,
                                            ),
                                            child: week.child,
                                          ),
                                        );
                                      }
                                    }(),
                                  ),
                                const SizedBox(height: 10),
                              ],
                            );
                          }
                        }
                        return null;
                      }(),
                    ),
                  if (widget.showAllButton && !context.isSmallScreen()) allButton,
                  Expanded(child: calendar),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getCurrentLocaleString(BuildContext context) {
    var currentLocale = const Locale('en', 'US');
    try {
      currentLocale = Localizations.localeOf(context);
    } catch (_) {
      debugPrint('Failed to load Localizations.localeOf(context)');
    }
    return '${currentLocale.languageCode}_${currentLocale.countryCode}';
  }

  List<CalendarEvent> _getEventsForDay(DateTime day) {
    return widget.events.where((event) => isSameDay(event.date, day)).toList();
  }

  bool _getHoliday(DateTime day) {
    if (widget.holidayEvents.isEmpty) {
      return false;
    } else {
      final isHoliday = widget.holidayEvents.contains(DateUtils.dateOnly(day));
      return isHoliday;
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<DateTime?>('startOfweek', startOfweek));
    properties.add(DiagnosticsProperty<DateTime?>('endOfweek', endOfweek));
  }
}

/// To get Current week of start and end day.
DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

/// Calendar Event model.
class CalendarEvent {
  /// Id of the event.
  final String id;

  /// Date / Time of the event.
  final DateTime date;

  /// Constructs a [CalendarEvent].
  const CalendarEvent({required this.id, required this.date});
}

/// Model for weeks that should have leading icons.
///
/// Should use either both `year` and `weekNumber` or `firstDayOfWeek`.
class WeekIcon {
  /// Year of week.
  final int? year;

  /// Week number in year.
  final int? weekNumber;

  /// The first day of the week for the icon to show.
  final DateTime? firstDayOfWeek;

  /// Widget to be displayed on the calendar.
  ///
  /// If an [Icon] is passed, the following styles are applied:
  /// * color: `ZdsColors.greySwatch(context)[900 (or 700 in dark mode)]`
  /// * size: `24`
  final Widget child;

  /// Semantic label for icon.
  final String? semanticLabel;

  /// Constructs a [WeekIcon].
  WeekIcon({
    required this.child,
    this.year,
    this.weekNumber,
    this.firstDayOfWeek,
    this.semanticLabel,
  }) : assert(
          year != null && weekNumber != null || firstDayOfWeek != null,
          'Should use either both year and weekNumber or firstDayOfWeek',
        );
}
