import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../zds_flutter.dart';

/// Variants of ZdsButton.
enum _ZdsButtonVariant {
  /// Filled button where the background is the defined color.
  filled,

  /// Outlined button where the outline border is the defined color, and the background is transparent.
  outlined,

  /// Text button equivalent with Zds styling.
  text,

  /// Non filled button with a border and muted grey colors.
  muted,
}

// TODO(colors): Add Zeta.

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
  /// The Widget that will go inside the button, typically a [Text] with style [Theme.textTheme.titleMedium].
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
  /// * [ZdsButton.outlined - outline color.
  /// * [ZdsButton.muted] - no change.
  final Color? customColor;

  /// This is for talkback text on child.
  final String? semanticLabel;

  final _ZdsButtonVariant _variant;

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
  })  : _variant = _ZdsButtonVariant.filled,
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
  })  : _variant = _ZdsButtonVariant.filled,
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
  })  : _variant = _ZdsButtonVariant.outlined,
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
  })  : _variant = _ZdsButtonVariant.text,
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
  })  : _variant = _ZdsButtonVariant.muted,
        isOnDarkBackground = false,
        isDangerButton = false;

  @override
  Widget build(BuildContext context) {
    final isChildText = child is Text;
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
        style: _getStyle(context, textPadding),
        clipBehavior: clipBehavior,
        child: child,
      ),
    );
  }

  ButtonStyle _getStyle(BuildContext context, EdgeInsetsGeometry? tp) {
    final textPadding = tp ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 6);

    const highlightBlueColor = Color(0xffB7DBFF); // TODO(colors): replace with theme color
    final errorColor = Theme.of(context).colorScheme.error;
    final onErrorColor = Theme.of(context).colorScheme.onError;
    final defaultBackgroundColor = Theme.of(context).elevatedButtonTheme.style!.backgroundColor!.resolve({})!;
    switch (_variant) {
      case _ZdsButtonVariant.filled:
        return ButtonStyle(
          padding: MaterialStateProperty.all(textPadding),
          textStyle: MaterialStateProperty.resolveWith<TextStyle?>(
            (states) => Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
          foregroundColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
            return isDangerButton ? onErrorColor : computeForeground(defaultBackgroundColor);
          }),
          backgroundColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
            if (customColor != null) {
              return customColor!;
            }
            return isDangerButton
                ? states.contains(MaterialState.disabled)
                    ? errorColor.withOpacity(0.33)
                    : errorColor
                : states.contains(MaterialState.disabled)
                    ? defaultBackgroundColor.withOpacity(0.33)
                    : defaultBackgroundColor;
          }),
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              final Color backgroundColor = isDangerButton ? errorColor : defaultBackgroundColor;
              if (states.contains(MaterialState.pressed)) {
                return backgroundColor.withLight(0.7, background: ZdsColors.black);
              }
              if (states.contains(MaterialState.hovered)) {
                return backgroundColor.withLight(0.85, background: ZdsColors.black);
              }
              return null; // Use the component's default.
            },
          ),
          side: MaterialStateProperty.resolveWith<BorderSide?>((Set<MaterialState> states) {
            if (states.contains(MaterialState.focused)) {
              return const BorderSide(color: highlightBlueColor, width: 3);
            }
            return null;
          }),
        );
      case _ZdsButtonVariant.outlined:
        return ButtonStyle(
          padding: MaterialStateProperty.all(textPadding),
          textStyle: MaterialStateProperty.resolveWith<TextStyle?>(
            (states) => Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w500,
                  color: customColor,
                ),
          ),
          foregroundColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
            if (customColor != null) {
              return customColor;
            }
            return isDangerButton
                ? states.contains(MaterialState.disabled)
                    ? errorColor.withOpacity(0.33)
                    : errorColor
                : states.contains(MaterialState.disabled)
                    ? defaultBackgroundColor.withOpacity(0.33)
                    : defaultBackgroundColor;
          }),
          backgroundColor: MaterialStateProperty.all(ZdsColors.transparent),
          side: MaterialStateProperty.resolveWith<BorderSide?>((Set<MaterialState> states) {
            if (states.contains(MaterialState.focused)) {
              return const BorderSide(color: highlightBlueColor, width: 3);
            }
            if (customColor != null) {
              return BorderSide(color: customColor!);
            }
            return isDangerButton
                ? BorderSide(color: states.contains(MaterialState.disabled) ? errorColor.withOpacity(0.33) : errorColor)
                : BorderSide(
                    color: states.contains(MaterialState.disabled)
                        ? defaultBackgroundColor.withOpacity(0.33)
                        : defaultBackgroundColor,
                  );
          }),
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              final Color backgroundColor = isDangerButton ? errorColor : defaultBackgroundColor;
              if (states.contains(MaterialState.pressed)) {
                return backgroundColor.withOpacity(0.2);
              }
              if (states.contains(MaterialState.hovered)) {
                return backgroundColor.withOpacity(0.1);
              }
              return null; // Use the component's default.
            },
          ),
        );
      case _ZdsButtonVariant.text:
        return ButtonStyle(
          padding: MaterialStateProperty.all(textPadding),
          textStyle: MaterialStateProperty.resolveWith<TextStyle?>(
            (states) => Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500),
          ),
          foregroundColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
            final foregroundColor = isOnDarkBackground ? ZdsColors.white : defaultBackgroundColor;
            if (customColor != null) {
              return customColor;
            }
            if (states.contains(MaterialState.disabled)) {
              return foregroundColor.withOpacity(0.33);
            }
            return foregroundColor;
          }),
          backgroundColor: MaterialStateProperty.all(ZdsColors.transparent),
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              final Color overlayColor = defaultBackgroundColor;
              if (states.contains(MaterialState.pressed)) {
                return overlayColor.withOpacity(0.2);
              }
              if (states.contains(MaterialState.hovered)) {
                return overlayColor.withOpacity(0.1);
              }
              return null; // Use the component's default.
            },
          ),
          side: MaterialStateProperty.resolveWith<BorderSide?>((Set<MaterialState> states) {
            if (states.contains(MaterialState.focused)) {
              return const BorderSide(color: highlightBlueColor, width: 3);
            }
            return null;
          }),
        );
      case _ZdsButtonVariant.muted:
        return ButtonStyle(
          padding: MaterialStateProperty.all(textPadding),
          textStyle: MaterialStateProperty.resolveWith<TextStyle?>(
            (states) => Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500),
          ),
          foregroundColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return ZdsColors.blueGrey.withOpacity(0.33);
            }
            return ZdsColors.blueGrey;
          }),
          backgroundColor: MaterialStateProperty.all(ZdsColors.transparent),
          side: MaterialStateProperty.resolveWith<BorderSide?>((Set<MaterialState> states) {
            if (states.contains(MaterialState.focused)) {
              return const BorderSide(color: highlightBlueColor, width: 3);
            }
            return BorderSide(color: ZdsColors.lightGrey);
          }),
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return ZdsColors.greySwatch(context)[200];
              }
              if (states.contains(MaterialState.hovered)) {
                return ZdsColors.greySwatch(context)[100];
              }
              return null; // Use the component's default.
            },
          ),
        );
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('isDangerButton', isDangerButton));
    properties.add(DiagnosticsProperty<bool>('isOnDarkBackground', isOnDarkBackground));
    properties.add(DiagnosticsProperty<bool>('autofocus', autofocus));
    properties.add(EnumProperty<Clip>('clipBehavior', clipBehavior));
    properties.add(DiagnosticsProperty<FocusNode?>('focusNode', focusNode));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onLongPress', onLongPress));
    properties.add(ObjectFlagProperty<ValueChanged<bool>?>.has('onHover', onHover));
    properties.add(ObjectFlagProperty<ValueChanged<bool>?>.has('onFocusChange', onFocusChange));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap));
    properties.add(DiagnosticsProperty<EdgeInsets?>('textPadding', textPadding));
    properties.add(ColorProperty('customColor', customColor));
    properties.add(StringProperty('semanticLabel', semanticLabel));
  }
}
