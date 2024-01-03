import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../zds_flutter.dart';

/// Variants of ZdsButton.
enum ZdsButtonVariant {
  /// Filled button where the background is the defined color.
  filled,

  /// Outlined button where the outline border is the defined color, and the background is transparent.
  outlined,

  /// Text button equivalent with Zds styling.
  text,

  /// Non filled button with a border and muted grey colors.
  muted,
}

/// An ElevatedButton with pre-applied Zds styling.
///
/// There are four variants:
/// * [ZdsButton], which returns a filled button.
/// * [ZdsButton.outlined], which returns a non-filled button with a border.
/// * [ZdsButton.text], which returns the equivalent of a TextButton with Zds styling.
/// * [ZdsButton.muted], which returns a non-filled button with a border and muted grey colors.
/// These variants can be thought of being the primary, secondary, tertiary, and quarternary buttons respectively.
///
/// If [isDangerButton] is true, it will make the button red, used for destructive actions (deleting, removing, etc...).
/// [isDangerButton] can only be set to true if the variant used is either [ZdsButton] or [ZdsButton.outlined].
///
/// If [onTap] and [onLongPress] are null, the button will be disabled and change its appareance to a disabled state.
///
/// The other parameters act the same way as the ones in [ElevatedButton].
class ZdsButton extends StatelessWidget {
  /// Creates a filled ZdsButton. (Primary button). Use [ZdsButton.filled] until old buttons are fully removed.
  /// Currently, this acts as a backward compatible constructor for the old buttons.
  ///
  /// The [child] argument, usually a [Text], must not be null.
  const ZdsButton({
    required this.child,
    super.key,
    this.onTap,
    this.isDangerButton = false,
    this.autofocus = false,
    this.clipBehavior = Clip.none,
    this.focusNode,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.textPadding,
    this.semanticLabel,
  })  : _variant = ZdsButtonVariant.filled,
        isOnDarkBackground = false,
        customColor = null;

  /// Creates a filled ZdsButton. (Primary button). Will be removed when old button versions are fully removed.
  /// Will be replaced with [ZdsButton] constructor.
  ///
  /// The [child] argument, usually a [Text], must not be null.
  const ZdsButton.filled({
    required this.child,
    super.key,
    this.onTap,
    this.isDangerButton = false,
    this.autofocus = false,
    this.clipBehavior = Clip.none,
    this.focusNode,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.textPadding,
    this.customColor,
    this.semanticLabel,
  })  : _variant = ZdsButtonVariant.filled,
        isOnDarkBackground = false;

  /// Creates an outlined ZdsButton. (Secondary button)
  ///
  /// The [child] argument, usually a [Text], must not be null.
  const ZdsButton.outlined({
    required this.child,
    super.key,
    this.onTap,
    this.isDangerButton = false,
    this.autofocus = false,
    this.clipBehavior = Clip.none,
    this.focusNode,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.textPadding,
    this.customColor,
    this.semanticLabel,
  })  : _variant = ZdsButtonVariant.outlined,
        isOnDarkBackground = false;

  /// Creates a ZdsButton that behaves as a TextButton. (Tertiary button)
  ///
  /// The [child] argument must not be null.
  const ZdsButton.text({
    required this.child,
    super.key,
    this.isOnDarkBackground = false,
    this.onTap,
    this.autofocus = false,
    this.clipBehavior = Clip.none,
    this.focusNode,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.textPadding,
    this.customColor,
    this.semanticLabel,
  })  : _variant = ZdsButtonVariant.text,
        isDangerButton = false;

  /// Constructs a muted ZdsButton. (Quaternary button)
  ///
  /// The [child] argument must not be null.
  const ZdsButton.muted({
    required this.child,
    super.key,
    this.onTap,
    this.autofocus = false,
    this.clipBehavior = Clip.none,
    this.focusNode,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.textPadding,
    this.customColor,
    this.semanticLabel,
  })  : _variant = ZdsButtonVariant.muted,
        isOnDarkBackground = false,
        isDangerButton = false;

  /// The Widget that will go inside the button, typically a [Text] with style [TextTheme.titleMedium].
  ///
  /// Must not be null.
  final Widget child;

  /// Whether to use danger/red colors. If true, the variant used must be either [ZdsButton] or [ZdsButton.outlined].
  ///
  /// Defaults to false.
  final bool isDangerButton;

