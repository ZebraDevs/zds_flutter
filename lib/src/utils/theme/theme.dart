import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

import '../../../zds_flutter.dart';
import 'text.dart';

/// Builds a theme that can be consumed by Zds components
///
/// [bt](Base Theme) is optional ThemeData that acts as the base of the theme.
///
/// [colorScheme] sets all colors within the library.
ThemeData buildTheme(ThemeData baseTheme, ColorScheme colorScheme) {
  // Primary text theme. Used for texts drawn on primary color. e.g app-bar title
  final primaryTextTheme = buildZdsTextTheme(
    baseTheme.primaryTextTheme.apply(
      bodyColor: colorScheme.onPrimary,
      displayColor: colorScheme.onPrimary,
    ),
  );

  final bodyTextTheme = buildZdsTextTheme(
    baseTheme.textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
  );

  final baseButtonStyle = _buildBaseButtonStyle(primaryTextTheme, colorScheme);

  final bool isWarm = colorScheme.background != ZdsColors.greyCoolSwatch[50];

  return baseTheme.copyWith(
    colorScheme: colorScheme,
    canvasColor: colorScheme.surface,
    brightness: colorScheme.brightness,
    textTheme: bodyTextTheme,
    primaryTextTheme: primaryTextTheme,
    primaryColor: colorScheme.primary,
    scaffoldBackgroundColor: colorScheme.background,
    indicatorColor: colorScheme.secondary,
    appBarTheme: _buildAppBarTheme(primaryTextTheme, colorScheme),
    elevatedButtonTheme: _buildElevatedButtonTheme(baseButtonStyle),
    textButtonTheme: _buildTextButtonTheme(baseButtonStyle, bodyTextTheme, colorScheme),
    bottomSheetTheme: _buildBottomSheetTheme(),
    iconTheme: _buildZdsIconTheme(baseTheme.iconTheme.copyWith(color: ZdsColors.white)),
    primaryIconTheme: _buildZdsIconTheme(baseTheme.primaryIconTheme.copyWith(color: colorScheme.onPrimary)),
    dividerTheme: _buildDividerTheme(baseTheme.dividerTheme),
    inputDecorationTheme: _buildInputDecorationTheme(bodyTextTheme, colorScheme, isWarm),
    bottomAppBarTheme: _buildBottomAppBarTheme(baseTheme.bottomAppBarTheme, colorScheme),
    bottomNavigationBarTheme: _buildBottomNavigationBarTheme(
      baseTheme.bottomNavigationBarTheme,
      bodyTextTheme,
      colorScheme,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: colorScheme.secondary),
    cardTheme: CardTheme(
      margin: const EdgeInsets.all(3),
      shadowColor: ZdsColors.shadowColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    ),
    popupMenuTheme: PopupMenuThemeData(
      textStyle: bodyTextTheme.bodyMedium,
      elevation: 5,
      color: colorScheme.surface,
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: colorScheme.secondary,
      selectionColor: colorScheme.secondary.withOpacity(0.4),
      selectionHandleColor: colorScheme.secondary,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: baseButtonStyle.copyWith(textStyle: MaterialStateProperty.resolveWith((_) => bodyTextTheme.titleSmall)),
    ),
    checkboxTheme: baseTheme.checkboxTheme.copyWith(
      fillColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return colorScheme.secondary;
        }
        return ZdsColors.blueGrey;
      }),
    ),
    radioTheme: baseTheme.radioTheme.copyWith(
      fillColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return colorScheme.secondary;
        }
        return ZdsColors.blueGrey;
      }),
    ),
    switchTheme: _buildSwitchTheme(baseTheme.switchTheme, colorScheme, isWarm).copyWith(
      thumbColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return colorScheme.secondary;
        }
        return ZdsColors.blueGrey;
      }),
    ),
  );
}

