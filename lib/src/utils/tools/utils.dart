import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

import '../../components/atoms/card.dart';
import '../../components/atoms/tab.dart';

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
  final DateTime d = date._firstDayOfWeek(startingDayOfWeek);
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
    final int myWeekday = weekday == 7 ? 1 : weekday + 1;
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
    final DateTime date = this;
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
    final int monthTotal = endOfMonthDate.difference(startOfMonthDate).inDays;

    final List<DateTime> weekNumbers = <DateTime>[];
    for (int i = 0; i < monthTotal; i = i + 7) {
      weekNumbers.add(startOfMonthDate.add(Duration(days: i))._firstDayOfWeek(startingDayOfWeekInt));
    }

    final List<int> weeks = <int>[];
    for (final DateTime week in weekNumbers) {
      final int weekNum = _getWeekNumber(week, startingDayOfWeekInt);
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
    final DateTime first = getFirstDayOfWeek(weekStartDay: weekStartDay);
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
  final DateTime weekDay = DateTime(2022).add(Duration(days: (weekNumber - 2) * 7));
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

  /// Returns a Color parsed from the contents of the String.
  ///
  /// Supports Hex colors with or without a leading #
  Color? toColor() {
    try {
      var hexColor = toUpperCase().replaceAll('#', ''); // Remove '#' and make uppercase for consistency.

      if (hexColor.length == 3) {
        // Convert shorthand (3 digits) to full length (6 digits)
        hexColor = hexColor.split('').map((c) => '$c$c').join();
      } else if (hexColor.length == 6) {
        // If 6 digits, append 'FF' for alpha at the beginning
        hexColor = 'FF$hexColor';
      } else if (hexColor.length != 8) {
        throw const FormatException('Invalid hex color format');
      }

      return Color(int.parse(hexColor, radix: 16));
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
      _transform(opacity, red, (background ?? Colors.white).red),
      _transform(opacity, green, (background ?? Colors.white).green),
      _transform(opacity, blue, (background ?? Colors.white).blue),
      1,
    );
  }

  /// This getter on the Color class that determines if the color is warm or not.
  /// We can use the Hue-Saturation-Value (HSV) representation of the color.
  /// A color is generally considered warm if its hue lies between 0 and 180 degrees.
  bool get isWarm {
    final HSVColor hsvColor = HSVColor.fromColor(this);
    return hsvColor.hue >= 0 && hsvColor.hue <= 180;
  }

  /// Creates a [Color] from a String.
  ///
  /// The String follows either of the "RRGGBB" or "AARRGGBB" formats, with an optional leading "#".
  static Color fromHex(String hexString) {
    final StringBuffer buffer = StringBuffer();
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
          backgroundColor: Colors.transparent,
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

/// System overlay should be opposite to the brightness of the background color.
SystemUiOverlayStyle computeSystemOverlayStyle(Color color) {
  return (color.isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark).copyWith(
    statusBarColor: Colors.transparent,
  );
}

/// Converts byte length to human readable format.
String fileSizeWithUnit(int bytes) {
  if (bytes <= 0) return '0 B';
  const List<String> suffixes = <String>['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
  final int i = (log(bytes) / log(1024)).floor();
  return '${(bytes / pow(1024, i)).toStringAsFixed(0)} ${suffixes[i]}';
}

/// Returns a color from a set of chosen theme colors.
///
/// Passing the same seed will yield the same color. Any object can be used as a seed.
Color getRandomColorFromTheme(Object? seed, {List<Color>? colors}) {
  final List<Color> setColors;
  Object? s = seed;

  if (colors == null || colors.isEmpty) {
    setColors = <ui.Color>[
      ZetaColorBase.red,
      ZetaColorBase.orange,
      ZetaColorBase.yellow,
      ZetaColorBase.green,
      ZetaColorBase.blue,
      ZetaColorBase.teal,
      ZetaColorBase.pink,
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
  return items.any((ZdsTab element) => element.icon != null);
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
    final DeviceType deviceType = getDeviceType();
    return deviceType == DeviceType.tabletLandscape || deviceType == DeviceType.tabletPortrait;
  }

  /// True if current device is a phone.
  bool isPhone() {
    final DeviceType deviceType = getDeviceType();
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

/// This extension adds utility functions to the Map class.
extension MapExtensions<Option, Value> on Map<Option, Value> {
  /// Gets the value from the map for the provided key. If the key does not
  /// exist in the map, it returns the value of the `fallback` parameter.
  ///
  /// - Parameters:
  ///   - key: The key for which to fetch the value from the map.
  ///   - fallback: The value to be returned if the key does not exist in the map.
  ///
  /// - Returns: The value for the given key if it exists, otherwise the `fallback` value.
  Value get(Option key, {required Value fallback}) {
    return this[key] ?? fallback;
  }
}

/// Method to return 'TextStyle'. This method will return a safe text style
/// by providing a fallback to a default text style when no text style is provided.
TextStyle safeTextStyle(TextStyle? style) {
  // Use the provided style if it exists, else we use the default TextStyle.
  return style ?? const TextStyle();
}

/// rotate array to left by position
List<T> rotateArrayLeft<T>(List<T> array, int positions) {
  final length = array.length;
  final normalizedPositions = positions % length;
  final rotatedPart = array.sublist(0, normalizedPositions);
  final remainingPart = array.sublist(normalizedPositions);
  return remainingPart + rotatedPart;
}

/// Generates a MaterialStateProperty based on given values for different states.
MaterialStateProperty<T?> materialStatePropertyResolver<T>({
  // Value when MaterialState is hovered
  T? hoveredValue,
  // Value when MaterialState is focused
  T? focusedValue,
  // Value when MaterialState is pressed
  T? pressedValue,
  // Value when MaterialState is dragged
  T? draggedValue,
  // Value when MaterialState is selected
  T? selectedValue,
  // Value when MaterialState is scrolledUnder
  T? scrolledUnderValue,
  // Value when MaterialState is disabled
  T? disabledValue,
  // Value when MaterialState is error
  T? errorValue,
  // Default value when no state is present
  T? defaultValue,
}) {
  // The blocks check for each possible state and returns the value
  // If none of the states is present, default value is returned
  return MaterialStateProperty.resolveWith<T?>((states) {
    if (hoveredValue != null && states.contains(MaterialState.hovered)) return hoveredValue;
    if (focusedValue != null && states.contains(MaterialState.focused)) return focusedValue;
    if (pressedValue != null && states.contains(MaterialState.pressed)) return pressedValue;
    if (draggedValue != null && states.contains(MaterialState.dragged)) return draggedValue;
    if (selectedValue != null && states.contains(MaterialState.selected)) return selectedValue;
    if (scrolledUnderValue != null && states.contains(MaterialState.scrolledUnder)) return scrolledUnderValue;
    if (disabledValue != null && states.contains(MaterialState.disabled)) return disabledValue;
    if (errorValue != null && states.contains(MaterialState.error)) return errorValue;
    return defaultValue;
  });
}

/// it gives us a allowed file types
/// If [useLiveMediaOnly] is true then we remove all media (images & videos) types from [allowedFileTypes] set of strings
/// If [useLiveMediaOnly] is false then we return [allowedFileTypes] as it is.
Set<String> getAllowedFileBrowserTypes({required bool useLiveMediaOnly, required Set<String> allowedFileTypes}) {
  if (useLiveMediaOnly) {
    final allowedFileBrowserTypes = Set<String>.from(allowedFileTypes)
      //remove all image file type
      ..removeWhere(
        (element) => {
          'apng',
          'avif',
          'gif',
          'jpg',
          'jpeg',
          'jfif',
          'pjpeg',
          'pjp',
          'png',
          'svg',
          'webp',
          'bmp',
          'ico',
          'cur',
          'tif',
          'tiff',
          'heif',
        }.contains(element),
      )
      //remove all video file type
      ..removeWhere(
        (element) => {
          'mp4',
          'mov',
          'm4v',
          'hevc',
          '3gp',
          'mkv',
          'ts',
          'webm',
        }.contains(element),
      );
    return allowedFileBrowserTypes;
  }
  return allowedFileTypes;
}

//// Generates color from String
extension ColorFromString on String {
  /// Creates a [Color] from a String.
  ///
  /// The String follows either of the "RRGGBB" or "AARRGGBB" formats, with an optional leading "#".
  Color colorFromHex() {
    final StringBuffer buffer = StringBuffer();
    if (length == 6 || length == 7) buffer.write('ff');
    buffer.write(replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  //// Function to convert CSS color string (rgb or rgba) to RGB
  Color colorFromRGBString() {
    final rgbaMatch = RegExp(r'rgba?\((\d+),\s*(\d+),\s*(\d+)(?:,\s*\d+\.?\d*)?\)').firstMatch(this);
    final red = int.parse(rgbaMatch?.group(1) ?? '0');
    final green = int.parse(rgbaMatch?.group(2) ?? '0');
    final blue = int.parse(rgbaMatch?.group(3) ?? '0') >> 16;
    final color = Color.fromRGBO(red, green, blue, 1);
    return color; //Color.fromRGBO(red,green,blue, 0.5);
  }

  //// Function to convert named CSS colors to RGB
  Color? colorFromNamedColor() {
    final Map<String, Color> namedColors = {
      'aliceBlue': const Color(0xFFF0F8FF),
      'antiqueWhite': const Color(0xFFFAEBD7),
      'aqua': const Color(0xFF00FFFF),
      'aquamarine': const Color(0xFF7FFFD4),
      'azure': const Color(0xFFF0FFFF),
      'beige': const Color(0xFFF5F5DC),
      'bisque': const Color(0xFFFFE4C4),
      'black': const Color(0xFF000000),
      'blanchedAlmond': const Color(0xFFFFEBCD),
      'blue': const Color(0xFF0000FF),
      'blueViolet': const Color(0xFF8A2BE2),
      'brown': const Color(0xFFA52A2A),
      'burlyWood': const Color(0xFFDEB887),
      'cadetBlue': const Color(0xFF5F9EA0),
      'chartreuse': const Color(0xFF7FFF00),
      'chocolate': const Color(0xFFD2691E),
      'coral': const Color(0xFFFF7F50),
      'cornflowerBlue': const Color(0xFF6495ED),
      'cornsilk': const Color(0xFFFFF8DC),
      'crimson': const Color(0xFFDC143C),
      'cyan': const Color(0xFF00FFFF),
      'darkBlue': const Color(0xFF00008B),
      'darkCyan': const Color(0xFF008B8B),
      'darkGoldenRod': const Color(0xFFB8860B),
      'darkGray': const Color(0xFFA9A9A9),
      'darkGreen': const Color(0xFF006400),
      'darkGrey': const Color(0xFFA9A9A9),
      'darkKhaki': const Color(0xFFBDB76B),
      'darkMagenta': const Color(0xFF8B008B),
      'darkOliveGreen': const Color(0xFF556B2F),
      'darkOrange': const Color(0xFFFF8C00),
      'darkOrchid': const Color(0xFF9932CC),
      'darkRed': const Color(0xFF8B0000),
      'darkSalmon': const Color(0xFFE9967A),
      'darkSeaGreen': const Color(0xFF8FBC8F),
      'darkSlateBlue': const Color(0xFF483D8B),
      'darkSlateGray': const Color(0xFF2F4F4F),
      'darkSlateGrey': const Color(0xFF2F4F4F),
      'darkTurquoise': const Color(0xFF00CED1),
      'darkViolet': const Color(0xFF9400D3),
      'deepPink': const Color(0xFFFF1493),
      'deepSkyBlue': const Color(0xFF00BFFF),
      'dimGray': const Color(0xFF696969),
      'dimGrey': const Color(0xFF696969),
      'dodgerBlue': const Color(0xFF1E90FF),
      'fireBrick': const Color(0xFFB22222),
      'floralWhite': const Color(0xFFFFFAF0),
      'forestGreen': const Color(0xFF228B22),
      'fuchsia': const Color(0xFFFF00FF),
      'gainsboro': const Color(0xFFDCDCDC),
      'ghostWhite': const Color(0xFFF8F8FF),
      'gold': const Color(0xFFFFD700),
      'goldenRod': const Color(0xFFDAA520),
      'gray': const Color(0xFF808080),
      'green': const Color(0xFF008000),
      'greenYellow': const Color(0xFFADFF2F),
      'grey': const Color(0xFF808080),
      'honeyDew': const Color(0xFFF0FFF0),
      'hotPink': const Color(0xFFFF69B4),
      'indianRed': const Color(0xFFCD5C5C),
      'indigo': const Color(0xFF4B0082),
      'ivory': const Color(0xFFFFFFF0),
      'khaki': const Color(0xFFF0E68C),
      'lavender': const Color(0xFFE6E6FA),
      'lavenderBlush': const Color(0xFFFFF0F5),
      'lawnGreen': const Color(0xFF7CFC00),
      'lemonChiffon': const Color(0xFFFFFACD),
      'lightBlue': const Color(0xFFADD8E6),
      'lightCoral': const Color(0xFFF08080),
      'lightCyan': const Color(0xFFE0FFFF),
      'lightGoldenRodYellow': const Color(0xFFFAFAD2),
      'lightGray': const Color(0xFFD3D3D3),
      'lightGreen': const Color(0xFF90EE90),
      'lightGrey': const Color(0xFFD3D3D3),
      'lightPink': const Color(0xFFFFB6C1),
      'lightSalmon': const Color(0xFFFFA07A),
      'lightSeaGreen': const Color(0xFF20B2AA),
      'lightSkyBlue': const Color(0xFF87CEFA),
      'lightSlateGray': const Color(0xFF778899),
      'lightSlateGrey': const Color(0xFF778899),
      'lightSteelBlue': const Color(0xFFB0C4DE),
      'lightYellow': const Color(0xFFFFFFE0),
      'lime': const Color(0xFF00FF00),
      'limeGreen': const Color(0xFF32CD32),
      'linen': const Color(0xFFFAF0E6),
      'magenta': const Color(0xFFFF00FF),
      'maroon': const Color(0xFF800000),
      'mediumAquaMarine': const Color(0xFF66CDAA),
      'mediumBlue': const Color(0xFF0000CD),
      'mediumOrchid': const Color(0xFFBA55D3),
      'mediumPurple': const Color(0xFF9370DB),
      'mediumSeaGreen': const Color(0xFF3CB371),
      'mediumSlateBlue': const Color(0xFF7B68EE),
      'mediumSpringGreen': const Color(0xFF00FA9A),
      'mediumTurquoise': const Color(0xFF48D1CC),
      'mediumVioletRed': const Color(0xFFC71585),
      'midnightBlue': const Color(0xFF191970),
      'mintCream': const Color(0xFFF5FFFA),
      'mistyRose': const Color(0xFFFFE4E1),
      'moccasin': const Color(0xFFFFE4B5),
      'navajoWhite': const Color(0xFFFFDEAD),
      'navy': const Color(0xFF000080),
      'oldLace': const Color(0xFFFDF5E6),
      'olive': const Color(0xFF808000),
      'oliveDrab': const Color(0xFF6B8E23),
      'orange': const Color(0xFFFFA500),
      'orangeRed': const Color(0xFFFF4500),
      'orchid': const Color(0xFFDA70D6),
      'paleGoldenRod': const Color(0xFFEEE8AA),
      'paleGreen': const Color(0xFF98FB98),
      'paleTurquoise': const Color(0xFFAFEEEE),
      'paleVioletRed': const Color(0xFFDB7093),
      'papayaWhip': const Color(0xFFFFEFD5),
      'peachPuff': const Color(0xFFFFDAB9),
      'peru': const Color(0xFFCD853F),
      'pink': const Color(0xFFFFC0CB),
      'plum': const Color(0xFFDDA0DD),
      'powderBlue': const Color(0xFFB0E0E6),
      'purple': const Color(0xFF800080),
      'rebeccaPurple': const Color(0xFF663399),
      'red': const Color(0xFFFF0000),
      'rosyBrown': const Color(0xFFBC8F8F),
      'royalBlue': const Color(0xFF4169E1),
      'saddleBrown': const Color(0xFF8B4513),
      'salmon': const Color(0xFFFA8072),
      'sandyBrown': const Color(0xFFF4A460),
      'seaGreen': const Color(0xFF2E8B57),
      'seaShell': const Color(0xFFFFF5EE),
      'sienna': const Color(0xFFA0522D),
      'silver': const Color(0xFFC0C0C0),
      'skyBlue': const Color(0xFF87CEEB),
      'slateBlue': const Color(0xFF6A5ACD),
      'slateGray': const Color(0xFF708090),
      'slateGrey': const Color(0xFF708090),
      'snow': const Color(0xFFFFFAFA),
      'springGreen': const Color(0xFF00FF7F),
      'steelBlue': const Color(0xFF4682B4),
      'tan': const Color(0xFFD2B48C),
      'teal': const Color(0xFF008080),
      'thistle': const Color(0xFFD8BFD8),
      'tomato': const Color(0xFFFF6347),
      'turquoise': const Color(0xFF40E0D0),
      'violet': const Color(0xFFEE82EE),
      'wheat': const Color(0xFFF5DEB3),
      'white': const Color(0xFFFFFFFF),
      'whiteSmoke': const Color(0xFFF5F5F5),
      'yellow': const Color(0xFFFFFF00),
      'yellowGreen': const Color(0xFF9ACD32),
    };

    return namedColors[toLowerCase()];
  }
}

/// Extension to determine if a [num] is a whole number.
extension Whole on num {
  /// Extension to determine if a [num] is a whole number.
  bool get isWhole => this % 1 == 0;
}

/// Extension on [Duration]
extension DurationFormatter on Duration {
  /// Returns a string with days, hours, minutes, and seconds in the
  /// following format: `MM:SS`. For example,
  ///
  ///   var d = new Duration( minutes:1, seconds:20);
  ///   d.formatted();  // "1:20"
  String formatted() {
    final segments = [inMinutes.remainder(60), inSeconds.remainder(60)].map((seg) {
      return seg.toString().padLeft(2, '0');
    }).toList();

    return segments.join(':');
  }
}
