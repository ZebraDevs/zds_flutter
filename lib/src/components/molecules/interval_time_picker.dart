// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE-3RD-PARTY file.

// Copyright Copyright 2020-2022 Fleximex.
// See LICENSE-3RD-PARTY file.

import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

// Examples can assume:
// late BuildContext context;

const Duration _kDialogSizeAnimationDuration = Duration(milliseconds: 200);
const Duration _kDialAnimateDuration = Duration(milliseconds: 200);
const double _kTwoPi = 2 * math.pi;
const Duration _kVibrateCommitDelay = Duration(milliseconds: 100);

enum _TimePickerMode { hour, minute }

const double _kTimePickerHeaderLandscapeWidth = 264;
const double _kTimePickerHeaderControlHeight = 80;

const double _kTimePickerWidthPortrait = 328;
const double _kTimePickerWidthLandscape = 528;

const double _kTimePickerHeightInput = 226;
const double _kTimePickerHeightPortrait = 496;
const double _kTimePickerHeightLandscape = 316;

const double _kTimePickerHeightPortraitCollapsed = 484;
const double _kTimePickerHeightLandscapeCollapsed = 304;

const BorderRadius _kDefaultBorderRadius = BorderRadius.all(Radius.circular(4));
const ShapeBorder _kDefaultShape = RoundedRectangleBorder(borderRadius: _kDefaultBorderRadius);

/// Interactive input mode of the time picker dialog.
///
/// In [TimePickerEntryMode.dial] mode, a clock dial is displayed and
/// the user taps or drags the time they wish to select. In
/// TimePickerEntryMode.input] mode, [TextField]s are displayed and the user
/// types in the time they wish to select.
enum TimePickerEntryMode {
  /// User picks time from a clock dial.
  ///
  /// Can switch to [input] by activating a mode button in the dialog.
  dial,

  /// User can input the time by typing it into text fields.
  ///
  /// Can switch to [dial] by activating a mode button in the dialog.
  input,

  /// User can only pick time from a clock dial.
  ///
  /// There is no user interface to switch to another mode.
  dialOnly,

  /// User can only input the time by typing it into text fields.
  ///
  /// There is no user interface to switch to another mode.
  inputOnly
}

/// Provides properties for rendering time picker header fragments.
@immutable
class _TimePickerFragmentContext {
  const _TimePickerFragmentContext({
    required this.selectedTime,
    required this.mode,
    required this.onTimeChange,
    required this.onModeChange,
    required this.onHourDoubleTapped,
    required this.onMinuteDoubleTapped,
    required this.use24HourDials,
  });

  final TimeOfDay selectedTime;
  final _TimePickerMode mode;
  final ValueChanged<TimeOfDay> onTimeChange;
  final ValueChanged<_TimePickerMode> onModeChange;
  final GestureTapCallback onHourDoubleTapped;
  final GestureTapCallback onMinuteDoubleTapped;
  final bool use24HourDials;
}

class _TimePickerHeader extends StatelessWidget {
  const _TimePickerHeader({
    required this.selectedTime,
    required this.mode,
    required this.orientation,
    required this.onModeChanged,
    required this.onChanged,
    required this.onHourDoubleTapped,
    required this.onMinuteDoubleTapped,
    required this.use24HourDials,
    required this.helpText,
  });

  final TimeOfDay selectedTime;
  final _TimePickerMode mode;
  final Orientation orientation;
  final ValueChanged<_TimePickerMode> onModeChanged;
  final ValueChanged<TimeOfDay> onChanged;
  final GestureTapCallback onHourDoubleTapped;
  final GestureTapCallback onMinuteDoubleTapped;
  final bool use24HourDials;
  final String? helpText;

