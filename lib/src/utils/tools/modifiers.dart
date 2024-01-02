import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';

import '../../../zds_flutter.dart';

/// A selection of modifiers on [Widget] for padding.
extension PaddingModifers on Widget {
  /// Applies [EdgeInsets.all] padding on this widget.
  Widget padding(double all) {
    return Padding(
      padding: EdgeInsets.all(all),
      child: this,
    );
  }

  /// Applies [EdgeInsets.only] padding on this widget.
  Widget paddingOnly({double left = 0, double right = 0, double top = 0, double bottom = 0}) {
    return Padding(
      padding: EdgeInsets.only(
        left: left,
        right: right,
        top: top,
        bottom: bottom,
      ),
      child: this,
    );
  }

  /// Applies padding to this widget using [EdgeInsets].
  Widget paddingInsets(EdgeInsets insets) {
    return Padding(
      padding: insets,
      child: this,
    );
  }
}

/// A selection of modifiers on [Widget] for colors
extension ColorModifers on Widget {
  /// Applies a decoration to the widget with a background color.
  Widget backgroundColor(Color color) {
    return DecoratedBox(
      decoration: BoxDecoration(color: color),
      child: this,
    );
  }

  /// Changes the widget's textStyle to use this color.
  Widget foregroundColor(Color color) {
    return DefaultTextStyle(
      style: TextStyle(color: color),
      child: this,
    );
  }

  /// Creates a [Stack] where this overlay will be shown on top of this widget.
  Widget overlay(
    Widget overlay, [
    Alignment alignment = Alignment.center,
  ]) {
    return Stack(
      alignment: alignment,
      children: <Widget>[
        this,
        overlay,
      ],
    );
  }
}

/// A selection of modifiers on [Widget] for layouts
extension LayoutModifiers on Widget {
  /// Frames this widget position.
  ///
  /// For example, this, in conjunction with other extensions, can be used to create an icon with a circle background.
  ///
  /// ```dart
  /// Icon(ZdsIcons.walk)
  ///   .frame(width: 30, height: 30, alignment: Alignment.center)
  ///   .backgroundColor(Theme.of(context).colorScheme.primary.withLight(0.1))
  ///   .circle(30),
  /// ```
  Widget frame({
    double? width = double.infinity,
    double? height = double.infinity,
    Alignment? alignment,
  }) {
    Widget content = this;
    if (alignment != null) {
      content = Align(
        alignment: alignment,
        child: this,
      );
    }
    return SizedBox(
      width: width,
      height: height,
      child: content,
    );
  }

  /// A similar extension to [frame], but that uses [BoxConstraints] instead of hardcoded size values.
  Widget frameConstrained({
    required double maxWidth,
    required double minHeight,
    required double minWidth,
    required double maxHeight,
    double? idealHeight,
    Alignment? alignment,
    double? idealWidth,
  }) {
    Widget content = this;
    if (alignment != null) {
      content = Align(
        alignment: alignment,
        child: this,
      );
    }
    final ConstrainedBox box = ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: minWidth,
        maxWidth: maxWidth,
        minHeight: minHeight,
        maxHeight: maxHeight,
      ),
      child: content,
    );

    if (idealWidth != null || idealHeight != null) {
      return SizedBox(
        width: idealWidth,
        height: idealHeight,
        child: box,
      );
    }

    return box;
  }

  /// Offsets the widget using an [Offset].
  Widget offset(Offset offset) {
    return Transform.translate(
      offset: offset,
      child: this,
    );
  }

  /// Offsets the widget using offset coordinates.
  Widget offsetOnly({double x = 0.0, double y = 0.0}) {
    return Transform.translate(
      offset: Offset(x, y),
      child: this,
    );
  }
}

///  Applies a decoration to the widget with a [Border].
extension BorderModifiers on Widget {
  /// Applies a decoration to the widget with a [Border].
  Widget border(Border style) {
    return DecoratedBox(
      decoration: BoxDecoration(border: style),
      child: this,
    );
  }
}

