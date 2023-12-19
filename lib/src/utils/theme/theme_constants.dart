import 'package:flutter/material.dart';
import '../../../zds_flutter.dart';

/// Default bottom bar height.
const double kBottomBarHeight = 62;

/// Default radius for search bar.
const double kSearchBorderRadius = 53;

/// Default radius for card.
const double kZdsCardRadius = 8;

/// Default card elevation.
const double kZdsCardElevation = 1;

/// Default card margin.
const double kZdsCardMargin = 3;

/// Shadow color used for cards
const Color kZdsCardShadowColor = Color(0x33444D56);

/// Default toolbar height.
const double kZdsToolbarHeight = 64;

/// Default horizontal menu padding.
const EdgeInsets kMenuHorizontalPadding = EdgeInsets.symmetric(horizontal: 24);

/// Default vertical menu padding.
const EdgeInsets kMenuVerticalPadding = EdgeInsets.symmetric(vertical: 24 / 2);

/// Default height of toast.
const double kToastHeight = 48;

/// Default header border size.
const double kHeaderBoarderSize = 1;

/// Default max action height.
const double kMaxActionHeight = 48;

/// Height for[ZdsToggleButton].
const double kBigToggleHeight = 40;

/// Default padding for [ZdsToggleButton].
const double kBigTogglePadding = 18;

/// Default border radius for [ZdsTag].
const double kDefaultBorderRadius = 6;

/// Rectangular border radius for [ZdsTag].
const double rectangularBorderRadius = 2;

/// Default horizontal padding for [ZdsList].
const double kDefaultHorizontalPadding = 14;

/// Default vertical  padding for [ZdsList].
const double kDefaultVerticalPadding = 8;

/// Space used for [ZdsInputBorder].
const double kSpace = 6;

/// Border radius used for [ZdsSelectableListTile].
const double kZdsSelectableListTileBorderRadius = 30;

/// Padding used for [ZdsSelectableListTile].
const EdgeInsets kZdsSelectableListTilePadding = EdgeInsets.all(2);

/// Width of [ZdsVerticalNav]
const double kVerticalNavWidth = 48;

/// Height of row in [ZdsCalendar]
const double calendarRowHeight = 60;

/// Height of days of week in [ZdsCalendar]
const double calendarDaysOfWeekHeight = 36;

/// Width / height of circular buttons in [ZdsCheckableButton].
const double kZdsCheckableButtonSize = 48;

/// Width / height of circular buttons in [ZdsCheckableButton].
@Deprecated('Use kZdsCheckableButtonSize instead')
const double checkableButtonSize = 48;

/// ListTile theme
const ZdsListTileTheme kZdsListTileTheme = ZdsListTileTheme(
  contentPadding: EdgeInsets.only(left: 24, top: 18, bottom: 18, right: 24),
  iconSize: 24,
  tileMargin: 6,
  labelAdditionalMargin: 10,
);

/// Toolbar theme
const kZdsToolbarTheme = ZdsToolbarThemeData(contentPadding: EdgeInsets.all(24));
