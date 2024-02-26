import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../zds_flutter.dart';

/// Returns a [ZdsBottomBarThemeData].
ZdsBottomBarThemeData buildZdsBottomBarThemeData(BuildContext context) {
  final themeData = Theme.of(context);
  return ZdsBottomBarThemeData(
    height: kBottomBarHeight,
    shadows: <BoxShadow>[
      BoxShadow(
        offset: const Offset(0, -1),
        color: themeData.colorScheme.onBackground.withOpacity(0.1),
        blurRadius: 2,
      ),
    ],
    backgroundColor: themeData.colorScheme.surface,
    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
  );
}

/// Theme for a ZdsListTile using Zds style.
///
/// See [ZdsListTile].
class ZdsListTileTheme {
  /// Constructs a [ZdsListTileTheme]
  const ZdsListTileTheme({
    required this.iconSize,
    required this.contentPadding,
    required this.tileMargin,
    required this.labelAdditionalMargin,
  });

  /// Interior padding on the tile.
  final EdgeInsets contentPadding;

  /// Size of any icons used in the leading or trailing widget.
  final double iconSize;

  /// Exterior margin of the tile.
  ///
  /// Only used if the tile is not shrink wrapped.
  final double tileMargin;

  /// Additional margin to be added to the tile after the leading widget but before the rest of the content.
  final double labelAdditionalMargin;
}

/// Applies style to any child of type [ZdsTabBar].
class ZdsTabBarStyleContainer {
  /// Constructs a [ZdsTabBarStyleContainer]
  ZdsTabBarStyleContainer({required this.theme, required this.customTheme});

  ///Base theme.
  final ThemeData theme;

  /// Custom theme for tab bar specifically.
  final ZdsTabBarThemeData customTheme;
}

/// Applies style to any child of type [ZdsBottomBar].
class ZdsBottomBarThemeData {
  /// Constructs a [ZdsBottomBarThemeData].
  ZdsBottomBarThemeData({
    required this.height,
    required this.shadows,
    required this.backgroundColor,
    required this.contentPadding,
  });

  /// Height of the bottom bar.
  final double height;

  /// Box shadows to be applied to the bottom bar.
  final List<BoxShadow> shadows;

  /// Background color of the bottom bar.
  final Color backgroundColor;

  /// Interior content padding of the bottom bar.
  final EdgeInsets contentPadding;

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
  /// Constructs a [ZdsBottomBarTheme].
  const ZdsBottomBarTheme({
    required super.child,
    required this.data,
    super.key,
  });

  /// Theme data to be applied.
  final ZdsBottomBarThemeData data;

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
  /// Constructor for [ZdsTabBarThemeData].
  const ZdsTabBarThemeData({required this.decoration, required this.height, this.iconSize = 16});

  /// Decoration for [ZdsTabBar].
  ///
  /// Typically [BoxDecoration].
  final BoxDecoration decoration;

  /// Height of [ZdsTabBar].
  final double height;

  /// Size of icon. Defaults to 16.
  final double iconSize;
}

/// Theme data for [ZdsToolbar].
class ZdsToolbarThemeData {
  /// Constructs a [ZdsToolbarThemeData].
  const ZdsToolbarThemeData({required this.contentPadding});

  /// Interior content padding for the toolbar.
  final EdgeInsets contentPadding;
}

/// Border used for input components, such as [TextField] to apply a Zds style.
class ZdsInputBorder extends InputBorder {
  /// Constructs a [ZdsInputBorder].
  const ZdsInputBorder({
    super.borderSide,
    this.space = kSpace,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  /// The space between the border and the interior content.
  ///
  /// Defaults to 6
  final double space;

  /// The border radius used for the border.
  ///
  /// Defaults to `BorderRadius.all(Radius.circular(12))`.
  final BorderRadius borderRadius;

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
  Widget get prefixIcon => Builder(
        builder: (context) {
          return Icon(ZdsIcons.search, color: Zeta.of(context).colors.iconSubtle);
        },
      );

  /// Gets default theme data for [ZdsListTile].
  @Deprecated('Use kZdsListTileTheme instead')
  ZdsListTileTheme get zdsListTileThemeData => kZdsListTileTheme;

  ///Gets default theme data for [ZdsToolbar].
  @Deprecated('Use kZdsToolbarTheme instead')
  ZdsToolbarThemeData get zdsToolbarThemeData => kZdsToolbarTheme;

  /// Gets default theme data for [ZdsSearchField]
  ThemeData zdsSearchThemeData(ThemeData baseTheme, ZdsSearchFieldVariant variant, ZetaColors zetaColors) {
    final OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(kSearchBorderRadius),
      borderSide: const BorderSide(
        style: BorderStyle.none,
      ),
    );

    InputDecorationTheme inputDecorationTheme(OutlineInputBorder border) {
      return InputDecorationTheme(
        border: border,
        focusedBorder: border,
        errorBorder: border,
        enabledBorder: border,
        disabledBorder: border,
        focusedErrorBorder: border,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      );
    }

    final CardTheme cardTheme = this.cardTheme.copyWith(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kSearchBorderRadius),
          ),
        );