/// A selection of modifiers on [Widget] for rendering
extension RenderingModifiers on Widget {
  /// Applies a [Clip] to the widget.
  Widget clipped(Clip clipBehavior) {
    return ClipRect(
      clipBehavior: clipBehavior,
      child: this,
    );
  }

  /// Applies a circular clip with a given radius.
  Widget circle(double radius) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: this,
    );
  }

  /// Applies a custom clip shape.
  Widget clipShape<T extends CustomClipper<Rect>>(
    T clipper,
    Clip clipBehavior,
  ) {
    return ClipRect(
      clipper: clipper,
      clipBehavior: clipBehavior,
      child: this,
    );
  }

  /// Applies a decoration to the widget with a [BorderRadius].
  Widget cornerRadius(double radius) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      ),
      child: this,
    );
  }

  /// Applies a [ShaderMask] to the widget.
  Widget mask(Shader Function(Rect bounds) mask) {
    return ShaderMask(
      shaderCallback: (Rect bounds) => mask(bounds),
      child: this,
    );
  }

  /// Changes the widget's opacity.
  Widget opacity(double opacity) {
    return Opacity(opacity: opacity, child: this);
  }

  /// Applies a decoration to the widget with a [BoxShadow].
  Widget shadow(
    Color color,
    double radius, {
    required double blur,
    double x = 0.0,
    double y = 0.0,
  }) {
    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            blurRadius: blur,
            spreadRadius: radius,
            color: color,
            offset: Offset(x, y),
          ),
        ],
      ),
      child: this,
    );
  }
}

/// Changes this widget's [TextStyle].
extension DefaultTextStylesModifiers on Widget {
  /// Changes this widget's [TextStyle].
  Widget textStyle(TextStyle? style, {TextOverflow? overflow, TextAlign? textAlign}) {
    return DefaultTextStyle(
      style: style ?? const TextStyle(),
      overflow: overflow ?? TextOverflow.ellipsis,
      textAlign: textAlign,
      child: this,
    );
  }
}

/// Applies a [Theme] with custom [ThemeData] to the widget.
extension ThemeModifiers on Widget {
  /// Applies a [Theme] with custom [ThemeData] to the widget.
  Widget applyTheme(ThemeData themeData) {
    return Theme(
      data: themeData,
      child: this,
    );
  }
}

/// Changes this widget's [TextStyle].
extension TextModifiers on Text {
  /// Changes this widget's [TextStyle].
  Widget font({
    double? size,
    String? family,
    FontWeight? weight,
    FontStyle? style,
  }) {
    return DefaultTextStyle(
      style: TextStyle(
        fontFamily: family,
        fontSize: size,
        fontWeight: weight,
        fontStyle: style,
      ),
      child: this,
    );
  }

  /// Changes the [TextStyle.height] for this widget.
  Widget lineSpacing(double height) {
    return DefaultTextStyle(
      style: TextStyle(
        height: height,
      ),
      child: this,
    );
  }

  /// Changes the [DefaultTextStyle.maxLines] for this widget.
  Widget lineLimit(int limit) {
    return DefaultTextStyle(
      maxLines: limit,
      style: style!,
      child: this,
    );
  }

  /// Changes the [DefaultTextStyle.textAlign] for this widget.
  Widget multilineTextAlignment(TextAlign textAlign) {
    return DefaultTextStyle(
      textAlign: textAlign,
      style: style!,
      child: this,
    );
  }

  /// Changes the [DefaultTextStyle.overflow] for this widget.
  Widget truncationMode(TextOverflow overflow) {
    return DefaultTextStyle(
      overflow: overflow,
      style: style!,
      child: this,
    );
  }

  /// Changes the [TextStyle.backgroundColor] for this widget.
  Widget backgroundColor(Color color) {
    return DefaultTextStyle(
      style: TextStyle(backgroundColor: color),
      child: this,
    );
  }

  /// Changes the [TextStyle.color] for this widget
  Widget foregroundColor(Color color) {
    return DefaultTextStyle(
      style: TextStyle(color: color),
      child: this,
    );
  }