/// Returns a [ZdsBottomBarThemeData].
ZdsBottomBarThemeData buildZdsBottomBarThemeData(BuildContext context) {
  return ZdsBottomBarThemeData(
    height: kBottomBarHeight,
    shadows: [
      BoxShadow(
        offset: const Offset(0, -1),
        color: Theme.of(context).colorScheme.onBackground.withOpacity(0.1),
        blurRadius: 2,
      ),
    ],
    backgroundColor: Theme.of(context).colorScheme.surface,
    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
  );
}

/// Theme for a ZdsListTile using Zds style.
///
/// See [ZdsListTile].
class ZdsListTileTheme {
  /// Interior padding on the tile.
  final EdgeInsets contentPadding;

  /// Size of any icons used in the leading or trailing widget.
  final double iconSize;

  /// Color of the subtitle text.
  final Color subtitleColor;

  /// Exterior margin of the tile.
  ///
  /// Only used if the tile is not shrink wrapped.
  final double tileMargin;

  /// Additional margin to be added to the tile after the leading widget but before the rest of the content.
  final double labelAdditionalMargin;

  /// Constructs a [ZdsListTileTheme]
  const ZdsListTileTheme({
    required this.iconSize,
    required this.contentPadding,
    required this.tileMargin,
    required this.labelAdditionalMargin,
    required this.subtitleColor,
  });
}

/// Applies style to any child of type [ZdsTabBar].
class ZdsTabBarStyleContainer {
  ///Base theme.
  final ThemeData theme;

  /// Custom theme for tab bar specifically.
  final ZdsTabBarThemeData customTheme;

  /// Constructs a [ZdsTabBarStyleContainer]
  ZdsTabBarStyleContainer({required this.theme, required this.customTheme});
}

/// Applies style to any child of type [ZdsBottomBar].
class ZdsBottomBarThemeData {
  /// Height of the bottom bar.
  final double height;

  /// Box shadows to be applied to the bottom bar.
  final List<BoxShadow> shadows;

  /// Background color of the bottom bar.
  final Color backgroundColor;

  /// Interior content padding of the bottom bar.
  final EdgeInsets contentPadding;

  /// Constructs a [ZdsBottomBarThemeData].
  ZdsBottomBarThemeData({
    required this.height,
    required this.shadows,
    required this.backgroundColor,
    required this.contentPadding,
  });

  /// Creates a copy of this ZdsBottomBarThemeData, but with the given fields replaced wih the new values.
  ZdsBottomBarThemeData copyWith({
    double? height,
    List<BoxShadow>? shadows,
    Color? backgroundColor,
    EdgeInsets? contentPadding,
  }) {
    return ZdsBottomBarThemeData(
      height: height ?? this.height,
      shadows: shadows ?? this.shadows,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      contentPadding: contentPadding ?? this.contentPadding,
    );
  }
}

/// Theme for ZdsBottomBar.
class ZdsBottomBarTheme extends InheritedWidget {
  /// Theme data to be applied.
  final ZdsBottomBarThemeData data;

  /// Constructs a [ZdsBottomBarTheme].
  const ZdsBottomBarTheme({
    required super.child,
    required this.data,
    super.key,
  });

  /// Returns the [ZdsBottomBarThemeData] object of the given type for the widget tree that corresponds to the given context.
  static ZdsBottomBarThemeData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ZdsBottomBarTheme>()!.data;
  }

  @override
  bool updateShouldNotify(ZdsBottomBarTheme oldWidget) {
    return true;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ZdsBottomBarThemeData>('data', data));
  }
}

/// Theme container for [ZdsTabBar].
class ZdsTabBarThemeData {
  /// Decoration for [ZdsTabBar].
  ///
  /// Typically [BoxDecoration].
  final Decoration decoration;

  /// Height of [ZdsTabBar].
  final double height;

  /// Size of icon. Defaults to 16.
  final double iconSize;

  /// Constructor for [ZdsTabBarThemeData].
  const ZdsTabBarThemeData({required this.decoration, required this.height, this.iconSize = 16});
}