  void _handleChangeMode(_TimePickerMode value) {
    if (value != mode) {
      onModeChanged(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context), 'Asserts that the given context has a [MediaQuery] ancestor.');
    final ThemeData themeData = Theme.of(context);
    final TimeOfDayFormat timeOfDayFormat = MaterialLocalizations.of(context).timeOfDayFormat(
      alwaysUse24HourFormat: MediaQuery.of(context).alwaysUse24HourFormat,
    );

    final _TimePickerFragmentContext fragmentContext = _TimePickerFragmentContext(
      selectedTime: selectedTime,
      mode: mode,
      onTimeChange: onChanged,
      onModeChange: _handleChangeMode,
      onHourDoubleTapped: onHourDoubleTapped,
      onMinuteDoubleTapped: onMinuteDoubleTapped,
      use24HourDials: use24HourDials,
    );

    final EdgeInsets padding;
    double? width;
    final Widget controls;

    switch (orientation) {
      case Orientation.portrait:
        // Keep width null because in portrait we don't cap the width.
        padding = const EdgeInsets.symmetric(horizontal: 24);
        controls = Column(
          children: <Widget>[
            const SizedBox(height: 16),
            SizedBox(
              height: kMinInteractiveDimension * 2,
              child: Row(
                children: <Widget>[
                  if (!use24HourDials && timeOfDayFormat == TimeOfDayFormat.a_space_h_colon_mm) ...<Widget>[
                    _DayPeriodControl(
                      selectedTime: selectedTime,
                      orientation: orientation,
                      onChanged: onChanged,
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Row(
                      // Hour/minutes should not change positions in RTL locales.
                      textDirection: TextDirection.ltr,
                      children: <Widget>[
                        Expanded(child: _HourControl(fragmentContext: fragmentContext)),
                        _StringFragment(timeOfDayFormat: timeOfDayFormat),
                        Expanded(child: _MinuteControl(fragmentContext: fragmentContext)),
                      ],
                    ),
                  ),
                  if (!use24HourDials && timeOfDayFormat != TimeOfDayFormat.a_space_h_colon_mm) ...<Widget>[
                    const SizedBox(width: 12),
                    _DayPeriodControl(
                      selectedTime: selectedTime,
                      orientation: orientation,
                      onChanged: onChanged,
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      case Orientation.landscape:
        width = _kTimePickerHeaderLandscapeWidth;
        padding = const EdgeInsets.symmetric(horizontal: 24);
        controls = Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (!use24HourDials && timeOfDayFormat == TimeOfDayFormat.a_space_h_colon_mm)
                _DayPeriodControl(
                  selectedTime: selectedTime,
                  orientation: orientation,
                  onChanged: onChanged,
                ),
              SizedBox(
                height: kMinInteractiveDimension * 2,
                child: Row(
                  // Hour/minutes should not change positions in RTL locales.
                  textDirection: TextDirection.ltr,
                  children: <Widget>[
                    Expanded(child: _HourControl(fragmentContext: fragmentContext)),
                    _StringFragment(timeOfDayFormat: timeOfDayFormat),
                    Expanded(child: _MinuteControl(fragmentContext: fragmentContext)),
                  ],
                ),
              ),
              if (!use24HourDials && timeOfDayFormat != TimeOfDayFormat.a_space_h_colon_mm)
                _DayPeriodControl(
                  selectedTime: selectedTime,
                  orientation: orientation,
                  onChanged: onChanged,
                ),
            ],
          ),
        );
    }

    return Container(
      width: width,
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 16),
          Text(
            helpText ?? MaterialLocalizations.of(context).timePickerDialHelpText,
            style: TimePickerTheme.of(context).helpTextStyle ?? themeData.textTheme.labelSmall,
          ),
          controls,
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<TimeOfDay>('selectedTime', selectedTime))
      ..add(EnumProperty<_TimePickerMode>('mode', mode))
      ..add(EnumProperty<Orientation>('orientation', orientation))
      ..add(ObjectFlagProperty<ValueChanged<_TimePickerMode>>.has('onModeChanged', onModeChanged))
      ..add(ObjectFlagProperty<ValueChanged<TimeOfDay>>.has('onChanged', onChanged))
      ..add(ObjectFlagProperty<GestureTapCallback>.has('onHourDoubleTapped', onHourDoubleTapped))
      ..add(ObjectFlagProperty<GestureTapCallback>.has('onMinuteDoubleTapped', onMinuteDoubleTapped))
      ..add(DiagnosticsProperty<bool>('use24HourDials', use24HourDials))
      ..add(StringProperty('helpText', helpText));
  }
}

class _HourMinuteControl extends StatelessWidget {
  const _HourMinuteControl({
    required this.text,
    required this.onTap,
    required this.onDoubleTap,
    required this.isSelected,
  });

  final String text;
  final GestureTapCallback onTap;
  final GestureTapCallback onDoubleTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TimePickerThemeData timePickerTheme = TimePickerTheme.of(context);
    final bool isDark = themeData.colorScheme.brightness == Brightness.dark;
    final Color textColor = timePickerTheme.hourMinuteTextColor ??
        WidgetStateColor.resolveWith((Set<WidgetState> states) {
          return states.contains(WidgetState.selected)
              ? themeData.colorScheme.primary
              : themeData.colorScheme.onSurface;
        });
    final Color backgroundColor = timePickerTheme.hourMinuteColor ??
        WidgetStateColor.resolveWith((Set<WidgetState> states) {
          return states.contains(WidgetState.selected)
              ? themeData.colorScheme.primary.withValues(alpha: isDark ? 0.24 : 0.12)
              : themeData.colorScheme.onSurface.withValues(alpha: 0.12);
        });
    final TextStyle style = timePickerTheme.hourMinuteTextStyle ?? themeData.textTheme.displayMedium!;
    final ShapeBorder shape = timePickerTheme.hourMinuteShape ?? _kDefaultShape;

    final Set<WidgetState> states = isSelected ? <WidgetState>{WidgetState.selected} : <WidgetState>{};
    return SizedBox(
      height: _kTimePickerHeaderControlHeight,
      child: Material(
        color: WidgetStateProperty.resolveAs(backgroundColor, states),
        clipBehavior: Clip.antiAlias,
        shape: shape,
        child: InkWell(
          onTap: onTap,
          onDoubleTap: isSelected ? onDoubleTap : null,
          child: Center(
            child: Text(
              text,
              style: style.copyWith(color: WidgetStateProperty.resolveAs(textColor, states)),
              textScaler: MediaQuery.textScalerOf(context),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('text', text))
      ..add(ObjectFlagProperty<GestureTapCallback>.has('onTap', onTap))
      ..add(ObjectFlagProperty<GestureTapCallback>.has('onDoubleTap', onDoubleTap))
      ..add(DiagnosticsProperty<bool>('isSelected', isSelected));
  }
}

/// Displays the hour fragment.
///
/// When tapped changes time picker dial mode to [_TimePickerMode.hour].
class _HourControl extends StatelessWidget {
  const _HourControl({
    required this.fragmentContext,
  });

  final _TimePickerFragmentContext fragmentContext;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context), 'Asserts that the given context has a [MediaQuery] ancestor.');
    final bool alwaysUse24HourFormat = MediaQuery.of(context).alwaysUse24HourFormat;
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final String formattedHour = localizations.formatHour(
      fragmentContext.selectedTime,
      alwaysUse24HourFormat: alwaysUse24HourFormat,
    );

    TimeOfDay hoursFromSelected(int hoursToAdd) {
      if (fragmentContext.use24HourDials) {
        final int selectedHour = fragmentContext.selectedTime.hour;
        return fragmentContext.selectedTime.replacing(
          hour: (selectedHour + hoursToAdd) % TimeOfDay.hoursPerDay,
        );
      } else {
        // Cycle 1 through 12 without changing day period.
        final int periodOffset = fragmentContext.selectedTime.periodOffset;
        final int hours = fragmentContext.selectedTime.hourOfPeriod;
        return fragmentContext.selectedTime.replacing(
          hour: periodOffset + (hours + hoursToAdd) % TimeOfDay.hoursPerPeriod,
        );
      }
    }

    final TimeOfDay nextHour = hoursFromSelected(1);
    final String formattedNextHour = localizations.formatHour(
      nextHour,
      alwaysUse24HourFormat: alwaysUse24HourFormat,
    );
    final TimeOfDay previousHour = hoursFromSelected(-1);
    final String formattedPreviousHour = localizations.formatHour(
      previousHour,
      alwaysUse24HourFormat: alwaysUse24HourFormat,
    );

    return Semantics(
      value: '${localizations.timePickerHourModeAnnouncement} $formattedHour',
      excludeSemantics: true,
      increasedValue: formattedNextHour,
      onIncrease: () {
        fragmentContext.onTimeChange(nextHour);
      },
      decreasedValue: formattedPreviousHour,
      onDecrease: () {
        fragmentContext.onTimeChange(previousHour);
      },
      child: _HourMinuteControl(
        isSelected: fragmentContext.mode == _TimePickerMode.hour,
        text: formattedHour,
        onTap: Feedback.wrapForTap(() => fragmentContext.onModeChange(_TimePickerMode.hour), context)!,
        onDoubleTap: fragmentContext.onHourDoubleTapped,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<_TimePickerFragmentContext>('fragmentContext', fragmentContext));
  }
}

/// A passive fragment showing a string value.
class _StringFragment extends StatelessWidget {
  const _StringFragment({
    required this.timeOfDayFormat,
  });

  final TimeOfDayFormat timeOfDayFormat;

  String _stringFragmentValue(TimeOfDayFormat timeOfDayFormat) {
    switch (timeOfDayFormat) {
      case TimeOfDayFormat.h_colon_mm_space_a:
      case TimeOfDayFormat.a_space_h_colon_mm:
      case TimeOfDayFormat.H_colon_mm:
      case TimeOfDayFormat.HH_colon_mm:
        return ':';
      case TimeOfDayFormat.HH_dot_mm:
        return '.';
      case TimeOfDayFormat.frenchCanadian:
        return 'h';
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TimePickerThemeData timePickerTheme = TimePickerTheme.of(context);
    final TextStyle hourMinuteStyle = timePickerTheme.hourMinuteTextStyle ?? theme.textTheme.displayMedium!;
    final Color textColor = timePickerTheme.hourMinuteTextColor ?? theme.colorScheme.onSurface;

    return ExcludeSemantics(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Center(
          child: Text(
            _stringFragmentValue(timeOfDayFormat),
            style: hourMinuteStyle.apply(color: WidgetStateProperty.resolveAs(textColor, <WidgetState>{})),
            textScaler: MediaQuery.textScalerOf(context),
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<TimeOfDayFormat>('timeOfDayFormat', timeOfDayFormat));
  }
}

/// Displays the minute fragment.
///
/// When tapped changes time picker dial mode to [_TimePickerMode.minute].
class _MinuteControl extends StatelessWidget {
  const _MinuteControl({
    required this.fragmentContext,
  });

  final _TimePickerFragmentContext fragmentContext;

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final String formattedMinute = localizations.formatMinute(fragmentContext.selectedTime);
    final TimeOfDay nextMinute = fragmentContext.selectedTime.replacing(
      minute: (fragmentContext.selectedTime.minute + 1) % TimeOfDay.minutesPerHour,
    );
    final String formattedNextMinute = localizations.formatMinute(nextMinute);
    final TimeOfDay previousMinute = fragmentContext.selectedTime.replacing(
      minute: (fragmentContext.selectedTime.minute - 1) % TimeOfDay.minutesPerHour,
    );
    final String formattedPreviousMinute = localizations.formatMinute(previousMinute);

    return Semantics(
      excludeSemantics: true,
      value: '${localizations.timePickerMinuteModeAnnouncement} $formattedMinute',
      increasedValue: formattedNextMinute,
      onIncrease: () {
        fragmentContext.onTimeChange(nextMinute);
      },
      decreasedValue: formattedPreviousMinute,
      onDecrease: () {
        fragmentContext.onTimeChange(previousMinute);
      },
      child: _HourMinuteControl(
        isSelected: fragmentContext.mode == _TimePickerMode.minute,
        text: formattedMinute,
        onTap: Feedback.wrapForTap(() => fragmentContext.onModeChange(_TimePickerMode.minute), context)!,
        onDoubleTap: fragmentContext.onMinuteDoubleTapped,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<_TimePickerFragmentContext>('fragmentContext', fragmentContext));
  }
}

/// Displays the am/pm fragment and provides controls for switching between am
/// and pm.
class _DayPeriodControl extends StatelessWidget {
  const _DayPeriodControl({
    required this.selectedTime,
    required this.onChanged,
    required this.orientation,
  });

  final TimeOfDay selectedTime;
  final Orientation orientation;
  final ValueChanged<TimeOfDay> onChanged;

  void _togglePeriod() {
    final int newHour = (selectedTime.hour + TimeOfDay.hoursPerPeriod) % TimeOfDay.hoursPerDay;
    final TimeOfDay newTime = selectedTime.replacing(hour: newHour);
    onChanged(newTime);
  }

  void _setAm(BuildContext context) {
    if (selectedTime.period == DayPeriod.am) {
      return;
    }
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        _announceToAccessibility(context, MaterialLocalizations.of(context).anteMeridiemAbbreviation);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        break;
    }
    _togglePeriod();
  }

  void _setPm(BuildContext context) {
    if (selectedTime.period == DayPeriod.pm) {
      return;
    }
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        _announceToAccessibility(context, MaterialLocalizations.of(context).postMeridiemAbbreviation);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        break;
    }
    _togglePeriod();
  }

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations materialLocalizations = MaterialLocalizations.of(context);
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TimePickerThemeData timePickerTheme = TimePickerTheme.of(context);
    final bool isDark = colorScheme.brightness == Brightness.dark;
    final Color textColor = timePickerTheme.dayPeriodTextColor ??
        WidgetStateColor.resolveWith((Set<WidgetState> states) {
          return states.contains(WidgetState.selected)
              ? colorScheme.primary
              : colorScheme.onSurface.withValues(alpha: 0.60);
        });
    final Color backgroundColor = timePickerTheme.dayPeriodColor ??
        WidgetStateColor.resolveWith((Set<WidgetState> states) {
          // The unselected day period should match the overall picker dialog
          // color. Making it transparent enables that without being redundant
          // and allows the optional elevation overlay for dark mode to be
          // visible.
          return states.contains(WidgetState.selected)
              ? colorScheme.primary.withValues(alpha: isDark ? 0.24 : 0.12)
              : Colors.transparent;
        });
    final bool amSelected = selectedTime.period == DayPeriod.am;
    final Set<WidgetState> amStates = amSelected ? <WidgetState>{WidgetState.selected} : <WidgetState>{};
    final bool pmSelected = !amSelected;
    final Set<WidgetState> pmStates = pmSelected ? <WidgetState>{WidgetState.selected} : <WidgetState>{};
    final TextStyle textStyle = timePickerTheme.dayPeriodTextStyle ?? Theme.of(context).textTheme.titleMedium!;
    final TextStyle amStyle = textStyle.copyWith(
      color: WidgetStateProperty.resolveAs(textColor, amStates),
    );
    final TextStyle pmStyle = textStyle.copyWith(
      color: WidgetStateProperty.resolveAs(textColor, pmStates),
    );
    OutlinedBorder shape =
        timePickerTheme.dayPeriodShape ?? const RoundedRectangleBorder(borderRadius: _kDefaultBorderRadius);
    final BorderSide borderSide = timePickerTheme.dayPeriodBorderSide ??
        BorderSide(
          color: Color.alphaBlend(colorScheme.onSurface.withValues(alpha: 0.38), colorScheme.surface),
        );
    // Apply the custom borderSide.
    shape = shape.copyWith(
      side: borderSide,
    );

    const maxScaleFactor = 2.0;

    final Widget amButton = Material(
      color: WidgetStateProperty.resolveAs(backgroundColor, amStates),
      child: InkWell(
        onTap: Feedback.wrapForTap(() => _setAm(context), context),
        child: Semantics(
          checked: amSelected,
          inMutuallyExclusiveGroup: true,
          button: true,
          child: Center(
            child: Text(
              materialLocalizations.anteMeridiemAbbreviation,
              style: amStyle,
              textScaler: MediaQuery.textScalerOf(context).clamp(maxScaleFactor: maxScaleFactor),
            ),
          ),
        ),
      ),
    );

    final Widget pmButton = Material(
      color: WidgetStateProperty.resolveAs(backgroundColor, pmStates),
      child: InkWell(
        onTap: Feedback.wrapForTap(() => _setPm(context), context),
        child: Semantics(
          checked: pmSelected,
          inMutuallyExclusiveGroup: true,
          button: true,
          child: Center(
            child: Text(
              materialLocalizations.postMeridiemAbbreviation,
              style: pmStyle,
              textScaler: MediaQuery.textScalerOf(context).clamp(maxScaleFactor: maxScaleFactor),
            ),
          ),
        ),
      ),
    );

    final Widget result;
    switch (orientation) {
      case Orientation.portrait:
        const double width = 52;
        result = _DayPeriodInputPadding(
          minSize: const Size(width, kMinInteractiveDimension * 2),
          orientation: orientation,
          child: SizedBox(
            width: width,
            height: _kTimePickerHeaderControlHeight,
            child: Material(
              clipBehavior: Clip.antiAlias,
              color: Colors.transparent,
              shape: shape,
              child: Column(
                children: <Widget>[
                  Expanded(child: amButton),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(top: borderSide),
                    ),
                    height: 1,
                  ),
                  Expanded(child: pmButton),
                ],
              ),
            ),
          ),
        );
      case Orientation.landscape:
        result = _DayPeriodInputPadding(
          minSize: const Size(0, kMinInteractiveDimension),
          orientation: orientation,
          child: SizedBox(
            height: 40,
            child: Material(
              clipBehavior: Clip.antiAlias,
              color: Colors.transparent,
              shape: shape,
              child: Row(
                children: <Widget>[
                  Expanded(child: amButton),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(left: borderSide),
                    ),
                    width: 1,
                  ),
                  Expanded(child: pmButton),
                ],
              ),
            ),
          ),
        );
    }
    return result;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<TimeOfDay>('selectedTime', selectedTime))
      ..add(EnumProperty<Orientation>('orientation', orientation))
      ..add(ObjectFlagProperty<ValueChanged<TimeOfDay>>.has('onChanged', onChanged));
  }
}