  /// Changes the [TextStyle.shadows] for this widget, using a singular shadow.
  Widget shadow(
    Color color,
    double radius, {
    required double blur,
    double x = 0.0,
    double y = 0.0,
  }) {
    return DefaultTextStyle(
      style: TextStyle(
        shadows: <BoxShadow>[
          BoxShadow(
            blurRadius: blur,
            spreadRadius: radius,
            color: color,
            offset: Offset(x, y),
          ),
        ],
      ),
      child: this,
    );
  }
}

/// Changes this Scaffold's [SystemUiOverlayStyle].
extension StatusBar on Scaffold {
  /// Changes this Scaffold's [SystemUiOverlayStyle].
  Widget statusBar(SystemUiOverlayStyle style) {
    return AnnotatedRegion<SystemUiOverlayStyle>(value: style, child: this);
  }
}

/// Applies Zds styling to [Widget]
extension Zds on Widget {
  /// Applies [EdgeInsets.all] with value 16 to this widget.
  Widget content() {
    return padding(16);
  }

  /// Applies bottom widget to this widget.
  ///
  /// Defaults to 22.
  Widget space([double size = 22.0]) {
    return paddingOnly(bottom: size);
  }
}

/// Makes this widget a [ZdsPopOverIconButton].

extension PopOver on Icon {
  /// Makes this widget a [ZdsPopOverIconButton].
  Widget withPopOver(WidgetBuilder popOverBuilder) {
    return ZdsPopOverIconButton(
      icon: this,
      popOverBuilder: popOverBuilder,
      iconSize: size ?? 24,
      color: color,
    );
  }
}

/// Center aligning row's children perfectly on the horizontal AND on the vertical axis
extension RowLayout on Row {
  /// Center aligning row's children perfectly on the horizontal AND on the vertical axis
  /// when used in a vertical MultichildRenderObject.
  ///
  /// ```
  /// e.g. normal Column or ListView with rows inside
  ///  750000   187
  ///  245000   14501
  ///  5000   0.5
  ///  10  1
  ///
  /// e.g. using this modifier method to create a grid where row's children
  /// are centered vertically inside the Column or ListView
  ///  750000    187
  ///  245000   14501
  ///   5000     0.5
  ///    10       1
  /// ```
  Row get gridCenteredChildren {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      children: children.map((Widget child) {
        return Expanded(
          child: Row(
            children: <Widget>[
              const Spacer(),
              child,
              const Spacer(),
            ],
          ),
        );
      }).toList(),
    );
  }
}

/// A selection of modifiers on TextTheme.
extension TextThemeExtension on TextTheme {
  /// TextStyle for tab item 1
  @Deprecated('Use bodyTextLarge, or bodyTextMedium if tab has icons.')
  TextStyle get tabItem1 {
    return bodyLarge!.copyWith(letterSpacing: 0.2);
  }

  /// TextStyle tabitem2
  @Deprecated('Use bodyTextLarge, or bodyTextMedium if tab has icons.')
  TextStyle get tabItem2 {
    return bodyMedium!;
  }

  /// TextStyle bodyText3
  @Deprecated('Use bodyTextSmall')
  TextStyle get bodyText3 {
    return titleLarge!.copyWith(fontWeight: FontWeight.w400);
  }
}