/// Theme data for [ZdsToolbar].
class ZdsToolbarThemeData {
  /// Interior content padding for the toolbar.
  final EdgeInsets contentPadding;

  /// Constructs a [ZdsToolbarThemeData].
  const ZdsToolbarThemeData({required this.contentPadding});
}

/// Border used for input components, such as [TextField] to apply a Zds style.
class ZdsInputBorder extends InputBorder {
  /// The space between the border and the interior content.
  ///
  /// Defaults to 6
  final double space;

  /// The border radius used for the border.
  ///
  /// Defaults to `BorderRadius.all(Radius.circular(12))`.
  final BorderRadius borderRadius;

  /// Constructs a [ZdsInputBorder].
  const ZdsInputBorder({
    super.borderSide = const BorderSide(color: ZdsColors.inputBorderColor),
    this.space = kSpace,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  static bool _cornersAreCircular(BorderRadius borderRadius) {
    return borderRadius.topLeft.x == borderRadius.topLeft.y &&
        borderRadius.bottomLeft.x == borderRadius.bottomLeft.y &&
        borderRadius.topRight.x == borderRadius.topRight.y &&
        borderRadius.bottomRight.x == borderRadius.bottomRight.y;
  }

  @override
  bool get isOutline => true;

  @override
  ZdsInputBorder copyWith({
    BorderSide? borderSide,
    BorderRadius? borderRadius,
    double? gapPadding,
  }) {
    return ZdsInputBorder(
      borderSide: borderSide ?? this.borderSide,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }

  @override
  EdgeInsetsGeometry get dimensions {
    return EdgeInsets.all(borderSide.width);
  }

  @override
  ZdsInputBorder scale(double t) {
    return ZdsInputBorder(
      borderSide: borderSide.scale(t),
      borderRadius: borderRadius * t,
    );
  }

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is ZdsInputBorder) {
      final ZdsInputBorder outline = a;
      return outline;
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is ZdsInputBorder) {
      final ZdsInputBorder outline = b;
      return outline;
    }
    return super.lerpTo(b, t);
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    final Rect setRect = Rect.fromLTWH(
      rect.left - (space - borderSide.width),
      rect.top + space,
      rect.width + ((space - borderSide.width) * 2),
      rect.height - (space * 2),
    );

    return Path()..addRRect(borderRadius.resolve(textDirection).toRRect(setRect).deflate(borderSide.width));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final Rect setRect = Rect.fromLTWH(
      rect.left - (space - borderSide.width),
      rect.top + space,
      rect.width + ((space - borderSide.width) * 2),
      rect.height - (space * 2),
    );
    return Path()..addRRect(borderRadius.resolve(textDirection).toRRect(setRect).deflate(space));
  }

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    double? gapStart,
    double gapExtent = 0.0,
    double gapPercentage = 0.0,
    TextDirection? textDirection,
  }) {
    assert(gapPercentage >= 0.0 && gapPercentage <= 1.0, 'gapPercentage must be between 0 and 1');
    assert(_cornersAreCircular(borderRadius), 'Corners must be circular');

    final Rect setRect = Rect.fromLTWH(
      rect.left - (space - borderSide.width),
      rect.top + space,
      rect.width + ((space - borderSide.width) * 2),
      rect.height - (space * 2),
    );

    final Paint paint = borderSide.toPaint();
    final RRect outer = borderRadius.toRRect(setRect);
    final RRect center = outer.deflate(space);
    canvas.drawRRect(center, paint);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is ZdsInputBorder && other.borderSide == borderSide && other.borderRadius == borderRadius;
  }

  @override
  int get hashCode => borderSide.hashCode ^ borderRadius.hashCode;
}

/// Extension of ThemeData.
extension ThemeExtension on ThemeData {
  /// Gets prefix icon used for [ZdsSearchField].
  Icon get prefixIcon => Icon(ZdsIcons.search, color: greySwatch[800]);