/// A widget to pad the area around the [_DayPeriodControl]'s inner [Material].
class _DayPeriodInputPadding extends SingleChildRenderObjectWidget {
  const _DayPeriodInputPadding({
    required Widget super.child,
    required this.minSize,
    required this.orientation,
  });

  final Size minSize;
  final Orientation orientation;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderInputPadding(minSize, orientation);
  }

  @override
  void updateRenderObject(BuildContext context, covariant _RenderInputPadding renderObject) {
    renderObject.minSize = minSize;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<Size>('minSize', minSize))
      ..add(EnumProperty<Orientation>('orientation', orientation));
  }
}

class _RenderInputPadding extends RenderShiftedBox {
  _RenderInputPadding(this._minSize, this.orientation, [RenderBox? child]) : super(child);

  final Orientation orientation;

  Size get minSize => _minSize;
  Size _minSize;
  set minSize(Size value) {
    if (_minSize == value) {
      return;
    }
    _minSize = value;
    markNeedsLayout();
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    if (child != null) {
      return math.max(child!.getMinIntrinsicWidth(height), minSize.width);
    }
    return 0;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    if (child != null) {
      return math.max(child!.getMinIntrinsicHeight(width), minSize.height);
    }
    return 0;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    if (child != null) {
      return math.max(child!.getMaxIntrinsicWidth(height), minSize.width);
    }
    return 0;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    if (child != null) {
      return math.max(child!.getMaxIntrinsicHeight(width), minSize.height);
    }
    return 0;
  }

  Size _computeSize({required BoxConstraints constraints, required ChildLayouter layoutChild}) {
    if (child != null) {
      final Size childSize = layoutChild(child!, constraints);
      final double width = math.max(childSize.width, minSize.width);
      final double height = math.max(childSize.height, minSize.height);
      return constraints.constrain(Size(width, height));
    }
    return Size.zero;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return _computeSize(
      constraints: constraints,
      layoutChild: ChildLayoutHelper.dryLayoutChild,
    );
  }

  @override
  void performLayout() {
    size = _computeSize(
      constraints: constraints,
      layoutChild: ChildLayoutHelper.layoutChild,
    );
    if (child != null) {
      final BoxParentData childParentData = child!.parentData! as BoxParentData;
      // Ignored as we need to set the offset whilst keeping childParentData as its own object.
      // This ignore is used because the cascade invocation warning does not apply here
      // as the offset is being set explicitly and is necessary for proper alignment.
      // ignore: cascade_invocations
      childParentData.offset = Alignment.center.alongOffset(size - child!.size as Offset);
    }
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (super.hitTest(result, position: position)) {
      return true;
    }

    if (position.dx < 0.0 ||
        position.dx > math.max(child!.size.width, minSize.width) ||
        position.dy < 0.0 ||
        position.dy > math.max(child!.size.height, minSize.height)) {
      return false;
    }

    Offset newPosition = child!.size.center(Offset.zero);
    switch (orientation) {
      case Orientation.portrait:
        if (position.dy > newPosition.dy) {
          newPosition += const Offset(0, 1);
        } else {
          newPosition += const Offset(0, -1);
        }
      case Orientation.landscape:
        if (position.dx > newPosition.dx) {
          newPosition += const Offset(1, 0);
        } else {
          newPosition += const Offset(-1, 0);
        }
    }

    return result.addWithRawTransform(
      transform: MatrixUtils.forceToPoint(newPosition),
      position: newPosition,
      hitTest: (BoxHitTestResult result, Offset position) {
        assert(position == newPosition, 'Asserts that the new position is not the same as the old position');
        return child!.hitTest(result, position: newPosition);
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<Orientation>('orientation', orientation))
      ..add(DiagnosticsProperty<Size>('minSize', minSize));
  }
}

class _TappableLabel {
  _TappableLabel({
    required this.value,
    required this.painter,
    required this.onTap,
  });

  /// The value this label is displaying.
  final int value;

  /// Paints the text of the label.
  final TextPainter painter;

  /// Called when a tap gesture is detected on the label.
  final VoidCallback onTap;
}

class _DialPainter extends CustomPainter {
  _DialPainter({
    required this.primaryLabels,
    required this.secondaryLabels,
    required this.backgroundColor,
    required this.accentColor,
    required this.dotColor,
    required this.theta,
    required this.textDirection,
    required this.selectedValue,
  }) : super(repaint: PaintingBinding.instance.systemFonts);

  final List<_TappableLabel> primaryLabels;
  final List<_TappableLabel> secondaryLabels;
  final Color backgroundColor;
  final Color accentColor;
  final Color dotColor;
  final double theta;
  final TextDirection textDirection;
  final int selectedValue;

  static const double _labelPadding = 28;

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.shortestSide / 2.0;
    final Offset center = Offset(size.width / 2.0, size.height / 2.0);
    final Offset centerPoint = center;
    canvas.drawCircle(centerPoint, radius, Paint()..color = backgroundColor);

    final double labelRadius = radius - _labelPadding;
    Offset getOffsetForTheta(double theta) {
      return center + Offset(labelRadius * math.cos(theta), -labelRadius * math.sin(theta));
    }

    void paintLabels(List<_TappableLabel>? labels) {
      if (labels == null) {
        return;
      }
      final double labelThetaIncrement = -_kTwoPi / labels.length;
      double labelTheta = math.pi / 2.0;

      for (final _TappableLabel label in labels) {
        final TextPainter labelPainter = label.painter;
        final Offset labelOffset = Offset(-labelPainter.width / 2.0, -labelPainter.height / 2.0);
        labelPainter.paint(canvas, getOffsetForTheta(labelTheta) + labelOffset);
        labelTheta += labelThetaIncrement;
      }
    }

    paintLabels(primaryLabels);

    final Paint selectorPaint = Paint()..color = accentColor;
    final Offset focusedPoint = getOffsetForTheta(theta);
    const double focusedRadius = _labelPadding - 4.0;
    canvas
      ..drawCircle(centerPoint, 4, selectorPaint)
      ..drawCircle(focusedPoint, focusedRadius, selectorPaint);
    selectorPaint.strokeWidth = 2.0;
    canvas.drawLine(centerPoint, focusedPoint, selectorPaint);

    // Add a dot inside the selector but only when it isn't over the labels.
    // This checks that the selector's theta is between two labels. A remainder
    // between 0.1 and 0.45 indicates that the selector is roughly not above any
    // labels. The values were derived by manually testing the dial.
    final double labelThetaIncrement = -_kTwoPi / primaryLabels.length;
    if (theta % labelThetaIncrement > 0.1 && theta % labelThetaIncrement < 0.45) {
      canvas.drawCircle(focusedPoint, 2, selectorPaint..color = dotColor);
    }

    final Rect focusedRect = Rect.fromCircle(
      center: focusedPoint,
      radius: focusedRadius,
    );
    canvas
      ..save()
      ..clipPath(Path()..addOval(focusedRect));
    paintLabels(secondaryLabels);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_DialPainter oldPainter) {
    return oldPainter.primaryLabels != primaryLabels ||
        oldPainter.secondaryLabels != secondaryLabels ||
        oldPainter.backgroundColor != backgroundColor ||
        oldPainter.accentColor != accentColor ||
        oldPainter.theta != theta;
  }
}

class _Dial extends StatefulWidget {
  const _Dial({
    required this.selectedTime,
    required this.interval,
    required this.visibleStep,
    required this.mode,
    required this.use24HourDials,
    required this.onChanged,
    required this.onHourSelected,
  });

  final TimeOfDay selectedTime;
  final int interval;
  final int visibleStep;
  final _TimePickerMode mode;
  final bool use24HourDials;
  final ValueChanged<TimeOfDay>? onChanged;
  final VoidCallback? onHourSelected;

  @override
  _DialState createState() => _DialState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<TimeOfDay>('selectedTime', selectedTime))
      ..add(IntProperty('interval', interval))
      ..add(IntProperty('visibleStep', visibleStep))
      ..add(EnumProperty<_TimePickerMode>('mode', mode))
      ..add(DiagnosticsProperty<bool>('use24HourDials', use24HourDials))
      ..add(ObjectFlagProperty<ValueChanged<TimeOfDay>?>.has('onChanged', onChanged))
      ..add(ObjectFlagProperty<VoidCallback?>.has('onHourSelected', onHourSelected));
  }
}