    switch (variant) {
      case ZdsSearchFieldVariant.outlined:
        return baseTheme.copyWith(
          inputDecorationTheme: inputDecorationTheme(
            border.copyWith(
              borderSide: BorderSide(color: zetaColors.borderSubtle),
            ),
          ),
          textSelectionTheme: TextSelectionThemeData(cursorColor: colorScheme.onSurface),
          hintColor: colorScheme.onSurface.withOpacity(0.5),
          cardTheme: cardTheme.copyWith(shadowColor: Colors.transparent),
        );
      case ZdsSearchFieldVariant.elevated:
        return baseTheme.copyWith(
          inputDecorationTheme: inputDecorationTheme(border),
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: colorScheme.onSurface,
          ),
          cardTheme: cardTheme,
          hintColor: colorScheme.onSurface.withOpacity(0.5),
        );
    }
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

  /// Generates theme for [ZdsTabBar].
  @Deprecated('Use ZdsTabBar.buildTheme() instead')
  ZdsTabBarStyleContainer zdsTabBarThemeData(
    BuildContext context, {
    required bool hasIcons,
    required ZdsTabBarColor color,
    Color? indicatorColor,
  }) {
    /// Builds [ZdsTabBarStyleContainer]. Defaults to primary color.
    ZdsTabBarStyleContainer tabBarStyle(
      BuildContext context, {
      required bool hasIcons,
      required Color selectedText,
      required Color background,
      required Color unselectedText,
      required Color indicator,
    }) {
      final double height = hasIcons ? 56.0 : 48.0;
      final ThemeData theme = Theme.of(context);

      final TabBarTheme tabBarTheme = theme.tabBarTheme.copyWith(indicatorSize: TabBarIndicatorSize.tab);
      final TextStyle? labelStyle = hasIcons ? theme.textTheme.bodySmall : theme.textTheme.bodyLarge;

      return ZdsTabBarStyleContainer(
        customTheme: ZdsTabBarThemeData(
          decoration: BoxDecoration(color: background),
          height: height,
        ),
        theme: theme.copyWith(
          tabBarTheme: tabBarTheme.copyWith(
            labelStyle: labelStyle,
            unselectedLabelStyle: labelStyle,
            unselectedLabelColor: unselectedText,
            labelColor: selectedText,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(
                width: 3,
                color: indicator,
              ),
            ),
          ),
        ),
      );
    }

    final zetaColors = Zeta.of(context).colors;
    switch (color) {
      case ZdsTabBarColor.primary:
        return tabBarStyle(
          context,
          hasIcons: hasIcons,
          background: zetaColors.primary,
          indicator: zetaColors.primary.onColor,
          selectedText: zetaColors.primary.onColor,
          unselectedText: zetaColors.primary.onColor.withOpacity(0.5),
        );
      case ZdsTabBarColor.basic:
        return tabBarStyle(
          context,
          hasIcons: hasIcons,
          background: colorScheme.background,
          indicator: zetaColors.primary,
          selectedText: zetaColors.textDefault,
          unselectedText: zetaColors.textSubtle,
        );
      case ZdsTabBarColor.surface:
        return tabBarStyle(
          context,
          hasIcons: hasIcons,
          background: zetaColors.surfacePrimary,
          indicator: zetaColors.primary,
          selectedText: zetaColors.textDefault,
          unselectedText: zetaColors.textSubtle,
        );
      case ZdsTabBarColor.appBar:
        final appBarTheme = Theme.of(context).appBarTheme;
        return tabBarStyle(
          context,
          hasIcons: hasIcons,
          background: appBarTheme.backgroundColor ?? zetaColors.surfacePrimary,
          indicator: appBarTheme.foregroundColor ?? zetaColors.primary,
          selectedText: appBarTheme.foregroundColor ?? zetaColors.textDefault,
          unselectedText: appBarTheme.foregroundColor?.withOpacity(0.5) ?? zetaColors.textSubtle,
        );
    }
  }

  /// Builds theme variants for [ZdsAppBar].
  ///
  /// See also
  /// * [ZdsTabBarColor].
  @Deprecated('Use ZdsAppBar.buildTheme() instead.')
  AppBarTheme buildAppBarTheme(ZdsTabBarColor color) {
    final isDarkMode = brightness == Brightness.dark;
    switch (color) {
      case ZdsTabBarColor.primary:
      case ZdsTabBarColor.appBar:
        final fgColor = isDarkMode ? colorScheme.cool.shade90 : colorScheme.onPrimary;
        final bgColor = isDarkMode ? colorScheme.cool.shade10 : colorScheme.primary;
        return AppBarTheme(
          systemOverlayStyle: computeSystemOverlayStyle(bgColor),
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          centerTitle: false,
          titleSpacing: 0,
          elevation: 0.5,
          iconTheme: IconThemeData(color: fgColor),
          actionsIconTheme: IconThemeData(color: fgColor),
        );
      case ZdsTabBarColor.basic:
        final fgColor = isDarkMode ? colorScheme.cool.shade90 : colorScheme.cool.shade10;
        final bgColor = isDarkMode ? colorScheme.cool.shade10 : colorScheme.cool.shade90;
        return AppBarTheme(
          systemOverlayStyle: computeSystemOverlayStyle(bgColor),
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          centerTitle: false,
          titleSpacing: 0,
          elevation: 0.5,
          iconTheme: IconThemeData(color: fgColor),
          actionsIconTheme: IconThemeData(color: fgColor),
        );
      case ZdsTabBarColor.surface:
        final fgColor = isDarkMode ? colorScheme.cool.shade90 : colorScheme.onSurface;
        final bgColor = isDarkMode ? colorScheme.cool.shade10 : colorScheme.surface;
        return AppBarTheme(
          systemOverlayStyle: computeSystemOverlayStyle(bgColor),
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          centerTitle: false,
          titleSpacing: 0,
          elevation: 0.5,
          iconTheme: IconThemeData(color: fgColor),
          actionsIconTheme: IconThemeData(color: fgColor),
        );
    }
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