  /// Gets default theme data for [ZdsListTile].
  ZdsListTileTheme get zdsListTileThemeData => ZdsListTileTheme(
        contentPadding: const EdgeInsets.only(left: 24, top: 18, bottom: 18, right: 24),
        iconSize: 24,
        subtitleColor: greySwatch.shade900,
        tileMargin: 6,
        labelAdditionalMargin: 10,
      );

  ///Gets default theme data for [ZdsToolbar].
  ZdsToolbarThemeData get zdsToolbarThemeData => const ZdsToolbarThemeData(
        contentPadding: EdgeInsets.all(24),
      );

  /// Gets default theme data for [ZdsSearchField]
  Map<ZdsSearchFieldVariant, ThemeData> get zdsSearchThemeData {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(kSearchBorderRadius),
      borderSide: const BorderSide(
        style: BorderStyle.none,
      ),
    );

    InputDecorationTheme inputDecorationTheme(OutlineInputBorder border) => InputDecorationTheme(
          border: border,
          focusedBorder: border,
          errorBorder: border,
          enabledBorder: border,
          disabledBorder: border,
          focusedErrorBorder: border,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        );

    final cardTheme = this.cardTheme.copyWith(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kSearchBorderRadius),
          ),
          shadowColor: ZdsColors.blueGrey.withOpacity(0.1),
        );

    return Map<ZdsSearchFieldVariant, ThemeData>.from({
      ZdsSearchFieldVariant.outlined: ThemeData(
        inputDecorationTheme: inputDecorationTheme(
          border.copyWith(
            borderSide: BorderSide(
              color: greySwatch[colorScheme.brightness == Brightness.dark ? 1000 : 500]!,
            ),
          ),
        ),
        textSelectionTheme: TextSelectionThemeData(cursorColor: colorScheme.onSurface),
        hintColor: colorScheme.onSurface.withOpacity(0.5),
        cardTheme: cardTheme.copyWith(shadowColor: ZdsColors.transparent),
      ),
      ZdsSearchFieldVariant.elevated: ThemeData(
        inputDecorationTheme: inputDecorationTheme(border),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: colorScheme.onSurface,
        ),
        cardTheme: cardTheme,
        hintColor: colorScheme.onSurface.withOpacity(0.5),
      ),
    });
  }

  /// Custom theme for [ZdsDateTimePicker].
  ThemeData get zdsDateTimePickerTheme {
    return copyWith(
      dialogBackgroundColor: colorScheme.brightness == Brightness.dark ? colorScheme.background : null,
      colorScheme: colorScheme.copyWith(
        primary: colorScheme.secondary.withLight(colorScheme.brightness == Brightness.dark ? 0.75 : 1),
        onPrimary: colorScheme.onSecondary,
      ),
    );
  }

  /// Builds [ZdsTabBarStyleContainer]. Defaults to primary color.
  ZdsTabBarStyleContainer _tabbarStyle(
    BuildContext context,
    bool hasIcons, {
    Color? selectedText,
    Color? background,
    Color? unselectedText,
    Color? indicator,
  }) {
    final height = hasIcons ? 56.0 : 48.0;
    final ThemeData theme = Theme.of(context);
    final ZetaColors colors = ZetaColors.of(context);
    final tabBarTheme = theme.tabBarTheme.copyWith(indicatorSize: TabBarIndicatorSize.tab);
    final labelStyle = hasIcons ? theme.textTheme.bodyXSmall : theme.textTheme.bodyLarge;
    if (colors.isDarkMode) return _tabBarDark(context, hasIcons);

    return ZdsTabBarStyleContainer(
      customTheme: ZdsTabBarThemeData(
        decoration: BoxDecoration(color: background ?? colors.primary.primary),
        height: height,
      ),
      theme: theme.copyWith(
        tabBarTheme: tabBarTheme.copyWith(
          labelStyle: labelStyle,
          unselectedLabelStyle: labelStyle,
          unselectedLabelColor: unselectedText ?? colors.cool.shade40,
          labelColor: selectedText ?? colors.onPrimary,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(
              width: 5,
              color: indicator ?? colors.primary.shade20,
            ),
          ),
        ),
      ),
    );
  }

  ZdsTabBarStyleContainer _tabBarDark(BuildContext context, bool hasIcons) {
    final height = hasIcons ? 56.0 : 48.0;
    final ThemeData theme = Theme.of(context);
    final ZetaColors colors = ZetaColors.of(context);
    final tabBarTheme = theme.tabBarTheme.copyWith(indicatorSize: TabBarIndicatorSize.tab);
    final labelStyle = hasIcons ? theme.textTheme.bodySmall : theme.textTheme.bodyLarge;
    return ZdsTabBarStyleContainer(
      customTheme: ZdsTabBarThemeData(
        decoration: BoxDecoration(color: colors.cool.shade10),
        height: height,
      ),
      theme: theme.copyWith(
        tabBarTheme: tabBarTheme.copyWith(
          labelStyle: labelStyle,
          unselectedLabelStyle: labelStyle,
          unselectedLabelColor: colors.textDefault,
          labelColor: colors.textSubtle,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(
              width: 5,
              color: colors.primary,
            ),
          ),
        ),
      ),
    );
  }

  /// Generates theme for [ZdsTabBar].
  Map<ZdsTabBarColor, ZdsTabBarStyleContainer> zdsTabBarThemeData(
    BuildContext context, {
    required bool hasIcons,
    Color? indicatorColor,
  }) {
    final ZetaColors colors = ZetaColors.of(context);
    return {
      ZdsTabBarColor.primary: _tabbarStyle(context, hasIcons),
      ZdsTabBarColor.basic: _tabbarStyle(
        context,
        hasIcons,
        background: colors.cool.shade90,
        selectedText: colors.cool.shade20,
        indicator: colors.primary.primary,
      ),
      ZdsTabBarColor.surface: _tabbarStyle(
        context,
        hasIcons,
        background: colors.surface,
        selectedText: colors.onSurface,
        indicator: colors.primary.primary,
        unselectedText: colors.cool.shade70,
      ),
    };
  }

  /// Builds theme variants for [ZdsAppBar].
  ///
  /// See also
  /// * [ZdsTabBarColor].
  Map<ZdsTabBarColor, AppBarTheme> buildAppBarTheme(ZetaColors colors) {
    final Map<ZdsTabBarColor, Color> foreground = {};
    final Map<ZdsTabBarColor, Color> background = {};

    foreground[ZdsTabBarColor.basic] = colors.isDarkMode ? colors.cool.shade90 : colors.cool.shade10;
    foreground[ZdsTabBarColor.primary] = colors.isDarkMode ? colors.cool.shade90 : colors.onPrimary;
    foreground[ZdsTabBarColor.surface] = colors.isDarkMode ? colors.cool.shade90 : colors.onSurface;

    background[ZdsTabBarColor.basic] = colors.isDarkMode ? colors.cool.shade10 : colors.cool.shade90;
    background[ZdsTabBarColor.primary] = colors.isDarkMode ? colors.cool.shade10 : colors.primary;
    background[ZdsTabBarColor.surface] = colors.isDarkMode ? colors.cool.shade10 : colors.surface;

    return {
      ZdsTabBarColor.primary: AppBarTheme(
        systemOverlayStyle: computeSystemOverlayStyle(background[ZdsTabBarColor.primary]!),
        backgroundColor: background[ZdsTabBarColor.primary],
        foregroundColor: foreground[ZdsTabBarColor.primary],
        centerTitle: false,
        titleSpacing: 0,
        elevation: 0.5,
        iconTheme: IconThemeData(color: foreground[ZdsTabBarColor.primary]),
        actionsIconTheme: IconThemeData(color: foreground[ZdsTabBarColor.primary]),
      ),
      ZdsTabBarColor.basic: AppBarTheme(
        systemOverlayStyle: computeSystemOverlayStyle(background[ZdsTabBarColor.basic]!),
        backgroundColor: background[ZdsTabBarColor.basic],
        foregroundColor: foreground[ZdsTabBarColor.basic],
        centerTitle: false,
        titleSpacing: 0,
        elevation: 0.5,
        iconTheme: IconThemeData(color: foreground[ZdsTabBarColor.basic]),
        actionsIconTheme: IconThemeData(color: foreground[ZdsTabBarColor.basic]),
      ),
      ZdsTabBarColor.surface: AppBarTheme(
        systemOverlayStyle: computeSystemOverlayStyle(background[ZdsTabBarColor.surface]!),
        backgroundColor: background[ZdsTabBarColor.surface],
        foregroundColor: foreground[ZdsTabBarColor.surface],
        centerTitle: false,
        titleSpacing: 0,
        elevation: 0.5,
        iconTheme: IconThemeData(color: foreground[ZdsTabBarColor.surface]),
        actionsIconTheme: IconThemeData(color: foreground[ZdsTabBarColor.surface]),
      ),
    };
  }

  /// Theme data used to create compact buttons.
  ///
  /// Should not be used often as buttons typically should not be too small.
  ThemeData get shrunkenButtonsThemeData {
    MaterialStateProperty<EdgeInsetsGeometry> buildShrunkenButtonPadding() {
      return MaterialStateProperty.all(EdgeInsets.zero);
    }

    return copyWith(
      textButtonTheme: TextButtonThemeData(
        style: textButtonTheme.style?.copyWith(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: buildShrunkenButtonPadding(),
          foregroundColor: MaterialStateProperty.all(colorScheme.primary),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: elevatedButtonTheme.style?.copyWith(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: buildShrunkenButtonPadding(),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: outlinedButtonTheme.style?.copyWith(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: buildShrunkenButtonPadding(),
        ),
      ),
    );
  }
}

/// Private functions
DividerThemeData _buildDividerTheme(DividerThemeData base) {
  return base.copyWith(thickness: 1, space: 1, color: ZdsColors.lightGrey.withOpacity(0.5));
}

IconThemeData _buildZdsIconTheme(IconThemeData base) {
  return base.copyWith(size: 30);
}

BottomNavigationBarThemeData _buildBottomNavigationBarTheme(
  BottomNavigationBarThemeData base,
  TextTheme textTheme,
  ColorScheme colorScheme,
) {
  final Color unselectedColor =
      colorScheme.brightness == Brightness.dark ? ZdsColors.greyWarmSwatch.shade400 : ZdsColors.greyWarmSwatch.shade900;

  return base.copyWith(
    type: BottomNavigationBarType.fixed,
    selectedLabelStyle: textTheme.bodySmall,
    unselectedLabelStyle: textTheme.bodySmall,
    unselectedItemColor: unselectedColor,
    selectedItemColor: colorScheme.secondary,
    selectedIconTheme: IconThemeData(size: 24, color: colorScheme.secondary),
    unselectedIconTheme: IconThemeData(size: 24, color: unselectedColor),
    elevation: 8,
  );
}

BottomAppBarTheme _buildBottomAppBarTheme(BottomAppBarTheme base, ColorScheme colorScheme) {
  return base.copyWith(
    color: colorScheme.surface,
    surfaceTintColor: colorScheme.onSurface,
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: kIsWeb ? 8 : 4),
  );
}