class _DialState extends State<_Dial> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _thetaController = AnimationController(
      duration: _kDialAnimateDuration,
      vsync: this,
    );
    _thetaTween = Tween<double>(begin: _getThetaForTime(widget.selectedTime));
    _theta = _thetaController.drive(CurveTween(curve: Easing.legacy)).drive(_thetaTween)
      ..addListener(() => setState(() {/* _theta.value has changed */}));
  }

  late ThemeData themeData;
  late MaterialLocalizations localizations;
  late MediaQueryData media;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    assert(debugCheckHasMediaQuery(context), 'Asserts that the given context has a [MediaQuery] ancestor.');
    themeData = Theme.of(context);
    localizations = MaterialLocalizations.of(context);
    media = MediaQuery.of(context);
  }

  @override
  void didUpdateWidget(_Dial oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.mode != oldWidget.mode || widget.selectedTime != oldWidget.selectedTime) {
      if (!_dragging) {
        _animateTo(_getThetaForTime(widget.selectedTime));
      }
    }
  }

  @override
  void dispose() {
    _thetaController.dispose();
    super.dispose();
  }

  late Tween<double> _thetaTween;
  late Animation<double> _theta;
  late AnimationController _thetaController;
  bool _dragging = false;

  static double _nearest(double target, double a, double b) {
    return ((target - a).abs() < (target - b).abs()) ? a : b;
  }

  void _animateTo(double targetTheta) {
    final double currentTheta = _theta.value;
    double beginTheta = _nearest(targetTheta, currentTheta, currentTheta + _kTwoPi);
    beginTheta = _nearest(targetTheta, beginTheta, currentTheta - _kTwoPi);
    _thetaTween
      ..begin = beginTheta
      ..end = targetTheta;
    _thetaController
      ..value = 0.0
      ..forward();
  }

  double _getThetaForTime(TimeOfDay time) {
    final int hoursFactor = widget.use24HourDials ? TimeOfDay.hoursPerDay : TimeOfDay.hoursPerPeriod;
    final double fraction = widget.mode == _TimePickerMode.hour
        ? (time.hour / hoursFactor) % hoursFactor
        : (time.minute / TimeOfDay.minutesPerHour) % TimeOfDay.minutesPerHour;
    return (math.pi / 2.0 - fraction * _kTwoPi) % _kTwoPi;
  }

  TimeOfDay _getTimeForTheta(double theta, {bool roundMinutes = false}) {
    final double fraction = (0.25 - (theta % _kTwoPi) / _kTwoPi) % 1.0;
    if (widget.mode == _TimePickerMode.hour) {
      int newHour;
      if (widget.use24HourDials) {
        newHour = (fraction * TimeOfDay.hoursPerDay).round() % TimeOfDay.hoursPerDay;
      } else {
        newHour = (fraction * TimeOfDay.hoursPerPeriod).round() % TimeOfDay.hoursPerPeriod;
        newHour = newHour + widget.selectedTime.periodOffset;
      }
      return widget.selectedTime.replacing(hour: newHour);
    } else {
      int minute = (fraction * TimeOfDay.minutesPerHour).round() % TimeOfDay.minutesPerHour;
      minute =
          ((minute + (widget.interval / 2).floor()) ~/ widget.interval) * widget.interval % TimeOfDay.minutesPerHour;
      return widget.selectedTime.replacing(minute: minute);
    }
  }

  TimeOfDay _notifyOnChangedIfNeeded({bool roundMinutes = false}) {
    final TimeOfDay current = _getTimeForTheta(_theta.value, roundMinutes: roundMinutes);
    if (widget.onChanged == null) {
      return current;
    }
    if (current != widget.selectedTime) {
      widget.onChanged!(current);
    }
    return current;
  }

  void _updateThetaForPan({bool roundMinutes = false}) {
    setState(() {
      final Offset offset = _position! - _center!;
      double angle = (math.atan2(offset.dx, offset.dy) - math.pi / 2.0) % _kTwoPi;
      if (roundMinutes) {
        angle = _getThetaForTime(_getTimeForTheta(angle, roundMinutes: roundMinutes));
      }
      _thetaTween
        ..begin = angle
        ..end = angle; // The controller doesn't animate during the pan gesture.
    });
  }

  Offset? _position;
  Offset? _center;

  void _handlePanStart(DragStartDetails details) {
    assert(!_dragging, 'Asserts that dragging is not currently true');
    _dragging = true;
    final RenderBox box = context.findRenderObject()! as RenderBox;
    _position = box.globalToLocal(details.globalPosition);
    _center = box.size.center(Offset.zero);
    _updateThetaForPan();
    _notifyOnChangedIfNeeded();
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    _position = _position! + details.delta;
    _updateThetaForPan();
    _notifyOnChangedIfNeeded();
  }

  void _handlePanEnd(DragEndDetails details) {
    assert(_dragging, 'Asserts that dragging is currently true');
    _dragging = false;
    _position = null;
    _center = null;
    _animateTo(_getThetaForTime(widget.selectedTime));
    if (widget.mode == _TimePickerMode.hour) {
      widget.onHourSelected?.call();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    final RenderBox box = context.findRenderObject()! as RenderBox;
    _position = box.globalToLocal(details.globalPosition);
    _center = box.size.center(Offset.zero);
    _updateThetaForPan(roundMinutes: true);
    final TimeOfDay newTime = _notifyOnChangedIfNeeded(roundMinutes: true);
    if (widget.mode == _TimePickerMode.hour) {
      if (widget.use24HourDials) {
        _announceToAccessibility(context, localizations.formatDecimal(newTime.hour));
      } else {
        _announceToAccessibility(context, localizations.formatDecimal(newTime.hourOfPeriod));
      }
      widget.onHourSelected?.call();
    } else {
      _announceToAccessibility(context, localizations.formatDecimal(newTime.minute));
    }
    _animateTo(_getThetaForTime(_getTimeForTheta(_theta.value, roundMinutes: true)));
    _dragging = false;
    _position = null;
    _center = null;
  }

  void _selectHour(int hour) {
    _announceToAccessibility(context, localizations.formatDecimal(hour));
    final TimeOfDay time;
    if (widget.mode == _TimePickerMode.hour && widget.use24HourDials) {
      time = TimeOfDay(hour: hour, minute: widget.selectedTime.minute);
    } else {
      if (widget.selectedTime.period == DayPeriod.am) {
        time = TimeOfDay(hour: hour, minute: widget.selectedTime.minute);
      } else {
        time = TimeOfDay(hour: hour + TimeOfDay.hoursPerPeriod, minute: widget.selectedTime.minute);
      }
    }
    final double angle = _getThetaForTime(time);
    _thetaTween
      ..begin = angle
      ..end = angle;
    _notifyOnChangedIfNeeded();
  }

  void _selectMinute(int minute) {
    _announceToAccessibility(context, localizations.formatDecimal(minute));
    final TimeOfDay time = TimeOfDay(
      hour: widget.selectedTime.hour,
      minute: minute,
    );
    final double angle = _getThetaForTime(time);
    _thetaTween
      ..begin = angle
      ..end = angle;
    _notifyOnChangedIfNeeded();
  }

  static const List<TimeOfDay> _amHours = <TimeOfDay>[
    TimeOfDay(hour: 12, minute: 0),
    TimeOfDay(hour: 1, minute: 0),
    TimeOfDay(hour: 2, minute: 0),
    TimeOfDay(hour: 3, minute: 0),
    TimeOfDay(hour: 4, minute: 0),
    TimeOfDay(hour: 5, minute: 0),
    TimeOfDay(hour: 6, minute: 0),
    TimeOfDay(hour: 7, minute: 0),
    TimeOfDay(hour: 8, minute: 0),
    TimeOfDay(hour: 9, minute: 0),
    TimeOfDay(hour: 10, minute: 0),
    TimeOfDay(hour: 11, minute: 0),
  ];

  static const List<TimeOfDay> _twentyFourHours = <TimeOfDay>[
    TimeOfDay(hour: 0, minute: 0),
    TimeOfDay(hour: 2, minute: 0),
    TimeOfDay(hour: 4, minute: 0),
    TimeOfDay(hour: 6, minute: 0),
    TimeOfDay(hour: 8, minute: 0),
    TimeOfDay(hour: 10, minute: 0),
    TimeOfDay(hour: 12, minute: 0),
    TimeOfDay(hour: 14, minute: 0),
    TimeOfDay(hour: 16, minute: 0),
    TimeOfDay(hour: 18, minute: 0),
    TimeOfDay(hour: 20, minute: 0),
    TimeOfDay(hour: 22, minute: 0),
  ];

  _TappableLabel _buildTappableLabel(TextTheme textTheme, Color color, int value, String label, VoidCallback onTap) {
    final TextStyle style = textTheme.bodyLarge!.copyWith(color: color);
    return _TappableLabel(
      value: value,
      painter: TextPainter(
        text: TextSpan(style: style, text: label),
        textDirection: TextDirection.ltr,
        textScaler: MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 2),
      )..layout(),
      onTap: onTap,
    );
  }

  List<_TappableLabel> _build24HourRing(TextTheme textTheme, Color color) => <_TappableLabel>[
        for (final TimeOfDay timeOfDay in _twentyFourHours)
          _buildTappableLabel(
            textTheme,
            color,
            timeOfDay.hour,
            localizations.formatHour(timeOfDay, alwaysUse24HourFormat: media.alwaysUse24HourFormat),
            () {
              _selectHour(timeOfDay.hour);
            },
          ),
      ];

  List<_TappableLabel> _build12HourRing(TextTheme textTheme, Color color) => <_TappableLabel>[
        for (final TimeOfDay timeOfDay in _amHours)
          _buildTappableLabel(
            textTheme,
            color,
            timeOfDay.hour,
            localizations.formatHour(timeOfDay, alwaysUse24HourFormat: media.alwaysUse24HourFormat),
            () {
              _selectHour(timeOfDay.hour);
            },
          ),
      ];

  List<_TappableLabel> _buildMinutes(TextTheme textTheme, Color color) {
    final minuteMarkerValues = <TimeOfDay>[];
    for (int i = 0; i < (TimeOfDay.minutesPerHour / widget.visibleStep).ceil(); i++) {
      minuteMarkerValues.add(TimeOfDay(hour: 0, minute: i * widget.visibleStep));
    }

    return <_TappableLabel>[
      for (final TimeOfDay timeOfDay in minuteMarkerValues)
        _buildTappableLabel(
          textTheme,
          color,
          timeOfDay.minute,
          localizations.formatMinute(timeOfDay),
          () {
            _selectMinute(timeOfDay.minute);
          },
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TimePickerThemeData pickerTheme = TimePickerTheme.of(context);
    final Color backgroundColor =
        pickerTheme.dialBackgroundColor ?? themeData.colorScheme.onSurface.withValues(alpha: 0.12);
    final Color accentColor = pickerTheme.dialHandColor ?? themeData.colorScheme.primary;
    final Color primaryLabelColor =
        WidgetStateProperty.resolveAs(pickerTheme.dialTextColor, <WidgetState>{}) ?? themeData.colorScheme.onSurface;
    final Color secondaryLabelColor =
        WidgetStateProperty.resolveAs(pickerTheme.dialTextColor, <WidgetState>{WidgetState.selected}) ??
            themeData.colorScheme.onPrimary;
    List<_TappableLabel> primaryLabels;
    List<_TappableLabel> secondaryLabels;
    final int selectedDialValue;
    switch (widget.mode) {
      case _TimePickerMode.hour:
        if (widget.use24HourDials) {
          selectedDialValue = widget.selectedTime.hour;
          primaryLabels = _build24HourRing(theme.textTheme, primaryLabelColor);
          secondaryLabels = _build24HourRing(theme.textTheme, secondaryLabelColor);
        } else {
          selectedDialValue = widget.selectedTime.hourOfPeriod;
          primaryLabels = _build12HourRing(theme.textTheme, primaryLabelColor);
          secondaryLabels = _build12HourRing(theme.textTheme, secondaryLabelColor);
        }
      case _TimePickerMode.minute:
        selectedDialValue = widget.selectedTime.minute;
        primaryLabels = _buildMinutes(theme.textTheme, primaryLabelColor);
        secondaryLabels = _buildMinutes(theme.textTheme, secondaryLabelColor);
    }

    return GestureDetector(
      excludeFromSemantics: true,
      onPanStart: _handlePanStart,
      onPanUpdate: _handlePanUpdate,
      onPanEnd: _handlePanEnd,
      onTapUp: _handleTapUp,
      child: CustomPaint(
        key: const ValueKey<String>('time-picker-dial'),
        painter: _DialPainter(
          selectedValue: selectedDialValue,
          primaryLabels: primaryLabels,
          secondaryLabels: secondaryLabels,
          backgroundColor: backgroundColor,
          accentColor: accentColor,
          dotColor: theme.colorScheme.surface,
          theta: _theta.value,
          textDirection: Directionality.of(context),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<ThemeData>('themeData', themeData))
      ..add(DiagnosticsProperty<MaterialLocalizations>('localizations', localizations))
      ..add(DiagnosticsProperty<MediaQueryData>('media', media));
  }
}

class _TimePickerInput extends StatefulWidget {
  const _TimePickerInput({
    required this.initialSelectedTime,
    required this.interval,
    required this.helpText,
    required this.errorInvalidText,
    required this.hourLabelText,
    required this.minuteLabelText,
    required this.autofocusHour,
    required this.autofocusMinute,
    required this.onChanged,
    this.restorationId,
  });

  /// The time initially selected when the dialog is shown.
  final TimeOfDay initialSelectedTime;

  /// The interval to be used.
  final int interval;

  /// Optionally provide your own help text to the time picker.
  final String? helpText;

  /// Optionally provide your own validation error text.
  final String? errorInvalidText;

  /// Optionally provide your own hour label text.
  final String? hourLabelText;

  /// Optionally provide your own minute label text.
  final String? minuteLabelText;

  final bool? autofocusHour;

  final bool? autofocusMinute;

  final ValueChanged<TimeOfDay> onChanged;

  /// Restoration ID to save and restore the state of the time picker input
  /// widget.
  ///
  /// If it is non-null, the widget will persist and restore its state
  ///
  /// The state of this widget is persisted in a [RestorationBucket] claimed
  /// from the surrounding [RestorationScope] using the provided restoration ID.
  final String? restorationId;

  @override
  _TimePickerInputState createState() => _TimePickerInputState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<TimeOfDay>('initialSelectedTime', initialSelectedTime))
      ..add(IntProperty('interval', interval))
      ..add(StringProperty('helpText', helpText))
      ..add(StringProperty('errorInvalidText', errorInvalidText))
      ..add(StringProperty('hourLabelText', hourLabelText))
      ..add(StringProperty('minuteLabelText', minuteLabelText))
      ..add(DiagnosticsProperty<bool?>('autofocusHour', autofocusHour))
      ..add(DiagnosticsProperty<bool?>('autofocusMinute', autofocusMinute))
      ..add(ObjectFlagProperty<ValueChanged<TimeOfDay>>.has('onChanged', onChanged))
      ..add(StringProperty('restorationId', restorationId));
  }
}

class _TimePickerInputState extends State<_TimePickerInput> with RestorationMixin {
  late final RestorableTimeOfDay _selectedTime = RestorableTimeOfDay(widget.initialSelectedTime);
  late final int _interval = widget.interval;
  final RestorableBool hourHasError = RestorableBool(false);
  final RestorableBool minuteHasError = RestorableBool(false);

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedTime, 'selected_time');
    registerForRestoration(hourHasError, 'hour_has_error');
    registerForRestoration(minuteHasError, 'minute_has_error');
  }

  int? _parseHour(String? value) {
    if (value == null) {
      return null;
    }

    int? newHour = int.tryParse(value);
    if (newHour == null) {
      return null;
    }

    if (MediaQuery.of(context).alwaysUse24HourFormat) {
      if (newHour >= 0 && newHour < 24) {
        return newHour;
      }
    } else {
      if (newHour > 0 && newHour < 13) {
        if ((_selectedTime.value.period == DayPeriod.pm && newHour != 12) ||
            (_selectedTime.value.period == DayPeriod.am && newHour == 12)) {
          newHour = (newHour + TimeOfDay.hoursPerPeriod) % TimeOfDay.hoursPerDay;
        }
        return newHour;
      }
    }
    return null;
  }

  int? _parseMinute(String? value) {
    if (value == null) {
      return null;
    }

    final int? newMinute = int.tryParse(value);
    if (newMinute == null) {
      return null;
    }

    if (newMinute >= 0 && newMinute < 60 && newMinute % _interval == 0) {
      return newMinute;
    }
    return null;
  }

  void _handleHourSavedSubmitted(String? value) {
    final int? newHour = _parseHour(value);
    if (newHour != null) {
      _selectedTime.value = TimeOfDay(hour: newHour, minute: _selectedTime.value.minute);
      widget.onChanged(_selectedTime.value);
    }
  }

  void _handleHourChanged(String value) {
    final int? newHour = _parseHour(value);
    if (newHour != null && value.length == 2) {
      // If a valid hour is typed, move focus to the minute TextField.
      FocusScope.of(context).nextFocus();
    }
  }

  void _handleMinuteSavedSubmitted(String? value) {
    final int? newMinute = _parseMinute(value);
    if (newMinute != null) {
      _selectedTime.value = TimeOfDay(hour: _selectedTime.value.hour, minute: int.parse(value!));
      widget.onChanged(_selectedTime.value);
    }
  }

  void _handleDayPeriodChanged(TimeOfDay value) {
    _selectedTime.value = value;
    widget.onChanged(_selectedTime.value);
  }

  String? _validateHour(String? value) {
    final int? newHour = _parseHour(value);
    setState(() {
      hourHasError.value = newHour == null;
    });
    // This is used as the validator for the [TextFormField].
    // Returning an empty string allows the field to go into an error state.
    // Returning null means no error in the validation of the entered text.
    return newHour == null ? '' : null;
  }

  String? _validateMinute(String? value) {
    final int? newMinute = _parseMinute(value);
    setState(() {
      minuteHasError.value = newMinute == null;
    });
    // This is used as the validator for the [TextFormField].
    // Returning an empty string allows the field to go into an error state.
    // Returning null means no error in the validation of the entered text.
    return newMinute == null ? '' : null;
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context), 'Asserts that the given context has a [MediaQuery] ancestor.');

    final MediaQueryData media = MediaQuery.of(context);
    final TimeOfDayFormat timeOfDayFormat =
        MaterialLocalizations.of(context).timeOfDayFormat(alwaysUse24HourFormat: media.alwaysUse24HourFormat);
    final bool use24HourDials = hourFormat(of: timeOfDayFormat) != HourFormat.h;
    final ThemeData theme = Theme.of(context);
    final TextStyle hourMinuteStyle = TimePickerTheme.of(context).hourMinuteTextStyle ?? theme.textTheme.displayMedium!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.helpText ?? MaterialLocalizations.of(context).timePickerInputHelpText,
            style: TimePickerTheme.of(context).helpTextStyle ?? theme.textTheme.labelSmall,
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (!use24HourDials && timeOfDayFormat == TimeOfDayFormat.a_space_h_colon_mm) ...<Widget>[
                _DayPeriodControl(
                  selectedTime: _selectedTime.value,
                  orientation: Orientation.portrait,
                  onChanged: _handleDayPeriodChanged,
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // Hour/minutes should not change positions in RTL locales.
                  textDirection: TextDirection.ltr,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(height: 8),
                          _HourTextField(
                            restorationId: 'hour_text_field',
                            selectedTime: _selectedTime.value,
                            style: hourMinuteStyle,
                            autofocus: widget.autofocusHour,
                            validator: _validateHour,
                            onSavedSubmitted: _handleHourSavedSubmitted,
                            onChanged: _handleHourChanged,
                            hourLabelText: widget.hourLabelText,
                          ),
                          const SizedBox(height: 8),
                          if (!hourHasError.value && !minuteHasError.value)
                            ExcludeSemantics(
                              child: Text(
                                widget.hourLabelText ?? MaterialLocalizations.of(context).timePickerHourLabel,
                                style: theme.textTheme.bodySmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      height: _kTimePickerHeaderControlHeight,
                      child: _StringFragment(timeOfDayFormat: timeOfDayFormat),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(height: 8),
                          _MinuteTextField(
                            restorationId: 'minute_text_field',
                            selectedTime: _selectedTime.value,
                            style: hourMinuteStyle,
                            autofocus: widget.autofocusMinute,
                            validator: _validateMinute,
                            onSavedSubmitted: _handleMinuteSavedSubmitted,
                            minuteLabelText: widget.minuteLabelText,
                          ),
                          const SizedBox(height: 8),
                          if (!hourHasError.value && !minuteHasError.value)
                            ExcludeSemantics(
                              child: Text(
                                widget.minuteLabelText ?? MaterialLocalizations.of(context).timePickerMinuteLabel,
                                style: theme.textTheme.bodySmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (!use24HourDials && timeOfDayFormat != TimeOfDayFormat.a_space_h_colon_mm) ...<Widget>[
                const SizedBox(width: 12),
                _DayPeriodControl(
                  selectedTime: _selectedTime.value,
                  orientation: Orientation.portrait,
                  onChanged: _handleDayPeriodChanged,
                ),
              ],
            ],
          ),
          if (hourHasError.value || minuteHasError.value)
            Text(
              widget.errorInvalidText ?? MaterialLocalizations.of(context).invalidTimeLabel,
              style: theme.textTheme.bodyMedium!.copyWith(color: theme.colorScheme.error),
            )
          else
            const SizedBox(height: 2),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<RestorableBool>('hourHasError', hourHasError))
      ..add(DiagnosticsProperty<RestorableBool>('minuteHasError', minuteHasError));
  }
}

class _HourTextField extends StatelessWidget {
  const _HourTextField({
    required this.selectedTime,
    required this.style,
    required this.autofocus,
    required this.validator,
    required this.onSavedSubmitted,
    required this.onChanged,
    required this.hourLabelText,
    this.restorationId,
  });

  final TimeOfDay selectedTime;
  final TextStyle style;
  final bool? autofocus;
  final FormFieldValidator<String> validator;
  final ValueChanged<String?> onSavedSubmitted;
  final ValueChanged<String> onChanged;
  final String? hourLabelText;
  final String? restorationId;

  @override
  Widget build(BuildContext context) {
    return _HourMinuteTextField(
      restorationId: restorationId,
      selectedTime: selectedTime,
      isHour: true,
      autofocus: autofocus,
      style: style,
      semanticHintText: hourLabelText ?? MaterialLocalizations.of(context).timePickerHourLabel,
      validator: validator,
      onSavedSubmitted: onSavedSubmitted,
      onChanged: onChanged,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<TimeOfDay>('selectedTime', selectedTime))
      ..add(DiagnosticsProperty<TextStyle>('style', style))
      ..add(DiagnosticsProperty<bool?>('autofocus', autofocus))
      ..add(ObjectFlagProperty<FormFieldValidator<String>>.has('validator', validator))
      ..add(ObjectFlagProperty<ValueChanged<String?>>.has('onSavedSubmitted', onSavedSubmitted))
      ..add(ObjectFlagProperty<ValueChanged<String>>.has('onChanged', onChanged))
      ..add(StringProperty('hourLabelText', hourLabelText))
      ..add(StringProperty('restorationId', restorationId));
  }
}

class _MinuteTextField extends StatelessWidget {
  const _MinuteTextField({
    required this.selectedTime,
    required this.style,
    required this.autofocus,
    required this.validator,
    required this.onSavedSubmitted,
    required this.minuteLabelText,
    this.restorationId,
  });

  final TimeOfDay selectedTime;
  final TextStyle style;
  final bool? autofocus;
  final FormFieldValidator<String> validator;
  final ValueChanged<String?> onSavedSubmitted;
  final String? minuteLabelText;
  final String? restorationId;

  @override
  Widget build(BuildContext context) {
    return _HourMinuteTextField(
      restorationId: restorationId,
      selectedTime: selectedTime,
      isHour: false,
      autofocus: autofocus,
      style: style,
      semanticHintText: minuteLabelText ?? MaterialLocalizations.of(context).timePickerMinuteLabel,
      validator: validator,
      onSavedSubmitted: onSavedSubmitted,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<TimeOfDay>('selectedTime', selectedTime))
      ..add(DiagnosticsProperty<TextStyle>('style', style))
      ..add(DiagnosticsProperty<bool?>('autofocus', autofocus))
      ..add(ObjectFlagProperty<FormFieldValidator<String>>.has('validator', validator))
      ..add(ObjectFlagProperty<ValueChanged<String?>>.has('onSavedSubmitted', onSavedSubmitted))
      ..add(StringProperty('minuteLabelText', minuteLabelText))
      ..add(StringProperty('restorationId', restorationId));
  }
}

class _HourMinuteTextField extends StatefulWidget {
  const _HourMinuteTextField({
    required this.selectedTime,
    required this.isHour,
    required this.autofocus,
    required this.style,
    required this.semanticHintText,
    required this.validator,
    required this.onSavedSubmitted,
    this.restorationId,
    this.onChanged,
  });

  final TimeOfDay selectedTime;
  final bool isHour;
  final bool? autofocus;
  final TextStyle style;
  final String semanticHintText;
  final FormFieldValidator<String> validator;
  final ValueChanged<String?> onSavedSubmitted;
  final ValueChanged<String>? onChanged;
  final String? restorationId;

  @override
  _HourMinuteTextFieldState createState() => _HourMinuteTextFieldState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<TimeOfDay>('selectedTime', selectedTime))
      ..add(DiagnosticsProperty<bool>('isHour', isHour))
      ..add(DiagnosticsProperty<bool?>('autofocus', autofocus))
      ..add(DiagnosticsProperty<TextStyle>('style', style))
      ..add(StringProperty('semanticHintText', semanticHintText))
      ..add(ObjectFlagProperty<FormFieldValidator<String>>.has('validator', validator))
      ..add(ObjectFlagProperty<ValueChanged<String?>>.has('onSavedSubmitted', onSavedSubmitted))
      ..add(ObjectFlagProperty<ValueChanged<String>?>.has('onChanged', onChanged))
      ..add(StringProperty('restorationId', restorationId));
  }
}

