import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../zds_flutter.dart';

/// Extension to add dividers to any view that can take an iterable.
extension ListDivider on List<Widget> {
  /// Divides a list of widgets with separators.
  Iterable<Widget> divide(Widget separator) sync* {
    if (isEmpty) return;

    final Iterator<Widget> iterator = this.iterator..moveNext();
    yield iterator.current;
    while (iterator.moveNext()) {
      yield separator;
      yield iterator.current;
    }
  }
}

/// Extension on [DateTimeRange].
extension DateTimeRangeUtils on DateTimeRange {
  /// Returns true if this [DateTimeRange] ranges a full natural month (e.g. January 1 to January 31).
  bool get isWholeMonth {
    return start.year == end.year && start.month == end.month && start.day == 1 && start.endOfMonth.day == end.day;
  }
}

/// Gets the first day of the first week of a month.
/// Commonly this is not the first of the month, unless that happens to fall on the start day of the week.
///
/// Optional `startingDayOfWeek` defaults to sunday (1). See `startingDayOfWeekToInt` for more information
DateTime startMonthDay(DateTime date, {int startingDayOfWeek = 1}) {
  final d = date._firstDayOfWeek(startingDayOfWeek);
  return DateTime(d.year, d.month);
}

/// Extension on [DateTime].
extension DateTimeFormatter on DateTime {
  /// Applies a [DateFormat] to this [DateTime].
  String format([String template = 'MM/dd/yyyy KK:mm a', String locale = 'en_US']) {
    return DateFormat(template, locale).format(this);
  }

  /// Returns date at 00:00:00
  DateTime get toMidnight {
    return DateTime(year, month, day);
  }

  /// Gets weekday from DateTime where sunday is 0 and saturday is 6
  int get getWeekday => weekday % 7;

  /// Returns the first day of the month of this [DateTime].
  DateTime get startOfMonth => DateTime(year, month);

  /// Returns the last day of the month in this [DateTime].
  DateTime get endOfMonth => DateTime(year, month + 1, 0);

  /// Gets the week number within a year.
  int get weekNumberOfYear {
    final int dayOfYear = int.parse(DateFormat('D').format(this));
    final myWeekday = weekday == 7 ? 1 : weekday + 1;
    int woy = ((dayOfYear - myWeekday + 10) / 7).floor();
    if (woy < 1) {
      woy = numberOfWeeksInYear(year - 1);
    } else if (woy > numberOfWeeksInYear(year)) {
      woy = 1;
    }
    return woy + 1;
  }

  int _getWeekNumber(DateTime date, int startingDayOfWeek) {
    final int dayOfYear = int.parse(DateFormat('D').format(date));
    int woy = ((dayOfYear - startingDayOfWeek + 10) / 7).floor();
    if (woy < 1) {
      woy = numberOfWeeksInYear(year - 1);
    } else if (woy > numberOfWeeksInYear(year)) {
      woy = 1;
    }
    return woy;
  }

  /// Returns true if the input DateTimes are on the same day, ignoring the time.
  bool isSameDay(DateTime input) {
    return input.year == year && input.month == month && input.day == day;
  }

  /// returns first date of the week
  DateTime _firstDayOfWeek(int startingDayOfWeekInt) {
    final date = this;
    final int weekNumber = _getWeekDayNumber(DateFormat('EEEE').format(date));
    final int difference = weekNumber - startingDayOfWeekInt;
    return date.subtract(Duration(days: difference));
  }

  /// Gets the week numbers for a month
  List<int> getWeeksNumbersInMonth(StartingDayOfWeek startingDayOfWeek, DateTime focusedDay) {
    final int startingDayOfWeekInt = startingDayOfWeekToInt(startingDayOfWeek);

    final DateTime startOfMonthDate = DateTime(year, month);
    final DateTime endOfMonthDate =
        DateTime(year, month).endOfMonth._firstDayOfWeek(startingDayOfWeekInt).add(const Duration(days: 6));
    final monthTotal = endOfMonthDate.difference(startOfMonthDate).inDays;

    final List<DateTime> weekNumbers = [];
    for (int i = 0; i < monthTotal; i = i + 7) {
      weekNumbers.add(startOfMonthDate.add(Duration(days: i))._firstDayOfWeek(startingDayOfWeekInt));
    }

    final List<int> weeks = [];
    for (final week in weekNumbers) {
      final weekNum = _getWeekNumber(week, startingDayOfWeekInt);
      weeks.add(weekNum);
    }
    return weeks;
  }