  /// Whether to use white text as the button is on a dark background. Can only be used with [ZdsButton.text]
  final bool isOnDarkBackground;

  /// Whether to autofocus on this button.
  ///
  /// Defaults to false.
  final bool autofocus;

  /// Whether to clip the contents of this button.
  ///
  /// Defaults to [Clip.none]
  final Clip clipBehavior;

  /// FocusNode for the button.
  ///
  /// The [autofocus] and [clipBehavior] arguments must not be null.
  final FocusNode? focusNode;

  /// If this and [onTap] are null, the button will be disabled.
  final VoidCallback? onLongPress;

  /// Called whenever a pointer enters or exits the button response area, with true if a pointer has entered this
  /// button and false if it has exited it.
  final ValueChanged<bool>? onHover;

  /// Called when the focus changes, with true if this widget's node gains focus, and false if it loses focus.
  final ValueChanged<bool>? onFocusChange;

  /// If this and [onLongPress] are null, the button will be disabled.
  final VoidCallback? onTap;

  /// padding for the text within the button
  final EdgeInsets? textPadding;

  /// Custom color override.
  ///
  /// Changes:
  /// * [ZdsButton.filled] - background color.
  /// * [ZdsButton.text] - text color.
  /// * [ZdsButton.outlined] - outline color.
  /// * [ZdsButton.muted] - no change.
  final Color? customColor;

  /// This is for talkback text on child.
  final String? semanticLabel;

  final ZdsButtonVariant _variant;

  @override
  Widget build(BuildContext context) {
    final bool isChildText = child is Text;
    return Semantics(
      label: semanticLabel ?? (isChildText ? (child as Text).data : ''),
      button: true,
      onTap: onTap,
      onLongPress: onLongPress,
      excludeSemantics: true,
      child: ElevatedButton(
        key: key,
        autofocus: autofocus,
        focusNode: focusNode,
        onPressed: onTap,
        onLongPress: onLongPress,
        onFocusChange: onFocusChange,
        onHover: onHover,
        style: getStyle(
          variant: _variant,
          zetaColors: Zeta.of(context).colors,
          textTheme: Theme.of(context).primaryTextTheme,
          textPadding: textPadding,
          isDangerButton: isDangerButton,
          isOnDarkBackground: isOnDarkBackground,
          customColor: customColor,
        ),
        clipBehavior: clipBehavior,
        child: child,
      ),
    );
  }

  /// Returns a ButtonStyle based on the provided parameters.
  ///
  /// - [variant]: The style variant of the button.
  /// - [zetaColors]: Colors configuration for the application/theme.
  /// - [textTheme]: The text theme for the application/theme.
  /// - [textPadding]: Optional padding for the button's text content.
  /// - [isDangerButton]: Flag to determine if the button indicates a dangerous action.
  /// - [isOnDarkBackground]: Flag to determine if the button is on a dark background.
  /// - [customColor]: An optional color to override the default button color.
  static ButtonStyle getStyle({
    required ZdsButtonVariant variant,
    required ZetaColors zetaColors,
    required TextTheme textTheme,
    EdgeInsetsGeometry? textPadding,
    bool isDangerButton = false,
    bool isOnDarkBackground = false,
    Color? customColor,
  }) {
    // Default text padding if none is provided.
    final EdgeInsetsGeometry tp = textPadding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 6);

    // Determine the default background color.
    final Color defaultBackground = customColor ?? (isDangerButton ? zetaColors.negative : zetaColors.secondary);