class _HourMinuteTextFieldState extends State<_HourMinuteTextField> with RestorationMixin {
  final RestorableTextEditingController controller = RestorableTextEditingController();
  final RestorableBool controllerHasBeenSet = RestorableBool(false);
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode()
      ..addListener(() {
        setState(() {}); // Rebuild.
      });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Only set the text value if it has not been populated with a localized
    // version yet.
    if (!controllerHasBeenSet.value) {
      controllerHasBeenSet.value = true;
      controller.value.text = _formattedValue;
    }
  }

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(controller, 'text_editing_controller');
    registerForRestoration(controllerHasBeenSet, 'has_controller_been_set');
  }

  String get _formattedValue {
    final bool alwaysUse24HourFormat = MediaQuery.of(context).alwaysUse24HourFormat;
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    return !widget.isHour
        ? localizations.formatMinute(widget.selectedTime)
        : localizations.formatHour(
            widget.selectedTime,
            alwaysUse24HourFormat: alwaysUse24HourFormat,
          );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TimePickerThemeData timePickerTheme = TimePickerTheme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    final InputDecorationTheme? inputDecorationTheme = timePickerTheme.inputDecorationTheme;
    InputDecoration inputDecoration;
    if (inputDecorationTheme != null) {
      inputDecoration = const InputDecoration().applyDefaults(inputDecorationTheme);
    } else {
      inputDecoration = InputDecoration(
        contentPadding: EdgeInsets.zero,
        filled: true,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        hintStyle: widget.style.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.36)),
        // TODO(rami-a): Remove this logic once https://github.com/flutter/flutter/issues/54104 is fixed.
        errorStyle: const TextStyle(fontSize: 0, height: 0), // Prevent the error text from appearing.
      );
    }
    final Color unfocusedFillColor = timePickerTheme.hourMinuteColor ?? colorScheme.onSurface.withValues(alpha: 0.12);
    // If screen reader is in use, make the hint text say hours/minutes.
    // Otherwise, remove the hint text when focused because the centered cursor
    // appears odd above the hint text.
    //
    // TODO(rami-a): Once https://github.com/flutter/flutter/issues/67571 is
    // resolved, remove the window check for semantics being enabled on web.
    final String? hintText =
        MediaQuery.of(context).accessibleNavigation || View.of(context).platformDispatcher.semanticsEnabled
            ? widget.semanticHintText
            : (focusNode.hasFocus ? null : _formattedValue);
    inputDecoration = inputDecoration.copyWith(
      hintText: hintText,
      fillColor: focusNode.hasFocus ? Colors.transparent : inputDecorationTheme?.fillColor ?? unfocusedFillColor,
    );

    return SizedBox(
      height: _kTimePickerHeaderControlHeight,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
        child: UnmanagedRestorationScope(
          bucket: bucket,
          child: TextFormField(
            restorationId: 'hour_minute_text_form_field',
            autofocus: widget.autofocus ?? false,
            expands: true,
            maxLines: null,
            inputFormatters: <TextInputFormatter>[
              LengthLimitingTextInputFormatter(2),
            ],
            focusNode: focusNode,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            style: widget.style.copyWith(color: timePickerTheme.hourMinuteTextColor ?? colorScheme.onSurface),
            controller: controller.value,
            decoration: inputDecoration,
            validator: widget.validator,
            onEditingComplete: () => widget.onSavedSubmitted(controller.value.text),
            onSaved: widget.onSavedSubmitted,
            onFieldSubmitted: widget.onSavedSubmitted,
            onChanged: widget.onChanged,
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<RestorableTextEditingController>('controller', controller))
      ..add(DiagnosticsProperty<RestorableBool>('controllerHasBeenSet', controllerHasBeenSet))
      ..add(DiagnosticsProperty<FocusNode>('focusNode', focusNode));
  }
}