  /// Gets first day of week.
  /// * `weekStartDay` is 0 indexed where Sunday is 0 and Saturday is 6
  /// Defaults to 0.
  DateTime getFirstDayOfWeek({int weekStartDay = 0}) {
    return DateTime(
      year,
      month,
      day - (getWeekday < weekStartDay ? 7 - weekStartDay + getWeekday : getWeekday - weekStartDay),
      hour,
      minute,
      second,
    );
  }

  /// Gets last day of week.
  /// * `weekStartDay` is 0 indexed where Sunday is 0 and Saturday is 6
  /// Defaults to 0.
  DateTime getLastDayOfWeek({int weekStartDay = 0}) {
    final first = getFirstDayOfWeek(weekStartDay: weekStartDay);
    return DateTime(
      first.year,
      first.month,
      first.day + 6,
      first.hour,
      first.minute,
      first.second,
    );
  }

  int _getWeekDayNumber(String weekDay) {
    int dayOfWeekNumber = -1;
    switch (weekDay) {
      case 'Sunday':
        dayOfWeekNumber = 1;
      case 'Monday':
        dayOfWeekNumber = 2;
      case 'Tuesday':
        dayOfWeekNumber = 3;
      case 'Wednesday':
        dayOfWeekNumber = 4;
      case 'Thursday':
        dayOfWeekNumber = 5;
      case 'Friday':
        dayOfWeekNumber = 6;
      case 'Saturday':
        dayOfWeekNumber = 7;
    }
    return dayOfWeekNumber;
  }
}

/// Returns an int representing the starting day of week.
///
/// 1 indexed starting at sunday
int startingDayOfWeekToInt(StartingDayOfWeek startingDayOfWeek) {
  switch (startingDayOfWeek) {
    case StartingDayOfWeek.sunday:
      return 1;
    case StartingDayOfWeek.monday:
      return 2;
    case StartingDayOfWeek.tuesday:
      return 3;
    case StartingDayOfWeek.wednesday:
      return 4;
    case StartingDayOfWeek.thursday:
      return 5;
    case StartingDayOfWeek.friday:
      return 6;
    case StartingDayOfWeek.saturday:
      return 7;
  }
}

/// Gets the date of the sunday of a week in a year.
DateTime firstSundayFromWeekInYear(int weekNumber, int year) {
  final weekDay = DateTime(2022).add(Duration(days: (weekNumber - 2) * 7));
  return weekDay.add(Duration(days: (DateTime.sunday - weekDay.weekday) % DateTime.daysPerWeek));
}

/// Gets the number of weeks in a year
int numberOfWeeksInYear(int year) {
  final DateTime dec28 = DateTime(year, 12, 28);
  final int dayOfDec28 = int.parse(DateFormat('D').format(dec28));
  return ((dayOfDec28 - dec28.weekday + 10) / 7).floor();
}

/// DateTime extension on [String].
extension DateTimeParser on String {
  /// Creates a [DateTime] from this [DateFormat].template string.
  DateTime? parseDate([String template = 'MM/dd/yyyy KK:mm a', String locale = 'en_US']) {
    try {
      return DateFormat(template, locale).parse(this);
    } catch (e) {
      return null;
    }
  }
}

/// Selection of extensions to [Color].
extension LightHexColor on Color {
  /// Lightens this [Color].
  Color withLight(double opacity, {Color? background}) {
    return Color.fromRGBO(
      _transform(opacity, red, (background ?? ZdsColors.white).red),
      _transform(opacity, green, (background ?? ZdsColors.white).green),
      _transform(opacity, blue, (background ?? ZdsColors.white).blue),
      1,
    );
  }

  /// Creates a [Color] from a String.
  ///
  /// The String follows either of the "RRGGBB" or "AARRGGBB" formats, with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Returns this Color's hexcode.
  ///
  /// Prefixes a hash sign if [leadingHashSign] is set to true (defaults to true).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';