SwitchThemeData _buildSwitchTheme(SwitchThemeData base, ColorScheme colorScheme, bool isWarm) {
  Color getColor(Set<MaterialState> states) {
    Color color = isWarm ? ZdsColors.greyWarmSwatch[900]! : ZdsColors.greyCoolSwatch[900]!;
    if (states.contains(MaterialState.selected)) {
      color = colorScheme.secondary;
    }
    if (states.contains(MaterialState.disabled)) {
      color = color.withOpacity(0.5);
    }

    return color;
  }

  return base.copyWith(
    thumbColor: MaterialStateProperty.resolveWith(getColor),
    trackColor: MaterialStateProperty.resolveWith((states) => getColor(states).withOpacity(0.2)),
  );
}

BottomSheetThemeData _buildBottomSheetTheme() {
  return BottomSheetThemeData(
    shape: _buildBottomSheetShapeBorder(),
  );
}

ShapeBorder _buildBottomSheetShapeBorder() {
  return const RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(14),
      topRight: Radius.circular(14),
    ),
  );
}

MaterialStateProperty<OutlinedBorder> _buildCircularShapeBorder() {
  return MaterialStateProperty.all(
    RoundedRectangleBorder(
      borderRadius: _buildButtonBorderRadius(),
    ),
  );
}