/// Signature for when the time picker entry mode is changed.
typedef EntryModeChangeCallback = void Function(TimePickerEntryMode);

/// A Material Design time picker designed to appear inside a popup dialog.
///
/// Pass this widget to [showDialog]. The value returned by [showDialog] is the
/// selected [TimeOfDay] if the user taps the "OK" button, or null if the user
/// taps the "CANCEL" button. The selected time is reported by calling
/// [Navigator.pop].
class IntervalTimePickerDialog extends StatefulWidget {
  /// Creates a Material Design time picker.
  ///
  /// [initialTime] must not be null.
  const IntervalTimePickerDialog({
    super.key,
    required this.initialTime,
    this.interval = 1,
    this.visibleStep = VisibleStep.fifths,
    this.cancelText,
    this.confirmText,
    this.helpText,
    this.errorInvalidText,
    this.hourLabelText,
    this.minuteLabelText,
    this.restorationId,
    this.initialEntryMode = TimePickerEntryMode.dial,
    this.onEntryModeChanged,
  });

  /// The time initially selected when the dialog is shown.
  final TimeOfDay initialTime;

  /// The entry mode for the picker. Whether it's text input or a dial.
  final TimePickerEntryMode initialEntryMode;

  /// The interval used for the minutes the user can choose.
  /// The default and minimum is 1. The maximum is 60.
  final int interval;

  /// The interval for the visible minute labels in the dial.
  final VisibleStep visibleStep;

  /// Optionally provide your own text for the cancel button.
  ///
  /// If null, the button uses [MaterialLocalizations.cancelButtonLabel].
  final String? cancelText;

  /// Optionally provide your own text for the confirm button.
  ///
  /// If null, the button uses [MaterialLocalizations.okButtonLabel].
  final String? confirmText;

  /// Optionally provide your own help text to the header of the time picker.
  final String? helpText;

  /// Optionally provide your own validation error text.
  final String? errorInvalidText;

  /// Optionally provide your own hour label text.
  final String? hourLabelText;

  /// Optionally provide your own minute label text.
  final String? minuteLabelText;

  /// Restoration ID to save and restore the state of the [IntervalTimePickerDialog].
  ///
  /// If it is non-null, the time picker will persist and restore the
  /// dialog's state.
  ///
  /// The state of this widget is persisted in a [RestorationBucket] claimed
  /// from the surrounding [RestorationScope] using the provided restoration ID.
  ///
  /// See also:
  ///
  ///  * [RestorationManager], which explains how state restoration works in
  ///    Flutter.
  final String? restorationId;

  /// Callback called when the selected entry mode is changed.
  final EntryModeChangeCallback? onEntryModeChanged;