  /// Returns this Color's hexcode without the alpha channel.
  ///
  /// Prefixes a hash sign if [leadingHashSign] is set to true (defaults to true).
  String toHexNoAlpha({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

int _transform(double p, int t, int b) {
  return (p * t + (1 - p) * b).round();
}

/// Render extensions on [BuildContext].
extension BuildContextRenderBox on BuildContext {
  /// Returns a [Rect] representing this widget's bounds.
  Rect get widgetBounds {
    return (owner != null && widgetRenderBox != null) ? widgetRenderBox!.semanticBounds : Rect.zero;
  }

  /// Returns an [Offset] representing this widget's screen position, with 0,0 being the top left of the screen.
  Offset get widgetGlobalPosition {
    return (owner != null && widgetRenderBox != null) ? widgetRenderBox!.localToGlobal(Offset.zero) : Offset.zero;
  }

  /// Returns this widget's [RenderBox].
  RenderBox? get widgetRenderBox {
    return findRenderObject() as RenderBox?;
  }
}

/// Shows a dialog with a [CircularProgressIndicator], used to indicate loading.
extension LoaderDialog on CircularProgressIndicator {
  /// Shows a dialog with a progress indicator, used to indicate loading while blocking the user's interaction with the
  /// app.
  ///
  /// Typically used where the completion of this action is necessary and should not be interrupted by the user (like a
  /// transaction, or saving an important and required file).
  static Future<void> show(BuildContext context, {required GlobalKey keyLoader}) async {
    await showDialog<void>(
      barrierDismissible: false,
      context: context,
      useRootNavigator: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: ZdsColors.transparent,
          elevation: 0,
          key: keyLoader,
          insetPadding: EdgeInsets.zero,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: const Center(
            child: SizedBox(
              height: 80,
              width: 80,
              child: ZdsCard(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(strokeWidth: 3),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Attempts to launch this urlString on a web view.
extension LaunchUrlInWebView on Uri {
  /// Attempts to launch this urlString on a web view.
  Future<bool> launch() => launchUrl(this);
}

/// Converts an input color into its shade with lightness
/// [input] Color to be converted
/// [shade] Shade from 0-1
Color getShadedColor(Color input, double shade) {
  return Color.fromARGB(
    input.alpha,
    changeShade(input.red, 1 - shade),
    changeShade(input.green, 1 - shade),
    changeShade(input.blue, 1 - shade),
  );
}

/// Converts individual red, green, or blue of an input color to match a specific lightness shade
/// [rgb] Red, green or blue color value of the initial color
/// [shade] Shade from 0-1
int changeShade(int rgb, double shade) => rgb + ((255 - rgb) * shade).floor();

/// Calculates a foreground color based on the input background color
/// [color] background color
Color computeForeground(Color color) {
  return color.isDark ? ZdsColors.white : ZdsColors.darkGrey;
}

/// System overlay should be opposite to the brightness of the background color.
SystemUiOverlayStyle computeSystemOverlayStyle(Color color) {
  return color.isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;
}

/// Checks if the color scheme is using warm or cool greys and returns the correct swatch.
extension ZdsCheckIsWarm on ThemeData {
  /// Checks if the color scheme is using warm or cool greys.
  bool get isWarm => colorScheme.background != ZdsColors.greyCoolSwatch[50];

  /// Gets correct [ZdsColors.greySwatch] based on if color scheme is warm or cool.
  MaterialColor get greySwatch => isWarm ? ZdsColors.greyWarmSwatch : ZdsColors.greyCoolSwatch;
}

/// Converts byte length to human readable format.
String fileSizeWithUnit(int bytes) {
  if (bytes <= 0) return '0 B';
  const suffixes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
  final i = (log(bytes) / log(1024)).floor();
  return '${(bytes / pow(1024, i)).toStringAsFixed(0)} ${suffixes[i]}';
}

/// Returns a color from a set of chosen theme colors.
///
/// Passing the same seed will yield the same color. Any object can be used as a seed.
Color getRandomColorFromTheme(Object? seed, {List<Color>? colors}) {
  final List<Color> setColors;
  Object? s = seed;

  if (colors == null || colors.isEmpty) {
    setColors = [
      ZdsColors.redSwatch['dark']!,
      ZdsColors.blueGrey,
      ZdsColors.blue,
      ZdsColors.teal,
      ZdsColors.purple,
      ZdsColors.greenSwatch['dark']!,
    ];
  } else {
    setColors = colors;
  }

  // If the Object is null (e.g. a user whose ID is null), then we always give it a set seed so the color returned is
  // the same each time
  s ??= 123;

  return setColors[Random(s.hashCode).nextInt(setColors.length)];
}

/// Checks if the ZdsTab contains an icon
bool hasIcons(List<ZdsTab> items) {
  return items.any((element) => element.icon != null);
}

/// Enum to define device types.
enum DeviceType {
  /// A device with a shortest side lower than 550dp that is in landscape mode.
  phoneLandscape,

  /// A device with a shortest side larger than 550dp that is in landscape mode
  tabletLandscape,

  /// A device with a shortest side lower than 550dp that is in portrait mode.
  phonePortrait,

  /// A device with a shortest side larger than 550dp that is in portrait mode
  tabletPortrait,
}

/// Utils to determine the [DeviceType] from the current context.
extension DeviceTypeFromContext on BuildContext {
  /// Determines the [DeviceType] from the current context.
  DeviceType getDeviceType() {
    final Orientation orientation = MediaQuery.of(this).orientation;
    if (MediaQuery.of(this).size.shortestSide < 550) {
      if (orientation == Orientation.landscape) {
        return DeviceType.phoneLandscape;
      } else {
        return DeviceType.phonePortrait;
      }
    } else if (orientation == Orientation.landscape) {
      return DeviceType.tabletLandscape;
    } else {
      return DeviceType.tabletPortrait;
    }
  }

  /// True if current device is a tablet.
  bool isTablet() {
    final deviceType = getDeviceType();
    return deviceType == DeviceType.tabletLandscape || deviceType == DeviceType.tabletPortrait;
  }

  /// True if current device is a phone.
  bool isPhone() {
    final deviceType = getDeviceType();
    return deviceType == DeviceType.phoneLandscape || deviceType == DeviceType.phonePortrait;
  }

  /// True if device is a tablet and landscape.
  bool isTabletLandscape() => getDeviceType() == DeviceType.tabletLandscape;

  /// Max width of small screen.
  static const int smallScreenBreakpoint = 330;

  /// True if the device screen is rather small
  bool isSmallScreen() => MediaQuery.of(this).size.width < smallScreenBreakpoint;

  /// True if the device screen height is rather small (please rename this)
  bool isShortScreen() => MediaQuery.of(this).size.height < smallScreenBreakpoint;

  /// True is device orientation is portrait.
  bool isPortrait() => MediaQuery.of(this).orientation == Orientation.portrait;

  /// True if device orientation is landscape.
  bool isLandscape() => MediaQuery.of(this).orientation == Orientation.landscape;
}

TextPainter _textPainter(String text, TextStyle style, int maxLines, [double maxWidth = double.infinity]) {
  return TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: maxLines,
    textDirection: ui.TextDirection.ltr,
  )..layout(maxWidth: maxWidth);
}

/// Determines if [text] will overflow in a given [width].
///
/// Optionally [maxLines] can be provided to check overflow on text with more than one line, otherwise it defaults to 1.
///
/// See also:
///   * [TextPainter]
bool hasTextOverflow(String text, TextStyle style, double width, {int maxLines = 1}) {
  final TextPainter textPainter = _textPainter(text, style, maxLines, width);
  return textPainter.didExceedMaxLines;
}

/// Gets the width of a [text] with a given [style].
///
/// Optionally [maxLines] can be provided to check overflow on text with more than one line, otherwise it defaults to 1.
///
/// See also:
///   * [TextPainter]
double textWidth(String text, TextStyle style, {int maxLines = 1}) => _textPainter(text, style, maxLines).width;

/// Returns the corresponding value for a given `selectedOption` from the `branches` map.
extension MapExtensions<Option, Value> on Map<Option, Value> {
  /// Returns the corresponding value for a given [key].
  /// If the [key] is not found within the map, or if the value for that key is `null`,
  /// the [orDefault] value is returned.
  ///
  /// Parameters:
  /// - `key`: The key to be looked up in the map.
  /// - `orDefault` (optional): The default value to be returned if the [key] is not found or if its value is `null`.
  ///                           If not provided, it defaults to `null`.
  ///
  /// Example:
  ///
  /// ```dart
  /// var fruitColors = {
  ///   'apple': 'red',
  ///   'banana': 'yellow',
  ///   'grape': 'purple'
  /// };
  /// print(fruitColors.get('apple', orDefault: 'unknown')); // Outputs: red
  /// print(fruitColors.get('orange', orDefault: 'unknown')); // Outputs: unknown
  /// ```
  Value? get(Option key, {Value? orDefault}) {
    return this[key] ?? orDefault;
  }
}