    // Common textStyle for all variants.
    final textStyle = MaterialStateProperty.all(textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500));

    // Helper function to calculate the overlay color.
    Color calculateOverlay({double opacity = 0.1, Color? background}) {
      return customColor?.withOpacity(opacity) ?? (background ?? defaultBackground).withOpacity(opacity);
    }

    switch (variant) {
      case ZdsButtonVariant.filled:
        return ButtonStyle(
          padding: MaterialStateProperty.all(tp),
          textStyle: textStyle,
          foregroundColor: materialStatePropertyResolver(
            defaultValue: defaultBackground.onColor,
            disabledValue: zetaColors.textDisabled,
          ),
          backgroundColor: materialStatePropertyResolver(
            defaultValue: defaultBackground,
            disabledValue: zetaColors.surfaceDisabled,
          ),
          overlayColor: materialStatePropertyResolver(
            hoveredValue: defaultBackground.darken(5), // Slight darkening for hover
            pressedValue: defaultBackground.darken(15), // More noticeable darkening for pressed state
            defaultValue: Colors.transparent,
          ),
          side: materialStatePropertyResolver(
            focusedValue: BorderSide(color: zetaColors.secondary.subtle, width: 3),
            disabledValue: BorderSide(color: zetaColors.borderDisabled),
          ),
        );
      case ZdsButtonVariant.outlined:
        return ButtonStyle(
          padding: MaterialStateProperty.all(tp),
          textStyle: textStyle,
          foregroundColor: materialStatePropertyResolver(
            defaultValue: defaultBackground,
            disabledValue: zetaColors.textDisabled,
          ),
          backgroundColor: materialStatePropertyResolver(
            defaultValue: Colors.transparent,
            disabledValue: zetaColors.surfaceDisabled,
          ),
          overlayColor: materialStatePropertyResolver(
            defaultValue: Colors.transparent,
            hoveredValue: calculateOverlay(),
            pressedValue: calculateOverlay(opacity: 0.2),
          ),
          side: materialStatePropertyResolver(
            focusedValue: BorderSide(color: zetaColors.secondary.subtle, width: 3),
            defaultValue: BorderSide(color: defaultBackground),
            disabledValue: BorderSide(color: zetaColors.borderDisabled),
          ),
        );
      case ZdsButtonVariant.text:
        return ButtonStyle(
          padding: MaterialStateProperty.all(tp),
          textStyle: textStyle,
          foregroundColor: materialStatePropertyResolver(
            defaultValue: isOnDarkBackground ? zetaColors.textInverse : defaultBackground,
            disabledValue: zetaColors.textDisabled,
          ),
          backgroundColor: materialStatePropertyResolver(
            defaultValue: Colors.transparent,
          ),
          overlayColor: materialStatePropertyResolver(
            defaultValue: Colors.transparent,
            hoveredValue: calculateOverlay(),
            pressedValue: calculateOverlay(opacity: 0.2),
          ),
          side: materialStatePropertyResolver(
            focusedValue: BorderSide(color: zetaColors.secondary.subtle, width: 3),
            disabledValue: const BorderSide(color: Colors.transparent),
          ),
        );
      case ZdsButtonVariant.muted:
        return ButtonStyle(
          padding: MaterialStateProperty.all(tp),
          textStyle: textStyle,
          foregroundColor: materialStatePropertyResolver(
            defaultValue: zetaColors.textDefault,
            disabledValue: zetaColors.textDisabled,
          ),
          backgroundColor: materialStatePropertyResolver(
            defaultValue: Colors.transparent,
            disabledValue: zetaColors.surfaceDisabled,
          ),
          overlayColor: materialStatePropertyResolver(
            defaultValue: Colors.transparent,
            hoveredValue: calculateOverlay(background: zetaColors.borderDefault),
            pressedValue: calculateOverlay(background: zetaColors.borderDefault, opacity: 0.2),
          ),
          side: materialStatePropertyResolver(
            focusedValue: BorderSide(color: zetaColors.secondary.subtle, width: 3),
            disabledValue: BorderSide(color: zetaColors.borderDisabled),
            defaultValue: BorderSide(color: zetaColors.borderDefault),
          ),
        );
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>('isDangerButton', isDangerButton))
      ..add(DiagnosticsProperty<bool>('isOnDarkBackground', isOnDarkBackground))
      ..add(DiagnosticsProperty<bool>('autofocus', autofocus))
      ..add(EnumProperty<Clip>('clipBehavior', clipBehavior))
      ..add(DiagnosticsProperty<FocusNode?>('focusNode', focusNode))
      ..add(ObjectFlagProperty<VoidCallback?>.has('onLongPress', onLongPress))
      ..add(ObjectFlagProperty<ValueChanged<bool>?>.has('onHover', onHover))
      ..add(ObjectFlagProperty<ValueChanged<bool>?>.has('onFocusChange', onFocusChange))
      ..add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap))
      ..add(DiagnosticsProperty<EdgeInsets?>('textPadding', textPadding))
      ..add(ColorProperty('customColor', customColor))
      ..add(StringProperty('semanticLabel', semanticLabel));
  }
}