  @override
  State<IntervalTimePickerDialog> createState() => _IntervalTimePickerDialogState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<TimeOfDay>('initialTime', initialTime))
      ..add(EnumProperty<TimePickerEntryMode>('initialEntryMode', initialEntryMode))
      ..add(IntProperty('interval', interval))
      ..add(EnumProperty<VisibleStep>('visibleStep', visibleStep))
      ..add(StringProperty('cancelText', cancelText))
      ..add(StringProperty('confirmText', confirmText))
      ..add(StringProperty('helpText', helpText))
      ..add(StringProperty('errorInvalidText', errorInvalidText))
      ..add(StringProperty('hourLabelText', hourLabelText))
      ..add(StringProperty('minuteLabelText', minuteLabelText))
      ..add(StringProperty('restorationId', restorationId))
      ..add(ObjectFlagProperty<EntryModeChangeCallback?>.has('onEntryModeChanged', onEntryModeChanged));
  }
}

// A restorable [TimePickerEntryMode] value.
//
// This serializes each entry as a unique `int` value.
class _RestorableTimePickerEntryMode extends RestorableValue<TimePickerEntryMode> {
  _RestorableTimePickerEntryMode(
    TimePickerEntryMode defaultValue,
  ) : _defaultValue = defaultValue;

  final TimePickerEntryMode _defaultValue;

  @override
  TimePickerEntryMode createDefaultValue() => _defaultValue;

  @override
  void didUpdateValue(TimePickerEntryMode? oldValue) {
    assert(
      debugIsSerializableForRestoration(value.index),
      'Asserts that the provided `object` is serializable for state restoration.',
    );
    notifyListeners();
  }

  @override
  TimePickerEntryMode fromPrimitives(Object? data) => TimePickerEntryMode.values[data! as int];

  @override
  Object? toPrimitives() => value.index;
}

// A restorable [_RestorableTimePickerEntryMode] value.
//
// This serializes each entry as a unique `int` value.
class _RestorableTimePickerMode extends RestorableValue<_TimePickerMode> {
  _RestorableTimePickerMode(
    _TimePickerMode defaultValue,
  ) : _defaultValue = defaultValue;

  final _TimePickerMode _defaultValue;

  @override
  _TimePickerMode createDefaultValue() => _defaultValue;

  @override
  void didUpdateValue(_TimePickerMode? oldValue) {
    assert(
      debugIsSerializableForRestoration(value.index),
      'Asserts that the provided `object` is serializable for state restoration.',
    );
    notifyListeners();
  }

  @override
  _TimePickerMode fromPrimitives(Object? data) => _TimePickerMode.values[data! as int];

  @override
  Object? toPrimitives() => value.index;
}

// A restorable [AutovalidateMode] value.
//
// This serializes each entry as a unique `int` value.
class _RestorableAutovalidateMode extends RestorableValue<AutovalidateMode> {
  _RestorableAutovalidateMode(
    AutovalidateMode defaultValue,
  ) : _defaultValue = defaultValue;

  final AutovalidateMode _defaultValue;

  @override
  AutovalidateMode createDefaultValue() => _defaultValue;

  @override
  void didUpdateValue(AutovalidateMode? oldValue) {
    assert(
      debugIsSerializableForRestoration(value.index),
      'Asserts that the provided `object` is serializable for state restoration.',
    );
    notifyListeners();
  }

  @override
  AutovalidateMode fromPrimitives(Object? data) => AutovalidateMode.values[data! as int];

  @override
  Object? toPrimitives() => value.index;
}

// A restorable [_RestorableTimePickerEntryMode] value.
//
// This serializes each entry as a unique `int` value.
//
// This value can be null.
class _RestorableTimePickerModeN extends RestorableValue<_TimePickerMode?> {
  _RestorableTimePickerModeN(
    _TimePickerMode? defaultValue,
  ) : _defaultValue = defaultValue;

  final _TimePickerMode? _defaultValue;

  @override
  _TimePickerMode? createDefaultValue() => _defaultValue;

  @override
  void didUpdateValue(_TimePickerMode? oldValue) {
    assert(
      debugIsSerializableForRestoration(value?.index),
      'Asserts that the provided `object` is serializable for state restoration.',
    );
    notifyListeners();
  }

  @override
  _TimePickerMode fromPrimitives(Object? data) => _TimePickerMode.values[data! as int];

  @override
  Object? toPrimitives() => value?.index;
}

class _IntervalTimePickerDialogState extends State<IntervalTimePickerDialog> with RestorationMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final _RestorableTimePickerEntryMode _entryMode = _RestorableTimePickerEntryMode(widget.initialEntryMode);
  final _RestorableTimePickerMode _mode = _RestorableTimePickerMode(_TimePickerMode.hour);
  final _RestorableTimePickerModeN _lastModeAnnounced = _RestorableTimePickerModeN(null);
  final _RestorableAutovalidateMode _autovalidateMode = _RestorableAutovalidateMode(AutovalidateMode.disabled);
  final RestorableBoolN _autofocusHour = RestorableBoolN(null);
  final RestorableBoolN _autofocusMinute = RestorableBoolN(null);
  final RestorableBool _announcedInitialTime = RestorableBool(false);

  late final int _interval;
  late final int _visibleStep;

  late final VoidCallback _entryModeListener;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    localizations = MaterialLocalizations.of(context);
    _announceInitialTimeOnce();
    _announceModeOnce();
  }

  @override
  void initState() {
    super.initState();
    _entryModeListener = () => widget.onEntryModeChanged?.call(_entryMode.value);
    _entryMode.addListener(_entryModeListener);
    _interval = widget.interval;
    _visibleStep = _parseVisibleStep(widget.visibleStep);
  }

  int _parseVisibleStep(VisibleStep vS) {
    switch (vS) {
      case VisibleStep.fifths:
        return 5;
      case VisibleStep.sixths:
        return 6;
      case VisibleStep.tenths:
        return 10;
      case VisibleStep.twelfths:
        return 12;
      case VisibleStep.fifteenths:
        return 15;
      case VisibleStep.twentieths:
        return 20;
      case VisibleStep.thirtieths:
        return 30;
      case VisibleStep.sixtieth:
        return 60;
    }
  }

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_entryMode, 'entry_mode');
    registerForRestoration(_mode, 'mode');
    registerForRestoration(_lastModeAnnounced, 'last_mode_announced');
    registerForRestoration(_autovalidateMode, 'autovalidateMode');
    registerForRestoration(_autofocusHour, 'autofocus_hour');
    registerForRestoration(_autofocusMinute, 'autofocus_minute');
    registerForRestoration(_announcedInitialTime, 'announced_initial_time');
    registerForRestoration(_selectedTime, 'selected_time');
  }

  RestorableTimeOfDay get selectedTime => _selectedTime;
  late final RestorableTimeOfDay _selectedTime = RestorableTimeOfDay(widget.initialTime);

  Timer? _vibrateTimer;
  late MaterialLocalizations localizations;

  void _vibrate() {
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        _vibrateTimer?.cancel();
        _vibrateTimer = Timer(_kVibrateCommitDelay, () {
          unawaited(HapticFeedback.vibrate());
          _vibrateTimer = null;
        });
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        break;
    }
  }

  void _handleModeChanged(_TimePickerMode mode) {
    _vibrate();
    setState(() {
      _mode.value = mode;
      _announceModeOnce();
    });
  }

  void _handleEntryModeToggle() {
    setState(() {
      switch (_entryMode.value) {
        case TimePickerEntryMode.dial:
          _autovalidateMode.value = AutovalidateMode.disabled;
          _entryMode.value = TimePickerEntryMode.input;
        case TimePickerEntryMode.input:
          _formKey.currentState!.save();
          _autofocusHour.value = false;
          _autofocusMinute.value = false;
          _entryMode.value = TimePickerEntryMode.dial;
        case TimePickerEntryMode.dialOnly:
        case TimePickerEntryMode.inputOnly:
          FlutterError('Can not change entry mode from $_entryMode');
      }
    });
  }

  void _announceModeOnce() {
    if (_lastModeAnnounced.value == _mode.value) {
      // Already announced it.
      return;
    }

    switch (_mode.value) {
      case _TimePickerMode.hour:
        _announceToAccessibility(context, localizations.timePickerHourModeAnnouncement);
      case _TimePickerMode.minute:
        _announceToAccessibility(context, localizations.timePickerMinuteModeAnnouncement);
    }
    _lastModeAnnounced.value = _mode.value;
  }

  void _announceInitialTimeOnce() {
    if (_announcedInitialTime.value) {
      return;
    }

    final MediaQueryData media = MediaQuery.of(context);
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    _announceToAccessibility(
      context,
      localizations.formatTimeOfDay(widget.initialTime, alwaysUse24HourFormat: media.alwaysUse24HourFormat),
    );
    _announcedInitialTime.value = true;
  }

  void _handleTimeChanged(TimeOfDay value) {
    _vibrate();
    setState(() {
      _selectedTime.value = value;
    });
  }

  void _handleHourDoubleTapped() {
    _autofocusHour.value = true;
    _handleEntryModeToggle();
  }

  void _handleMinuteDoubleTapped() {
    _autofocusMinute.value = true;
    _handleEntryModeToggle();
  }

  void _handleHourSelected() {
    setState(() {
      _mode.value = _TimePickerMode.minute;
    });
  }

  void _handleCancel() {
    Navigator.pop(context);
  }

  void _handleOk() {
    if (_entryMode.value == TimePickerEntryMode.input || _entryMode.value == TimePickerEntryMode.inputOnly) {
      final FormState form = _formKey.currentState!;
      if (!form.validate()) {
        setState(() {
          _autovalidateMode.value = AutovalidateMode.always;
        });
        return;
      }
      form.save();
    }
    Navigator.pop(context, _selectedTime.value);
  }

  Size _dialogSize(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final ThemeData theme = Theme.of(context);

    final double timePickerWidth;
    final double timePickerHeight;
    switch (_entryMode.value) {
      case TimePickerEntryMode.dial:
      case TimePickerEntryMode.dialOnly:
        switch (orientation) {
          case Orientation.portrait:
            timePickerWidth = _kTimePickerWidthPortrait;
            timePickerHeight = theme.materialTapTargetSize == MaterialTapTargetSize.padded
                ? _kTimePickerHeightPortrait
                : _kTimePickerHeightPortraitCollapsed;
          case Orientation.landscape:
            timePickerWidth = _kTimePickerWidthLandscape;
            timePickerHeight = theme.materialTapTargetSize == MaterialTapTargetSize.padded
                ? _kTimePickerHeightLandscape
                : _kTimePickerHeightLandscapeCollapsed;
        }
      case TimePickerEntryMode.input:
      case TimePickerEntryMode.inputOnly:
        timePickerWidth = _kTimePickerWidthPortrait;
        timePickerHeight = _kTimePickerHeightInput;
    }
    return Size(timePickerWidth, timePickerHeight);
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context), 'Asserts that the given context has a [MediaQuery] ancestor.');
    final MediaQueryData media = MediaQuery.of(context);
    final TimeOfDayFormat timeOfDayFormat =
        localizations.timeOfDayFormat(alwaysUse24HourFormat: media.alwaysUse24HourFormat);
    final bool use24HourDials = hourFormat(of: timeOfDayFormat) != HourFormat.h;
    final ThemeData theme = Theme.of(context);
    final ShapeBorder shape = TimePickerTheme.of(context).shape ?? _kDefaultShape;
    final Orientation orientation = media.orientation;

    final Widget actions = Row(
      children: <Widget>[
        const SizedBox(width: 10),
        if (_entryMode.value == TimePickerEntryMode.dial || _entryMode.value == TimePickerEntryMode.input)
          IconButton(
            color: TimePickerTheme.of(context).entryModeIconColor ??
                theme.colorScheme.onSurface.withValues(
                  alpha: theme.colorScheme.brightness == Brightness.dark ? 1.0 : 0.6,
                ),
            onPressed: _handleEntryModeToggle,
            icon: Icon(_entryMode.value == TimePickerEntryMode.dial ? Icons.keyboard : Icons.access_time),
            tooltip: _entryMode.value == TimePickerEntryMode.dial
                ? MaterialLocalizations.of(context).inputTimeModeButtonLabel
                : MaterialLocalizations.of(context).dialModeButtonLabel,
          ),
        Expanded(
          child: Container(
            alignment: AlignmentDirectional.centerEnd,
            constraints: const BoxConstraints(minHeight: 52),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: OverflowBar(
              spacing: 8,
              overflowAlignment: OverflowBarAlignment.end,
              children: <Widget>[
                TextButton(
                  onPressed: _handleCancel,
                  child: Text(widget.cancelText ?? localizations.cancelButtonLabel),
                ),
                TextButton(
                  onPressed: _handleOk,
                  child: Text(widget.confirmText ?? localizations.okButtonLabel),
                ),
              ],
            ),
          ),
        ),
      ],
    );

    final Widget picker;
    switch (_entryMode.value) {
      case TimePickerEntryMode.dial:
      case TimePickerEntryMode.dialOnly:
        final Widget dial = Padding(
          padding: orientation == Orientation.portrait
              ? const EdgeInsets.symmetric(horizontal: 36, vertical: 24)
              : const EdgeInsets.all(24),
          child: ExcludeSemantics(
            child: AspectRatio(
              aspectRatio: 1,
              child: _Dial(
                interval: _interval,
                visibleStep: _visibleStep,
                mode: _mode.value,
                use24HourDials: use24HourDials,
                selectedTime: _selectedTime.value,
                onChanged: _handleTimeChanged,
                onHourSelected: _handleHourSelected,
              ),
            ),
          ),
        );

        final Widget header = _TimePickerHeader(
          selectedTime: _selectedTime.value,
          mode: _mode.value,
          orientation: orientation,
          onModeChanged: _handleModeChanged,
          onChanged: _handleTimeChanged,
          onHourDoubleTapped: _handleHourDoubleTapped,
          onMinuteDoubleTapped: _handleMinuteDoubleTapped,
          use24HourDials: use24HourDials,
          helpText: widget.helpText,
        );

        switch (orientation) {
          case Orientation.portrait:
            picker = Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                header,
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      // Dial grows and shrinks with the available space.
                      Expanded(child: dial),
                      actions,
                    ],
                  ),
                ),
              ],
            );
          case Orientation.landscape:
            picker = Column(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      header,
                      Expanded(child: dial),
                    ],
                  ),
                ),
                actions,
              ],
            );
        }
      case TimePickerEntryMode.input:
      case TimePickerEntryMode.inputOnly:
        picker = Form(
          key: _formKey,
          autovalidateMode: _autovalidateMode.value,
          child: SingleChildScrollView(
            restorationId: 'time_picker_scroll_view',
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _TimePickerInput(
                  initialSelectedTime: _selectedTime.value,
                  interval: _interval,
                  helpText: widget.helpText,
                  errorInvalidText: widget.errorInvalidText,
                  hourLabelText: widget.hourLabelText,
                  minuteLabelText: widget.minuteLabelText,
                  autofocusHour: _autofocusHour.value,
                  autofocusMinute: _autofocusMinute.value,
                  onChanged: _handleTimeChanged,
                  restorationId: 'time_picker_input',
                ),
                actions,
              ],
            ),
          ),
        );
    }

    final Size dialogSize = _dialogSize(context);
    return Dialog(
      shape: shape,
      backgroundColor: TimePickerTheme.of(context).backgroundColor ?? theme.colorScheme.surface,
      insetPadding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: (_entryMode.value == TimePickerEntryMode.input || _entryMode.value == TimePickerEntryMode.inputOnly)
            ? 0.0
            : 24.0,
      ),
      child: AnimatedContainer(
        width: dialogSize.width,
        height: dialogSize.height,
        duration: _kDialogSizeAnimationDuration,
        curve: Curves.easeIn,
        child: picker,
      ),
    );
  }

  @override
  void dispose() {
    _vibrateTimer?.cancel();
    _vibrateTimer = null;
    _entryMode.removeListener(_entryModeListener);
    super.dispose();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<RestorableTimeOfDay>('selectedTime', selectedTime))
      ..add(DiagnosticsProperty<MaterialLocalizations>('localizations', localizations));
  }
}