ButtonStyle _buildBaseButtonStyle(TextTheme textTheme, ColorScheme colorScheme) {
  return ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(colorScheme.secondary),
    textStyle: MaterialStateProperty.all<TextStyle?>(textTheme.headlineSmall?.copyWith(color: colorScheme.onSecondary)),
    padding: MaterialStateProperty.all(_buildButtonPadding()),
    shape: _buildCircularShapeBorder(),
    side: _buildBaseButtonBorderSide(),
    elevation: MaterialStateProperty.all(0),
    visualDensity: VisualDensity.standard,
  );
}

MaterialStateProperty<BorderSide> _buildBaseButtonBorderSide() {
  return MaterialStateProperty.all(BorderSide.none);
}

ElevatedButtonThemeData _buildElevatedButtonTheme(ButtonStyle base) {
  return ElevatedButtonThemeData(style: base);
}

TextButtonThemeData _buildTextButtonTheme(ButtonStyle baseButtonStyle, TextTheme textTheme, ColorScheme colorScheme) {
  return TextButtonThemeData(
    style: baseButtonStyle.copyWith(
      textStyle: MaterialStateProperty.all<TextStyle?>(textTheme.titleMedium?.copyWith(color: colorScheme.secondary)),
      backgroundColor: MaterialStateProperty.all<Color>(ZdsColors.transparent),
    ),
  );
}