/// Applies Semanctics to [Widget]
extension SemanticsModifier on Widget {
  /// Include Semantics with label this widget.
  Widget semantics({
    Key? key,
    bool container = false,
    bool explicitChildNodes = false,
    bool excludeSemantics = false,
    bool? enabled,
    bool? checked,
    bool? selected,
    bool? toggled,
    bool? button,
    bool? slider,
    bool? keyboardKey,
    bool? link,
    bool? header,
    bool? textField,
    bool? readOnly,
    bool? focusable,
    bool? focused,
    bool? inMutuallyExclusiveGroup,
    bool? obscured,
    bool? multiline,
    bool? scopesRoute,
    bool? namesRoute,
    bool? hidden,
    bool? image,
    bool? liveRegion,
    int? maxValueLength,
    int? currentValueLength,
    String? label,
    AttributedString? attributedLabel,
    String? value,
    AttributedString? attributedValue,
    String? increasedValue,
    AttributedString? attributedIncreasedValue,
    String? decreasedValue,
    AttributedString? attributedDecreasedValue,
    String? hint,
    AttributedString? attributedHint,
    String? onTapHint,
    String? onLongPressHint,
    TextDirection? textDirection,
    SemanticsSortKey? sortKey,
    SemanticsTag? tagForChildren,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    VoidCallback? onScrollLeft,
    VoidCallback? onScrollRight,
    VoidCallback? onScrollUp,
    VoidCallback? onScrollDown,
    VoidCallback? onIncrease,
    VoidCallback? onDecrease,
    VoidCallback? onCopy,
    VoidCallback? onCut,
    VoidCallback? onPaste,
    VoidCallback? onDismiss,
    MoveCursorHandler? onMoveCursorForwardByCharacter,
    MoveCursorHandler? onMoveCursorBackwardByCharacter,
    SetSelectionHandler? onSetSelection,
    SetTextHandler? onSetText,
    VoidCallback? onDidGainAccessibilityFocus,
    VoidCallback? onDidLoseAccessibilityFocus,
    Map<CustomSemanticsAction, VoidCallback>? customSemanticsActions,
  }) {
    return Semantics.fromProperties(
      key: key,
      container: container,
      explicitChildNodes: explicitChildNodes,
      excludeSemantics: excludeSemantics,
      properties: SemanticsProperties(
        enabled: enabled,
        checked: checked,
        toggled: toggled,
        selected: selected,
        button: button,
        slider: slider,
        keyboardKey: keyboardKey,
        link: link,
        header: header,
        textField: textField,
        readOnly: readOnly,
        focusable: focusable,
        focused: focused,
        inMutuallyExclusiveGroup: inMutuallyExclusiveGroup,
        obscured: obscured,
        multiline: multiline,
        scopesRoute: scopesRoute,
        namesRoute: namesRoute,
        hidden: hidden,
        image: image,
        liveRegion: liveRegion,
        maxValueLength: maxValueLength,
        currentValueLength: currentValueLength,
        label: label,
        attributedLabel: attributedLabel,
        value: value,
        attributedValue: attributedValue,
        increasedValue: increasedValue,
        attributedIncreasedValue: attributedIncreasedValue,
        decreasedValue: decreasedValue,
        attributedDecreasedValue: attributedDecreasedValue,
        hint: hint,
        attributedHint: attributedHint,
        textDirection: textDirection,
        sortKey: sortKey,
        tagForChildren: tagForChildren,
        onTap: onTap,
        onLongPress: onLongPress,
        onScrollLeft: onScrollLeft,
        onScrollRight: onScrollRight,
        onScrollUp: onScrollUp,
        onScrollDown: onScrollDown,
        onIncrease: onIncrease,
        onDecrease: onDecrease,
        onCopy: onCopy,
        onCut: onCut,
        onPaste: onPaste,
        onMoveCursorForwardByCharacter: onMoveCursorForwardByCharacter,
        onMoveCursorBackwardByCharacter: onMoveCursorBackwardByCharacter,
        onDidGainAccessibilityFocus: onDidGainAccessibilityFocus,
        onDidLoseAccessibilityFocus: onDidLoseAccessibilityFocus,
        onDismiss: onDismiss,
        onSetSelection: onSetSelection,
        onSetText: onSetText,
        customSemanticsActions: customSemanticsActions,
        hintOverrides: onTapHint != null || onLongPressHint != null
            ? SemanticsHintOverrides(
                onTapHint: onTapHint,
                onLongPressHint: onLongPressHint,
              )
            : null,
      ),
      child: this,
    );
  }

  /// Exclude Semantics for this widget.
  Widget excludeSemantics() {
    return ExcludeSemantics(
      child: this,
    );
  }

  /// Merge Semantics for this widget.
  Widget mergeSemantics() {
    return MergeSemantics(
      child: this,
    );
  }
}