/// Shows a dialog containing a Material Design time picker.
///
/// The returned Future resolves to the time selected by the user when the user
/// closes the dialog. If the user cancels the dialog, null is returned.
///
/// {@tool snippet}
/// Show a dialog with [initialTime] equal to the current time.
///
/// ```dart
/// Future<TimeOfDay?> selectedTime = showIntervalTimePicker(
///   initialTime: TimeOfDay.now(),
///   context: context,
/// );
/// ```
/// {@end-tool}
///
/// The [context], [useRootNavigator] and [routeSettings] arguments are passed to
/// [showDialog], the documentation for which discusses how it is used.
///
/// The [builder] parameter can be used to wrap the dialog widget
/// to add inherited widgets like [Localizations.override],
/// [Directionality], or [MediaQuery].
///
/// The `initialEntryMode` parameter can be used to
/// determine the initial time entry selection of the picker (either a clock
/// dial or text input).
///
/// The [interval] parameter is used for setting the interval used for the TimePicker.
/// The default and minimum value is 1. The maximum is 60.
///
/// The [visibleStep] parameter is used for which minute labels the TimePicker will show.
///
/// Optional strings for the [helpText], [cancelText], [errorInvalidText],
/// [hourLabelText], [minuteLabelText] and [confirmText] can be provided to
/// override the default values.
///
/// {@macro flutter.widgets.RawDialogRoute}
///
/// By default, the time picker gets its colors from the overall theme's
/// [ColorScheme]. The time picker can be further customized by providing a
/// [TimePickerThemeData] to the overall theme.
///
/// {@tool snippet}
/// Show a dialog with the text direction overridden to be [TextDirection.rtl].
///
/// ```dart
/// Future<TimeOfDay?> selectedTimeRTL = showIntervalTimePicker(
///   context: context,
///   initialTime: TimeOfDay.now(),
///   builder: (BuildContext context, Widget? child) {
///     return Directionality(
///       textDirection: TextDirection.rtl,
///       child: child!,
///     );
///   },
/// );
/// ```
/// {@end-tool}
///
/// {@tool snippet}
/// Show a dialog with time unconditionally displayed in 24 hour format.
///
/// ```dart
/// Future<TimeOfDay?> selectedTime24Hour = showIntervalTimePicker(
///   context: context,
///   initialTime: const TimeOfDay(hour: 10, minute: 47),
///   builder: (BuildContext context, Widget? child) {
///     return MediaQuery(
///       data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
///       child: child!,
///     );
///   },
/// );
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [showDatePicker], which shows a dialog that contains a Material Design
///    date picker.
///  * [TimePickerThemeData], which allows you to customize the colors,
///    typography, and shape of the time picker.
///  * [DisplayFeatureSubScreen], which documents the specifics of how
///    [DisplayFeature]s can split the screen into sub-screens.
Future<TimeOfDay?> showIntervalTimePicker({
  required BuildContext context,
  required TimeOfDay initialTime,
  int interval = 1,
  VisibleStep visibleStep = VisibleStep.fifths,
  TransitionBuilder? builder,
  bool useRootNavigator = true,
  TimePickerEntryMode initialEntryMode = TimePickerEntryMode.dial,
  String? cancelText,
  String? confirmText,
  String? helpText,
  String? errorInvalidText,
  String? hourLabelText,
  String? minuteLabelText,
  RouteSettings? routeSettings,
  EntryModeChangeCallback? onEntryModeChanged,
  Offset? anchorPoint,
}) {
  assert(interval >= 1 && interval <= 60, 'Asserts that the interval is inclusive to the range 0 to 60');
  assert(
    debugCheckHasMaterialLocalizations(context),
    'Asserts that the given context has a [Localizations] ancestor that contains a [MaterialLocalizations] delegate.',
  );

  final Widget dialog = IntervalTimePickerDialog(
    initialTime: initialTime,
    interval: interval,
    visibleStep: visibleStep,
    initialEntryMode: initialEntryMode,
    cancelText: cancelText,
    confirmText: confirmText,
    helpText: helpText,
    errorInvalidText: errorInvalidText,
    hourLabelText: hourLabelText,
    minuteLabelText: minuteLabelText,
    onEntryModeChanged: onEntryModeChanged,
  );
  return showDialog<TimeOfDay>(
    context: context,
    useRootNavigator: useRootNavigator,
    builder: (BuildContext context) {
      return builder == null ? dialog : builder(context, dialog);
    },
    routeSettings: routeSettings,
    anchorPoint: anchorPoint,
  );
}

/// Steps shown on time picker.
enum VisibleStep {
  /// Every 5 minutes
  fifths,

  /// Every 6 minutes
  sixths,

  /// Every 10 minutes
  tenths,

  /// Every 12 minutes
  twelfths,

  /// Every 15 minutes
  fifteenths,

  /// Every 20 minutes
  twentieths,

  /// Every 30 minutes
  thirtieths,

  /// Every hour
  sixtieth,
}

void _announceToAccessibility(BuildContext context, String message) {
  unawaited(SemanticsService.announce(message, Directionality.of(context)));
}