EdgeInsets _buildButtonPadding() {
  return const EdgeInsets.symmetric(horizontal: 24, vertical: 10);
}

BorderRadius _buildButtonBorderRadius() {
  return const BorderRadius.all(Radius.circular(71));
}

AppBarTheme _buildAppBarTheme(TextTheme textTheme, ColorScheme colorScheme) {
  return AppBarTheme(
    systemOverlayStyle: computeSystemOverlayStyle(colorScheme.primary),
    backgroundColor: colorScheme.primary,
    foregroundColor: colorScheme.onPrimary,
    centerTitle: false,
    titleSpacing: 0,
    elevation: 0.5,
    titleTextStyle: textTheme.headlineLarge,
  );
}

InputDecorationTheme _buildInputDecorationTheme(TextTheme textTheme, ColorScheme colorScheme, bool isWarm) {
  return InputDecorationTheme(
    contentPadding: const EdgeInsets.symmetric(vertical: 27),
    floatingLabelBehavior: FloatingLabelBehavior.always,
    border: const ZdsInputBorder(),
    focusedBorder: const ZdsInputBorder(),
    enabledBorder: const ZdsInputBorder(),
    disabledBorder: const ZdsInputBorder(),
    errorBorder: ZdsInputBorder(borderSide: BorderSide(color: colorScheme.error)),
    focusedErrorBorder: ZdsInputBorder(borderSide: BorderSide(color: colorScheme.error)),
    focusColor: isWarm ? ZdsColors.greyWarmSwatch[600] : ZdsColors.greyCoolSwatch[600],
    labelStyle: TextStyle(
      fontSize: 19,
      fontWeight: FontWeight.w500,
      color: ZdsColors.blueGrey,
      height: 0,
    ),
    counterStyle: textTheme.bodyMedium?.copyWith(
      height: 0.9,
      color: ZdsColors.darkGrey,
    ),
  );
}
